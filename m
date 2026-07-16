Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CCD400DE8;
	Thu, 16 Jul 2026 14:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210514; cv=none; b=PQZ4S0P2zIHovi4rqQErCjj6RYsoz3DT0dAyN+kDvCc23HmW1uXdRVIucOcK67dRKFlS0g1ATWOnWB7DvWLpM3WiVvgvIR+xdcJN+8Jp3vGKG7uMcJ+3rzK+pgQXUYlFgsTeyigvALSXoQrMtkkeMCjSSZGl9pwXuoIZ2Q0AlP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210514; c=relaxed/simple;
	bh=7ffeYztPkPQav325mrKaSy5+EJr0wd/CkEZAmmvjUUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYgAMUujI4k5GE7eSKRVufQcAXKrmjCb3YuKTYcJ/Hyf1oBRH34rEIF2fw30aqcMCigmaovMfr81tFxURFYyU325i5KZV/rnsinX2uWu7xYp4axPIVlTmlXxUNmte9iTrFBBum60dolxIeDNrMv6Znj+y6anWvzh+mhhrFrEggE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GpxujJ8z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GpxujJ8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F721F000E9;
	Thu, 16 Jul 2026 14:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210513;
	bh=L7CPMFdc7ZFoRCoj9JM3Hdr3dPdhaa3LUqsXf3FSB0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GpxujJ8zmwUqiDi08bB/F1lngtpsQPiVOw6p2HaQQ738SWpVdPOniW3LPC4ePAHUz
	 7PBQU8HddsQZgLNYttSXTZvHiuQiCNQ8bstvK0ZLUnjvoQVFkGhIRxYTnEHWPgAX7d
	 5pCuQATVnX/woOlqSYKsWDQrmdZKy0gzdhHpGRIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 075/480] iio: light: al3010: read both ALS ADC registers again
Date: Thu, 16 Jul 2026 15:27:02 +0200
Message-ID: <20260716133046.334632673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


