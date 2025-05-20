Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4804D242D98;
	Tue, 20 May 2025 14:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750860; cv=none; b=oB6GE2FxrTg7FXvabvSK3BmgAJl12P3AvtiIK1cbhwtM2EWA2XEVJinaeAk7RUi+1m6UND/EhI+s9EiBuK0SgLvchjfrtwaCpdtJMs42suYxxzsHlUh0q1A2A95LmD4wXelZ/mZkKFezR4LRj5PbiWFfZVzwS7BT2wh1uW9G3fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750860; c=relaxed/simple;
	bh=j4lz3jRBo5JkiNAb62OQ9KrAfXR0jPfVE8169NUKghw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3bgA55vxDbIF1Uv+wJ2JKV8J3fEnPJrjrdrGAPVTH7C948NfsIKhsfkDW1YJ7zOZIr48YVU2+l+wsNgW0dbzVM0wrDIIPzrx13qVj3oUblvn8FseV1Wo9uCdDnj/CEipWyLtTJVq65QRwmtlmCBf46nj6+mIKwFOcEy/aCdwPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbckZZW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbckZZW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1DEC4CEE9;
	Tue, 20 May 2025 14:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750860;
	bh=j4lz3jRBo5JkiNAb62OQ9KrAfXR0jPfVE8169NUKghw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NbckZZW3t6hjSXrdMM6VAZB/MW7bGBUsp3DGidtoLxtkFfmnvL3gE6boXK/gRKX9o
	 6bBrCGxt4uCd10HmFYlw9qagAFdK5JQNFMnNQ061DGpl8n48jJ2eOXXj78biD3LROC
	 EkbsibleiJQw90aHPdrrtQkCDi730ni1vcEfnAWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.14 115/145] spi: tegra114: Use value to check for invalid delays
Date: Tue, 20 May 2025 15:51:25 +0200
Message-ID: <20250520125815.051877884@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


