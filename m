Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309AC18A6D2;
	Tue, 10 Sep 2024 09:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961682; cv=none; b=IpOEWP39bipnzOQ21xVwSDmvTbHMm0uE13uwYiJwdGdOPsUi54oWe2BtboSglQyZS76Vt0wPZ2pVMKNFOfbjgXP2CQj8PtUtRjdgPhpoRveFAbtg6d2eUKQrHhBRtK/JxpQVIIsCGLgLP+UdZcJEnKhMkfTohhwkUCbpwlxJNQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961682; c=relaxed/simple;
	bh=T57nclyuoISE1CquRsqgWhSFuTtZnh+dn5Ml7DrP9NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2Q1uG+cXKQZglgkbDDKwAhvy82BayjyzVAgRrTT6/dr4upvAH2VHEkWBMjY4MfBm97PX27tIUDwLrzKvjcqXh1gDMuTOfWPxgj30o4cEE4kVcTd7szzIL7/dq0s7E7Muw9U6gJbLh9JbFsf3l26fMieWfx7afz3OKS9ygAWA6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MzQ/4nf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MzQ/4nf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7CBC4CEC6;
	Tue, 10 Sep 2024 09:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961682;
	bh=T57nclyuoISE1CquRsqgWhSFuTtZnh+dn5Ml7DrP9NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MzQ/4nf/4CcSh/SUuLhb84iB+XroYq0492acj1jlE6bNERJYaWzA9zICsIXXrcn7X
	 ZBoZPOwBrfTgWts21yDd7BT9MU5HJJ2vNvdy5sGloSSGWv4ID9kiQGX/rV7vIDIogU
	 cQrTcldJNKFtH6ln9ijvD29j8ICz6XSOHDP9Y+NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 152/375] can: m_can: disable_all_interrupts, not clear active_interrupts
Date: Tue, 10 Sep 2024 11:29:09 +0200
Message-ID: <20240910092627.576722865@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Schneider-Pargmann <msp@baylibre.com>

[ Upstream commit a572fea86c9b06cd3e6e89d79d565b52cb7e7cff ]

active_interrupts is a cache for the enabled interrupts and not the
global masking of interrupts. Do not clear this variable otherwise we
may loose the state of the interrupts.

Fixes: 07f25091ca02 ("can: m_can: Implement receive coalescing")
Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://lore.kernel.org/all/20240805183047.305630-6-msp@baylibre.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index d15655df6393..073842ab210d 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -449,7 +449,6 @@ static inline void m_can_disable_all_interrupts(struct m_can_classdev *cdev)
 {
 	m_can_coalescing_disable(cdev);
 	m_can_write(cdev, M_CAN_ILE, 0x0);
-	cdev->active_interrupts = 0x0;
 
 	if (!cdev->net->irq) {
 		dev_dbg(cdev->dev, "Stop hrtimer\n");
-- 
2.43.0



