Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB478248BA0;
	Wed, 15 Jan 2025 10:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937776; cv=none; b=oVjTzOJG4G4IrVMBrrMX58RvKzTcZaJEFUtSIgt8GGOiL3KgP/6gKF/2U5szwCCrajvzy9+LIV83SFY8NP/hEHjw26BC9+IXo7l/BPuqOVcdlSkpi+g9SCimTUtmKI1Xke6oXXeDBvkIUfhFezIxBArAV61av6bmIdgU4sZVlY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937776; c=relaxed/simple;
	bh=/a83vzZ6uavvmsxtLlHoI7RpFtqkjyyGcRItAJcIn2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jm87Tt9YZ5QLchGHbjNu/QONGiUURAhpYV4uTzgNtvkXBdhVtkkfHSAGJhKMYnR1t5+ZnWzyyHG9ADo3zE5E+adj4W3TkfqHc/h0ean8ZCcTWmUvz9agG7y37BoSC2Vk3HzMzXEWJLQxwRi7LLKPt5Q/UqXnlvjVw0YYLyaMO7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aDn3B+KK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aDn3B+KK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B17FC4CEE4;
	Wed, 15 Jan 2025 10:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937775;
	bh=/a83vzZ6uavvmsxtLlHoI7RpFtqkjyyGcRItAJcIn2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aDn3B+KKArCFK8Z3gbWkjIxF4qmDwRzh+zoLZkJCF7CNOanmO4J/orC66YP7mfmqf
	 HuPltKiNXGJ0A18QHY2gSCDe8UhIf9cgf1ENwhEU3WnShQQs27jAroP5v4Ks9Y+k01
	 7lAJnDNUYFlN8qPGBhBh1YfsNb5sGEz1wVX6PMvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 78/92] iio: adc: ad7124: Disable all channels at probe time
Date: Wed, 15 Jan 2025 11:37:36 +0100
Message-ID: <20250115103550.675031939@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

commit 4be339af334c283a1a1af3cb28e7e448a0aa8a7c upstream.

When during a measurement two channels are enabled, two measurements are
done that are reported sequencially in the DATA register. As the code
triggered by reading one of the sysfs properties expects that only one
channel is enabled it only reads the first data set which might or might
not belong to the intended channel.

To prevent this situation disable all channels during probe. This fixes
a problem in practise because the reset default for channel 0 is
enabled. So all measurements before the first measurement on channel 0
(which disables channel 0 at the end) might report wrong values.

Fixes: 7b8d045e497a ("iio: adc: ad7124: allow more than 8 channels")
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/20241104101905.845737-2-u.kleine-koenig@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7124.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -931,6 +931,9 @@ static int ad7124_setup(struct ad7124_st
 		 * set all channels to this default value.
 		 */
 		ad7124_set_channel_odr(st, i, 10);
+
+		/* Disable all channels to prevent unintended conversions. */
+		ad_sd_write_reg(&st->sd, AD7124_CHANNEL(i), 2, 0);
 	}
 
 	return ret;


