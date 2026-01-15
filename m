Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902683BFE43;
	Thu, 15 Jan 2026 17:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498252; cv=none; b=pZAHPX7BYt0GMA2dtGbcHTLFSAvLcYIlJZS6FQYGrPvndyVrGctziDDX0BfT6RS0Fr70negQSHFo0fjgU4NbAXAKivokJ9kG3BFp81X2BzqSh1Vj10ls5IPE203uvhMdsGHPPxzsgTsPKFdQelR8I+HLmEPgQIeTg8y7cBbWwBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498252; c=relaxed/simple;
	bh=J6QB77yQHYZL5DEIEmf7/dOZkraIKVyBJIzJA+Qk1YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRpRw6248O0sgPTUGtTtkkd2vJhLsfWFAT5vHUxdkLIgyHpwYpMyLxwfqmVZx7cCFZFfD7njLPRSRi9qX38VS1xFiZ6yTQBpeagafKX/94G0x+wmnOtEzl1awSvAYbRlUSv90gjvvXtj0awz837/4a2yWdhB17Q2NBgjN899lxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gz+kjURx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gz+kjURx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4EC7C116D0;
	Thu, 15 Jan 2026 17:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498252;
	bh=J6QB77yQHYZL5DEIEmf7/dOZkraIKVyBJIzJA+Qk1YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gz+kjURx4ZsW5Ml+VhSsCyELViZ82qW07sK2x1CCGjT5QioxZklov6GVfyF5y1K8b
	 P4ZMfLJp5qfAIhJkh0MWddfqeRsIGyKRcQ6cKxmtVoW+i6W1A3GBZG2vt6MylWxs0A
	 qchTJ04L3+bU0ejEtdPkd6xISzf3xt5N/988M18E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8dd915c7cb0490fc8c52@syzkaller.appspotmail.com,
	Deepakkumar Karn <dkarn@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 349/554] net: usb: rtl8150: fix memory leak on usb_submit_urb() failure
Date: Thu, 15 Jan 2026 17:46:55 +0100
Message-ID: <20260115164258.860403074@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
index 011cf3a35378..fa69d59a309a 100644
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



