Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DBC2EA171;
	Tue, 22 Jul 2025 14:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193396; cv=none; b=pxI2bWcEPOAtJ2gQV3Guqw6ycMxFG3kAdaznaOVObd/lB24J6fROW+xhR6UyNqgG/cykrCq68n9xYJtCF+pkURv64fz8kqnMcqAfONeXdS8fwa14AzjL/LNm6UqHzKKIHWjRoClChcCa0bcNw6mfCtwjzbI2ld0tFszgJYoEmgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193396; c=relaxed/simple;
	bh=Dl2qpA4XWYSnQGFHjoxQq4jvNi8GLN7kwHw7DrE33R4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OpHXDUNRmrXu/5dzd7fbWr6y+T54jWV0OVS2oAHSQK0OSS1/6HE3WTRbcYoSsFPKlipQcK7mZ9AOfmHTLjz5HnemOYbantBmwDdnz3ksZmGadHi4/Ry66jLxUBM1s4gWLKFytU5aQMpt74uFa9eG/fJMZkXABr/S27qFs0DwYUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMuRj5d4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMuRj5d4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71D8C4CEEB;
	Tue, 22 Jul 2025 14:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193396;
	bh=Dl2qpA4XWYSnQGFHjoxQq4jvNi8GLN7kwHw7DrE33R4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMuRj5d4ELuTLxo7hI48HSmrxHmuuSJoQEdoF28ASCRLxGD22P9OWXy+/Y/Ml6mO9
	 ENel4FBcPP1vwqSSLKNXIxlEQ64EZlKJeViG/oJHO5uFTlU+O81XQt+STPbNnCc3LN
	 dILyNqNdYk2lDuG7LcESPo8kCy1OS0gGz78895qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.15 080/187] iio: adc: ad7380: fix adi,gain-milli property parsing
Date: Tue, 22 Jul 2025 15:44:10 +0200
Message-ID: <20250722134348.708635210@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 24fa69894ea3f76ecb13d7160692ee574a912803 upstream.

Change the data type of the "adi,gain-milli" property from u32 to u16.
The devicetree binding specifies it as uint16, so we need to read it as
such to avoid an -EOVERFLOW error when parsing the property.

Fixes: c904e6dcf402 ("iio: adc: ad7380: add support for adaq4370-4 and adaq4380-4")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250619-iio-adc-ad7380-fix-adi-gain-milli-parsing-v1-1-4c27fb426860@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7380.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ad7380.c
+++ b/drivers/iio/adc/ad7380.c
@@ -1920,8 +1920,9 @@ static int ad7380_probe(struct spi_devic
 
 	if (st->chip_info->has_hardware_gain) {
 		device_for_each_child_node_scoped(dev, node) {
-			unsigned int channel, gain;
+			unsigned int channel;
 			int gain_idx;
+			u16 gain;
 
 			ret = fwnode_property_read_u32(node, "reg", &channel);
 			if (ret)
@@ -1933,7 +1934,7 @@ static int ad7380_probe(struct spi_devic
 						     "Invalid channel number %i\n",
 						     channel);
 
-			ret = fwnode_property_read_u32(node, "adi,gain-milli",
+			ret = fwnode_property_read_u16(node, "adi,gain-milli",
 						       &gain);
 			if (ret && ret != -EINVAL)
 				return dev_err_probe(dev, ret,


