Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C2514A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3752DC433C8;
	Thu, 24 Aug 2023 17:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897457;
	bh=SO8WX+LFmxXr6UUmFFPArPhPPckXGDD2R/YBK9GJ1GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qiA5VDNBUZhR7iEBHnPWW+xWCDMmVIKcaE7Y17lCMerM6c7udNxHyhhtDCYsp/dLg
	 ZwmTHPV//Kn7abqUvZu3kpA42DJdKT0JfrRJ53kS52c6f1kpihQUsV53FeaFVrkpXU
	 fZzmBmu5Og290F7L0b0MoxnFGJhtPzJ4gDDccW9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/135] usb: gadget: u_serial: Avoid spinlock recursion in __gs_console_push
Date: Thu, 24 Aug 2023 19:08:20 +0200
Message-ID: <20230824170618.376785621@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth K <quic_prashk@quicinc.com>

[ Upstream commit e5990469943c711cb00bfde6338d2add6c6d0bfe ]

When serial console over USB is enabled, gs_console_connect
queues gs_console_work, where it acquires the spinlock and
queues the usb request, and this request goes to gadget layer.
Now consider a situation where gadget layer prints something
to dmesg, this will eventually call gs_console_write() which
requires cons->lock. And this causes spinlock recursion. Avoid
this by excluding usb_ep_queue from the spinlock.

 spin_lock_irqsave //needs cons->lock
 gs_console_write
	.
	.
 _printk
 __warn_printk
 dev_warn/pr_err
	.
	.
 [USB Gadget Layer]
	.
	.
 usb_ep_queue
 gs_console_work
 __gs_console_push // acquires cons->lock
 process_one_work

Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Link: https://lore.kernel.org/r/1683638872-6885-1-git-send-email-quic_prashk@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/u_serial.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/function/u_serial.c b/drivers/usb/gadget/function/u_serial.c
index 3b5a6430e2418..a717b53847a8e 100644
--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -917,8 +917,11 @@ static void __gs_console_push(struct gs_console *cons)
 	}
 
 	req->length = size;
+
+	spin_unlock_irq(&cons->lock);
 	if (usb_ep_queue(ep, req, GFP_ATOMIC))
 		req->length = 0;
+	spin_lock_irq(&cons->lock);
 }
 
 static void gs_console_work(struct work_struct *work)
-- 
2.40.1



