Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F5B47A88A;
	Fri,  7 Aug 2026 15:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116947; cv=none; b=TWsD4itWGGaiVw5oKxAHoqqN+tVIPy0yky7ECKaiQa0vVh0MDevPc+PKPAR+HhHka0YvO8G19F9yIKSgpq5Q2SkU1XYtM/Yt6c/6IgJgB/1Y+Gi4bysREuuWeZ14P3B7+3gfotVUHoroMczyQM3oTZK90boVSyNPuuJ2jjHHnyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116947; c=relaxed/simple;
	bh=sdIUE5bZpH7PQar50IrgXCrvrzB6kPOE2TdIRDOVu2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RffX/Efp2nABQ/5ZAsLHXxaJxZBNgUC+avs10QaPtz23gwiQ43RO/12N//GjXIRiKrzyF1JhKVfA1R8VXb1nPjFvUwffqfe+iQ97sgTsbueSPQQiAgI10b3qZ2T2VRdD/CB2pWUTUi2441j+ulY2XEn4pcykltdv+t878daduyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4UOVPN3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4UOVPN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EDF1F000E9;
	Fri,  7 Aug 2026 15:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116945;
	bh=AdNRgmWQxPbFrvZSn3TBgl3LVfQY7ETmxYaR5RxG9+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y4UOVPN3LKiu2j9B8gi8zkwfxP2bFHsx1ImhkoanFcMRGoZK1t+ez4jg3jGx+2NVj
	 Yk7XCmfUdgqC+gC4tbVNAin4go9XtRs0Q0uEdbyipf6GoQ/DzFIDEhvRiMhxBdFN10
	 hLGUcw8NW/R3KxnMvQb2XRmrcsFyEMoi6fK+4ZoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 145/438] Bluetooth: hci_sync: hold conn in hci_connect_pa_sync() callback
Date: Fri,  7 Aug 2026 16:35:41 +0200
Message-ID: <20260807143431.097321326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2860779e6a791..6c3dc910fdeba 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -7251,7 +7251,7 @@ static void create_pa_complete(struct hci_dev *hdev, void *data, int err)
 	bt_dev_dbg(hdev, "err %d", err);
 
 	if (err == -ECANCELED)
-		return;
+		goto done;
 
 	hci_dev_lock(hdev);
 
@@ -7275,6 +7275,8 @@ static void create_pa_complete(struct hci_dev *hdev, void *data, int err)
 
 unlock:
 	hci_dev_unlock(hdev);
+done:
+	hci_conn_put(conn);
 }
 
 static int hci_le_past_params_sync(struct hci_dev *hdev, struct hci_conn *conn,
@@ -7425,8 +7427,11 @@ int hci_connect_pa_sync(struct hci_dev *hdev, struct hci_conn *conn)
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



