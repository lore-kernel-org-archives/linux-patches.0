Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922F936B07E;
	Wed, 28 Jan 2026 15:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614109; cv=none; b=uc/6IvyMakxs4SWG6AMfLLDdFXv5kadFlCA4TOnRdkFba3JhQ9i0WWE0fGA+nQ3ZEhklV9jWZ4NQXWDH29mQXkNkcT6B32YWe3ltGMsn3RKNHSKC/Nwy7QXWdhntRMwPRwUliakx2ksqqIglHftZT3bragfKHWd/VrdCJL8qn5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614109; c=relaxed/simple;
	bh=mUfZPWNgeYljeG5W1hNaOXEalsgf/HNEWuh5NL0IviM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BESgD+1tIAEMWSWba3F/qQhyiGxzZ1VBwMaLVi3PRUneOZWCM1ZNINplla7nMyf7/i8FzSd13pmxjYsvi8DeLhqoewvrI/mwSYIN3V47yIfS60ptn7LL/5HdALj+Dp537HYgOjP1XeDjFzArYt+CEimMnM0FewcAq7+VIrMISo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zufXyWsq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zufXyWsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB9BC4CEF1;
	Wed, 28 Jan 2026 15:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614109;
	bh=mUfZPWNgeYljeG5W1hNaOXEalsgf/HNEWuh5NL0IviM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zufXyWsqi3rCzV/N6w3CJD6EycQdKNFC8LnJAKl5tHrVwGBXTS92UuBxya9IwrXml
	 uX5aXOqQFw2MJEQ8SOcw2fpxmjGTnzq2G59tX4B4WB8RgSec9eeIDHOtaQdul/gcLb
	 rJfB5Px3/CSnbASIZVwqJ6N6ZHtGh8HXY8Ox7BRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e8cb6691a7cf68256cb8@syzkaller.appspotmail.com,
	Szymon Wilczek <swilczek.lx@gmail.com>,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/254] can: etas_es58x: allow partial RX URB allocation to succeed
Date: Wed, 28 Jan 2026 16:19:43 +0100
Message-ID: <20260128145344.970220740@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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
index bb49a2c0a9a5c..77f193861bccc 100644
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



