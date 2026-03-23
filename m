Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7935D21D00A;
	Mon, 23 Mar 2026 13:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274258; cv=none; b=to3YGpRUwKWgKRWNsefh+QL3kDGw0f3Tavh7EXIcIh+0tOyinCVPSsOJB3CejLloO3wWAgQLxGmwOKvGQ3ecB+X+LJBe8oQxx0x7BUiov8zOKQU/EDIY723PxMyIk9Mo9BD798wP73jCm0jDh0GZ3U7ahlBStcdW8jlG78avtMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274258; c=relaxed/simple;
	bh=6JOjag13x4GsQt6i57pLLF/J7dY5iOYkU06WqaywZRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKaipyyjbt2hpOoztJbx/mm8jlgcModbSpZqTock0vyywIppPxdSsaeaGbulAuhWkKIE0SqTryTIRCw8iNRj7GO5zSat9cegRFiv/TCNCKDkqvhZ6uFy31KXhFiVojKVFfIU826eKz/XyiD2apcE/xW0XQyDydSAVRYAGb6f7wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/7nBjzP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/7nBjzP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C05C4CEF7;
	Mon, 23 Mar 2026 13:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274258;
	bh=6JOjag13x4GsQt6i57pLLF/J7dY5iOYkU06WqaywZRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/7nBjzP3UCWUQCH1BVuBOo2sBixDR3E0CmE4Y9pvuXi1yu8/y3+foevwnblMRaHY
	 rq6Zovdb1wG5rlngcfpHEpCFkcBATdQEAmZ+rOrSXBFPtAYw1ojWZeWGtsKaohor4H
	 U+kmcZu6bmq2gxgIjzEWRSwVODoZh2TGXILUifaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Tao <wangtao554@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 123/220] Bluetooth: MGMT: Fix list corruption and UAF in command complete handlers
Date: Mon, 23 Mar 2026 14:45:00 +0100
Message-ID: <20260323134508.478784767@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 0e46f9e08b106..2c63f49c33018 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2195,10 +2195,7 @@ static void set_mesh_complete(struct hci_dev *hdev, void *data, int err)
 	sk = cmd->sk;
 
 	if (status) {
-		mgmt_cmd_status(cmd->sk, hdev->id, MGMT_OP_SET_MESH_RECEIVER,
-				status);
-		mgmt_pending_foreach(MGMT_OP_SET_MESH_RECEIVER, hdev, true,
-				     cmd_status_rsp, &status);
+		mgmt_cmd_status(cmd->sk, hdev->id, cmd->opcode, status);
 		goto done;
 	}
 
@@ -5377,7 +5374,7 @@ static void mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev,
 
 	mgmt_cmd_complete(cmd->sk, cmd->hdev->id, cmd->opcode,
 			  mgmt_status(status), &rp, sizeof(rp));
-	mgmt_pending_remove(cmd);
+	mgmt_pending_free(cmd);
 
 	hci_dev_unlock(hdev);
 	bt_dev_dbg(hdev, "add monitor %d complete, status %d",
-- 
2.51.0



