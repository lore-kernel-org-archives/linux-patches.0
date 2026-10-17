Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C993F2C026C;
	Sat, 17 Oct 2026 16:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254577; cv=none; b=RcRa4TC9idj+3uH0KxuF/NoT6wmLOTWMGNxig95JASFwqSppN3r+ycBxAjbpuQaqsyX9feIE1zaBi8C0/KA3PIHJO/KFcW4mpbX4soar82T1z/8Kh/MjJnkr/lR1i//Q7fGP4VYA8f+sNBgdRpqbMi+kqdYf1ZaSf7YwjcFo3nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254577; c=relaxed/simple;
	bh=LJwauTlMcG4KEDay/PJt4xntI/KamjYzq/DOjMeoxmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFiG24iNDQyfbzQBK76nSabxPfjfBq3g1T1L0AfpPrbAOF637xe0XmrUMArP6OrEhgD/QcU3Zsg/ib4yIMXPKyPmc+ymRDultO/yWCrul14vanAxojXepmAIqc3tUlbfKmw8pUCW9+cmdK4oXBvWjaAGNJSLIMYNRAskwsG4ov0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mreCJMp8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mreCJMp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D64C1F000C4;
	Sat, 17 Oct 2026 16:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254576;
	bh=FEm6a+OOjFx68o2PCCqBF1NelUAjOpGGIctSVaCZeLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mreCJMp87OWePvaw5MjeiBsthilKpNHZqWCFsP8W9Gynb+EfxB2zq1TIDYqdHXj/r
	 EQQYR1rqvHKgC669rvAdHCE6dOuzYI/UkJyJewqbCs7fezZaj6Xz9eylu9WY12z6rL
	 0SkZjUU9HU7gaChyoUMZxCRRrdSvO/BKlNbp+nvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 493/869] Bluetooth: hci_sync: hold conn in hci_connect_pa_sync() callback
Date: Sat, 17 Oct 2026 17:55:34 +0200
Message-ID: <20261017160049.753159977@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 44fc74069d8988f2825246f9401218e29de2c0ab ]

There is theoretical UAF if the conn is freed while the hci_sync task is
running.

Hold refcount to avoid that.

Fixes: 6d0417e4e1cf ("Bluetooth: hci_conn: Fix not setting conn_timeout for Broadcast Receiver")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 3e3706231458d..2d28a649f33b0 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -7317,7 +7317,7 @@ static void create_pa_complete(struct hci_dev *hdev, void *data, int err)
 	bt_dev_dbg(hdev, "err %d", err);
 
 	if (err == -ECANCELED)
-		return;
+		goto done;
 
 	hci_dev_lock(hdev);
 
@@ -7341,6 +7341,8 @@ static void create_pa_complete(struct hci_dev *hdev, void *data, int err)
 
 unlock:
 	hci_dev_unlock(hdev);
+done:
+	hci_conn_put(conn);
 }
 
 static int hci_le_pa_create_sync(struct hci_dev *hdev, void *data)
@@ -7430,8 +7432,11 @@ int hci_connect_pa_sync(struct hci_dev *hdev, struct hci_conn *conn)
 {
 	int err;
 
-	err = hci_cmd_sync_queue_once(hdev, hci_le_pa_create_sync, conn,
+	err = hci_cmd_sync_queue_once(hdev, hci_le_pa_create_sync,
+				      hci_conn_get(conn),
 				      create_pa_complete);
+	if (err)
+		hci_conn_put(conn);
 	return (err == -EEXIST) ? 0 : err;
 }
 
-- 
2.53.0



