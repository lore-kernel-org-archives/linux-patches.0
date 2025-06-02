Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86A52C324F;
	Mon,  2 Jun 2025 14:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875352; cv=none; b=kFMXYD+ST86tiJc79B/fHBVBT81ByH4hOXxGReCoVLx/sF99lA2pSKlOlp5PjfjcQ51I1Mu7K91sDoBo6ARinIIjihhAo4Y1MwecAwufTRlecEu9hXbb9MzC0MjNniMTfAVTw+XZIIG9+pVlEobR8YNAoUMCOg2QxSkb+6FHznQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875352; c=relaxed/simple;
	bh=v4F2fbw99f765ZhLoGIQxbkGYx25eYUQkLdFXYFXBiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEppAdS6elO0wFIg66SxcLwLJI6IwZt7dqN7plpLtBBEuOzLEYZn9HvEgcVhGfa1DHX8+jcCVr5vl28thZ4Tk2YQ0q0hnSf5MZEjihU9RbKQc04oKifkeFe+i2AjuTdQVXOYoVvGC4cmg5v0U5NTYHizq4tLNOdGMLmjcM8N0uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUWmM6Jh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUWmM6Jh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A349DC4CEEB;
	Mon,  2 Jun 2025 14:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875352;
	bh=v4F2fbw99f765ZhLoGIQxbkGYx25eYUQkLdFXYFXBiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UUWmM6JhASoazrIk1MB/6AncR85ZnOiGDjZCj2AFe7GVH8wNYcPOp3JZKKRllnk5c
	 eTBt6brjsntq+GgxVB3c5WkOO+1uZqDQvR1dCOnglfUadabKVZ/GKrzN0PX86YCc7j
	 qEXKgJptkaDSlFQFyKtd/v7aStAIDdYyeqzAp7ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.10 108/270] usb: typec: fix potential array underflow in ucsi_ccg_sync_control()
Date: Mon,  2 Jun 2025 15:46:33 +0200
Message-ID: <20250602134311.651310179@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit e56aac6e5a25630645607b6856d4b2a17b2311a5 upstream.

The "command" variable can be controlled by the user via debugfs.  The
worry is that if con_index is zero then "&uc->ucsi->connector[con_index
- 1]" would be an array underflow.

Fixes: 170a6726d0e2 ("usb: typec: ucsi: add support for separate DP altmode devices")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/c69ef0b3-61b0-4dde-98dd-97b97f81d912@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ The function ucsi_ccg_sync_write() is renamed to ucsi_ccg_sync_control()
  in commit 13f2ec3115c8 ("usb: typec: ucsi:simplify command sending API").
  Apply this patch to ucsi_ccg_sync_write() in 6.1.y accordingly. ]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_ccg.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -573,6 +573,10 @@ static int ucsi_ccg_sync_write(struct uc
 		    uc->has_multiple_dp) {
 			con_index = (uc->last_cmd_sent >> 16) &
 				    UCSI_CMD_CONNECTOR_MASK;
+			if (con_index == 0) {
+				ret = -EINVAL;
+				goto unlock;
+			}
 			con = &uc->ucsi->connector[con_index - 1];
 			ucsi_ccg_update_set_new_cam_cmd(uc, con, (u64 *)val);
 		}
@@ -588,6 +592,7 @@ static int ucsi_ccg_sync_write(struct uc
 err_clear_bit:
 	clear_bit(DEV_CMD_PENDING, &uc->flags);
 	pm_runtime_put_sync(uc->dev);
+unlock:
 	mutex_unlock(&uc->lock);
 
 	return ret;


