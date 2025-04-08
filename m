Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E1126B0A7;
	Tue,  8 Apr 2025 11:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111762; cv=none; b=ptHjaFYSAsHGm6qPJDgdyd55wy7WtDG06g284dtALPzE41+y8TPB8cqorlePvHUgFQzmy28u0wwlU1aOJNisbPvXktcUnXL50p1MAuf13o2EkwodoXYP6eIg3gD3dgVZxmnk+2JMRbCRNV1xCr47vjn7C36s1fC8TwCuCWyu/4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111762; c=relaxed/simple;
	bh=H3CA9wYjvwNBslnOEC0ne7WgV7bVJNlZMEms/n8ptqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A603ZjmB4G1CqmfmeRrH9fnto8fJbSd/iXg946ymYL33si5Mtb3kmIklKVJ+FM2j+K2YQXS3ny/UsQaeJkMKzU4ilJ40DDJ1/1ak8f2SELhcnoNroDz3yO2rzR0caH7KMEwbLanxdm8vVHw9s/e5yFYIdPwExSC28OpRXjBQrGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNqWEX4q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNqWEX4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C8FC4CEE5;
	Tue,  8 Apr 2025 11:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111762;
	bh=H3CA9wYjvwNBslnOEC0ne7WgV7bVJNlZMEms/n8ptqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNqWEX4q8bvBK5+FVCG2paOx0lV/qHHRkH5/dm3r2MqcPBdVcob9i37HghZFHGWaj
	 kpN9n3mfqyRuxwrLuhm6Fzeq5U9pFBYzRsgB115363tTzCyI9lwBNIF5ODJQA03a0P
	 vYJRcWmyPUjDmcKdc5Ss6/WWGgfc7IUZGH72WH/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 548/731] objtool, spi: amd: Fix out-of-bounds stack access in amd_set_spi_freq()
Date: Tue,  8 Apr 2025 12:47:25 +0200
Message-ID: <20250408104927.023504130@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 76e51db43fe4aaaebcc5ddda67b0807f7c9bdecc ]

If speed_hz < AMD_SPI_MIN_HZ, amd_set_spi_freq() iterates over the
entire amd_spi_freq array without breaking out early, causing 'i' to go
beyond the array bounds.

Fix that by stopping the loop when it gets to the last entry, so the low
speed_hz value gets clamped up to AMD_SPI_MIN_HZ.

Fixes the following warning with an UBSAN kernel:

  drivers/spi/spi-amd.o: error: objtool: amd_set_spi_freq() falls through to next function amd_spi_set_opcode()

Fixes: 3fe26121dc3a ("spi: amd: Configure device speed")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Mark Brown <broonie@kernel.org>
Cc: Raju Rangoju <Raju.Rangoju@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/78fef0f2434f35be9095bcc9ffa23dd8cab667b9.1742852847.git.jpoimboe@kernel.org
Closes: https://lore.kernel.org/r/202503161828.RUk9EhWx-lkp@intel.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-amd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-amd.c b/drivers/spi/spi-amd.c
index c85997478b819..17fc0b17e756d 100644
--- a/drivers/spi/spi-amd.c
+++ b/drivers/spi/spi-amd.c
@@ -302,7 +302,7 @@ static void amd_set_spi_freq(struct amd_spi *amd_spi, u32 speed_hz)
 {
 	unsigned int i, spd7_val, alt_spd;
 
-	for (i = 0; i < ARRAY_SIZE(amd_spi_freq); i++)
+	for (i = 0; i < ARRAY_SIZE(amd_spi_freq)-1; i++)
 		if (speed_hz >= amd_spi_freq[i].speed_hz)
 			break;
 
-- 
2.39.5



