Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDB2368264;
	Tue,  6 Jan 2026 17:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722097; cv=none; b=GQdGVSZhD4o6gu66THz11jdQ1OeF985Q6fTyEGJHe6+hx3xlB5vRu1YCFJ6dl44SIMsLilo9A/PPRqnXRpInd9YdjT8SSOTzD2zeo0URe/mPQvV+VLt3i+jEQNkoiB7CSFynQvAOQcFgOmtFUIT3Q2rhirU5yOz7CkMHq1mUbeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722097; c=relaxed/simple;
	bh=/YC42PXbOrSKcNond8pu1cX9Poxe5d1hKhIiQptsNTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lhhpDSrIfyJzGMxSvsVdEeu+KA96rx4WROcLLqWlEFgeEUPCp8GG7NMbHAj7cWmMDGYZ00+2JqdQ0wVm8fDaPwzCvawUVdwAkjQkrdnJd04DTeSHNjt3syR8pMdZ04hRh9rsukZbtxiLPWI0BZWPOedaaQkdIIaxVavneR/JBWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fc+ZNi6D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fc+ZNi6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B697C16AAE;
	Tue,  6 Jan 2026 17:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722097;
	bh=/YC42PXbOrSKcNond8pu1cX9Poxe5d1hKhIiQptsNTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fc+ZNi6DDJah4hxV92Iddo6hclNl3lTc/fqU/07h2oZ56QTuOYwysHqnvWN3A30ky
	 /Wh5SLHjpqVuLIH3LR1NcrBCo6FpQGQFJ4eWxkL7m2RhDFlk9vgI+VY9GE6i2Pfr2L
	 VPiSeKYUvDYQ7XQ1jpkGMXpX17Vq2u5zR2IDN4yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.18 131/312] leds: leds-cros_ec: Skip LEDs without color components
Date: Tue,  6 Jan 2026 18:03:25 +0100
Message-ID: <20260106170552.582546258@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Thomas Weißschuh <linux@weissschuh.net>

commit 4dbf066d965cd3299fb396f1375d10423c9c625c upstream.

A user reports that on their Lenovo Corsola Magneton with EC firmware
steelix-15194.270.0 the driver probe fails with EINVAL. It turns out
that the power LED does not contain any color components as indicated
by the following "ectool led power query" output:

Brightness range for LED 1:
        red     : 0x0
        green   : 0x0
        blue    : 0x0
        yellow  : 0x0
        white   : 0x0
        amber   : 0x0

The LED also does not react to commands sent manually through ectool and
is generally non-functional.

Instead of failing the probe for all LEDs managed by the EC when one
without color components is encountered, silently skip those.

Cc: stable@vger.kernel.org
Fixes: 8d6ce6f3ec9d ("leds: Add ChromeOS EC driver")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://patch.msgid.link/20251028-cros_ec-leds-no-colors-v1-1-ebe13a02022a@weissschuh.net
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-cros_ec.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/leds/leds-cros_ec.c
+++ b/drivers/leds/leds-cros_ec.c
@@ -142,9 +142,6 @@ static int cros_ec_led_count_subleds(str
 		}
 	}
 
-	if (!num_subleds)
-		return -EINVAL;
-
 	*max_brightness = common_range;
 	return num_subleds;
 }
@@ -189,6 +186,8 @@ static int cros_ec_led_probe_one(struct
 						&priv->led_mc_cdev.led_cdev.max_brightness);
 	if (num_subleds < 0)
 		return num_subleds;
+	if (num_subleds == 0)
+		return 0; /* LED without any colors, skip */
 
 	priv->cros_ec = cros_ec;
 	priv->led_id = id;


