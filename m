Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD92288B9;
	Sat, 12 Sep 2026 16:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230926; cv=none; b=dHYEp/78cO3F37qYE5XUxxfxXowwl2rH1LtqkA3PqZMYA3VXf0hOjlacEZUKOhER7PD8UhCbLZSEVWezmInTP0xjzbrzArokdwuefVuBRgso1kdk7zXmgwu9f4o4JEtFWLuOIin0TCNuOwMvlCq6p6Xx6x/syOUIabGjlTAhijw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230926; c=relaxed/simple;
	bh=ksgGJpX4VRjjLKEabi0jjmTUtryVWKTUjqDjFpqf8lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oa9YMtfXJTUVcQKvQecPxLwaddEpeAosXRca5WVYtiat2V3UmJ3cFHpZ47z8moe84oft5sSZA5BMYHYRVymPPECsNMPravaqVk+5qKlkr63NJeK35IQRKipKe9oW0o2DOR6V/EW0TNN2o+JCrgd/N6QOedug6g3Pp8Yr3HGZcK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWssw5c1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWssw5c1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24951F000FF;
	Sat, 12 Sep 2026 16:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230925;
	bh=CQCY4I40vBfr35SFpkidO0oyRUgZgYQBN6C8CYRdw94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UWssw5c1RlsMd4RDG55u+/nVOk3rl1wtAHEI6AbfLQ4qrdsWVJhJ7bRCH+nOh1jT/
	 W2CjA4CdC8DjTFh/7VBqp/PSpI210LtvaZzoy9TCZztGnjV+5uNaeBQqU+7Ya+x8i8
	 vOOB9jK9x/dx/snGo+xV/qgJ0EnWEPDUbRIBxhpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0894/1191] IB/isert: post the full-feature receive buffers after session registration
Date: Sat, 12 Sep 2026 09:00:22 +0200
Message-ID: <20260912065608.318784638@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

[ Upstream commit 5247dde9daac7e107853b6fea043f7f47be033f7 ]

isert_put_login_tx() posts the full-feature receive buffers before
__transport_register_session() runs, so an initiator that does not wait
for the final Login Response can still have a SCSI command executed
against an se_session whose se_tpg is NULL - the same oops as the
previous patch, at target_submit+0xbe.

Post them from isert_get_rx_pdu(), which the previous patch already uses
to send that response, and post them before that send: the receive queue
is filled at the moment the initiator is told it may use it.  Allocating
there keeps the existing property that a memory allocation failure cannot
happen once the final Login Response is on the wire.

The receive queue is already empty between the final Login Request and
isert_post_recvm(); this moves the second point later, from a median of
92 us to 172 us over 1200 logins.  Only an initiator that sends before it
has been told to can reach that window, and on IB and RoCE its send is
retried there until the buffers appear - isert_rdma_accept() asks for
rnr_retry_count = 7.  iWARP has no RNR flow control, so there the same
send terminates the connection instead.

Measured over rxe, 400 login cycles per run, with an initiator that does
not wait: an instrumented build counted no entries to isert_recv_done()
before the buffers are posted in 10 runs, where that initiator oopsed
8 of 10 unpatched runs and 5 of 10 with only the previous patch.

Not tested: iWARP, discovery sessions over iSER, and real HCAs.

Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) target driver")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Link: https://patch.msgid.link/20260731041212.1733364-2-yhlee@isslab.korea.ac.kr
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 41 ++++++++++++-------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 6bbe74521be77..6d969931ab8ff 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -952,21 +952,7 @@ isert_put_login_tx(struct iscsit_conn *conn, struct iscsi_login *login,
 	}
 	if (!login->login_failed) {
 		if (login->login_complete) {
-			ret = isert_alloc_rx_descriptors(isert_conn);
-			if (ret)
-				return ret;
-
-			ret = isert_post_recvm(isert_conn,
-					       ISERT_QP_MAX_RECV_DTOS);
-			if (ret)
-				return ret;
-
-			/* Now we are in FULL_FEATURE phase */
-			mutex_lock(&isert_conn->mutex);
-			isert_conn->state = ISER_CONN_FULL_FEATURE;
-			mutex_unlock(&isert_conn->mutex);
-
-			/* Sent from isert_get_rx_pdu() after registration. */
+			/* Posted and sent from isert_get_rx_pdu(). */
 			isert_conn->login_rsp_pending = true;
 			return 0;
 		}
@@ -2639,13 +2625,26 @@ static void isert_get_rx_pdu(struct iscsit_conn *conn)
 	struct isert_conn *isert_conn = conn->context;
 	struct completion comp;
 
+	/* The login timeout timer can fail the login after isert_put_login_tx(). */
+	if (!isert_conn->login_rsp_pending)
+		return;
+
+	isert_conn->login_rsp_pending = false;
+
 	/* The session is registered by now; see isert_put_login_tx(). */
-	if (isert_conn->login_rsp_pending) {
-		isert_conn->login_rsp_pending = false;
-		if (isert_login_post_send(isert_conn,
-					  &isert_conn->login_tx_desc))
-			return;
-	}
+	if (isert_alloc_rx_descriptors(isert_conn))
+		return;
+
+	if (isert_post_recvm(isert_conn, ISERT_QP_MAX_RECV_DTOS))
+		return;
+
+	/* Now we are in FULL_FEATURE phase */
+	mutex_lock(&isert_conn->mutex);
+	isert_conn->state = ISER_CONN_FULL_FEATURE;
+	mutex_unlock(&isert_conn->mutex);
+
+	if (isert_login_post_send(isert_conn, &isert_conn->login_tx_desc))
+		return;
 
 	init_completion(&comp);
 
-- 
2.53.0



