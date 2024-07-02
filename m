Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7C415B0FE;
	Tue,  2 Jul 2024 17:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940285; cv=none; b=S/G4hrBlMtghhmGGpyala/t3mVXf9NQv+fNCmTnbHCBE1xfMrRYPzVf54m4pCDhU6Ylbu0ZoioB8KyvwaIquE3UAApP7GBf87HuVOUWQxB9iK+ghbuPIAcVUfc6OD6coHxDR5ryCC/5Xa3iZnxYOzQ0C9QilpLRIPSPM1VFumIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940285; c=relaxed/simple;
	bh=F5xEDRN82ZGIb4CwWE+vdXgrl/e/MRxiQaPfpqQsuSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GfuZNwW52NLaHXxmVkPFf2z9XTGwU9T28OxO9zF4LKiHzCSEDg9tmoTucCbuS5D40LBGLlBdH9Um3AIxaNrAgU6SuL8MkoC2tUG/+qIt6cN8pFRV19jiE1y+rX2brDRprqCaxMrf2nhUwwugGiotU6VdgniQEsVpY8rT/pCI24Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMRBHecF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMRBHecF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3108CC116B1;
	Tue,  2 Jul 2024 17:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940285;
	bh=F5xEDRN82ZGIb4CwWE+vdXgrl/e/MRxiQaPfpqQsuSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMRBHecFhvaL8pkYL47gwA5hhS3pwJ6ivnnRTSb6+c2Js1frG3HN+XqneLtB+aBvf
	 QVZkrX1z8MNlGBOtd52NkEKq/uAO2nbhXmRMGYalIytXAL3xR3xXZ1NvAHu4UvdKTK
	 J3sj99NGzHr72+b+jlR4rwmvXH4+Zz4UuFo5F8S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 108/222] gpiolib: cdev: Ignore reconfiguration without direction
Date: Tue,  2 Jul 2024 19:02:26 +0200
Message-ID: <20240702170248.094960803@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Gibson <warthog618@gmail.com>

[ Upstream commit b440396387418fe2feaacd41ca16080e7a8bc9ad ]

linereq_set_config() behaves badly when direction is not set.
The configuration validation is borrowed from linereq_create(), where,
to verify the intent of the user, the direction must be set to in order to
effect a change to the electrical configuration of a line. But, when
applied to reconfiguration, that validation does not allow for the unset
direction case, making it possible to clear flags set previously without
specifying the line direction.

Adding to the inconsistency, those changes are not immediately applied by
linereq_set_config(), but will take effect when the line value is next get
or set.

For example, by requesting a configuration with no flags set, an output
line with GPIO_V2_LINE_FLAG_ACTIVE_LOW and GPIO_V2_LINE_FLAG_OPEN_DRAIN
set could have those flags cleared, inverting the sense of the line and
changing the line drive to push-pull on the next line value set.

Skip the reconfiguration of lines for which the direction is not set, and
only reconfigure the lines for which direction is set.

Fixes: a54756cb24ea ("gpiolib: cdev: support GPIO_V2_LINE_SET_CONFIG_IOCTL")
Signed-off-by: Kent Gibson <warthog618@gmail.com>
Link: https://lore.kernel.org/r/20240626052925.174272-3-warthog618@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-cdev.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index 04261adf320b8..5639abce6ec57 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -1534,12 +1534,14 @@ static long linereq_set_config(struct linereq *lr, void __user *ip)
 		line = &lr->lines[i];
 		desc = lr->lines[i].desc;
 		flags = gpio_v2_line_config_flags(&lc, i);
-		gpio_v2_line_config_flags_to_desc_flags(flags, &desc->flags);
-		edflags = flags & GPIO_V2_LINE_EDGE_DETECTOR_FLAGS;
 		/*
-		 * Lines have to be requested explicitly for input
-		 * or output, else the line will be treated "as is".
+		 * Lines not explicitly reconfigured as input or output
+		 * are left unchanged.
 		 */
+		if (!(flags & GPIO_V2_LINE_DIRECTION_FLAGS))
+			continue;
+		gpio_v2_line_config_flags_to_desc_flags(flags, &desc->flags);
+		edflags = flags & GPIO_V2_LINE_EDGE_DETECTOR_FLAGS;
 		if (flags & GPIO_V2_LINE_FLAG_OUTPUT) {
 			int val = gpio_v2_line_config_output_value(&lc, i);
 
@@ -1547,7 +1549,7 @@ static long linereq_set_config(struct linereq *lr, void __user *ip)
 			ret = gpiod_direction_output(desc, val);
 			if (ret)
 				return ret;
-		} else if (flags & GPIO_V2_LINE_FLAG_INPUT) {
+		} else {
 			ret = gpiod_direction_input(desc);
 			if (ret)
 				return ret;
-- 
2.43.0



