Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F2A42189F;
	Wed,  4 Feb 2026 15:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217435; cv=none; b=O3ek91QjRPFjbyyMZH9rmL71oV6LhWAp8+N7kdfQa+mpGIJhNY3TuuMeYyfoRpUyNa7lBEx297+P+QGswPFQ6VNDrsBMMVVNmx/Izv/vhi37+qDGgDWuq6CJFdJkPbd6QTqeahkkA3Ci/hC3QrLPWehFPOh3uTD943gTBVWkb6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217435; c=relaxed/simple;
	bh=NpXE1MInl9BqsKrjEEM9kuB2e70bG/CAOmmU63iq0qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDe2Oh9/MaHEgl2fnOJVyedDMn35Ne27nZZJt1vuvgC0km3dQLQ2rfIIoWdUTYeu/c/OP9EmhbbrAs/ZQHf1z64Jr1PxwAIBbACxh3Q9ATsXmRqTLbOiRrDihGbYG6yFphI5F5MOMsW7eTBp20ProIftnIdA40T3T5ZxMtnPGsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJ1sxC3d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJ1sxC3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A10C4CEF7;
	Wed,  4 Feb 2026 15:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217435;
	bh=NpXE1MInl9BqsKrjEEM9kuB2e70bG/CAOmmU63iq0qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJ1sxC3dM1QKV3sDcso89PlKwJcGd2HX7FfgGdDf2vJei33ZTzzHub6ja075xDF54
	 bP7+OpM8XlUCpqgz5NT4cShqHY+yRtWe9oCzmRa8k7XqDpnpY+z7AlWylZtRUt0gj1
	 2UfH2vMFXWr99tL0hT4WS0xdhATpL6oEsk8dtr2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e8cb6691a7cf68256cb8@syzkaller.appspotmail.com,
	Szymon Wilczek <swilczek.lx@gmail.com>,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/280] can: etas_es58x: allow partial RX URB allocation to succeed
Date: Wed,  4 Feb 2026 15:36:20 +0100
Message-ID: <20260204143909.855193874@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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
index 41bea531234db..6995fbce829ad 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -1735,7 +1735,7 @@ static int es58x_alloc_rx_urbs(struct es58x_device *es58x_dev)
 	dev_dbg(dev, "%s: Allocated %d rx URBs each of size %u\n",
 		__func__, i, rx_buf_len);
 
-	return ret;
+	return 0;
 }
 
 /**
-- 
2.51.0



