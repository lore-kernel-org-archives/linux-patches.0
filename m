Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD931741C4;
	Wed,  3 Jul 2024 10:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003476; cv=none; b=MNPqBv3EjffCXUZth7vp1HGoh7LHouKe6CokBPs6Gpb43VyuqJxqw78lDUO6GwANYDh5kSNzsskWXS2bwnNRDraKy0IkrSUfguXbwVqSvAkkb8zHm5Pz/WI6OrLRZH80EG9PB0kJLgxXlQ6Bpy8BLzWLuEEeC5uW2KpduZPIsU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003476; c=relaxed/simple;
	bh=3Yu+UU6vaPrhQqXYocTs5xy1rRslQ6L1N7cLgKCZ73s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoEECyCwAIevlNrVeFdNZwMKtB6kaOO+IY9wBs5B6zUzJM5qoR/AMRrr4igVNGpzSXirpHVYFr/JvdbdKs/i7kqyXd2jQtk+9i9X77OhFM9x7r7eL5hlA9mIB77RfSb9HqfABaeq3ifDPvTiKuqLcZuOL0uFmkNg26pzczyMZ0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnuwDY+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnuwDY+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962E3C2BD10;
	Wed,  3 Jul 2024 10:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003476;
	bh=3Yu+UU6vaPrhQqXYocTs5xy1rRslQ6L1N7cLgKCZ73s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SnuwDY+QpbCGIOKA5qUcn1YRSqmch7AGcnp66Nx5AmaJZl5BU0Q8jiRlY4W0kpOKk
	 vW15YJH+yDQe30lB44UK2UT4MIP7ND5xzpcFbP4rqTpWMT2ERRUrqJV+JsXpler6KH
	 nhr+XOHWV+AzJpvO7aFmdzR9txmmP7P3Mw2UiJvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	syzbot+5f996b83575ef4058638@syzkaller.appspotmail.com,
	syzbot+1b2abad17596ad03dcff@syzkaller.appspotmail.com
Subject: [PATCH 4.19 029/139] USB: class: cdc-wdm: Fix CPU lockup caused by excessive log messages
Date: Wed,  3 Jul 2024 12:38:46 +0200
Message-ID: <20240703102831.541933241@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 22f00812862564b314784167a89f27b444f82a46 upstream.

The syzbot fuzzer found that the interrupt-URB completion callback in
the cdc-wdm driver was taking too long, and the driver's immediate
resubmission of interrupt URBs with -EPROTO status combined with the
dummy-hcd emulation to cause a CPU lockup:

cdc_wdm 1-1:1.0: nonzero urb status received: -71
cdc_wdm 1-1:1.0: wdm_int_callback - 0 bytes
watchdog: BUG: soft lockup - CPU#0 stuck for 26s! [syz-executor782:6625]
CPU#0 Utilization every 4s during lockup:
	#1:  98% system,	  0% softirq,	  3% hardirq,	  0% idle
	#2:  98% system,	  0% softirq,	  3% hardirq,	  0% idle
	#3:  98% system,	  0% softirq,	  3% hardirq,	  0% idle
	#4:  98% system,	  0% softirq,	  3% hardirq,	  0% idle
	#5:  98% system,	  1% softirq,	  3% hardirq,	  0% idle
Modules linked in:
irq event stamp: 73096
hardirqs last  enabled at (73095): [<ffff80008037bc00>] console_emit_next_record kernel/printk/printk.c:2935 [inline]
hardirqs last  enabled at (73095): [<ffff80008037bc00>] console_flush_all+0x650/0xb74 kernel/printk/printk.c:2994
hardirqs last disabled at (73096): [<ffff80008af10b00>] __el1_irq arch/arm64/kernel/entry-common.c:533 [inline]
hardirqs last disabled at (73096): [<ffff80008af10b00>] el1_interrupt+0x24/0x68 arch/arm64/kernel/entry-common.c:551
softirqs last  enabled at (73048): [<ffff8000801ea530>] softirq_handle_end kernel/softirq.c:400 [inline]
softirqs last  enabled at (73048): [<ffff8000801ea530>] handle_softirqs+0xa60/0xc34 kernel/softirq.c:582
softirqs last disabled at (73043): [<ffff800080020de8>] __do_softirq+0x14/0x20 kernel/softirq.c:588
CPU: 0 PID: 6625 Comm: syz-executor782 Tainted: G        W          6.10.0-rc2-syzkaller-g8867bbd4a056 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024

Testing showed that the problem did not occur if the two error
messages -- the first two lines above -- were removed; apparently adding
material to the kernel log takes a surprisingly large amount of time.

In any case, the best approach for preventing these lockups and to
avoid spamming the log with thousands of error messages per second is
to ratelimit the two dev_err() calls.  Therefore we replace them with
dev_err_ratelimited().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Suggested-by: Greg KH <gregkh@linuxfoundation.org>
Reported-and-tested-by: syzbot+5f996b83575ef4058638@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-usb/00000000000073d54b061a6a1c65@google.com/
Reported-and-tested-by: syzbot+1b2abad17596ad03dcff@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-usb/000000000000f45085061aa9b37e@google.com/
Fixes: 9908a32e94de ("USB: remove err() macro from usb class drivers")
Link: https://lore.kernel.org/linux-usb/40dfa45b-5f21-4eef-a8c1-51a2f320e267@rowland.harvard.edu/
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/29855215-52f5-4385-b058-91f42c2bee18@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -252,14 +252,14 @@ static void wdm_int_callback(struct urb
 			dev_err(&desc->intf->dev, "Stall on int endpoint\n");
 			goto sw; /* halt is cleared in work */
 		default:
-			dev_err(&desc->intf->dev,
+			dev_err_ratelimited(&desc->intf->dev,
 				"nonzero urb status received: %d\n", status);
 			break;
 		}
 	}
 
 	if (urb->actual_length < sizeof(struct usb_cdc_notification)) {
-		dev_err(&desc->intf->dev, "wdm_int_callback - %d bytes\n",
+		dev_err_ratelimited(&desc->intf->dev, "wdm_int_callback - %d bytes\n",
 			urb->actual_length);
 		goto exit;
 	}


