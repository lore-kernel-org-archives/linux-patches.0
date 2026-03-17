Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4D421D5B0;
	Tue, 17 Mar 2026 17:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768112; cv=none; b=BakhJa4DghDriW1gx2XWHOqnBOcdLsCV3WgYIsLa9UTD3DUsTkeDw/SarxIMNmN1HYPKBnQOxUd2gaOBvKSjXFrcgPnTQm99LosgQz5E4co7ZvCwGSySsBGnQrDYFuyUV6lBV7tn0lSqeAG9yDXIDnlkxjhNfQ0QSRZzJcVodes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768112; c=relaxed/simple;
	bh=ARqy4z+Jd2cjBQjvq4yvWM79YkjqY31FUHUxaFPS15E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZrIrDNE1CWVS86i4ZfCOZnhyVK7NB0e3HI/3hA1KZ8X18/sKrX3PfM+YcMmW8dIMOZ8+62dwyyHvfqh2fsyfAM7jCIBx4xvgrlkMDALKxwUe0wCz9jJY/buFBXDaNoSBDdeIxBEJjkok46v4Ip1TS4QzxT5yc0iLhAgM0dqD8iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xHZHEZLs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xHZHEZLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C921C2BC86;
	Tue, 17 Mar 2026 17:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768112;
	bh=ARqy4z+Jd2cjBQjvq4yvWM79YkjqY31FUHUxaFPS15E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xHZHEZLsBu9ZKgpD6BrGpR2LwRsD+RihxqrzneXyulAI4qZi8ay/4cwYO8yFbICRE
	 Plbp2KRmqX4A6p/5BeLGd2xWjqm6GhZvlhxcnHUQ1xwmVQLE0wrysGRt7q4gG7K4FJ
	 a8nXzH/YeKLduZLnC76Ib2t0WOKNYj7rm0YoIc3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.18 233/333] pmdomain: bcm: bcm2835-power: Fix broken reset status read
Date: Tue, 17 Mar 2026 17:34:22 +0100
Message-ID: <20260317163008.006169928@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

commit 550bae2c0931dbb664a61b08c21cf156f0a5362a upstream.

bcm2835_reset_status() has a misplaced parenthesis on every PM_READ()
call. Since PM_READ(reg) expands to readl(power->base + (reg)), the
expression:

    PM_READ(PM_GRAFX & PM_V3DRSTN)

computes the bitwise AND of the register offset PM_GRAFX with the
bitmask PM_V3DRSTN before using the result as a register offset, reading
from the wrong MMIO address instead of the intended PM_GRAFX register.
The same issue affects the PM_IMAGE cases.

Fix by moving the closing parenthesis so PM_READ() receives only the
register offset, and the bitmask is applied to the value returned by
the read.

Fixes: 670c672608a1 ("soc: bcm: bcm2835-pm: Add support for power domains under a new binding.")
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/bcm/bcm2835-power.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pmdomain/bcm/bcm2835-power.c
+++ b/drivers/pmdomain/bcm/bcm2835-power.c
@@ -573,11 +573,11 @@ static int bcm2835_reset_status(struct r
 
 	switch (id) {
 	case BCM2835_RESET_V3D:
-		return !PM_READ(PM_GRAFX & PM_V3DRSTN);
+		return !(PM_READ(PM_GRAFX) & PM_V3DRSTN);
 	case BCM2835_RESET_H264:
-		return !PM_READ(PM_IMAGE & PM_H264RSTN);
+		return !(PM_READ(PM_IMAGE) & PM_H264RSTN);
 	case BCM2835_RESET_ISP:
-		return !PM_READ(PM_IMAGE & PM_ISPRSTN);
+		return !(PM_READ(PM_IMAGE) & PM_ISPRSTN);
 	default:
 		return -EINVAL;
 	}


