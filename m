Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50F32D9488;
	Thu, 15 Jan 2026 17:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498955; cv=none; b=W95G1D6v5mRL1oUYKiwgvV9yQET2B84QlG+TCtt04+I/rytb+kf123hqQJQqAOjs1BkwZTjlSRfS0TQHJQhxwX5S0TqV3HC9D5KEQR4RuIxxW3zaT1X8NEJ9z6j/wLXlPrfjHaIIsgdhwq/OxbyXpXiE5sUZHz50kTGRUDMg/yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498955; c=relaxed/simple;
	bh=AV1M0K+WNRtEplGWKJjthm9rWJKi/OoADTljZuJcnEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0d3psKm3AR1CKpoWbfj/WfTPv7kWWnCvQ74O7fbAkiz0BXSRHvxNhrduA+GxngHUNVowfQzg+AXFlwE7V4CBTVDVrMNAOuAYTPtx7I+MEv751fhogPAfot633+7RBBR+tIH8tKeTWKV2axPqmjOY8GPesdP0XKhjwCeWbZnrts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A3bg/V3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3bg/V3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44323C116D0;
	Thu, 15 Jan 2026 17:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498955;
	bh=AV1M0K+WNRtEplGWKJjthm9rWJKi/OoADTljZuJcnEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A3bg/V3+ke+2z0DW1HyTzoUCQZpxG/1yf5AsWY43OePCyHEQNp5OaPy7GaXzNoxri
	 CcTRb5sbTpr4yC7M/iGH25pQgo9xqL/9+qxPkkOUA0SOv2l4BXt908INHgSiicmVY5
	 EKkA7ip6CZ8y/MBsPPy319ZtzxS3BvdStTKmeSD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7811bb68a317954a0347@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.10 025/451] comedi: multiq3: sanitize config options in multiq3_attach()
Date: Thu, 15 Jan 2026 17:43:46 +0100
Message-ID: <20260115164231.802160560@linuxfoundation.org>
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

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit f24c6e3a39fa355dabfb684c9ca82db579534e72 upstream.

Syzbot identified an issue [1] in multiq3_attach() that induces a
task timeout due to open() or COMEDI_DEVCONFIG ioctl operations,
specifically, in the case of multiq3 driver.

This problem arose when syzkaller managed to craft weird configuration
options used to specify the number of channels in encoder subdevice.
If a particularly great number is passed to s->n_chan in
multiq3_attach() via it->options[2], then multiple calls to
multiq3_encoder_reset() at the end of driver-specific attach() method
will be running for minutes, thus blocking tasks and affected devices
as well.

While this issue is most likely not too dangerous for real-life
devices, it still makes sense to sanitize configuration inputs. Enable
a sensible limit on the number of encoder chips (4 chips max, each
with 2 channels) to stop this behaviour from manifesting.

[1] Syzbot crash:
INFO: task syz.2.19:6067 blocked for more than 143 seconds.
...
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5254 [inline]
 __schedule+0x17c4/0x4d60 kernel/sched/core.c:6862
 __schedule_loop kernel/sched/core.c:6944 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6959
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7016
 __mutex_lock_common kernel/locking/mutex.c:676 [inline]
 __mutex_lock+0x7e6/0x1350 kernel/locking/mutex.c:760
 comedi_open+0xc0/0x590 drivers/comedi/comedi_fops.c:2868
 chrdev_open+0x4cc/0x5e0 fs/char_dev.c:414
 do_dentry_open+0x953/0x13f0 fs/open.c:965
 vfs_open+0x3b/0x340 fs/open.c:1097
...

Reported-by: syzbot+7811bb68a317954a0347@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7811bb68a317954a0347
Fixes: 77e01cdbad51 ("Staging: comedi: add multiq3 driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20251023132205.395753-1-n.zhandarovich@fintech.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/multiq3.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/staging/comedi/drivers/multiq3.c
+++ b/drivers/staging/comedi/drivers/multiq3.c
@@ -68,6 +68,11 @@
 #define MULTIQ3_TRSFRCNTR_OL		0x10	/* xfer CNTR to OL (x and y) */
 #define MULTIQ3_EFLAG_RESET		0x06	/* reset E bit of flag reg */
 
+/*
+ * Limit on the number of optional encoder channels
+ */
+#define MULTIQ3_MAX_ENC_CHANS		8
+
 static void multiq3_set_ctrl(struct comedi_device *dev, unsigned int bits)
 {
 	/*
@@ -313,6 +318,10 @@ static int multiq3_attach(struct comedi_
 	s->insn_read	= multiq3_encoder_insn_read;
 	s->insn_config	= multiq3_encoder_insn_config;
 
+	/* sanity check for number of encoder channels */
+	if (s->n_chan > MULTIQ3_MAX_ENC_CHANS)
+		s->n_chan = MULTIQ3_MAX_ENC_CHANS;
+
 	for (i = 0; i < s->n_chan; i++)
 		multiq3_encoder_reset(dev, i);
 


