Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040711;
	b=DUI6CmTTQoFXVsd4/Y1zdjA3Atjr6zeq6tjujDBFHH9T8yWTeQ0mTeqNur8891It60Zp
	 kJaGxbsa+NGAXRQ8L1TSkrnGusYTY43hCI5ML9Fu0mJ/9u9co7LcOW2Od+XLdW/vE6BU5
	 Tox2myEwwff/PDOYtCe3Xjqe125HnN+DakE4rEWe3VcvIjyyLpL8ithrkv5OwElBVaBiw
	 tcSaoGH8he2erx0j1VCw7o7JtO9aIVsxoK1NWhJxtFIc6lx43Kncu7Ec7XwH+/uqbvuJ2
	 RevIaHvQGNDslQfKkX+n5b4U9wrQilQdQp0dqk/MO5DGddcA08EAmnBnCbFfuX32KbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K6sn5QzRKpQxcZ11ImS64AJt5LC+IrIIjrsS1CavtNM=;
	b=2cEeDxI4gK2Y2iOvsP7MMMGxUAH60hElmbCe/lmVj+vRaI6GQZZac8vWMErLWCw5NtNJ
	 8OpisUnMAJTE6rUimwla+q0WeHJKPWkcxdMbTIRHUAFwSIX2mfhAzTfVxP0U7adLSeWzz
	 mptsquJnjIXIxM2+3kmunbZPbwtCfb0Nsb6F7yLnnSxBgBAqF0eE6SvHEhp+NYgtBrArS
	 n/NMW/bq7gihYHji3yrkj5a8ght08k5aLAUtdwRIhUavvX5F/jVCortWpJAT40yNiAF6m
	 Rd7CuKOQjft2N70+FEcXQNaSbu8jJipFLTAzRpd4jXoKEuI4kbtTX5+Fp0uoj8bEXvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LwFHvO69;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B694606A320;
	Wed, 18 Nov 2026 22:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LwFHvO69
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9311F000C4;
	Wed, 18 Nov 2026 22:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040711;
	bh=K6sn5QzRKpQxcZ11ImS64AJt5LC+IrIIjrsS1CavtNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LwFHvO69FliaS+8kpTuSfw6ya7WEn7sj4kDAbfMpXR3hAHcmWzlHgS6ArcXfq+8nS
	 M+ZXVNFXTiL6yA1uGDWCpqMVe10gkDxoABbYqdgwQjFPbrmFVlLgPHQ8LS7H4xnOZ/
	 BcQpOaVJmbs2zz6pcI5ifEsuiPzJWEPU6zjwjmZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2555/3318] power: supply: ab8500_btemp: Fix event temperature reporting
Date: Wed, 18 Nov 2026 15:52:57 +0100
Message-ID: <20261118150437.925987298@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 95990cda8e42dda4bd3f1475d578323981bd8579 ]

The event-aware path initializes its local temperature to zero and
compares that zero against the thermal thresholds. Consequently some
events report the measured temperature after it crosses the event
threshold, while others always report the threshold.

Start with the measured temperature, clamp it according to the active
event, and convert to tenths of a degree only once. This path is used
by AB8505 and later variants.

Fixes: 1f855824757e ("ab8500-btemp: AB8500 battery temperature driver")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-5-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_btemp.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/power/supply/ab8500_btemp.c b/drivers/power/supply/ab8500_btemp.c
index 1c6aed46091e9..9083c7c56aed4 100644
--- a/drivers/power/supply/ab8500_btemp.c
+++ b/drivers/power/supply/ab8500_btemp.c
@@ -468,39 +468,29 @@ static void ab8500_btemp_periodic(struct ab8500_btemp *di,
  */
 static int ab8500_btemp_get_temp(struct ab8500_btemp *di)
 {
-	int temp = 0;
+	int temp = di->bat_temp;
 
 	/*
 	 * The BTEMP events are not reliabe on AB8500 cut3.3
 	 * and prior versions
 	 */
-	if (is_ab8500_3p3_or_earlier(di->parent)) {
-		temp = di->bat_temp * 10;
-	} else {
+	if (!is_ab8500_3p3_or_earlier(di->parent)) {
 		if (di->events.btemp_low) {
 			if (temp > di->btemp_ranges.btemp_low_limit)
-				temp = di->btemp_ranges.btemp_low_limit * 10;
-			else
-				temp = di->bat_temp * 10;
+				temp = di->btemp_ranges.btemp_low_limit;
 		} else if (di->events.btemp_high) {
 			if (temp < di->btemp_ranges.btemp_high_limit)
-				temp = di->btemp_ranges.btemp_high_limit * 10;
-			else
-				temp = di->bat_temp * 10;
+				temp = di->btemp_ranges.btemp_high_limit;
 		} else if (di->events.btemp_lowmed) {
 			if (temp > di->btemp_ranges.btemp_med_limit)
-				temp = di->btemp_ranges.btemp_med_limit * 10;
-			else
-				temp = di->bat_temp * 10;
+				temp = di->btemp_ranges.btemp_med_limit;
 		} else if (di->events.btemp_medhigh) {
 			if (temp < di->btemp_ranges.btemp_med_limit)
-				temp = di->btemp_ranges.btemp_med_limit * 10;
-			else
-				temp = di->bat_temp * 10;
-		} else
-			temp = di->bat_temp * 10;
+				temp = di->btemp_ranges.btemp_med_limit;
+		}
 	}
-	return temp;
+
+	return temp * 10;
 }
 
 /**
-- 
2.53.0



