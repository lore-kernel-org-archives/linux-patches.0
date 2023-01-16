Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C8546B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A5FC433EF;
	Mon, 16 Jan 2023 16:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886250;
	bh=m7Cs7PtQTDJ9azT61YVLPH9M3zV/gyDEGAiUie6ovp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VTWBWoVic215z/KBFVrOrn/dfIA2ZtDeONEe8l4ivjOyQRST7y0Td1XktD4RD5pw1
	 Zs9ZAJEwifVmTROnCKQYYvIuyQZYJdK3UDxjDfmvGGiE4Cd0Xoey/Rzq4q3EgHTzP9
	 3RYEwrEAwXdl1PppeQJLmisKzRP/F/2fywapRSDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Renner Berthing <emil.renner.berthing@canonical.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 360/658] pwm: sifive: Call pwm_sifive_update_clock() while mutex is held
Date: Mon, 16 Jan 2023 16:47:28 +0100
Message-Id: <20230116154926.054900962@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 45558b3abb87eeb2cedb8a59cb2699c120b5102a ]

As was documented in commit 0f02f491b786 ("pwm: sifive: Reduce time the
controller lock is held") a caller of pwm_sifive_update_clock() must
hold the mutex. So fix pwm_sifive_clock_notifier() to grab the lock.

While this necessity was only documented later, the race exists since
the driver was introduced.

Fixes: 9e37a53eb051 ("pwm: sifive: Add a driver for SiFive SoC PWM")
Reported-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Reviewed-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Link: https://lore.kernel.org/r/20221018061656.1428111-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-sifive.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-sifive.c b/drivers/pwm/pwm-sifive.c
index cc63f9baa481..538297ef8255 100644
--- a/drivers/pwm/pwm-sifive.c
+++ b/drivers/pwm/pwm-sifive.c
@@ -221,8 +221,11 @@ static int pwm_sifive_clock_notifier(struct notifier_block *nb,
 	struct pwm_sifive_ddata *ddata =
 		container_of(nb, struct pwm_sifive_ddata, notifier);
 
-	if (event == POST_RATE_CHANGE)
+	if (event == POST_RATE_CHANGE) {
+		mutex_lock(&ddata->lock);
 		pwm_sifive_update_clock(ddata, ndata->new_rate);
+		mutex_unlock(&ddata->lock);
+	}
 
 	return NOTIFY_OK;
 }
-- 
2.35.1



