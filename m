Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063119;
	b=M6ydOWoApC0pcogYSCsexAKZ7Z6Brvki9cz197t+267v88uEJACMxkRNY3OefXQVTEh6
	 jny16/Dd1HVPEK1N6cm5Tf0a9odvkUhJeJqkjdTViH4tvgVuXAPI/vKu5BeNOIsQ9bIeK
	 TRYLDtVBDle+08NyBNskUupomBoPILMmWTl79CyHfJDW+ILG0Tcnj7iPGxY2r9ILsX9CK
	 +qoiHtwYgCo7bqxPYkAzwWlPMlEpvOtIHpNY8c6wgPHBrEVXKkjvlrVAN2THfztP6A9e+
	 h9LIsLCmKel90PUWx96FlWqV9itHXxLK6HsZfgdqEu4SnBinRgXwurEviRG7IaDBZBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EFPKrLTGSbhrxib/0NUjMWV8cmdWi4elg5GOY9y4xHM=;
	b=BXWcgG/Q2v4mBX0urU+TDmNI1MsPS5ByUabY3nCC0uwrHG407RRwdNrmlWMBsj/pnFqb
	 0MdZ8OdpH7FI4Lf9ivEKNCTob/eMKMD0b2+TyIwAY1QugK4hltSfH0i1rS0J8Ol6KTkDj
	 ojCNI26MGHGTVGitp3pklZ6zpmGWDzXg8LjSUAmVN5SGJZD40AQrqlw6j3luxjYxSi2+1
	 G4IMYj0uMdWgWlYnkJDSwzPtycFEnY3zy9Ps+o1Ts7QVBU7s8m0npdFPTHMQEFZGxxPNr
	 HfhbanGppE3bMJV0LM9QBlQDUIbWDvUm/5hrpSzTi2d6ows2fu3P4Q1rN8V38ySTEWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bBNdmm73;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A428606A33B;
	Sat,  7 Nov 2026 14:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bBNdmm73
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5B71F0089F;
	Sat,  7 Nov 2026 14:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063118;
	bh=EFPKrLTGSbhrxib/0NUjMWV8cmdWi4elg5GOY9y4xHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bBNdmm73CDqZfupvkGwSPE2reYlgWexQmBwsnkH+vpwl/Q0NfOlWrtJP1ufLyhngX
	 hJc2W2xfub686L1VejJab5LfiFv12Uq/GWnNy/5EZIkz35ho3OJT+r60P9aVgrSixQ
	 zMbyWLmo6q+QZ4ohQnsSM+KABIJPTzbR9kJCilnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 313/869] media: exynos4-is: Fix a race between s_stream(0) and the interrupt handler
Date: Sat,  7 Nov 2026 08:49:55 -0500
Message-ID: <20261107134903.118316658@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0ce293b0718b6..0862fd14d41e3 100644
--- a/drivers/media/platform/samsung/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/samsung/exynos4-is/fimc-lite.c
@@ -1209,9 +1209,8 @@ static int fimc_lite_subdev_s_stream(struct v4l2_subdev *sd, int on)
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



