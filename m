Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E251E7669;
	Tue, 15 Oct 2024 11:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992331; cv=none; b=dZixbjbNYAb8XR6NcdNCV14K03hBKQTQI6yR//JmhGk10577wajNNDG2FYGS+uAKI1sFtTj4bOfbpgXDMPvXAOTXwD/ATD2oKscCXijN3uNfewISzgrfJsscN1UoFlDDYE8WsiwQd9QXpDvC2sELO8oRK2T67/GEV0QNx0xjYwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992331; c=relaxed/simple;
	bh=mRVrKpj+3v/fRYI14h1gFxMVAb+WfTQ1M3zDkhtifgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBIFoQwIf7Se0wYg3iW0oFD5/jm5nwzCwnfxIT7WxotcUN9ciVICyHlRlsCU9JypihFTOp1DQjaGWVvAYzqTI2v9IT5Rb+6/nLAOnR2QQlJsS1u+pmrNL4hqMQkG/xxiJVR0ZRKHgBHFLt4TQ88vtRbk+4u/dMh06rr1EoTJhbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdxFYTkU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdxFYTkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932AAC4CEC6;
	Tue, 15 Oct 2024 11:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992331;
	bh=mRVrKpj+3v/fRYI14h1gFxMVAb+WfTQ1M3zDkhtifgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdxFYTkUse+1IODcE3hs94AUaib1Gqb63/e88yT9snpG7yuI51Kue1jfZCnB9/8iz
	 YIK2PldKONFCeJEY//elC8WRps31zdW0fYc9m0Guv70lw0KGN/mPwPfjzkBqqfv3Pa
	 zQvigGqHh5sYlrqvtf3gTp0dW+qRu7e9W37/9+Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 5.15 086/691] gpiolib: cdev: Ignore reconfiguration without direction
Date: Tue, 15 Oct 2024 13:20:34 +0200
Message-ID: <20241015112443.773948727@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Gibson <warthog618@gmail.com>

commit b440396387418fe2feaacd41ca16080e7a8bc9ad upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-cdev.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -1186,15 +1186,18 @@ static long linereq_set_config_unlocked(
 	for (i = 0; i < lr->num_lines; i++) {
 		desc = lr->lines[i].desc;
 		flags = gpio_v2_line_config_flags(lc, i);
+		/*
+		 * Lines not explicitly reconfigured as input or output
+		 * are left unchanged.
+		 */
+		if (!(flags & GPIO_V2_LINE_DIRECTION_FLAGS))
+			continue;
+
 		polarity_change =
 			(!!test_bit(FLAG_ACTIVE_LOW, &desc->flags) !=
 			 ((flags & GPIO_V2_LINE_FLAG_ACTIVE_LOW) != 0));
 
 		gpio_v2_line_config_flags_to_desc_flags(flags, &desc->flags);
-		/*
-		 * Lines have to be requested explicitly for input
-		 * or output, else the line will be treated "as is".
-		 */
 		if (flags & GPIO_V2_LINE_FLAG_OUTPUT) {
 			int val = gpio_v2_line_config_output_value(lc, i);
 
@@ -1202,7 +1205,7 @@ static long linereq_set_config_unlocked(
 			ret = gpiod_direction_output(desc, val);
 			if (ret)
 				return ret;
-		} else if (flags & GPIO_V2_LINE_FLAG_INPUT) {
+		} else {
 			ret = gpiod_direction_input(desc);
 			if (ret)
 				return ret;


