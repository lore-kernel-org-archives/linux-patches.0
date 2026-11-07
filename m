Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062203;
	b=msDrPastPcss18LAr4CQG0ryfQUkLGMSOtoK3UaELBYh7t7bhRF2dnZodnDCc+7rXqbm
	 hJ44ZCjD6yTnBqkcz9yPPZGqoVd283Im0TIXUNY3fRhpvjZZyN1TQMbx0Ket5PtM7D21J
	 bnv9W+5LzDaB96pqdDsISMnKEeZIkMKhfxqo733MsnpBqTUktpOIdoWT9pJC3b0PXWMBd
	 ZZUXqogQcWGr9dUpAF0pa9I9pppu0q1SugVsATLdkb3bvbPjfGqQgTVJ8brwLsCQhkw7D
	 VbT5J5Iod2b/0V87ggrf4b/ghPIMbfhylMtQfqEOm3Sf6H9iHYlEv45n7IsEseM4Zcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062203;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i7cpCH5uET77srBlHSy2YzB29Wtn3jUgWHGgjLsnd4g=;
	b=5Uw0xPGHzQAuN9s4grrCU5eTQSdD5qSiYnVKvhfbN4wJtSxEOxz6M6Uby8CLqMGzE3U8
	 AsyGB2Je4qE0EZPq7kohjllErOdsbZDeBjYVsCVpS0b533o4OO8lkz8KnOjgeMkn/Ersz
	 pwEGbHGS6AZfNGZOsWJPTNV1jqZ6FAZxPLJoD3im5DfapJtviyAMwLr/oZqCYANe/UEDo
	 5fWSflkthIHTDut0JSWnibdGN3/gAQ13dWWOfWn4SjRoQ1+o5PirUlVoVRL+34GUntrtl
	 /6UVZ/FRWfj9ujh2SFpGpnxTqUF9zwzjfOZem0jWmOAs71SCvxo1qT4WmFZjxso4SKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZQDFe/+v";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDDB606A326;
	Sat,  7 Nov 2026 14:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZQDFe/+v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0571F008A2;
	Sat,  7 Nov 2026 14:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062202;
	bh=i7cpCH5uET77srBlHSy2YzB29Wtn3jUgWHGgjLsnd4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZQDFe/+vDqKbdPedDPMausRx9uuW2W2cc/TaoVPLL9A/mQc5BLQ6WhVwvlp5yRzHE
	 6hUhDAFb5RqYaaNr+tZOtSJNpSU7TC6znve7CAtvzQXIsocw/C774HQB7LWWleFtE9
	 gB9bgZsIFY/KHcVcH/MBhGuAl7MN5tyh/UKgyVPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1120/1536] media: exynos4-is: Fix a race between s_stream(0) and the interrupt handler
Date: Sat,  7 Nov 2026 08:52:16 -0500
Message-ID: <20261107135029.165028185@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1a4d754432154..6c24893295858 100644
--- a/drivers/media/platform/samsung/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/samsung/exynos4-is/fimc-lite.c
@@ -1211,9 +1211,8 @@ static int fimc_lite_subdev_s_stream(struct v4l2_subdev *sd, int on)
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



