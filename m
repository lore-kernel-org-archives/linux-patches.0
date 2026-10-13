Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C908D4F85D0;
	Tue, 13 Oct 2026 12:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893741; cv=none; b=VXw2f+0PViIIpLvegjlCnCuBV7N95Wd4l4Hh/lCcEcEkqXrZig/LkGWM/RIrAzq/67jqmMv31KV9ZN0Ql2N5HuOGaW+wg8CsDfAeJiCWulFpUSMEGhgpuvdTs4bRjbO7SwAiB/eRJW1rpCFj8d01iWGHX5RcGQe2eL1eYH7HXwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893741; c=relaxed/simple;
	bh=lKNyCJGA4VGxT36x8bd9wBPplYzLJcwg+RGQkr/rVoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEOhl4mN6R76NBKuGyfWuj7CMNVp+O/uYLJpe49Lh3OE9/T8hQAMM3/8pggALrrKKH+AVgC8pQ5XlPQcz4U54fSYQg444TO3nQ4edhPloWG1J39+zpoWPBXxXgVxZjaUgeR+s/Ej6c7Y311qH9g9+PeUxN43WCnAgGZLBo6rLvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eHH3ABJs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eHH3ABJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317591F000FF;
	Tue, 13 Oct 2026 12:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893740;
	bh=hE0FTj6Q3qwVrYFnCzzFxnHwpFWowN3ghqyGfLxNH9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eHH3ABJsbAduYLqbK0DDUpjpQHWZbMCGcjdlSJLuQmMDKGHC6+y/TvAGts4tFevhL
	 EFyRrXo3+eeYXL6/5+Ew35I8Athl+syb5/fiibIqmyHF2DqFHQxBWHntgQx8MOINqo
	 6+jL9Yif9ALqsw/1QwWJ4RVlMQuocJpzZirNXSX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 326/621] Bluetooth: hci_sync: hold conn in hci_connect_big_sync() callback
Date: Tue, 13 Oct 2026 13:35:21 +0200
Message-ID: <20261013112928.589713356@linuxfoundation.org>
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

[ Upstream commit 56e78b670356caab0b607e8aad4cf819a1909d07 ]

There is theoretical UAF if the conn is freed while the hci_sync task is
running.

Hold refcount to avoid that. Handle NULL hcon, return 0 + do nothing to
match the previous behavior.

Fixes: 024421cf3992 ("Bluetooth: hci_conn: Fix not setting timeout for BIG Create Sync")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 7589cd154c9bf..b7ac42d8f79f7 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -7438,10 +7438,12 @@ static void create_big_complete(struct hci_dev *hdev, void *data, int err)
 	bt_dev_dbg(hdev, "err %d", err);
 
 	if (err == -ECANCELED)
-		return;
+		goto done;
 
-	if (hci_conn_valid(hdev, conn))
-		clear_bit(HCI_CONN_CREATE_BIG_SYNC, &conn->flags);
+	clear_bit(HCI_CONN_CREATE_BIG_SYNC, &conn->flags);
+
+done:
+	hci_conn_put(conn);
 }
 
 static int hci_le_big_create_sync(struct hci_dev *hdev, void *data)
@@ -7493,7 +7495,13 @@ int hci_connect_big_sync(struct hci_dev *hdev, struct hci_conn *conn)
 {
 	int err;
 
-	err = hci_cmd_sync_queue_once(hdev, hci_le_big_create_sync, conn,
+	if (!conn)
+		return 0;
+
+	err = hci_cmd_sync_queue_once(hdev, hci_le_big_create_sync,
+				      hci_conn_get(conn),
 				      create_big_complete);
+	if (err)
+		hci_conn_put(conn);
 	return (err == -EEXIST) ? 0 : err;
 }
-- 
2.53.0



