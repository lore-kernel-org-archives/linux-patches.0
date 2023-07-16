Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C1E8F71
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D831C433C9;
	Sun, 16 Jul 2023 19:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537243;
	bh=VIHjfcXAm+tNptNO+QMjNBZyJcveG8NdRHDPcmAox2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MaSVRaYg+6p3E2UAMUV5UUADFBE+AYwYK5xoA8a5egxUKLgKEyxQxEoNh9qDIKi06
	 D1r4S7VLnJhhQ22XeyG5brRvYvxdgQNbt8e6KNRYiHQiqfSmloUWAtO3RMzkovRuz8
	 640ejj92dzNpe5PV6HfurU7B94/XxZOu7aVPHp+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.4 007/800] iio: addac: ad74413: dont set DIN_SINK for functions other than digital input
Date: Sun, 16 Jul 2023 21:37:40 +0200
Message-ID: <20230716194949.278066437@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

commit a4cba07e64e6ec22d9504a1a45d29afa863dc19c upstream.

Apparently, despite the name Digital Input Configuration Register, the
settings in the DIN_CONFIGx registers also affect other channel
functions. In particular, setting a non-zero value in the DIN_SINK
field breaks the resistance measurement function.

Now, one can of course argue that specifying a drive-strength-microamp
property along with a adi,ch-func which is not one of the digital
input functions is a bug in the device tree. However, we have a rather
complicated setup with instances of ad74412r on external hardware
modules, and have set a default drive-strength-microamp in our DT
fragments describing those, merely modifying the adi,ch-func settings
to reflect however the modules have been wired up. And restricting
this setting to just being done for digital input doesn't make the
driver any more complex.

Fixes: 504eb485589d1 (iio: ad74413r: wire up support for drive-strength-microamp property)
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Link: https://lore.kernel.org/r/20230503105042.453755-1-linux@rasmusvillemoes.dk
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/addac/ad74413r.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/addac/ad74413r.c b/drivers/iio/addac/ad74413r.c
index e3366cf5eb31..6b0e8218f150 100644
--- a/drivers/iio/addac/ad74413r.c
+++ b/drivers/iio/addac/ad74413r.c
@@ -1317,13 +1317,14 @@ static int ad74413r_setup_gpios(struct ad74413r_state *st)
 		}
 
 		if (config->func == CH_FUNC_DIGITAL_INPUT_LOGIC ||
-		    config->func == CH_FUNC_DIGITAL_INPUT_LOOP_POWER)
+		    config->func == CH_FUNC_DIGITAL_INPUT_LOOP_POWER) {
 			st->comp_gpio_offsets[comp_gpio_i++] = i;
 
-		strength = config->drive_strength;
-		ret = ad74413r_set_comp_drive_strength(st, i, strength);
-		if (ret)
-			return ret;
+			strength = config->drive_strength;
+			ret = ad74413r_set_comp_drive_strength(st, i, strength);
+			if (ret)
+				return ret;
+		}
 
 		ret = ad74413r_set_gpo_config(st, i, gpo_config);
 		if (ret)
-- 
2.41.0



