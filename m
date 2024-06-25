Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D961487E9;
	Tue, 25 Jun 2024 09:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309130; cv=none; b=GEzUmXGYXlUlEyT/L9+lahJJE3MDdQCkbCcEMiebVaqJ4sP5+mCixmvzrO+KsgmwoTniHGA6AImkGE2DpEBkSch8UeV2RCwFgZ0zMDr730lqcncx8ZT1sqdkglX6am+7QiOxHTvTFU6iP0IFENu3pHL23fZlag/ZtlzD+oa3L6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309130; c=relaxed/simple;
	bh=WKzH2fmEWebstAUwK3iibYD6hghDMviDEUOAqCmIlFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TiX3jDF+b3xFJjtKzNxoM16Nh7y+HmuntCW8wFNZ5eyNIa2W3Cufhcmkxc9Ejy9P0cphJGPsNL7ZCzVDKLSN3f6yZzArDOFF6DP8f6arl8Glj6Kyz9wwfZ70yWuESkf9vTDMfhNb1WsiEM48qWlwgmZM9HJUNzPVEXtcaZ70UYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i80Vh9s7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i80Vh9s7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10728C4AF09;
	Tue, 25 Jun 2024 09:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309130;
	bh=WKzH2fmEWebstAUwK3iibYD6hghDMviDEUOAqCmIlFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i80Vh9s75qiBKGzHXpvEmJdM2y27rmVZZ+DIz9ZaPRun6MkyCClxtXnHG4v8UGzzj
	 S3k+mUoyAab+k0MuT7d9ENHPz2S3fy/XMORV3e3dKSLfcMRx9VyRWNAxqPt7peA2Hb
	 EBfA64zigUIowAnFNbqMuNYOjvFyUEll8CoE9E/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/192] spi: cs42l43: Correct SPI root clock speed
Date: Tue, 25 Jun 2024 11:32:57 +0200
Message-ID: <20240625085541.205975300@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 4eecb644b8b82f5279a348f6ebe77e3d6e5b1b05 ]

The root clock is actually 49.152MHz not 40MHz, as it is derived from
the primary audio clock, update the driver to match. This error can
cause the actual clock rate to be higher than the requested clock rate
on the SPI bus.

Fixes: ef75e767167a ("spi: cs42l43: Add SPI controller support")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://msgid.link/r/20240604131704.3227500-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cs42l43.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-cs42l43.c b/drivers/spi/spi-cs42l43.c
index c1556b6529092..3169febd80514 100644
--- a/drivers/spi/spi-cs42l43.c
+++ b/drivers/spi/spi-cs42l43.c
@@ -19,7 +19,7 @@
 #include <linux/units.h>
 
 #define CS42L43_FIFO_SIZE		16
-#define CS42L43_SPI_ROOT_HZ		(40 * HZ_PER_MHZ)
+#define CS42L43_SPI_ROOT_HZ		49152000
 #define CS42L43_SPI_MAX_LENGTH		65532
 
 enum cs42l43_spi_cmd {
-- 
2.43.0



