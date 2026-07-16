Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA003422E3D;
	Thu, 16 Jul 2026 13:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209127; cv=none; b=KhbF11SmLlXmY4Fwj/92GFHdOz6gVpUfHnJXKZomiDBsbgsZz06aXJuAbyoZt8iywua+75EqO/A46atMYKwV8HENRw2yxSVB9Js4UlX7WUkAU2pNPJ++9F1AX8ZZMA4Ged7v4j3n13DznPV1tKxCnAJk6WQ5zMlcgJBqdpA0xhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209127; c=relaxed/simple;
	bh=dl6xXoqTq7PNS6ASizgube3eGDCtaQy+jS6mtO16z5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ja5iPbVU6VhnFmcy/FkirVbY22Z1yLddO3T484a7dE2OKNgXv/J7Tn0SMbyLZcyL8y0eO+V3ZBnd15sPgBPgOp8hcC8/QJMwiz5CVWMSHnSMpb9MVM2ejRHBk8RH/YhD75sHAn23oACFNUbYdKkeEMisF8ALwaDtTA/zA0V6TUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G8jsl+Tb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G8jsl+Tb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292F31F000E9;
	Thu, 16 Jul 2026 13:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209126;
	bh=3Mb+KjZfL0e43SHwa44mzEhrFPiR+Ib3zbwryygy7d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G8jsl+TbaD7H3QlwjlFp879BFhvjEc4GvkcMpMdY/r45x7KbBE21qy/Vsc4CHLPY2
	 hvl6AIU81PpZ7GrYnKDX9RoJ3Yf6izdjMMsYLBXj5l7e1U8siaOtFW1oqV1xxrR5FB
	 +rbKCsAybj+bzusF4rrJi9rYINfvz5NeP6C91FWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 065/518] iio: light: al3320a: read both ALS ADC registers again
Date: Thu, 16 Jul 2026 15:25:33 +0200
Message-ID: <20260716133049.206916666@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander A. Klimov <grandmaster@al2klimov.de>

commit 744bccc2647c6b2206290e8e40890a23812116b3 upstream.

al3320a_read_raw() used to read two adjacent registers
until the driver was modernized using the regmap framework.
That cleanup accidentally replaced the 16-bit word read
with a single byte read. I'm reverting latter.

Fixes: 1850e6ae7f91 ("iio: light: al3320a: Implement regmap support")
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/al3320a.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/iio/light/al3320a.c
+++ b/drivers/iio/light/al3320a.c
@@ -135,7 +135,8 @@ static int al3320a_read_raw(struct iio_d
 			    int *val2, long mask)
 {
 	struct al3320a_data *data = iio_priv(indio_dev);
-	int ret, gain, raw;
+	int ret, gain;
+	__le16 raw;
 
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
@@ -144,11 +145,12 @@ static int al3320a_read_raw(struct iio_d
 		 * - low byte of output is stored at AL3320A_REG_DATA_LOW
 		 * - high byte of output is stored at AL3320A_REG_DATA_LOW + 1
 		 */
-		ret = regmap_read(data->regmap, AL3320A_REG_DATA_LOW, &raw);
+		ret = regmap_bulk_read(data->regmap, AL3320A_REG_DATA_LOW,
+				       &raw, sizeof(raw));
 		if (ret)
 			return ret;
 
-		*val = raw;
+		*val = le16_to_cpu(raw);
 
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_SCALE:


