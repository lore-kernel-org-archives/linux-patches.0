Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF2C1DE8BE;
	Tue, 26 Aug 2025 14:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216883; cv=none; b=L4WiciEpEb2sPLfxuQpRpTct4M8LHmcSKypI3TRnvPS4bufMhfS81RaWuswS+7QmMjDV0OX7rHJu0OBuh1Qo/uu35xqSRD6njsvmoUzUq3ESxONT0VuwflN9ajSKOiZodVzq/np4JNPnW/x0f5An60Lx50CBVBZW8iAUcYT66Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216883; c=relaxed/simple;
	bh=+OI5njkpkehpVoD/6y8kKKEUCpMiZRMzFSNzA7IscJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNnh01oGBxo1UHVxMuky+gC3wL0RMTKwXcevcfDJMfUjUo4n6LF1hfmG+mQFTG4oKREdC1bSImAz7jqWL96hmrnX9th7Kb0rPviEW6uAI0Vunmdgvoq9CGJNu99eD9vW8DJ1P8PujSSG+LiQGYlfase15rph1U10r9+6F5zOkEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hpImaPwL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hpImaPwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852C9C4CEF1;
	Tue, 26 Aug 2025 14:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216882;
	bh=+OI5njkpkehpVoD/6y8kKKEUCpMiZRMzFSNzA7IscJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hpImaPwL//kl4IJwqnY8C0AH4rIL0R4DffZaAVmy+K2Iu8lhFZHBeMsVJaCXK7Ar9
	 frlKp56w86HWSdbGOC3olPOj628PsTUjdnncPD7anvV4o30WAAal12bcp0z5Fz4FfQ
	 7D9orDr9d8T3osUSB99bjmxaXlg67kY9iCwC6K7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 579/644] iio: proximity: isl29501: fix buffered read on big-endian systems
Date: Tue, 26 Aug 2025 13:11:10 +0200
Message-ID: <20250826111000.880030955@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: David Lechner <dlechner@baylibre.com>

commit de18e978d0cda23e4c102e18092b63a5b0b3a800 upstream.

Fix passing a u32 value as a u16 buffer scan item. This works on little-
endian systems, but not on big-endian systems.

A new local variable is introduced for getting the register value and
the array is changed to a struct to make the data layout more explicit
rather than just changing the type and having to recalculate the proper
length needed for the timestamp.

Fixes: 1c28799257bc ("iio: light: isl29501: Add support for the ISL29501 ToF sensor.")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250722-iio-use-more-iio_declare_buffer_with_ts-7-v2-1-d3ebeb001ed3@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/isl29501.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/iio/proximity/isl29501.c
+++ b/drivers/iio/proximity/isl29501.c
@@ -938,12 +938,18 @@ static irqreturn_t isl29501_trigger_hand
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct isl29501_private *isl29501 = iio_priv(indio_dev);
 	const unsigned long *active_mask = indio_dev->active_scan_mask;
-	u32 buffer[4] __aligned(8) = {}; /* 1x16-bit + naturally aligned ts */
+	u32 value;
+	struct {
+		u16 data;
+		aligned_s64 ts;
+	} scan = { };
 
-	if (test_bit(ISL29501_DISTANCE_SCAN_INDEX, active_mask))
-		isl29501_register_read(isl29501, REG_DISTANCE, buffer);
+	if (test_bit(ISL29501_DISTANCE_SCAN_INDEX, active_mask)) {
+		isl29501_register_read(isl29501, REG_DISTANCE, &value);
+		scan.data = value;
+	}
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buffer, pf->timestamp);
+	iio_push_to_buffers_with_timestamp(indio_dev, &scan, pf->timestamp);
 	iio_trigger_notify_done(indio_dev->trig);
 
 	return IRQ_HANDLED;


