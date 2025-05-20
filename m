Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2541B222570;
	Tue, 20 May 2025 14:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749974; cv=none; b=izBG4TKpZFiB7bawXFF/V3/JNWyGbKv70hXB9hJfGshirbV5WDTsqAybvxJSx/XJ+0NI2V4rJ/d7/wcllnGH4pFwWL8RYa6TqJnZ2ByTxc2wrnR0/Cxqrm2cAt91tCu6klbNT+cncNJnVPx1ELU87MP0H4DSIcngTiFc5HrYhrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749974; c=relaxed/simple;
	bh=dKvhh4Z46PVf1/5dKzNUHF8YWUzBPJeJOSfNdB+4ffk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLoJOscimfz9m+NobTP+WqPOHH+7FrljuhZqreX9cPvT+rxxmFR67B813jCMW53pfhQVx66DMkUou3ufu67ZfrdAqzp+HQmTJ314iHYUYr/Xn6nKpGFFlgqwurTebHx1KSwyUEdYHuva+i4iTCJVNF1lvlIEwQhq+XOZEN6htzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GOa0zfy4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GOa0zfy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369D2C4CEE9;
	Tue, 20 May 2025 14:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749973;
	bh=dKvhh4Z46PVf1/5dKzNUHF8YWUzBPJeJOSfNdB+4ffk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOa0zfy4Tuut3vxTyH5PdOnwc17Uersbuwh67dCb3dvmUYl85d/x8IvwLarrre/Az
	 NXyo3KbMOdUGKZ3TOiY9w2TZnkD1r/gEa/MihP/cAUZXXh0AnKt050HV7LZLap/imy
	 T52zvAvYgaEt00k2EYzxo/7MaTodl+KAza/d7PMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 089/117] spi: tegra114: Use value to check for invalid delays
Date: Tue, 20 May 2025 15:50:54 +0200
Message-ID: <20250520125807.526074287@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Kling <webgeek1234@gmail.com>

commit e979a7c79fbc706f6dac913af379ef4caa04d3d5 upstream.

A delay unit of 0 is a valid entry, thus it is not valid to check for
unused delays. Instead, check the value field; if that is zero, the
given delay is unset.

Fixes: 4426e6b4ecf6 ("spi: tegra114: Don't fail set_cs_timing when delays are zero")
Cc: stable@vger.kernel.org
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20250506-spi-tegra114-fixup-v1-1-136dc2f732f3@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-tegra114.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -728,9 +728,9 @@ static int tegra_spi_set_hw_cs_timing(st
 	u32 inactive_cycles;
 	u8 cs_state;
 
-	if ((setup->unit && setup->unit != SPI_DELAY_UNIT_SCK) ||
-	    (hold->unit && hold->unit != SPI_DELAY_UNIT_SCK) ||
-	    (inactive->unit && inactive->unit != SPI_DELAY_UNIT_SCK)) {
+	if ((setup->value && setup->unit != SPI_DELAY_UNIT_SCK) ||
+	    (hold->value && hold->unit != SPI_DELAY_UNIT_SCK) ||
+	    (inactive->value && inactive->unit != SPI_DELAY_UNIT_SCK)) {
 		dev_err(&spi->dev,
 			"Invalid delay unit %d, should be SPI_DELAY_UNIT_SCK\n",
 			SPI_DELAY_UNIT_SCK);


