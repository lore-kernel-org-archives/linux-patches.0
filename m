Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EC11946C8;
	Fri,  9 Jan 2026 12:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960760; cv=none; b=hOuj3vO7EylWWIWo0PqfUpUuOc03MptQ6BSatD3m8qczg7cMB93lIR3cjneRAOR5uBw/VHqWpsUrhOfSnECPWI5kQtSY8VfzSbetiLd86tZRyMDfU9ZD8NQRqMDB4oA2TYQ5SO6t/loyUYdL8B6OFxEkBiuf21zscb1Yn7SgvYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960760; c=relaxed/simple;
	bh=MH6xTNstf+C7Frz7f9h5V6XndKZm9tktYeEpS3Rwx2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oL+WqWmb8V4ydSRbHpM2zbk8/xe+aP+srFa11iU5b0Lif3vfSM5tmAoGPV10tAl+3E53v9873PmmI7a3YeXYcjtVnwGSRJHg9603wDHqBeh1S5MPM7x6WxavzGg1C+sHPU936SKkuvkzwzB8xPt1Tx0QPVNjJ93dmiWSmM5hbTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=syyszSwC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="syyszSwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20A7C4CEF1;
	Fri,  9 Jan 2026 12:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960760;
	bh=MH6xTNstf+C7Frz7f9h5V6XndKZm9tktYeEpS3Rwx2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=syyszSwCQicmO4DRjwTm82NiWuDki8JrnoMCvLX1UQhkfFJruymYn0BmbLWC7imre
	 2RdG8XTATSBMGRK+J4ty8mrg5pUcIm73JMterqwG9x5jdaroWLlv1HrX/slYv13PiK
	 DaVVj6QYHEg0PaelmmITI8+D4EVmOY+0o9X2AiGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8dd915c7cb0490fc8c52@syzkaller.appspotmail.com,
	Deepakkumar Karn <dkarn@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 515/737] net: usb: rtl8150: fix memory leak on usb_submit_urb() failure
Date: Fri,  9 Jan 2026 12:40:54 +0100
Message-ID: <20260109112153.374073120@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Deepakkumar Karn <dkarn@redhat.com>

[ Upstream commit 12cab1191d9890097171156d06bfa8d31f1e39c8 ]

In async_set_registers(), when usb_submit_urb() fails, the allocated
  async_req structure and URB are not freed, causing a memory leak.

  The completion callback async_set_reg_cb() is responsible for freeing
  these allocations, but it is only called after the URB is successfully
  submitted and completes (successfully or with error). If submission
  fails, the callback never runs and the memory is leaked.

  Fix this by freeing both the URB and the request structure in the error
  path when usb_submit_urb() fails.

Reported-by: syzbot+8dd915c7cb0490fc8c52@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8dd915c7cb0490fc8c52
Fixes: 4d12997a9bb3 ("drivers: net: usb: rtl8150: concurrent URB bugfix")
Signed-off-by: Deepakkumar Karn <dkarn@redhat.com>
Link: https://patch.msgid.link/20251216151304.59865-2-dkarn@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/rtl8150.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 278e6cb6f4d9..e40b0669d9f4 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -211,6 +211,8 @@ static int async_set_registers(rtl8150_t *dev, u16 indx, u16 size, u16 reg)
 		if (res == -ENODEV)
 			netif_device_detach(dev->netdev);
 		dev_err(&dev->udev->dev, "%s failed with %d\n", __func__, res);
+		kfree(req);
+		usb_free_urb(async_urb);
 	}
 	return res;
 }
-- 
2.51.0



