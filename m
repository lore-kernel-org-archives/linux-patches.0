Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AF33947A6;
	Mon, 23 Mar 2026 14:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274912; cv=none; b=GVluT4RU/8q+aceSthhS7whF7c39qP2p/inEkN3mjBpY4N7DBYU0YRm1VAYKlO+J6tsVW3bzOJXCblBj0NTMQUEVeDToRop54cJdFf9i5bR3fXRPQ//GFK4zQBgy79Hjck5sjt1PDibtmJH2tyl69FPGGnZh6NdiIVA4ku1DYao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274912; c=relaxed/simple;
	bh=nzjy+XaIGenUDTNQsexW67DG2QRo3PWZlzFg4GQ2fWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pM53ten5hrEcBTxQ+C6+M3LAvvxC+FD3Tzv/bvCex46+h6AafzSFv4DE8+QJEplocnHVfHIQHxw3S5zWmiTzeqvdhgkio8av16hkdI1JBzIDu0/JiqsCxhyQEVhkXxD7e4d5G6UjBWuws/SSw0ra/QbhNUnsi+2XZJ0qycRLNV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6RQSq7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6RQSq7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4EFC4CEF7;
	Mon, 23 Mar 2026 14:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274912;
	bh=nzjy+XaIGenUDTNQsexW67DG2QRo3PWZlzFg4GQ2fWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6RQSq7GeouOUOp4kdw06VnQAe+E4PEnnPJ5Z/TqOKVuryYvqek4GZ5C4VDohlmNK
	 NWYXX8d85JA/C7eMDCDwtr4GkqDVKbKnohvPUiF18TKSgfyPvenKFZKrzoesNsTR5m
	 PvQl6bzhIeeEZxnxUAxQwEcocrE4m9j0OQ0YvQ/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Tao <wangtao554@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 127/212] Bluetooth: MGMT: Fix list corruption and UAF in command complete handlers
Date: Mon, 23 Mar 2026 14:45:48 +0100
Message-ID: <20260323134507.781832641@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Wang Tao <wangtao554@huawei.com>

[ Upstream commit 17f89341cb4281d1da0e2fb0de5406ab7c4e25ef ]

Commit 302a1f674c00 ("Bluetooth: MGMT: Fix possible UAFs") introduced
mgmt_pending_valid(), which not only validates the pending command but
also unlinks it from the pending list if it is valid. This change in
semantics requires updates to several completion handlers to avoid list
corruption and memory safety issues.

This patch addresses two left-over issues from the aforementioned rework:

1. In mgmt_add_adv_patterns_monitor_complete(), mgmt_pending_remove()
is replaced with mgmt_pending_free() in the success path. Since
mgmt_pending_valid() already unlinks the command at the beginning of
the function, calling mgmt_pending_remove() leads to a double list_del()
and subsequent list corruption/kernel panic.

2. In set_mesh_complete(), the use of mgmt_pending_foreach() in the error
path is removed. Since the current command is already unlinked by
mgmt_pending_valid(), this foreach loop would incorrectly target other
pending mesh commands, potentially freeing them while they are still being
processed concurrently (leading to UAFs). The redundant mgmt_cmd_status()
is also simplified to use cmd->opcode directly.

Fixes: 302a1f674c00 ("Bluetooth: MGMT: Fix possible UAFs")
Signed-off-by: Wang Tao <wangtao554@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index ee2dd26b1b82b..1a270f0b17d9e 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2183,10 +2183,7 @@ static void set_mesh_complete(struct hci_dev *hdev, void *data, int err)
 	sk = cmd->sk;
 
 	if (status) {
-		mgmt_cmd_status(cmd->sk, hdev->id, MGMT_OP_SET_MESH_RECEIVER,
-				status);
-		mgmt_pending_foreach(MGMT_OP_SET_MESH_RECEIVER, hdev, true,
-				     cmd_status_rsp, &status);
+		mgmt_cmd_status(cmd->sk, hdev->id, cmd->opcode, status);
 		goto done;
 	}
 
@@ -5295,7 +5292,7 @@ static void mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev,
 
 	mgmt_cmd_complete(cmd->sk, cmd->hdev->id, cmd->opcode,
 			  mgmt_status(status), &rp, sizeof(rp));
-	mgmt_pending_remove(cmd);
+	mgmt_pending_free(cmd);
 
 	hci_dev_unlock(hdev);
 	bt_dev_dbg(hdev, "add monitor %d complete, status %d",
-- 
2.51.0



