Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058348;
	b=qLXMcE5lkhZCTRetgXT+cZcwA8ouFvMVgWa8uww+aiQUj8dXvLziZghFe0bxNdfKCHF8
	 HDTiu7RjaAoMzaM6jTXxh1/J15fhUJvl6Friz//0BcWACq5OpEkhVKctIFbwJCTsFewcl
	 tedAOt7Q08wtUYLIknWK39IiC5G6yTyZOkpk2WPAdCn/P/zJv9VARwVM/7cXmLS6SV4IA
	 RUBnbakoJpN1/N7xcyIgu3PifEJzodCQw1pUHSoeYjgPQdTHL2LHh/4mfzhO50d0/uBdS
	 NnsCGzHsKpR/xKlrUdzz/YZU7jrhR0omJs2JUn4hGqUOHqhjLM09aDbGLqaSNXkAU6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058348;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qgDkHCf4TgNMhFPYQ8ansvn+aonS2Di+0n+RBp5gw+k=;
	b=EM544TapJWulLAY8l2XAQ0ACPByWQzReOzLhNg3C/vhtaxO8koaVSayIRGATuJpFh4eq
	 /FGO7aFrYRWPwUjXjISk2EgGFlBzJNs1Vd0IBYt1NCsITFGp6C4xB5G3abzhk/IA6QqwB
	 HnuTDJc8h4Iwvblz9rDCpObRX1QotlnMyN8vAS1B9rae8U/+e1PajRFCqsrbQwMZeOe+M
	 NM0pgJc9gRKEUX4uRUNhcJsTB+UXJrvti1M9BBojm5pp1FAOz57EslUEm/FW+4SRqOOW5
	 YUvtsAHsw06gldfP8H9wvijLm+RWP10HfHn5zRe9gVu68VsQ75Yi+e2z63ZUXSjsWoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kG5u+JmQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41769606A31C;
	Thu, 19 Nov 2026 03:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kG5u+JmQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D001F000C4;
	Thu, 19 Nov 2026 03:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058347;
	bh=qgDkHCf4TgNMhFPYQ8ansvn+aonS2Di+0n+RBp5gw+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kG5u+JmQWmKHuHgx3HOhNy7EyHHuC7hr0PyWY+cFXIwxDSoOtK99Pw5QjbOrg/Nho
	 HRAc6Hy4yyCYni+7pOY5n3EBNg/nuee5vrRH8bgdR3oY3KsNyxKS7OqCHl4uSpztI7
	 73Lxme/ActrcZQsIAhANMNksSy0oQvhDOD+g7i3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0454/1848] media: exynos4-is: Fix a race between s_stream(0) and the interrupt handler
Date: Wed, 18 Nov 2026 15:41:32 +0100
Message-ID: <20261118145933.495744091@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/media/platform/exynos4-is/fimc-lite.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index d279f282d5921..525ade8bb70b2 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1212,9 +1212,8 @@ static int fimc_lite_subdev_s_stream(struct v4l2_subdev *sd, int on)
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



