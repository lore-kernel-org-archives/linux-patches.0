Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CC851C078;
	Wed, 30 Sep 2026 16:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784695; cv=none; b=RO5H/QMU+vlTVoktTFcK4JD7CdUEga9K8v5F4VMCiVMBJ3ylXvXVTDqfovQIZafsc4YBUTnemDG8iN9LaOD+L//ELM+Tvs9NDiARS2gNNQbwihaiPF42nvPPaRk159tJ0/8nhD2JdPAZBw6ZXNex9x5q1n6SU6Asj0iULa89ZdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784695; c=relaxed/simple;
	bh=3jjSFfyplRQ1x1WnpxTYJnQgI6fjAKDVQfR9Lgz58GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fljA0kahMZuNwZhIIooQvrA9BYhj06XM2U3zTpaZx4QnvV/eBE6rDMjC2DleIO7KAwh8lignMo84AN1HKh4HdI55FrFkN8RDNyUWG8S+S77fWh6hEzVTs3jI/DVKswqSppNOnv8JW1eBBl+1MKNt443CVsxLKS7M3AXGjaoGaok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxmk7gAf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxmk7gAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803001F000FF;
	Wed, 30 Sep 2026 16:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784686;
	bh=IpMfnUXijDSGZY2JdraPxDHgCccID3d30SEvTXSdkCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yxmk7gAfsBPAYVDaZlIDr6ewZogitsHncHrBkFitGSZ9ZLmsBePgjbldgUwondqY6
	 XQcRoD7Hs6vKjhCE36pP8vaVXN2GCim/ZA3WxoqrIvIHpcZHKa0MnBFW2iySXvz1NK
	 fk9zuYYIEmoi4y9J4NHaJQvOw/gMrC1iRiHk6FI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 242/982] ksmbd: fix outstanding credit leak on abort and error paths
Date: Wed, 30 Sep 2026 17:16:18 +0200
Message-ID: <20260930152421.993219735@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 4a0b7826615a01c47924334a2e8a9dbd84a598b2 ]

smb2_validate_credit_charge() adds the request's CreditCharge to
conn->outstanding_credits when an SMB2 PDU is received, and
smb2_set_rsp_credits() subtracts it again when the response is built.
However smb2_set_rsp_credits() only runs on the normal response path:

  - __process_request() returning SERVER_HANDLER_ABORT (unimplemented
    command, command index out of range, signature check failure, or a
    handler that sets send_no_response such as a cancelled blocking
    lock) breaks out of the processing loop before set_rsp_credits() is
    called;
  - smb2_set_rsp_credits() itself returns early with -EINVAL (total
    credit overflow or insufficient credits) before the subtraction.

On all of these paths the charge added at receive time is never
returned, so conn->outstanding_credits only grows. Because a client can
repeatedly trigger them (e.g. by sending unimplemented commands or by
issuing and cancelling blocking locks), outstanding_credits eventually
reaches total_credits and smb2_validate_credit_charge() then rejects
every subsequent request, wedging the connection.

Record the charge that was added in work->credit_charge and release any
charge still pending at the single send. exit point of
__handle_ksmbd_work(), which all abort and error paths fall through to.
smb2_set_rsp_credits() clears work->credit_charge once it has returned
the charge so the response path is unchanged and the credit is never
released twice. Paths that never charged a credit (no multi-credit
support, validation failure) leave work->credit_charge at zero and are
unaffected.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/ksmbd_work.h |  7 +++++++
 fs/smb/server/server.c     | 14 ++++++++++++++
 fs/smb/server/smb2misc.c   |  9 ++++++---
 fs/smb/server/smb2pdu.c    |  1 +
 4 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index 8ca2c813246e6..9c3f834901e13 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -63,6 +63,13 @@ struct ksmbd_work {
 	/* Number of granted credits */
 	unsigned int			credits_granted;
 
+	/*
+	 * Credit charge added to conn->outstanding_credits at receive time
+	 * for the SMB2 PDU currently being processed, pending release.  Zero
+	 * once the charge has been returned (on the response or error path).
+	 */
+	unsigned short			credit_charge;
+
 	/* response smb header size */
 	unsigned int                    response_sz;
 
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index fe797e8fe9419..ac7477edc62f2 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -238,6 +238,20 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 	} while (is_chained == true);
 
 send:
+	/*
+	 * Release any credit charge still outstanding for this request.  On
+	 * the normal path smb2_set_rsp_credits() already returned it, but the
+	 * abort, error and send-no-response paths skip that call, so the
+	 * charge would otherwise leak and eventually exhaust the connection's
+	 * outstanding credit window.
+	 */
+	if (work->credit_charge) {
+		spin_lock(&conn->credits_lock);
+		conn->outstanding_credits -= work->credit_charge;
+		work->credit_charge = 0;
+		spin_unlock(&conn->credits_lock);
+	}
+
 	if (work->tcon)
 		ksmbd_tree_connect_put(work->tcon);
 	smb3_preauth_hash_rsp(work);
diff --git a/fs/smb/server/smb2misc.c b/fs/smb/server/smb2misc.c
index 6a4f1b8a0b13c..8b56770f36ed8 100644
--- a/fs/smb/server/smb2misc.c
+++ b/fs/smb/server/smb2misc.c
@@ -298,9 +298,10 @@ static inline int smb2_ioctl_resp_len(struct smb2_ioctl_req *h)
 		le32_to_cpu(h->MaxOutputResponse);
 }
 
-static int smb2_validate_credit_charge(struct ksmbd_conn *conn,
+static int smb2_validate_credit_charge(struct ksmbd_work *work,
 				       struct smb2_hdr *hdr)
 {
+	struct ksmbd_conn *conn = work->conn;
 	unsigned int req_len = 0, expect_resp_len = 0, calc_credit_num, max_len;
 	unsigned short credit_charge = le16_to_cpu(hdr->CreditCharge);
 	void *__hdr = hdr;
@@ -357,8 +358,10 @@ static int smb2_validate_credit_charge(struct ksmbd_conn *conn,
 		ksmbd_debug(SMB, "Limits exceeding the maximum allowable outstanding requests, given : %u, pending : %u\n",
 			    credit_charge, conn->outstanding_credits);
 		ret = 1;
-	} else
+	} else {
 		conn->outstanding_credits += credit_charge;
+		work->credit_charge = credit_charge;
+	}
 
 	spin_unlock(&conn->credits_lock);
 
@@ -466,7 +469,7 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 
 validate_credit:
 	if ((work->conn->vals->req_capabilities & SMB2_GLOBAL_CAP_LARGE_MTU) &&
-	    smb2_validate_credit_charge(work->conn, hdr))
+	    smb2_validate_credit_charge(work, hdr))
 		return 1;
 
 	return 0;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ebd13393f8d46..1f903350039cf 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -342,6 +342,7 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
 
 	conn->total_credits -= credit_charge;
 	conn->outstanding_credits -= credit_charge;
+	work->credit_charge = 0;
 	credits_requested = max_t(unsigned short,
 				  le16_to_cpu(req_hdr->CreditRequest), 1);
 
-- 
2.53.0



