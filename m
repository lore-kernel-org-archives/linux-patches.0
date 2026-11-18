Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036326;
	b=GI56ohaJjnFantuODxcEErrv22PW7FCgV7+hgYXSPXPJNvGGM1jvhFGwxiOjPfZWXEOp
	 WvCKr+zI3fPuiK2tf71NbXwJlYasPjwEUrtKe78nTqbU4vJP73DdWqiE4lV/gT1U2XYmM
	 zTYBCm/wZUHQr6Yosw0jgRxInHH2q3aLnIE8ayV+4IMz024645B2lhmpWuZI5drpxJmt7
	 wj6NcLpivVXR1otjVJV2bv0ayr1EOWd6XKDZsvrOHax+0cYgH93cjojI3J8tmgQ2wbBOd
	 WycLh4LWi3R2bb/sl2QNhLUb53Bqh7gyXDdrieYlowAInbwWAnEJpQrttGyk4g4taaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zbY3XeuQz6uRg43PDMZEqZvYYv0Fr6+qvRi+99KEJ/A=;
	b=WMLKG2Tex1OpwP1tDUgtsDndcp2k33G3U6ZIlwNMM8RMmDjcp8tigu3B8lxcGrgTZqXy
	 shg3bJIA369KkvP1Y+MgV6giIlgslhk5dKSpOU0W+6PeDb179/lTVDtRVq3II7O+4RUYo
	 GWV117iD5q8JJEujEeszteueqhw28k67A8a6xzoKDTssP1aLTAPgs9Zbu3UpTu9LGAoyP
	 rR1/Y7P/1SJ6B6vHoHdlhhv8950xqNreBFrVhk2QNhfIB4N/YZnSVKETuj2YHUeRhLEuS
	 MpELzVN5JDTftRcW/ZqzmZZF+hHmtBNz9cGx/DiMzbANvxgfUFRYfSyuVyuiqIMnL/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AUdG5BuL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FCA606A325;
	Wed, 18 Nov 2026 21:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AUdG5BuL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072191F000C4;
	Wed, 18 Nov 2026 21:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036325;
	bh=zbY3XeuQz6uRg43PDMZEqZvYYv0Fr6+qvRi+99KEJ/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AUdG5BuLHnMuYAeIcd04/e8eTETlvLZROM2pRpFC3aDnGicyndBfdzZ6lACGkhElU
	 mw5FlXFRq4ZA8xJ/NC7VOSH3YI5GiSdlIDFCXN8Y+qiY2XSZTDrTt4qLUTElmuEzNx
	 Uk57OPnrF4i7zhdbltfWt/EEpoT5Cz81goi9Y4AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0976/3318] media: exynos4-is: Fix a race between s_stream(0) and the interrupt handler
Date: Wed, 18 Nov 2026 15:26:38 +0100
Message-ID: <20261118150349.005187440@linuxfoundation.org>
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

From: Ginger Li <ginger.jzllee@gmail.com>

[ Upstream commit c65eb69f8170975802ddbede84420553eb681d62 ]

fimc_lite_subdev_s_stream(on = 0) sets ST_FLITE_OFF outside of the
fimc->slock protected region, and only then stops the capture in the
hardware.  flite_irq_handler() runs under fimc->slock and clears
ST_FLITE_OFF, so an interrupt can be handled in between: the handler finds
ST_FLITE_OFF already set, clears it and wakes up fimc->irq_queue before the
capture has actually been stopped.  The wait_event_timeout() right after it
then returns immediately and the driver continues as if the capture had
stopped.

Set ST_FLITE_OFF in the same critical section that stops the capture, as
fimc_lite_stop_capture() already does.

Fixes: 6319d6a002be ("[media] fimc-lite: Add ISP FIFO output support")
Cc: stable@vger.kernel.org
Signed-off-by: Ginger Li <ginger.jzllee@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/samsung/exynos4-is/fimc-lite.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/samsung/exynos4-is/fimc-lite.c b/drivers/media/platform/samsung/exynos4-is/fimc-lite.c
index 9396b10b5b1cc..dcf235d7d9317 100644
--- a/drivers/media/platform/samsung/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/samsung/exynos4-is/fimc-lite.c
@@ -1213,9 +1213,8 @@ static int fimc_lite_subdev_s_stream(struct v4l2_subdev *sd, int on)
 			spin_unlock_irqrestore(&fimc->slock, flags);
 		}
 	} else {
-		set_bit(ST_FLITE_OFF, &fimc->state);
-
 		spin_lock_irqsave(&fimc->slock, flags);
+		set_bit(ST_FLITE_OFF, &fimc->state);
 		flite_hw_capture_stop(fimc);
 		spin_unlock_irqrestore(&fimc->slock, flags);
 
-- 
2.53.0



