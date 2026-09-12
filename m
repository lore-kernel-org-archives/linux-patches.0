Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5FA4BEE43;
	Sat, 12 Sep 2026 18:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238843; cv=none; b=psGGWPpRP7EC3felQuW7H42qcp9UoDSyYPgXavhE3DmWQTZm2jBHAN8IU2/po1RT+p8XQ3/TejU/tyGOHzCBf918ai55V+oXZXRaQPawJcbsVDuFelXlFtZxV7fv5nrRMgFbZGXQgirLD3wyv5gWqZfiencsdnYzQmbLdgfUvoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238843; c=relaxed/simple;
	bh=wIQbXsgm5zENwAvHO9F9HJwLZm9lfC/jFCwckBLWX0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQUSDJuCcSHi+duy6hlS6CZox1e5emEYND6CS/h1OeClF6qFFQbjgu5mphELBEnI71laliyb18pO6akmm4cKQXUknxcOQ2xps0kSSQQtWcKu4/uy2pIBXJu8NPWgBd31tqmCSA+HiyuuvElRcjPdBLURYTfn7hKiWTFUn72e6Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nqw753hw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nqw753hw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230281F000FF;
	Sat, 12 Sep 2026 18:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238842;
	bh=wCE1m1ePw42II0WKd3dB+Mpw6nJvvKJSL5fiWNxubiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nqw753hw+UpwJ/t/JgvnpJoIClb4/H8WVhDHp8cdPLZ3sZAvhzu50oa9o4DTbokW/
	 ieklIbSg3Ku9gHQLoIUKq3vSm0MJfbl7VSLr+Gd7zaRCQkbsaOwxTIiuf5iUN1VQQH
	 uSdVSKcI5bbHa6QXg/iX+nhEpm83Yf0txAiYWs7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 545/935] misc: bcm-vk: Use acquire/release for msgq_inited
Date: Sat, 12 Sep 2026 08:59:35 +0200
Message-ID: <20260912065539.322998036@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 066b9ef7fcd74..fa14fd9ad1bf4 100644
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



