Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB99F37FF60;
	Sat, 12 Sep 2026 16:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229701; cv=none; b=Rxd4QkctYPxkWehtAXNy3FllEgmk39aeW0q9ePxI82SunqIc+DL2Vk9ZyW+noTMvG+H164zuX7eKQqsvlUGl+EGQtJ4jDdcn4LWS2bTNwRnnqA6YZqbUd3mUaWyyRyTYp8SUxn5qyqTIiC3U4G9PWhuTQsq8JLd2++NSvIHVAOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229701; c=relaxed/simple;
	bh=C5mOsAh6+1bwUVC7c0n58edv1EpURjgbrllLaxmjFfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAlPsxx4BfzMwy0rlEBGGj2qRdw/kmAdLVSFKMS5wTJAtvmpcq6qiib4Ia0l1D02l7LTkNniw0C3o13s/rvmOLHy6EyxYpEz3v438R8QebEZb8sPW5+mCB8llwesQ582DlahYrc6G0M3fNn25wzQJx8DFwA9grIwlLhHlyUjtrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Oy/evp3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Oy/evp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C921F000FF;
	Sat, 12 Sep 2026 16:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229699;
	bh=NGcU+jYA4OPmk9VaplQjrEsr/eJQ15of1E8K7lhMEDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Oy/evp35rhSFCr8Gxi/G2eXQ01u0MQ6p/VDGc0SN0DO9HurEF1JanHgr2E08V6cJ
	 sOQwhofLMDdDufqDM5XvOu+cSe52kfe2Rmou9o6UDeuSTa6W6DhbT2TaovCkU0y1f8
	 ++3ZfT8+x4mrHYaw4/mnGgzM4RenmsTgTwarK41c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0641/1191] misc: bcm-vk: Use acquire/release for msgq_inited
Date: Sat, 12 Sep 2026 08:56:09 +0200
Message-ID: <20260912065602.651205481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 97888c83c5ef3..3f98979dd0fa3 100644
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



