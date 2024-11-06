Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4342C1E230D;
	Wed,  6 Nov 2024 12:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896854; cv=none; b=oWtB1GlL6FwwOglHXkeZinG7TmMALz9k7czPdb0yHU0r7s4HYg6/qcfUZyMgmSKPZ8cU7FllU/OCDa1PmPg8NsH97m+8bDv1QNl1AY/V+8xQXc/SpQXE+nyoLkqoC3yc+E5rOVkniWi9JU1d3IDNvBbeT/Cyr51gQ+LsXwv8wPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896854; c=relaxed/simple;
	bh=dJKB/5Rpw/Vsw4sCh0TpbW6igoO0nghQwRGCsvHSyL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvRX4LG6/CLOYWc2TwOTjZYnplgGcgCxncJUG5DvzGJOu2bL4BFrQk0TomDV43XoEOZ4LpA6euv2q+s4c1YE98OSJGBgYvhZn4FMxa/E7oZAfkx0oxReZhI0DHf2m/SfuVrWo1MHK0ctJAsdN+gmJ7BmRCqMot7a6hGA8seUSY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLvJHiF1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLvJHiF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBAEC4CED4;
	Wed,  6 Nov 2024 12:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896853;
	bh=dJKB/5Rpw/Vsw4sCh0TpbW6igoO0nghQwRGCsvHSyL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLvJHiF1uC2UJzsjPnYqcd4ISiYGaduqSmXkfCqFjkKsT4MP+Dy878Pic9x/UTSh/
	 N9eWvH/TQk2JQszf1HkSyZEOXgbyKB449A3m+FP4QsrFmoSGkUGVmA62iIuWH3u/Xv
	 YtGGyeja7r/K77oyfWaaYUitmmcpRMr3r6Y0Zk7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 094/110] iio: light: veml6030: fix microlux value calculation
Date: Wed,  6 Nov 2024 13:05:00 +0100
Message-ID: <20241106120305.781415079@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 63dd163cd61dda6f38343776b42331cc6b7e56e0 upstream.

The raw value conversion to obtain a measurement in lux as
INT_PLUS_MICRO does not calculate the decimal part properly to display
it as micro (in this case microlux). It only calculates the module to
obtain the decimal part from a resolution that is 10000 times the
provided in the datasheet (0.5376 lux/cnt for the veml6030). The
resulting value must still be multiplied by 100 to make it micro.

This bug was introduced with the original implementation of the driver.

Only the illuminance channel is fixed becuase the scale is non sensical
for the intensity channels anyway.

Cc: stable@vger.kernel.org
Fixes: 7b779f573c48 ("iio: light: add driver for veml6030 ambient light sensor")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241016-veml6030-fix-processed-micro-v1-1-4a5644796437@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/veml6030.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/veml6030.c
+++ b/drivers/iio/light/veml6030.c
@@ -522,7 +522,7 @@ static int veml6030_read_raw(struct iio_
 			}
 			if (mask == IIO_CHAN_INFO_PROCESSED) {
 				*val = (reg * data->cur_resolution) / 10000;
-				*val2 = (reg * data->cur_resolution) % 10000;
+				*val2 = (reg * data->cur_resolution) % 10000 * 100;
 				return IIO_VAL_INT_PLUS_MICRO;
 			}
 			*val = reg;


