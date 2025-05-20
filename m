Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37674247289;
	Tue, 20 May 2025 14:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750406; cv=none; b=UGhE/prwGPvp1wMUrNBhzU4jTjcxVkUelFoZaYn+OkI2+ZXo+CoDBF8qWnLcVkKRXvnwjAJjUUW1dhzdY+g8lfY133H0nBRlW/3eX3ml98IcO/yv3OqBMn583Y7y8I+t9Si2gtpkGgBOrhlQsj3lgWr3KWX9Aj0JbgNvGBxByBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750406; c=relaxed/simple;
	bh=SVqY0nyTu6Q/dV6gRD8XyKY75WEOEOtJmpUYPVl8BRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YloEZnOaTqjZQ0FZlNxz3iYHB8WCWJ+TsJ/++9E1wHFIgXv8Qdt9OtSPl0DwTFoWLn9ehws8ATBnGmwborylvJfCuXjtI+Q7+RlKrpivTVpSrPrw8JjtW2/haByvhJ2B+dmasHzemUONL9obS/lkzJm38KXU+oN7yeUR1B3uSNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C27DOVDZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C27DOVDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A782C4CEE9;
	Tue, 20 May 2025 14:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750406;
	bh=SVqY0nyTu6Q/dV6gRD8XyKY75WEOEOtJmpUYPVl8BRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C27DOVDZEivZAuTiKfyAHDNqOlgDzmcWfLt/sH1LIXHT8ODROtjeG3ZMQZeC3xOJ1
	 apQRz3yhDiVy4IvYHk09eRAKHmKV/277wSx4+x5r0JW6I3QNliTqqAvDLQLpQqUJJa
	 0xLJEY344QtyCGBcBjoXuHs6SeWExjSsyc+OibpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 112/143] spi: tegra114: Use value to check for invalid delays
Date: Tue, 20 May 2025 15:51:07 +0200
Message-ID: <20250520125814.443948383@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


