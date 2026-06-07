Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A264328610;
	Sun,  7 Jun 2026 10:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828604; cv=none; b=GK3ivwj9tiYcgy22r9xIsrq3GSvNPa0xoJRiNxrBLiat/g3UUsRGliCSjnx7W/gnHttnVI4rsFNECR35XaqShHXTPPZMnaer3t6//rFYisZpVJGRS2l5I8UuM4U9sK5E/I2mMAcEqoPGB9jp2IVJdNfiMXj4l0TLgt3jYL4SAtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828604; c=relaxed/simple;
	bh=9SDDMULFLPjSB64oB3uZstYO7IbkVZ249n1MfpfWuzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5zsymOH4z9WesEI8mGERZUR5M9AMtcDDB3YyZyrwB9s+K4fJsk0QhxONKWZCwQ5Gg3o4kFwtH9AsfYwbnu1J3y70JMN7ncxNuHORvemkE6Dgd2Isyq3YBZom2pUpEYZ+T+lNlmDHp9+JeG7CpQOrnUQeDI8M5sCkoReZDtlPTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zN/jrUdH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zN/jrUdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349801F00893;
	Sun,  7 Jun 2026 10:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828603;
	bh=9D//keXnZWj3vG/pzJDK1vMokLX9l0Ilx95sjSlJo/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zN/jrUdHB0JebYm1gtDLjT2ZmMKkP/2hJvjZq+6i8Bl/lbzxAA0mJ0IteGrgvJCQC
	 5Q9gLGCwL9n9Aps5T0gWspM1bleejEc5W/3sdYt2m+MKD3FRuT1RYrPYMAzXDVjgvD
	 a6xM1jGyBDNNLClhqEpQx8AQ7y/BFKVgYoQzXqBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.0 196/332] iio: chemical: scd30: fix division by zero in write_raw
Date: Sun,  7 Jun 2026 11:59:25 +0200
Message-ID: <20260607095735.256911810@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit 5aba4f94b225617a55fed442a70329b2ee19c0a5 upstream.

Add a zero check for val2 before using it as a divisor when setting the
sampling frequency. A user writing a zero fractional part to the
sampling_frequency sysfs attribute triggers a division by zero in the
kernel.

Fixes: 64b3d8b1b0f5 ("iio: chemical: scd30: add core driver")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/scd30_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/chemical/scd30_core.c
+++ b/drivers/iio/chemical/scd30_core.c
@@ -256,7 +256,7 @@ static int scd30_write_raw(struct iio_de
 	guard(mutex)(&state->lock);
 	switch (mask) {
 	case IIO_CHAN_INFO_SAMP_FREQ:
-		if (val)
+		if (val || !val2)
 			return -EINVAL;
 
 		val = 1000000000 / val2;


