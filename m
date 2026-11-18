Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038398;
	b=zRqB7fBboJtPZI0XV8YjDpdw6wt8f7Hmk/HxSD9IU6S6SilFUNNLMgc3HDsmkcw8xHOa
	 zxHp0GKHez2jSp4phwOxsiObpIGQXR2hoikBdQrgqDeztIdHvOSk4ddsU6LOWw3b5n6+R
	 N0fyB0Rt2YikT+XtEWjZ/qKjWtIWU4p4TE2F9Mxz8UasiWwi7ZOskI1GeIUuJ5aGI/Z9P
	 KveMbed0fidzzCdOQUi0kbZ1mSfMWyoTXsv/iU/uZREK+SkT8em90uHQuEU1OOcgD+TZ9
	 FxXHNWB3mJOVBXYY3soq4yxSxaZVWtVo+nSqfLnQQFm9SAZNa0e0Fb1sGKYou8ehXyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038398;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nOt+AMzNgzuEzM+3YaMpDCb2mfZBUsfV/A1H/IEgEvw=;
	b=f5uwNB+nhgv5sxZshjUoJOpQvHs797XgTIfGLni51w7HwDmztY32b0rklOg/GhuhouUF
	 oYdc8pr0JbWpW/adWNakAuD6Qyc2ebJAL8NzoVU2UcJnZa367Y6yQFdcIvmDvADWLI+sh
	 JFtEHkCeo3odWNRjC4MhJmk4CSPxGbNPp8yFxGbkwPiiks83FSPmiJmiqYtEdhbs0ijVm
	 HXOy9FPQ8X0zKZYjrnf+A4GhCSD8Ots6C9seAgDDycNe3NTRPJXtedOts2wYzgWbyuApU
	 Mgmo3XJDHwATQSHYRfvgojC7i0m+fFIU6i6tWyGT7awUfp+J+97ByTz/G571L3p1yEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=00tSwdnH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F7D606A320;
	Wed, 18 Nov 2026 21:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=00tSwdnH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CAA1F000C5;
	Wed, 18 Nov 2026 21:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038398;
	bh=nOt+AMzNgzuEzM+3YaMpDCb2mfZBUsfV/A1H/IEgEvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=00tSwdnHYNOOJDbXtDvX1mpLuwPnfPzkZY7/03CvU8BXNyEQhbXx3PyOUKi9jJOuX
	 FfxlMmd1SCCLlDerxj9l/PDOS48eLkHSSHh0L5jU7zeSovq1Q5HpddrwMeyxvpfkcT
	 jqwA0zWmDYUleNTVJvG/gA+sB2cY2vThLNsZKCBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Fuzzey <martin.fuzzey@flowbird.group>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1729/3318] serial: sc16is7xx: fix data corruption due to unexpected xon/xoff
Date: Wed, 18 Nov 2026 15:39:11 +0100
Message-ID: <20261118150413.737997331@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Fuzzey <martin.fuzzey@flowbird.group>

[ Upstream commit 8bb50e95c0abd44607bc60a43032c1dbf7470d5a ]

The hardware supports automatically sending XON/OFF based on the
FIFO status and that is already implemented by the driver.
However that capability was not announced with the UPF_SOFT_FLOW bit.

When the port is opened with the default of XON enabled the driver
configures that in the hardware.
If userspace does not want XON/OFF (which is normally the case) it will
use TCSETS to disactivate it. However the serial core optimises this
to only notify the driver if someting imporant has changed, and for
XON/XOFF thit is only if the  driver declares UPF_SOFT_FLOW.

So we end up with unwanted XON/XOFF in the data stream.

The problem only occurs if nothing else needed to be set by termios,
ie if the user space requested values are the same as the default values,
except for XON/XOFF.
Since the default speed is 9600 this means that the problem only occurs
when requesting 9600, otherwise the call to the driver will be made to
change the speed, and that will also clear the XON/XOFF.
As 9600 is quite rare these days that probably explains why this hasn't
already been seen.

It also only occurs on the first port open after boot since the subsequent
opens will use the "logical state" set by TCSETS but not communicated to
the driver the first time.

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
Fixes: dfeae619d781 ("serial: sc16is7xx")
Cc: stable@kernel.org
Link: https://patch.msgid.link/20261001100534.1225894-1-martin.fuzzey@flowbird.group
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 34260d06b114b..7278977a66ca0 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1588,7 +1588,7 @@ static int sc16is7xx_probe(struct device *dev,
 		s->p[i].port.irq	= irq;
 		s->p[i].port.type	= PORT_SC16IS7XX;
 		s->p[i].port.fifosize	= SC16IS7XX_FIFO_SIZE;
-		s->p[i].port.flags	= UPF_FIXED_TYPE | UPF_LOW_LATENCY;
+		s->p[i].port.flags	= UPF_FIXED_TYPE | UPF_LOW_LATENCY | UPF_SOFT_FLOW;
 		s->p[i].port.iobase	= i;
 		/*
 		 * Use all ones as membase to make sure uart_configure_port() in
-- 
2.53.0



