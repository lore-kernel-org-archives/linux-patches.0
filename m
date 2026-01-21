Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49038369215;
	Wed, 21 Jan 2026 18:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019463; cv=none; b=eB3B9pfMiXYvUbIiR+OAbIjcXCxwD7gmOIp9sg0AZf9yixgCOSRlTFchUgDsZkOgaIDWiJDZYMNiC5wj4JPV96DqgRnGdnvFky/q8MkDIhZ+hhp+/iqgITj1Du/cUF8dapwRyeOoRn+OsoJDBRMqlWFjrGX4/JuJTFzA+HWT+uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019463; c=relaxed/simple;
	bh=BBFBy35/wxYWPcO8b3XU5zkhx01jSzT2OTzW0JOMjok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgQN863he3ejqbFR4GzKb9RqDTaT7mVG4CyyMRoYuIJadKsldX3uwGSde4MFuKScfeRO/Y+JUVxGnX1f4d1mhGwjLPIBpWYs2ayw2sigPkhpFnqsPtEe+TMUtr1Hr7FltQkBCHyRheNlxjy7BtbCWz/YBEL3cF22jhjpOh2Cgvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kfrlpS8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kfrlpS8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83150C4CEF1;
	Wed, 21 Jan 2026 18:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019462;
	bh=BBFBy35/wxYWPcO8b3XU5zkhx01jSzT2OTzW0JOMjok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kfrlpS8//S50uJbJptRriZ5wkyVSNUz+VwvBc0nhWsLP1O16n8CWS67J96HH1FXuy
	 Ozl/fhkaJBGxHKODJq2cYeAMZ8UGEgyP6X7zsMe/OCNUPXV7lrGV37O9X5kwu1Yaj6
	 rg9NZLCHuB/dt7FC/PhTk7jypxnWqQOiheilaLhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e8cb6691a7cf68256cb8@syzkaller.appspotmail.com,
	Szymon Wilczek <swilczek.lx@gmail.com>,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/139] can: etas_es58x: allow partial RX URB allocation to succeed
Date: Wed, 21 Jan 2026 19:14:22 +0100
Message-ID: <20260121181411.971993532@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Szymon Wilczek <swilczek.lx@gmail.com>

[ Upstream commit b1979778e98569c1e78c2c7f16bb24d76541ab00 ]

When es58x_alloc_rx_urbs() fails to allocate the requested number of
URBs but succeeds in allocating some, it returns an error code.
This causes es58x_open() to return early, skipping the cleanup label
'free_urbs', which leads to the anchored URBs being leaked.

As pointed out by maintainer Vincent Mailhol, the driver is designed
to handle partial URB allocation gracefully. Therefore, partial
allocation should not be treated as a fatal error.

Modify es58x_alloc_rx_urbs() to return 0 if at least one URB has been
allocated, restoring the intended behavior and preventing the leak
in es58x_open().

Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces")
Reported-by: syzbot+e8cb6691a7cf68256cb8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e8cb6691a7cf68256cb8
Signed-off-by: Szymon Wilczek <swilczek.lx@gmail.com>
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Link: https://patch.msgid.link/20251223011732.39361-1-swilczek.lx@gmail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 4fc9bed0d2e1e..d483cb7cfbcd5 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -1736,7 +1736,7 @@ static int es58x_alloc_rx_urbs(struct es58x_device *es58x_dev)
 	dev_dbg(dev, "%s: Allocated %d rx URBs each of size %u\n",
 		__func__, i, rx_buf_len);
 
-	return ret;
+	return 0;
 }
 
 /**
-- 
2.51.0



