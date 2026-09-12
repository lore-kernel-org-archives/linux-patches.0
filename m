Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBD2366052;
	Sat, 12 Sep 2026 09:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204911; cv=none; b=q8nUFruZygDAr6+WdMcZEdVMHg1ONcPys8Cq6icxkC07z9IQbqYNKc9BwkWrtD9jNSLToXgEsTnYBjJ+gJWaUChfSMiakI2DAy3QNbVzwII4HaeUouy5bB6UaG/mVjeqLiPbjDy5JhQLFKgTGsajhyrNajJpoptR5BVf3gOTPT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204911; c=relaxed/simple;
	bh=COFRfdtcF/1Zd3R6XiSpUE+73K+eefUBJQElt1XDXus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yg/BPkxVmJz0HUI+MHsjpDpMb0LjqVcy8pbrFa65KFaJQV8WSM89DnyoCWkFR3dRhhtmdm6FSvlZj4qAGNOJWVnmFw8/L37x9vJqryOxIfsqj6tBfrGvDKaTSpmOPd+J80nB0nG4f4qTjkOGEufi/3S2PuY4rQk3agFg8u+HxLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kr9lT4/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kr9lT4/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C6E1F000FF;
	Sat, 12 Sep 2026 09:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204910;
	bh=T0o4sLjJnhrW6sPHsjqJ2oYytZ4JvdbiZSIvcBiXecQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kr9lT4/qpYAZRv3TjzkywD8QvipBBQgTLIuen1Yw9DMn4jEBZXpumi/QesLCrpQpk
	 9OLUS0dTJEfqPA/MRJorsuplTrf04ZbjVLThH86WuH+eXxsr5oUVVyn0Wfno0mI1lW
	 l2nqPhEaDRmdJXYlC7xI0QCmdPinuC3P1z+hym2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Rosen Penev <rosenp@gmail.com>,
	Julian Braha <julianbraha@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1693/1815] ASoC: fix unmet dependencies on PPC_BESTCOMM and SND_SOC_AC97_BUS
Date: Sat, 12 Sep 2026 08:57:23 +0200
Message-ID: <20260912065728.724628192@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit 72cc574aa3791aa4f05d247b4e884cdbd135819a ]

SND_MPC52xx_SOC_PCM030 and SND_MPC52xx_SOC_EFIKA both select
SND_SOC_MPC5200_AC97 without ensuring its dependency on PPC_BESTCOMM is
met. This causes unmet dependencies such as:

WARNING: unmet direct dependencies detected for SND_SOC_MPC5200_AC97
  Depends on [n]: SOUND [=m] && SND [=m] && SND_SOC [=m] && SND_POWERPC_SOC [=m] && PPC_BESTCOMM [=n]
  Selected by [m]:
  - SND_MPC52xx_SOC_PCM030 [=m] && SOUND [=m] && SND [=m] && SND_SOC [=m] && SND_POWERPC_SOC [=m] && PPC_MPC5200_SIMPLE [=y]

In v1, Rosen pointed out that the import of "mpc5200_dma.h" is actually
unnecessary, and Arnd suggested that the 'select' of SND_SOC_MPC5200_AC97
be changed to 'depends on'.

This resolves all 3 unmet dependencies.

These unmet dependency bugs were detected by kconfirm, a static analysis tool
for Kconfig.

Fixes: a9262c4fd404 ("ASoC: Support for AC97 on Phytec pmc030 base board.")
Fixes: 6ffee43ecf8b ("ASoC: Fabric bindings for STAC9766 on the Efika")
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Julian Braha <julianbraha@gmail.com>
Link: https://patch.msgid.link/20260821175410.179631-1-julianbraha@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/Kconfig               | 4 ++--
 sound/soc/fsl/efika-audio-fabric.c  | 2 --
 sound/soc/fsl/pcm030-audio-fabric.c | 2 --
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index 8ae59c0948788..04940879dfd80 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -244,7 +244,7 @@ config SND_SOC_MPC5200_AC97
 config SND_MPC52xx_SOC_PCM030
 	tristate "SoC AC97 Audio support for Phytec pcm030 and WM9712"
 	depends on PPC_MPC5200_SIMPLE
-	select SND_SOC_MPC5200_AC97
+	depends on SND_SOC_MPC5200_AC97
 	select SND_SOC_WM9712
 	help
 	  Say Y if you want to add support for sound on the Phytec pcm030
@@ -253,7 +253,7 @@ config SND_MPC52xx_SOC_PCM030
 config SND_MPC52xx_SOC_EFIKA
 	tristate "SoC AC97 Audio support for bbplan Efika and STAC9766"
 	depends on PPC_EFIKA
-	select SND_SOC_MPC5200_AC97
+	depends on SND_SOC_MPC5200_AC97
 	select SND_SOC_STAC9766
 	help
 	  Say Y if you want to add support for sound on the Efika.
diff --git a/sound/soc/fsl/efika-audio-fabric.c b/sound/soc/fsl/efika-audio-fabric.c
index 4d3266d9cbb79..e9c728bae8b97 100644
--- a/sound/soc/fsl/efika-audio-fabric.c
+++ b/sound/soc/fsl/efika-audio-fabric.c
@@ -22,8 +22,6 @@
 #include <sound/initval.h>
 #include <sound/soc.h>
 
-#include "mpc5200_dma.h"
-
 #define DRV_NAME "efika-audio-fabric"
 
 SND_SOC_DAILINK_DEFS(analog,
diff --git a/sound/soc/fsl/pcm030-audio-fabric.c b/sound/soc/fsl/pcm030-audio-fabric.c
index 5542c4ee6d129..a7a5dba83a2f8 100644
--- a/sound/soc/fsl/pcm030-audio-fabric.c
+++ b/sound/soc/fsl/pcm030-audio-fabric.c
@@ -13,8 +13,6 @@
 
 #include <sound/soc.h>
 
-#include "mpc5200_dma.h"
-
 #define DRV_NAME "pcm030-audio-fabric"
 
 struct pcm030_audio_data {
-- 
2.53.0



