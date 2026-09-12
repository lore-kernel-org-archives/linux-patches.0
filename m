Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AB33090D7;
	Sat, 12 Sep 2026 14:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223478; cv=none; b=BgueC0vJ/SQgGBwon50ZZVN3g3Go34FshTlDzkr94ioqmFcGXjaB8ozD6BHne8xX7qqtRWTjO9ixEwnm7K+mAFrPtcATblos1hwdwFjA3O5Kkp3m8DaQqUu2FcHFVOiI7nYj8ke3J2gcooLHK0zV3JVsQLMw0zM/uvKDmOHamVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223478; c=relaxed/simple;
	bh=E9QGMJFPZJ5Ip8UPgtPY1oBWK2Y4VogO8jIA4XMbUgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ekKLLIeqdVurkQp5EfRV6gV6Xuf/l4EGnUNjI/PAH+AZVzvYq4TuF65d9eBUkIxgsBW0w5avBjCTPaNKHv92UPAoHPH5oty4WQlrKO8vKf3YdkKTPuH+eNQe6iqMHmF3lB8A5zdZpAN87YGbA1ATM3xBZETQfVDez9ttif7dKCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmLRreCW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmLRreCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6541F000FF;
	Sat, 12 Sep 2026 14:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223473;
	bh=GxP61T9bPaLQnRIRWZSaN4nnQaqJDrPuy6wa1wccZIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kmLRreCWZ0mm/G6rhOS2DSkGQXMBKoycelFlUxKdNqewpxDDMSlyoEakGlgKa2XB7
	 CEPr8p2AN/v14MLW9H3pZK/6D44gzD/RzWL+fjFqBGfsj5WqSMx6Lej8drBjQ0ZipZ
	 uJZ0jUkol3f7EPTLPEbjtpiKga3BiA5JzryV63ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0796/1424] misc: bcm-vk: Use acquire/release for msgq_inited
Date: Sat, 12 Sep 2026 08:53:48 +0200
Message-ID: <20260912065625.121971906@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Gui-Dong Han <hanguidong02@gmail.com>

[ Upstream commit 61b101c6a150057b6d512421ed108aed16e822ea ]

bcm_vk_sync_msgq() fills the message queue information and then sets
msgq_inited. Readers call bcm_vk_drv_access_ok() before accessing the
message queues and their cached queue information.

atomic_set()/atomic_read() do not order those accesses. A reader can see
msgq_inited set while still seeing stale queue information. Use release
when publishing the initialized queues and acquire when checking the gate.

Keep the clear in bcm_vk_blk_drv_access() as atomic_set(). It closes the
gate and does not publish queue state to readers.

Fixes: 111d746bb476 ("misc: bcm-vk: add VK messaging support")
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Link: https://patch.msgid.link/20260603021127.3285057-1-hanguidong02@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/bcm-vk/bcm_vk_msg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/bcm-vk/bcm_vk_msg.c b/drivers/misc/bcm-vk/bcm_vk_msg.c
index 54e25e9bc51b1..c339a83e4f4fd 100644
--- a/drivers/misc/bcm-vk/bcm_vk_msg.c
+++ b/drivers/misc/bcm-vk/bcm_vk_msg.c
@@ -108,7 +108,8 @@ u32 msgq_avail_space(const struct bcm_vk_msgq __iomem *msgq,
 
 bool bcm_vk_drv_access_ok(struct bcm_vk *vk)
 {
-	return (!!atomic_read(&vk->msgq_inited));
+	/* Pair with the release store after message queue initialization. */
+	return !!atomic_read_acquire(&vk->msgq_inited);
 }
 
 void bcm_vk_set_host_alert(struct bcm_vk *vk, u32 bit_mask)
@@ -501,7 +502,8 @@ int bcm_vk_sync_msgq(struct bcm_vk *vk, bool force_sync)
 			msgq++;
 		}
 	}
-	atomic_set(&vk->msgq_inited, 1);
+	/* Publish message queue info before allowing driver access. */
+	atomic_set_release(&vk->msgq_inited, 1);
 
 	return ret;
 }
-- 
2.53.0



