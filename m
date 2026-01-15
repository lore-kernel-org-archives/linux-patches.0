Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AAF33993;
	Thu, 15 Jan 2026 17:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499399; cv=none; b=uNBQpbppj5imFa82wdWLnlhUsBJhX38ijJXCgb7S2SvfvhLrFEKw1mCEwNBg+Bz0z4G5EM871UDk4s/wqTU4439s5MKf+eyvBY7J/Bou05xI5smx7fCrvBmCJ1RzJQ+0ZU+r2esuqZoTCvr/d2amUjLG4s754+cQkvF+9abGLMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499399; c=relaxed/simple;
	bh=11InHHmsUCJQIsQa1lGzTRO3Wt6LTmZVzUCeD50vrHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMDukw21R1exQXnLzF6LEJSrnQz5cTHj+/BNZjhSzSPHwWVPm1oaT1qucJWmdBW5cRlUEV0kfvUiwPhaLXJS9gGYY2F+dYKLkOE+8ewMlnqcSqCxOAl8ysmHWFMNt9k2isLIrL0IGbrcJJmjiJMi8lj6jmExiZ5x0QoQwZfGqm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGXGEELl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGXGEELl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3576DC19425;
	Thu, 15 Jan 2026 17:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499399;
	bh=11InHHmsUCJQIsQa1lGzTRO3Wt6LTmZVzUCeD50vrHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGXGEELl2GVQUZTgCDraHPqwaDn1gMRkUpALlqM8twPW0Y/HdhtQJZaCA/paMMlZc
	 bSqSHHYZV1FjcF3Jub3ZhnL5VKcdXHxlCYjxq1Dow1yjs32Jj314XXdme5MPdZOgFB
	 6Ysr/UHSKqsptS8oFyAnczF2zXWvcJo2B4hIRqX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+205ef33a3b636b4181fb@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 214/451] usbip: Fix locking bug in RT-enabled kernels
Date: Thu, 15 Jan 2026 17:46:55 +0100
Message-ID: <20260115164238.640450617@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Xu <lizhi.xu@windriver.com>

[ Upstream commit 09bf21bf5249880f62fe759b53b14b4b52900c6c ]

Interrupts are disabled before entering usb_hcd_giveback_urb().
A spinlock_t becomes a sleeping lock on PREEMPT_RT, so it cannot be
acquired with disabled interrupts.

Save the interrupt status and restore it after usb_hcd_giveback_urb().

syz reported:
BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
Call Trace:
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 rt_spin_lock+0xc7/0x2c0 kernel/locking/spinlock_rt.c:57
 spin_lock include/linux/spinlock_rt.h:44 [inline]
 mon_bus_complete drivers/usb/mon/mon_main.c:134 [inline]
 mon_complete+0x5c/0x200 drivers/usb/mon/mon_main.c:147
 usbmon_urb_complete include/linux/usb/hcd.h:738 [inline]
 __usb_hcd_giveback_urb+0x254/0x5e0 drivers/usb/core/hcd.c:1647
 vhci_urb_enqueue+0xb4f/0xe70 drivers/usb/usbip/vhci_hcd.c:818

Reported-by: syzbot+205ef33a3b636b4181fb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=205ef33a3b636b4181fb
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20250916014143.1439759-1-lizhi.xu@windriver.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/usbip/vhci_hcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/usbip/vhci_hcd.c b/drivers/usb/usbip/vhci_hcd.c
index 2d2506c59881..e5660f0e97e8 100644
--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -830,15 +830,15 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flag
 no_need_xmit:
 	usb_hcd_unlink_urb_from_ep(hcd, urb);
 no_need_unlink:
-	spin_unlock_irqrestore(&vhci->lock, flags);
 	if (!ret) {
 		/* usb_hcd_giveback_urb() should be called with
 		 * irqs disabled
 		 */
-		local_irq_disable();
+		spin_unlock(&vhci->lock);
 		usb_hcd_giveback_urb(hcd, urb, urb->status);
-		local_irq_enable();
+		spin_lock(&vhci->lock);
 	}
+	spin_unlock_irqrestore(&vhci->lock, flags);
 	return ret;
 }
 
-- 
2.51.0



