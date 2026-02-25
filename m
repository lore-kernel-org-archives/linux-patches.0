Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D733016F7;
	Wed, 25 Feb 2026 06:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002674; cv=none; b=IXTz/FSsj1xDUqRqgvOPiRT3U50RjeJ491zthCmakoFQa4qumxou/+oMJ5v+iADluPfGmcSDeCj6f3gHS4dusLvwAd4a5QFPG+kPXkz47EjUZ17HQw16MKcp1xlTIhcJ53MZw/NelYiWS9AOdNRmO2a+l1HIXIbzKxic/nCCLkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002674; c=relaxed/simple;
	bh=xu/LA9qUF5fQDRDOZI+B5fps52WgMVXKbpvQsLNxGAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMukaZcAQjMTShBvAAbH0a/HRYOWqaQ5YPQd/krjc4009q+e7czXb4vDbW/6paavC4DIwc+fuoMgnjiaZzPTmITZIcTn5qwOYRjCsB/9deDyQW63Wu8nqjmInPCVf0JNL9izkemi0UGB2lFiWmJ8+PFGn1ZqFsaXPCe2wLR8ITk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wbuti/+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wbuti/+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26B7C116D0;
	Wed, 25 Feb 2026 06:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002673;
	bh=xu/LA9qUF5fQDRDOZI+B5fps52WgMVXKbpvQsLNxGAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wbuti/+JxYF0G0ldlOXYNUiJ4fR96m92rwFxh+mauGMeRxKSUwpCtav0gxKuVQBev
	 xAR80PIqLj1hpnfTOo27u4JriIhCmjmMNEh1pqjrIf0MqvP+LOwDlOT0YiFxN6LLUP
	 +KDmQLdhlGMRAjLBoCJDXRFuOqCL8fYk9d0Zs1Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 457/641] soundwire: intel_ace2x: add SND_HDA_CORE dependency
Date: Tue, 24 Feb 2026 17:23:03 -0800
Message-ID: <20260225012359.588542696@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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



