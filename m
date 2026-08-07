Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D126E281369;
	Fri,  7 Aug 2026 15:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116023; cv=none; b=U8zsYBJK5eugCEac54J8xRcfHrZmEz0RkjvD3RZDWqFGcziNKXWFQxzl8YTnoFMUQWhwpdhJJqPH1tEAVaUCnogcPGoVVrwzke7msqgJahQB6vuP/wMXRDzKx/fRbJoahFPFWlhXfDjIQ0UuKaC6Rg+Svbnua132VxUtAMS11Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116023; c=relaxed/simple;
	bh=4PlqMZlRGR0plAtVultT9lp+9+DgVGD437/j2FVR5tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpCroiMrqHAY66tAw2kSP4BodhpmG21wSieTU9JCFCCywPnxF2izrv0VZLE6YqhmJhJJAMe5VoYLmMrPJX4YS/EXYDtKQ2vkre2uvrmio6JgurXdUeW7DUcaQhKsrezbvoU9OIa+TyIjFs2Av0W7tmrvdzZY47LvR8bztJMTwQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GcomP9bg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GcomP9bg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395971F00A3A;
	Fri,  7 Aug 2026 15:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116022;
	bh=m1W+ziERWv2yT+Yoi3vIVlLJzJPWjUP5tMNvEO8pb60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GcomP9bgO904KdNU4nboGrL4bo1smc92hNV7ivWFA1wD2H7o0QZw/xqPPps44of2d
	 /nzXnKvlUzmecRP1XB/gFWt+SQW1t39dvffISszmSZnSNsrIT9yrcXiZKUOuvV4nTL
	 QyVGM+kFe1eSaX1//fr61DmrXipQVHIiKhNfmaUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/261] Bluetooth: hci_conn: hold conn reference in abort_conn_sync()
Date: Fri,  7 Aug 2026 16:37:05 +0200
Message-ID: <20260807143416.850911845@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 5761d003daa987ac81463f570713ce9c9dd204e5 ]

There is theoretical UAF if the conn is freed while the hci_sync task is
running.

Hold refcount to avoid that.

Fixes: 227a0cdf4a02 ("Bluetooth: MGMT: Fix not generating command complete for MGMT_OP_DISCONNECT")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 7625461dff7ae..e4364a64ffd57 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2896,6 +2896,13 @@ static int abort_conn_sync(struct hci_dev *hdev, void *data)
 	return hci_abort_conn_sync(hdev, conn, conn->abort_reason);
 }
 
+static void abort_conn_destroy(struct hci_dev *hdev, void *data, int err)
+{
+	struct hci_conn *conn = data;
+
+	hci_conn_put(conn);
+}
+
 int hci_abort_conn(struct hci_conn *conn, u8 reason)
 {
 	struct hci_dev *hdev = conn->hdev;
@@ -2921,6 +2928,9 @@ int hci_abort_conn(struct hci_conn *conn, u8 reason)
 	 * as a result to MGMT_OP_DISCONNECT/MGMT_OP_UNPAIR which does
 	 * already queue its callback on cmd_sync_work.
 	 */
-	err = hci_cmd_sync_run_once(hdev, abort_conn_sync, conn, NULL);
+	err = hci_cmd_sync_run_once(hdev, abort_conn_sync, hci_conn_get(conn),
+				    abort_conn_destroy);
+	if (err)
+		hci_conn_put(conn);
 	return (err == -EEXIST) ? 0 : err;
 }
-- 
2.53.0



