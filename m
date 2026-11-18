Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045227;
	b=txj0ZN3YWhOGPOyMr280DAKQ6wKCzMX16ox4nGIvOhgkaptRaUyzgKfPWUdJYsti+8C3
	 E6JojtVnG0xvzRmoVLNRbPNF6faru+90sQMuefkhNYLRRrx1ajR3bNeo7lusF3RAC0he9
	 zxj68cRE4RtQKWyvedQ8RgDabV2VSC9G0Gn+mAlZtB4LPUBpZ930zoDQGthbs88PqH15V
	 cQZ1gwnyjvPTqPqx2Ic8tpVRq5H8kXYzQIj+EIYTl6IcQklBSLvDKkeaeShJySy2qADHq
	 YA+25iejajcMEsHlZ/qaQZUcXcIKrfT/4YfYBTi/qyms6kII1aUdlzQhUH55ipc6FDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1cPO2n0Sd66VtBKDOteKeRh4cnZm6l2FmQJnLbRdISE=;
	b=DiV01pXzj5vsZYfahaxHL1m7CbzflT/lOV+13naSZJBwZS+f8XNnnJJcuCsfVUZMIYc1
	 +uvHb8xe9nKbSl5fQd5/hP4aC3e15JfjKGzonlaqxEg+4Sl2t7f1VZQkt0WsiSIuYrgwz
	 q/Ziak4dUFTM3M4CwxTKuzamkLAPe6c7ok2bDa+BwX2WqDyHsAfYxQ8beHX8xAbIuZNvp
	 jsqpwFmmtekLdlUOCTPqWVjqae7Yn0WDJ52Sq3CxHPPYB3mmUJV5+w/RmQ/yc5Fe5Rz7D
	 wIXZq/eOUie1bi3dGj4pGhnpXGl7NKQhD9WyPqtj6+uUiweBvgQSNzZuVwcD8ppIMXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OkOHwC6d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80810606A325;
	Wed, 18 Nov 2026 23:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OkOHwC6d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8ED1F000C4;
	Wed, 18 Nov 2026 23:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045227;
	bh=1cPO2n0Sd66VtBKDOteKeRh4cnZm6l2FmQJnLbRdISE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OkOHwC6dvBHCgZR1CU5orx8HU+VTnk8e6DRsk0pXqODJRP2jAp/OOeybVq82wQIjd
	 x6VNe8t2jdZ0tTJz4lOd54/+14kjK7K0OFY61J7WggcK1NKsgyAaj3rz+mS2tpQNot
	 gPjRu/eNwZV02SmZDvi/Cvh4JIDm3qlW8y1Esj/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0849/2857] media: exynos4-is: Fix a race between s_stream(0) and the interrupt handler
Date: Wed, 18 Nov 2026 15:31:23 +0100
Message-ID: <20261118150232.141719163@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e185a40305a8f..ee36c96ea80aa 100644
--- a/drivers/media/platform/samsung/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/samsung/exynos4-is/fimc-lite.c
@@ -1210,9 +1210,8 @@ static int fimc_lite_subdev_s_stream(struct v4l2_subdev *sd, int on)
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



