Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DF6256C84;
	Wed, 25 Feb 2026 01:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983450; cv=none; b=Tyxy9d0ZFLwwPiIAgu3lU8Gy+epn5G4Be8LR33gsfWJjdnSJXYg9wiOjx0mZXGevV0MxhNFS4FaxZc1NiCOlo6adr2hp75Rw8ZBXCY830/j1ZH+Phkd1vTm2CiHJnZz42GcKCBgqZkpVqkl7a77gnT68dsJnRISweyk/23zrcf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983450; c=relaxed/simple;
	bh=VLfygZwy6Gd4ofN+zDlP8MBzk1sLe9JKENlW1Prw/5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZCBt9/8jn5zJqwD2Ev3rsyXGyDfolUB6YpRRs603oUeH5HI5KP9p60188YY23d8dfpaflpnMVHBsXiXeT7h3ka4q0NHHiUvBi4ebnK3zLqboAvxjZWyHGfPWVNBJPCf/9RW3KjirrGilLzct8gLyIj2Cjs2yGwjGLKTJxTS2nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tqrcp1YI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tqrcp1YI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DE4C116D0;
	Wed, 25 Feb 2026 01:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983450;
	bh=VLfygZwy6Gd4ofN+zDlP8MBzk1sLe9JKENlW1Prw/5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tqrcp1YIMwI52QSzE4I9w5QfcdkHZSUijwMMDCB3HZt5uCRIhjY2mpK87PF/IPUW5
	 qEKmChLR/BEW/VDAI3k7MD89WC+ErEcNJJ4Vq45l4IMcEuM1CZR5KYkd2zQne4H2Gn
	 JuCwFW+lolIh+bTBXipjojPKwY8J0XuDSnIaSxLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 566/781] soundwire: intel_ace2x: add SND_HDA_CORE dependency
Date: Tue, 24 Feb 2026 17:21:15 -0800
Message-ID: <20260225012413.685599235@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit dc3a6a942e9ee3f18560bfcb16c06bb94f37fabf ]

The ace2x driver can optionally use the HDA infrastructure, but can still
build without that. However, with SND_HDA_CORE=m and SND_HDA_ALIGNED_MMIO=y,
it fails to link as built-in:

aarch64-linux-ld: drivers/soundwire/intel_ace2x.o: in function `intel_shim_wake':
intel_ace2x.c:(.text+0x2518): undefined reference to `snd_hdac_aligned_read'
aarch64-linux-ld: intel_ace2x.c:(.text+0x25d4): undefined reference to `snd_hdac_aligned_read'
aarch64-linux-ld: intel_ace2x.c:(.text+0x268c): undefined reference to `snd_hdac_aligned_write'

Add a Kconfig dependency that forces the soundwire driver to be a loadable
module if necessary.

Fixes: 79e7123c078d ("soundwire: intel_ace2x: fix wakeup handling")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20251223215014.534756-1-arnd@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soundwire/Kconfig b/drivers/soundwire/Kconfig
index ad56393e4c93b..196a7daaabdb8 100644
--- a/drivers/soundwire/Kconfig
+++ b/drivers/soundwire/Kconfig
@@ -40,6 +40,7 @@ config SOUNDWIRE_INTEL
 	select AUXILIARY_BUS
 	depends on ACPI && SND_SOC
 	depends on SND_SOC_SOF_HDA_MLINK || !SND_SOC_SOF_HDA_MLINK
+	depends on SND_HDA_CORE || !SND_HDA_ALIGNED_MMIO
 	help
 	  SoundWire Intel Master driver.
 	  If you have an Intel platform which has a SoundWire Master then
-- 
2.51.0



