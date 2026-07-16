Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2483BED2D;
	Thu, 16 Jul 2026 13:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209119; cv=none; b=YniZ0T7HeLyccpYGp34bTIW6wgumfLg9MpUIj0clp80tqy3i4QItBMl3ii92zsPGerc4fIDwVJdyvJnjFp9YYYQlUKpSGyY6s6PCHa4x/58yPuEI2dJ55fy3zwEWMUc0aODzOCpa+HcicvkaIL7iDBzWJC+kD6pKfAGNRM7hcqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209119; c=relaxed/simple;
	bh=X6vLQe3Lqx0pNGrcvgRe2ON/Ab9CIqflMGesOBwctDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbWDpNXEMCdpTvcSZ8FJqi5zBe8UOrvN/S2qIRpbUFdRa97fDZAIlEjh3AUpvgTtIBYx4Hf22iiq67XM9zbvf97sxWWo2DcHojmBWXdVskfpJQO9adTQeYZYYZnD+U4B6iRolOeh2LRlPczemsfBUvc6PfHlXPLrS1DbTCjkzHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1zEOvfIp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1zEOvfIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DDB1F000E9;
	Thu, 16 Jul 2026 13:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209118;
	bh=VmM2TNQO9z13ZN2uvln0SQ5LQWRxqJGdXp0FQJO16yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1zEOvfIplfSbTcm2ixpneM5w0E7DdW5+703Zz6b2JyQGj0Zc+1ZIq9AyDpdOvdZfU
	 KEsN7x91OuIXgAUgeqDPMoo6lIuqcfbBpSvH0BOXRCNuAQimL0JPRsjwBAhIEUKoSS
	 Oh/s2FSONTFZ4hWlmloAPXikPm2dLGQQeHhZvVls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 063/518] iio: light: al3010: read both ALS ADC registers again
Date: Thu, 16 Jul 2026 15:25:31 +0200
Message-ID: <20260716133049.160861154@linuxfoundation.org>
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

commit ee78fae068f52a5582aaf448d9414f826855c106 upstream.

al3010_read_raw() used to read two adjacent registers
until the driver was modernized using the regmap framework.
That cleanup accidentally replaced the 16-bit word read
with a single byte read. I'm reverting latter.

Fixes: 0e5e21e23dd6 ("iio: light: al3010: Implement regmap support")
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/al3010.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/iio/light/al3010.c
+++ b/drivers/iio/light/al3010.c
@@ -111,7 +111,8 @@ static int al3010_read_raw(struct iio_de
 			   int *val2, long mask)
 {
 	struct al3010_data *data = iio_priv(indio_dev);
-	int ret, gain, raw;
+	int ret, gain;
+	__le16 raw;
 
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
@@ -120,11 +121,12 @@ static int al3010_read_raw(struct iio_de
 		 * - low byte of output is stored at AL3010_REG_DATA_LOW
 		 * - high byte of output is stored at AL3010_REG_DATA_LOW + 1
 		 */
-		ret = regmap_read(data->regmap, AL3010_REG_DATA_LOW, &raw);
+		ret = regmap_bulk_read(data->regmap, AL3010_REG_DATA_LOW,
+				       &raw, sizeof(raw));
 		if (ret)
 			return ret;
 
-		*val = raw;
+		*val = le16_to_cpu(raw);
 
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_SCALE:


