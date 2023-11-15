Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE8A2836B
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5pHcVOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FEAC433C8;
	Wed, 15 Nov 2023 20:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081162;
	bh=263TiVKwma71NdauysdTr0i93lzradtWD9Q2BIhulPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5pHcVOkh2emnHLuEmQseTNDGTr2pE3iwL5U4lN9pHIgPSs4aG7KAV5Ku+IeLWWjd
	 fZ46oUmQuVDpreFZSGNFH0WQU1cYeVjnHqgWhdSPSJNLYMm+wl06Kwl+7WlTnZweLQ
	 uvDKXb19k1MBst2WbotqjtNAC0GFfsjdwE7cPMFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 51/88] leds: trigger: ledtrig-cpu:: Fix output may be truncated issue for cpu
Date: Wed, 15 Nov 2023 15:36:03 -0500
Message-ID: <20231115191429.223606090@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191426.221330369@linuxfoundation.org>
References: <20231115191426.221330369@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ff50f53276131a3059e8307d11293af388ed2bcd ]

In order to teach the compiler that 'trig->name' will never be truncated,
we need to tell it that 'cpu' is not negative.

When building with W=1, this fixes the following warnings:

  drivers/leds/trigger/ledtrig-cpu.c: In function ‘ledtrig_cpu_init’:
  drivers/leds/trigger/ledtrig-cpu.c:155:56: error: ‘%d’ directive output may be truncated writing between 1 and 11 bytes into a region of size 5 [-Werror=format-truncation=]
    155 |                 snprintf(trig->name, MAX_NAME_LEN, "cpu%d", cpu);
        |                                                        ^~
  drivers/leds/trigger/ledtrig-cpu.c:155:52: note: directive argument in the range [-2147483648, 7]
    155 |                 snprintf(trig->name, MAX_NAME_LEN, "cpu%d", cpu);
        |                                                    ^~~~~~~
  drivers/leds/trigger/ledtrig-cpu.c:155:17: note: ‘snprintf’ output between 5 and 15 bytes into a destination of size 8
    155 |                 snprintf(trig->name, MAX_NAME_LEN, "cpu%d", cpu);
        |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: 8f88731d052d ("led-triggers: create a trigger for CPU activity")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/3f4be7a99933cf8566e630da54f6ab913caac432.1695453322.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/trigger/ledtrig-cpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-cpu.c b/drivers/leds/trigger/ledtrig-cpu.c
index 1fca1ad00c3b9..19e068cadedfb 100644
--- a/drivers/leds/trigger/ledtrig-cpu.c
+++ b/drivers/leds/trigger/ledtrig-cpu.c
@@ -134,7 +134,7 @@ static int ledtrig_prepare_down_cpu(unsigned int cpu)
 
 static int __init ledtrig_cpu_init(void)
 {
-	int cpu;
+	unsigned int cpu;
 	int ret;
 
 	/* Supports up to 9999 cpu cores */
@@ -156,7 +156,7 @@ static int __init ledtrig_cpu_init(void)
 		if (cpu >= 8)
 			continue;
 
-		snprintf(trig->name, MAX_NAME_LEN, "cpu%d", cpu);
+		snprintf(trig->name, MAX_NAME_LEN, "cpu%u", cpu);
 
 		led_trigger_register_simple(trig->name, &trig->_trig);
 	}
-- 
2.42.0



