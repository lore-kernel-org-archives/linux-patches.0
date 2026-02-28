Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE16379EF7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301893; cv=none; b=LxX4dUUic/9okKe5QfYGooB3HzMQYXy1rfVLD66Pn7nyJHggEFGHjIvezLyT2iKrBVMPCV2y9Qc2T2kIWSqBfWy1B90LX904+neVSpr7XDdPDpx3RAuR8qNxzraDX/Tk2NeAhEKFUtye8brr5KlfAD2E6FgqJIVQH2EC265ykw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301893; c=relaxed/simple;
	bh=azGAy0U9lhIpAe5iZFZEw04x31TjJDIcYvSO/4NUc7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uflsp5Y6YSdHxCeH85rVUMZWIRwYANaT93cUMy4TYByKZUss3uc/DPdHmQnRWODCy8hHgT4w/gkIgGSV4TUtBA6byHXoMh1JvuY1/V/5xuPgWwrabh8uU4jpNO+rWzQH7/Ii8UxeWKujoq9x2Kc1U1lf4aaGyhby7cfMiFslq8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=boQBOFWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="boQBOFWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C316C2BCB4;
	Sat, 28 Feb 2026 18:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301893;
	bh=azGAy0U9lhIpAe5iZFZEw04x31TjJDIcYvSO/4NUc7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=boQBOFWFbFsoxcS48pRPn/3Za8InwKpN8KCmSHqL73jhv/El+5R+JHLaUszSSMa10
	 zCLU88DVNljC0jK+TPz/hv54zLl18l7Gn+i6jaUBXJwzkmynuOaXytP0iZPrvHe3J4
	 t8romID42FpnE/oJS8Fn9x1F0KzWcVogsiQR4SCZe/IY4cPFMHe08l2eawJTEshl5m
	 1KYIA+VB9i05Q5aDAHdPbkzx0cyAArtN8RrRwbUARGd97HbjRYO1C0/tfLYP4EXm+E
	 xn4hqfSlC0hzlK6rjBJVif7nLnr7eS/+KABPd0qK87SKn2hNs7VjkzGNrj8hcelOas
	 JT6fcH9g5Ls5w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Arnd Bergmann <arnd@arndb.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 321/385] soundwire: intel_ace2x: add SND_HDA_CORE dependency
Date: Sat, 28 Feb 2026 12:59:03 -0500
Message-ID: <20260228180011.1568201-321-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 4d8f3b7024ae5..a057c64d93f0b 100644
--- a/drivers/soundwire/Kconfig
+++ b/drivers/soundwire/Kconfig
@@ -38,6 +38,7 @@ config SOUNDWIRE_INTEL
 	select AUXILIARY_BUS
 	depends on ACPI && SND_SOC
 	depends on SND_SOC_SOF_HDA_MLINK || !SND_SOC_SOF_HDA_MLINK
+	depends on SND_HDA_CORE || !SND_HDA_ALIGNED_MMIO
 	help
 	  SoundWire Intel Master driver.
 	  If you have an Intel platform which has a SoundWire Master then
-- 
2.51.0

