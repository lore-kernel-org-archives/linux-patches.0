Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7525803BB;
	Wed,  9 Sep 2026 14:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963809; cv=none; b=ErpXFmGhKtT/yJbW99ffPOjGnqsODDaTvYBT5vpUBnnuQ9xSB2pF1dyMFyNDqD5FqXh1S2F/+PImMwezSkbP1CthJZD0Q4KpqSe2ntWDWgrkr8ZKejd2/m3Ff7aScQcHsY4i+5Jjzj546DfPQXdXk96Asy+rAumuJ1scYNC1p6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963809; c=relaxed/simple;
	bh=YboomoBvyK0hNkQQsWuhi2XFQecmPqTsAzpEPZvhteQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSyTh6SlDs+eEgocyBsI2sfYsQ7mNWd9yRUs+HombfDi80XJqVnWGQYBgq3XHddQ9JHg9xL/fxI4chYwCCme8hBrFHaWKa+KKUE7SO+sQZga6JN18Py4HZ4aiHbQfyEsdV9IVFPS+iFOxFB6RL9XBKhQ5TXpYcMC49CT6+9akdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZ8UVPdk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZ8UVPdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C247F1F00A3A;
	Wed,  9 Sep 2026 14:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963808;
	bh=ETC2urYqMuSQo/DOUkAfvEksWa2+BnCYDTh6rJ/co9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WZ8UVPdk2fcWJrMQhd9CxnrTGwCbewel7UnXoX1hx5+hywxcL4f7XIAtDFXQeJlSj
	 6ZkQbMX8gjP0OEBVcMzno0ekeJO4nDsVv5Q7bp4VNQTzh/coZ73JG4ogH7EOhouvHn
	 yLL4FA7mq285rgLzoSdpPWkXSY9p5oJIGj/kQk6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Matteo Martelli <matteomartelli3@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 205/583] iio: adc: pac1921: fix wrong channel used in trigger handler read
Date: Wed,  9 Sep 2026 15:38:10 +0200
Message-ID: <20260909134245.247018809@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Cong Nguyen <congnt264@gmail.com>

commit 3364c56b20c1c496bdb8c8df32f96a9947dbf98e upstream.

pac1921_trigger_handler() walks the enabled channels with
iio_for_each_active_channel(), which yields the scan index (bit) of each
active channel, while ch is a separate counter used to pack the samples
contiguously into the scan buffer.

The register to read was looked up with the packing counter instead of
the scan index:

	ret = pac1921_read_res(priv, idev->channels[ch].address, &val);

pac1921_channels[] is ordered by scan index, so channels[bit] is the
channel that is actually enabled, whereas channels[ch] is merely the
ch-th array entry. These coincide only when the enabled channels form a
contiguous prefix (e.g. all channels enabled). With a sparse scan mask -
for example when only the power channel (scan index 3) is enabled - the
handler reads the wrong register (VBUS instead of VPOWER) and pushes it
to userspace as the enabled channel's data.

Index the channel array by the scan index (bit) to read the correct
register, keeping ch only for contiguous packing into the scan buffer.

Fixes: 371f778b83cd ("iio: adc: add support for pac1921")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Acked-by: Matteo Martelli <matteomartelli3@gmail.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/pac1921.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/pac1921.c
+++ b/drivers/iio/adc/pac1921.c
@@ -1037,7 +1037,7 @@ static irqreturn_t pac1921_trigger_handl
 	iio_for_each_active_channel(idev, bit) {
 		u16 val;
 
-		ret = pac1921_read_res(priv, idev->channels[ch].address, &val);
+		ret = pac1921_read_res(priv, idev->channels[bit].address, &val);
 		if (ret)
 			goto done;
 


