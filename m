Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10003FF1DE;
	Fri, 15 May 2026 15:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860754; cv=none; b=cw/+amusKZq9AWtd4ZWzQV4iLhbREI6UpmHAKZTHDwH5kAkRfPx+/XidXDMP241A7AEdRNEmhwB9+n61p+rFU2Yrx5K5O/xlostARLuqR0xorX3RozAvjNeo3fDmOT9xh71nSpOf+mpbyskSmdwhNgnXC3NmV/L8ICs1k92QF00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860754; c=relaxed/simple;
	bh=UFzmcRo70+u5S0d8cI3dbDcTMXTU0++zEZfoAfftkY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYXI0XNC0V5PYWSPgAYVYbXlSggJPtI6OPDmTAbjDXo8X+rc02ty5NFtOQxYseH9EbQVpmmMTpVCh03WkZ6wYXNPt186oz04Kv3TiApUcPTRztURt+Yzb7zWCBU9qqTOZ8DJB2SKiJw3if3t+6g2Xy/vGOjLtUGwGZWu3ymjxOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVG74tzS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVG74tzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77700C2BCB0;
	Fri, 15 May 2026 15:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860753;
	bh=UFzmcRo70+u5S0d8cI3dbDcTMXTU0++zEZfoAfftkY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVG74tzSMyPHXVUznUCf2B+nJb5H4qkB5Gg4qZB8AqYKq3YvI402us4cp8A7r5cjV
	 xVLnEyHl/f81efet0VJgG12nAGlbAxc4XNxug22OjgG/d3jUhMtWXsgHmSMxML8Jct
	 65FbT1AnLg5+JWt5DnNJcUHquYnFH2DLbkn89pjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Santos <Jonathan.Santos@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 064/474] iio: adc: ad7768-1: fix one-shot mode data acquisition
Date: Fri, 15 May 2026 17:42:53 +0200
Message-ID: <20260515154716.427683619@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Santos <Jonathan.Santos@analog.com>

commit 8be19e233744961db6069da9c9ab63eb085a0447 upstream.

According to the datasheet, one-shot mode requires a SYNC_IN pulse to
trigger a new sample conversion. In the current implementation, No sync
pulse was sent after switching to one-shot mode and reinit_completion()
was called before mode switching, creating a race condition where spurious
interrupts during mode change could trigger completion prematurely.

Fix by sending a sync pulse after configuring one-shot mode and
reinit_completion() to ensure it only waits for the actual conversion
completion.

Fixes: a5f8c7da3dbe ("iio: adc: Add AD7768-1 ADC basic support")
Signed-off-by: Jonathan Santos <Jonathan.Santos@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7768-1.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ad7768-1.c
+++ b/drivers/iio/adc/ad7768-1.c
@@ -241,12 +241,17 @@ static int ad7768_scan_direct(struct iio
 	struct ad7768_state *st = iio_priv(indio_dev);
 	int readval, ret;
 
-	reinit_completion(&st->completion);
-
 	ret = ad7768_set_mode(st, AD7768_ONE_SHOT);
 	if (ret < 0)
 		return ret;
 
+	reinit_completion(&st->completion);
+
+	/* One-shot mode requires a SYNC pulse to generate a new sample */
+	ret = ad7768_send_sync_pulse(st);
+	if (ret)
+		return ret;
+
 	ret = wait_for_completion_timeout(&st->completion,
 					  msecs_to_jiffies(1000));
 	if (!ret)


