Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5B41C32EB;
	Tue,  8 Oct 2024 13:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393012; cv=none; b=GGbURfxwBvH9l00XcQ3EDwTOVmeG8IAjCDzy208WyIIvohzcuw3RNc4dXjzQACkP2BkQ5iE1ouVvP8YgSQg2MKW3XjgNtut/l0IdgP5pEP0L26bcAY2XvlM64DMn+8GLFLt1K9pgJ57LdcmTqb44M2etkT1enHrV+ulSiRi2Srw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393012; c=relaxed/simple;
	bh=A6iheNIUpMozOMipg1i+1S39MXPkST9LFZtdPqjDVPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIbuPg4iW1oEI5jBFD7AE/d9E+M0KMZs5m1P1wxwQZzJcCATMJ87jRKgNk78qUpbLl0Lh8boDQB93ku1mFU3ZdpolAxW4lFyESchJgq33aA0TsSYCN4rU+h42kYzz3z8zIRXzUTiJT/bvgJ2/9DXRVZkk6zpty/vrJle1jtwJeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QPgSgaGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QPgSgaGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1B5C4CEC7;
	Tue,  8 Oct 2024 13:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393012;
	bh=A6iheNIUpMozOMipg1i+1S39MXPkST9LFZtdPqjDVPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QPgSgaGXiPFl3LLNCpw9EbZKParuv8EqWexEITJnKGpHj3kbLiKkOEecWqlRA2yAk
	 9sTeVemc1RdelHpe4bDNQO1SkhPOJP7m4dJWWQNVjyc3t44jvq/7lyhD1aRDytZZUs
	 Au/3Pe7py1w6Ug6fvcQfRUFX1/Hoq8+C52XnMZHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/386] mailbox: bcm2835: Fix timeout during suspend mode
Date: Tue,  8 Oct 2024 14:04:14 +0200
Message-ID: <20241008115629.687589505@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit dc09f007caed3b2f6a3b6bd7e13777557ae22bfd ]

During noirq suspend phase the Raspberry Pi power driver suffer of
firmware property timeouts. The reason is that the IRQ of the underlying
BCM2835 mailbox is disabled and rpi_firmware_property_list() will always
run into a timeout [1].

Since the VideoCore side isn't consider as a wakeup source, set the
IRQF_NO_SUSPEND flag for the mailbox IRQ in order to keep it enabled
during suspend-resume cycle.

[1]
PM: late suspend of devices complete after 1.754 msecs
WARNING: CPU: 0 PID: 438 at drivers/firmware/raspberrypi.c:128
 rpi_firmware_property_list+0x204/0x22c
Firmware transaction 0x00028001 timeout
Modules linked in:
CPU: 0 PID: 438 Comm: bash Tainted: G         C         6.9.3-dirty #17
Hardware name: BCM2835
Call trace:
unwind_backtrace from show_stack+0x18/0x1c
show_stack from dump_stack_lvl+0x34/0x44
dump_stack_lvl from __warn+0x88/0xec
__warn from warn_slowpath_fmt+0x7c/0xb0
warn_slowpath_fmt from rpi_firmware_property_list+0x204/0x22c
rpi_firmware_property_list from rpi_firmware_property+0x68/0x8c
rpi_firmware_property from rpi_firmware_set_power+0x54/0xc0
rpi_firmware_set_power from _genpd_power_off+0xe4/0x148
_genpd_power_off from genpd_sync_power_off+0x7c/0x11c
genpd_sync_power_off from genpd_finish_suspend+0xcc/0xe0
genpd_finish_suspend from dpm_run_callback+0x78/0xd0
dpm_run_callback from device_suspend_noirq+0xc0/0x238
device_suspend_noirq from dpm_suspend_noirq+0xb0/0x168
dpm_suspend_noirq from suspend_devices_and_enter+0x1b8/0x5ac
suspend_devices_and_enter from pm_suspend+0x254/0x2e4
pm_suspend from state_store+0xa8/0xd4
state_store from kernfs_fop_write_iter+0x154/0x1a0
kernfs_fop_write_iter from vfs_write+0x12c/0x184
vfs_write from ksys_write+0x78/0xc0
ksys_write from ret_fast_syscall+0x0/0x54
Exception stack(0xcc93dfa8 to 0xcc93dff0)
[...]
PM: noirq suspend of devices complete after 3095.584 msecs

Link: https://github.com/raspberrypi/firmware/issues/1894
Fixes: 0bae6af6d704 ("mailbox: Enable BCM2835 mailbox support")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/bcm2835-mailbox.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/bcm2835-mailbox.c b/drivers/mailbox/bcm2835-mailbox.c
index fbfd0202047c3..ea12fb8d24015 100644
--- a/drivers/mailbox/bcm2835-mailbox.c
+++ b/drivers/mailbox/bcm2835-mailbox.c
@@ -145,7 +145,8 @@ static int bcm2835_mbox_probe(struct platform_device *pdev)
 	spin_lock_init(&mbox->lock);
 
 	ret = devm_request_irq(dev, irq_of_parse_and_map(dev->of_node, 0),
-			       bcm2835_mbox_irq, 0, dev_name(dev), mbox);
+			       bcm2835_mbox_irq, IRQF_NO_SUSPEND, dev_name(dev),
+			       mbox);
 	if (ret) {
 		dev_err(dev, "Failed to register a mailbox IRQ handler: %d\n",
 			ret);
-- 
2.43.0



