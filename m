Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB05F3D9DA8;
	Tue, 13 Oct 2026 12:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893726; cv=none; b=dTbfsG5BGEQ60zOgDQnK7M3AycqB6M3Wf2X2jo5ERTSM2cXmEdyx4Kn60YoiqKIyQlNzDDoXRq/Eep2U0ps0nhgi7+byHWBHf5HziBRgFZGrL0wNkbmKQH+63UQK2Y3+ad9+cIrzV85BCpr0luk5LrA5hOiAaTWp4/riAP15CsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893726; c=relaxed/simple;
	bh=Qt+0syp9jmRI7h6KjQjIOvlaVgIzIyv7/hHbJ3U8Kt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QYUroBtVrS9BCO0wgG2CUPRhdxWx9YgFAFejOfGWCbyUFJHgtJEbl5dJNB24asVLpcXTHO4yqlvbbJ3Dys3Q60TGkM+Z2J1C2pDgarjNNlbZXqTkYEg1/uCLFPlyxmK5JEAq26uG33NzvRb53N9lysJvJq9/udPG5JmXOeQPtd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4G3igjR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4G3igjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C921F000FF;
	Tue, 13 Oct 2026 12:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893725;
	bh=BnmlecXSxWk3gj677/7AbhXWJFmXS3OOwu1SVbGWQKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J4G3igjRfgwvEM+0SQu74ZSNciSpLWC8aKP5GzM+lRIqFW/XAa7kJhonreVxN5fkT
	 Q4ss82dj17UsEp3Ls3vhKsF1iBZXXkOdIqdPReQ1luThNzc/cJKpVMfSYo5ka6ql+c
	 bP9ERwq8ouSSpN6N+U/tkj9yikouduBrCqK7wSm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 322/621] Bluetooth: hci_sync: hold conn in hci_connect_pa_sync() callback
Date: Tue, 13 Oct 2026 13:35:17 +0200
Message-ID: <20261013112928.494721297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 961c3edb33e67..7589cd154c9bf 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -7308,7 +7308,7 @@ static void create_pa_complete(struct hci_dev *hdev, void *data, int err)
 	bt_dev_dbg(hdev, "err %d", err);
 
 	if (err == -ECANCELED)
-		return;
+		goto done;
 
 	hci_dev_lock(hdev);
 
@@ -7332,6 +7332,8 @@ static void create_pa_complete(struct hci_dev *hdev, void *data, int err)
 
 unlock:
 	hci_dev_unlock(hdev);
+done:
+	hci_conn_put(conn);
 }
 
 static int hci_le_pa_create_sync(struct hci_dev *hdev, void *data)
@@ -7421,8 +7423,11 @@ int hci_connect_pa_sync(struct hci_dev *hdev, struct hci_conn *conn)
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



