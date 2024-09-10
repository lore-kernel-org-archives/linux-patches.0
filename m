Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60256224F6;
	Tue, 10 Sep 2024 09:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962090; cv=none; b=UigMg92oKcV8AfDzzyvDGWgFw5yNwV2V8oZsOCuOmmqsbyBG3d/cGZp8FmDhMzyQI3FchfjDA993BttXBZ/VW8qV+qlEsTX4VRDwnMoeTyL1KcOx9puEEBghWZIOCjj9S6+gX1h4OUs3KAKJV8p+liSmNsYPz2xDZmH0oA0yhrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962090; c=relaxed/simple;
	bh=MMertbNdc7iR2eVaUI3o5rTaE3ROqmPmEoKbCKR6L+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7mfYJ2lxEEkLHnrSM0vzw2YLLWcn33A45VbatiXodLTMFIIoxTvDwascZQtQbV/a2p5dtDkj6xlghZ5QgK6VuAZu269SkTvPOKJFXUinIFOqXc1Y8sh1olngvOvK/LeprrzDqJ5qSWDqomkFa6ShD2APIzHDXu9ojrUKKk4P/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJV309xG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJV309xG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA00C4CEC3;
	Tue, 10 Sep 2024 09:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962090;
	bh=MMertbNdc7iR2eVaUI3o5rTaE3ROqmPmEoKbCKR6L+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJV309xGahJ+eCIB8FrfPUKW552O2n0XaPgL38BlIszuHC0oLc1JvPRkZlFapDTp7
	 nVt/KYW4WHP85YpNXVPAG1vaa8N6rL6BnyN6vthrpYziSwb3jqeW4BoUK2foeKGbo8
	 q/eyc/P3aZo9/jqNCnURN0+JlqwdgfnmDcyW2qac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dumitru Ceclan <dumitru.ceclan@analog.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.10 292/375] iio: adc: ad7124: fix DT configuration parsing
Date: Tue, 10 Sep 2024 11:31:29 +0200
Message-ID: <20240910092632.373073257@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dumitru Ceclan <mitrutzceclan@gmail.com>

commit 61cbfb5368dd50ed0d65ce21d305aa923581db2b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7124.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -842,8 +842,6 @@ static int ad7124_parse_channel_config(s
 	st->channels = channels;
 
 	device_for_each_child_node_scoped(dev, child) {
-		cfg = &st->channels[channel].cfg;
-
 		ret = fwnode_property_read_u32(child, "reg", &channel);
 		if (ret)
 			return ret;
@@ -861,6 +859,7 @@ static int ad7124_parse_channel_config(s
 		st->channels[channel].ain = AD7124_CHANNEL_AINP(ain[0]) |
 						  AD7124_CHANNEL_AINM(ain[1]);
 
+		cfg = &st->channels[channel].cfg;
 		cfg->bipolar = fwnode_property_read_bool(child, "bipolar");
 
 		ret = fwnode_property_read_u32(child, "adi,reference-select", &tmp);


