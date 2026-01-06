Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141942FE579;
	Tue,  6 Jan 2026 17:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720897; cv=none; b=McS3B3fOaH/nOyAr7KTpGu1Vh7Kk0fJW+bATL2eYFzaSHMO6+x7CwomU2nFUnPJ0KvCBwOwLZdgUUWmJT7M1hYgZPPpu1MY16KCKDtMMItVlYvzAM1hkpSgkXPMC51URQcEutd7UeksmgHmyKwnoY/TR4yBsYY/0/qlhRc+OL5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720897; c=relaxed/simple;
	bh=XEFNPQFVdFA4PXkYscyCrLqyZOaawpxKyb8NsEa9DeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VF3T1SNwARTKySQy6x3C1IhUL4/XDUsj1+/1hKouoK7I8CZ695tm/LGl7xPqJXF3U16H8qIz01+WUjkIIqqaKFjODBbN47/a3movnEAxM+CpfwOFhWCzO9t27nc+UA2vaJ0tKg/z0UCrLyG+tPM7a9k12QCgfsLcPW0JdZ1DTEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOG6a7Pf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOG6a7Pf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46993C116C6;
	Tue,  6 Jan 2026 17:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720896;
	bh=XEFNPQFVdFA4PXkYscyCrLqyZOaawpxKyb8NsEa9DeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOG6a7PfNQYZxBmWMXvj9N9jUXrSimECeAv8/INzBMJFWga/2sHOL545kJ14vyC3D
	 PwSYu3Kd53NVOomwtYRpVdqnHzvlCHEipE1qQvs2qzA6OaUAw/66VItORPueWaE5sw
	 v5XcSAmxzdd4sxsqTnRj2ssllRE7FUZoiBnYwRKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.12 374/567] leds: leds-cros_ec: Skip LEDs without color components
Date: Tue,  6 Jan 2026 18:02:36 +0100
Message-ID: <20260106170505.177618604@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -155,9 +155,6 @@ static int cros_ec_led_count_subleds(str
 		}
 	}
 
-	if (!num_subleds)
-		return -EINVAL;
-
 	*max_brightness = common_range;
 	return num_subleds;
 }
@@ -202,6 +199,8 @@ static int cros_ec_led_probe_one(struct
 						&priv->led_mc_cdev.led_cdev.max_brightness);
 	if (num_subleds < 0)
 		return num_subleds;
+	if (num_subleds == 0)
+		return 0; /* LED without any colors, skip */
 
 	priv->cros_ec = cros_ec;
 	priv->led_id = id;


