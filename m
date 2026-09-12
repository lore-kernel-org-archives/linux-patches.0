Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A54379C38;
	Sat, 12 Sep 2026 10:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207642; cv=none; b=OquBvhEYa1x3+thK1j9ivI/aDPVuhJmceHqKC6TEbc1qic4xtunVhLaWtS0XIXu4ubdaFkFz1v9/QqgoH1fk0E+fTCjAKdlx1pGNXvYbwGIuOFFqABF05NiAi1G+9dW0+shgynj0r6cPTG0YEOc53ZpwPuFN1ikHSpMFVssYqSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207642; c=relaxed/simple;
	bh=JKqT6IPAzqX5KS0cZ3KyS6aSRE83N65bJ5HYnTLZJPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnQpilu/DzSkfPGt+lkus8Pqt8AS5rV6spC9V7FaqvDCFQ5E1JUvTpm+8TQmYrhifkqwathTgmtgTeUTr5bjieUvMgpK1xivMHwcS9cTun678YhPNuBZdKyRxi93Pb9PDh4aHdWdtKt+2o07a4iv2p48cKFD48cuycXH7ut4ioA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/s4I5YN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/s4I5YN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932291F000FF;
	Sat, 12 Sep 2026 10:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207641;
	bh=tibelXgP3kn6xRKfQXziOAk3+/+rMIlvECoVm50tVDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p/s4I5YNIana+HIvpsD+ncLa6MiyJ6WconlyURj1jLpwegaWaCqdSLRQQWsGfjMw8
	 EBUxPPyGSY3+NmB/CEF+AEbb1kCHctzmVnGD6fisUXqeX/+5cpI1CyELmcuPLLs9eW
	 fCQnXMPF5Y5bdzlqDVtrsW/0ulg9HNGczMJL8ao8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0452/1518] misc: bcm-vk: Use acquire/release for msgq_inited
Date: Sat, 12 Sep 2026 08:43:41 +0200
Message-ID: <20260912065633.674135983@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 665a3888708ac..a36a6c7d384a9 100644
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



