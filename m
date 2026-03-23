Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A71C26D4F9;
	Mon, 23 Mar 2026 14:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277410; cv=none; b=JIwlq1rKnUSuUBnUn1RUly1BDouAGLtQP0OzmjenZjKyKCSZu/O0aWF5GibH8pZLVmwEVRIdCzC1sSGEBedLf7woFW9/k1VKgpmSG0W19Flirnkq5sX2U0YMmcXdrrBVQpx7mtfosTCKHXCHLaLXyD+ytIZZBlK2BPJATt+GUdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277410; c=relaxed/simple;
	bh=NxRrME8uV0AlI95HG+DmFzOvJowEHAsZSq8aMVjVoP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyJodGvuz3gY3khu3qKdq4z7LAb1OSTkezosdnOzM6+XZQ+h6yyRGXoB6+qrSx/W3A52TanUjrPrH5WHDG+3sL/FKGb7Yd0F584WNsIwbhsoA/YVN/PobBzwLVdCbuCVbSAcUHThTUMo0D+V37yfhDQDhTfBcLxzzLPWHCZqv2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EIDIhoZL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EIDIhoZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247A9C4CEF7;
	Mon, 23 Mar 2026 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277410;
	bh=NxRrME8uV0AlI95HG+DmFzOvJowEHAsZSq8aMVjVoP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EIDIhoZLHA3EutaZ3oBWPNxMVJAA1SIOsKKnpH1DK4hBKt/+G1/IMU0aVmee71mix
	 lw5dFuVoqPK4APdoH0CKCiPbvYmXwZItl/qS6yxSe7BUBWQoGtnbgRozhc4GpHkO3D
	 wnXUjZcOmmBWxuAH0z0Srw7rcWRF+aEg8q0GJXMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Tao <wangtao554@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 385/460] Bluetooth: MGMT: Fix list corruption and UAF in command complete handlers
Date: Mon, 23 Mar 2026 14:46:21 +0100
Message-ID: <20260323134536.029610250@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
index 4894e6444900a..b1df591a53805 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2172,10 +2172,7 @@ static void set_mesh_complete(struct hci_dev *hdev, void *data, int err)
 	sk = cmd->sk;
 
 	if (status) {
-		mgmt_cmd_status(cmd->sk, hdev->id, MGMT_OP_SET_MESH_RECEIVER,
-				status);
-		mgmt_pending_foreach(MGMT_OP_SET_MESH_RECEIVER, hdev, true,
-				     cmd_status_rsp, &status);
+		mgmt_cmd_status(cmd->sk, hdev->id, cmd->opcode, status);
 		goto done;
 	}
 
@@ -5354,7 +5351,7 @@ static void mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev,
 
 	mgmt_cmd_complete(cmd->sk, cmd->hdev->id, cmd->opcode,
 			  mgmt_status(status), &rp, sizeof(rp));
-	mgmt_pending_remove(cmd);
+	mgmt_pending_free(cmd);
 
 	hci_dev_unlock(hdev);
 	bt_dev_dbg(hdev, "add monitor %d complete, status %d",
-- 
2.51.0



