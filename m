Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31C4155A3C;
	Mon, 16 Sep 2024 12:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488509; cv=none; b=mhxfJREXWVzuINNImFbc7XjHrRl7yrhmiFG8S/hqTX01nzkjq7JKHwVnCdSdNkYMxWa9CJ2nyAVjoHZYjdFXJzTUrFIaXlAHGeVXcFt3uzvWV/Yn1TxYcxXHe/rvW4aj8R21+HIjTbD+wrwL4pIX+FGE8Wf1VwrFAukpEW8acRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488509; c=relaxed/simple;
	bh=6O0S07BSYH2gXJw8doMUQARbR0JF9b3wOcBBSb12SO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aR6nD9HuVA3ynNCNbgLakLns8LKhHIPo70MXovnbPXj8BULuK1+KhOCCjDXCC/yDm9dtJtpOcn4b/RGjMfuflApA7mBJG2e2i+109p/70emcFWUsyYu8rwqnmLCbU5xO2sRSgx3ru926mD1GcfDRnnOLYZ7G6vXRnXmakjxKSdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPBremsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPBremsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42546C4CECE;
	Mon, 16 Sep 2024 12:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488509;
	bh=6O0S07BSYH2gXJw8doMUQARbR0JF9b3wOcBBSb12SO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rPBremsdxCSV2W7vE7qLDG10RSpf8g57Eq3yjpHfnJ1jZQqV+BOOVMUeF/kPwBym1
	 snCrMEcVknoz/W998YFl6CyNv2u8C2rZw+PaICrpGuiElEsWjx8vUS42IIVkUbHfXh
	 HwDaUoFqOG5Z4I8iO4DqnGxjdyztO0nQBc86D7L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dumitru Ceclan <dumitru.ceclan@analog.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 04/91] iio: adc: ad7124: fix DT configuration parsing
Date: Mon, 16 Sep 2024 13:43:40 +0200
Message-ID: <20240916114224.656385094@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dumitru Ceclan <mitrutzceclan@gmail.com>

[ Upstream commit 61cbfb5368dd50ed0d65ce21d305aa923581db2b ]

The cfg pointer is set before reading the channel number that the
configuration should point to. This causes configurations to be shifted
by one channel.
For example setting bipolar to the first channel defined in the DT will
cause bipolar mode to be active on the second defined channel.

Fix by moving the cfg pointer setting after reading the channel number.

Fixes: 7b8d045e497a ("iio: adc: ad7124: allow more than 8 channels")
Signed-off-by: Dumitru Ceclan <dumitru.ceclan@analog.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://patch.msgid.link/20240806085133.114547-1-dumitru.ceclan@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7124.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ad7124.c b/drivers/iio/adc/ad7124.c
index bd323c6bd756..d2fe0269b6d3 100644
--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -842,8 +842,6 @@ static int ad7124_parse_channel_config(struct iio_dev *indio_dev,
 	st->channels = channels;
 
 	device_for_each_child_node_scoped(dev, child) {
-		cfg = &st->channels[channel].cfg;
-
 		ret = fwnode_property_read_u32(child, "reg", &channel);
 		if (ret)
 			return ret;
@@ -861,6 +859,7 @@ static int ad7124_parse_channel_config(struct iio_dev *indio_dev,
 		st->channels[channel].ain = AD7124_CHANNEL_AINP(ain[0]) |
 						  AD7124_CHANNEL_AINM(ain[1]);
 
+		cfg = &st->channels[channel].cfg;
 		cfg->bipolar = fwnode_property_read_bool(child, "bipolar");
 
 		ret = fwnode_property_read_u32(child, "adi,reference-select", &tmp);
-- 
2.43.0



