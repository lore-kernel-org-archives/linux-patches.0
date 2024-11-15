Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D664952F9E;
	Fri, 15 Nov 2024 07:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731654043; cv=none; b=V5qt5gaVc6uCTfk+lLH4E6oPHSk4VrhcBRID6FnxhbiLn/vhfq4i97F0S/MSSQCfWYDXq8dbZMzCq4pooFgJo+5K4UW6SbdEN+RVFYSec4bJxgudZdNhg1ZhbhxjtaNo4tXD0pLz7CLjAdrQSfHDjlgStP1pfRD1wNZjIMCyPF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731654043; c=relaxed/simple;
	bh=q4Y2EaM7dMVLzaAvnJ9gvCusdvZGiDxSjufpH0Lc1Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RA1MzBnyOBHgzWQ5JjNjj6u1Lsq3xmlSgkfo544h9jYvwdVmRCUW3c8dMdMHrYZFsyK01KPwKSHwxWxcAuCCMwfoGzPPwxTV4w7aCa/KQTikrY5fqh/y48UfW7hhfWgvP4ojBiT9Ln3v5JL9JZvqTfHGXBZizjGnNoYdx8GwGF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yV20nlQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yV20nlQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2F2C4CED0;
	Fri, 15 Nov 2024 07:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731654043;
	bh=q4Y2EaM7dMVLzaAvnJ9gvCusdvZGiDxSjufpH0Lc1Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yV20nlQitdMsC58/GunqAtQz6LphPPRea1pZmQQTTQ0HyomVk+hzXgcE52/Xg0QGp
	 iggV1xL3dKrd8uDXGxUACrvvKiFY5IX5IG4xKuq/wIDD9mivT9yC2vSBRaRbMUkEBt
	 as18k5fS9FecHPss3Musk5TZsOGgtnPFS25ypfR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yann Sionneau <ysionneau@kalrayinc.com>,
	Julian Vetter <jvetter@kalrayinc.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 08/22] sound: Make CONFIG_SND depend on INDIRECT_IOMEM instead of UML
Date: Fri, 15 Nov 2024 07:38:54 +0100
Message-ID: <20241115063721.474928624@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063721.172791419@linuxfoundation.org>
References: <20241115063721.172791419@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Vetter <jvetter@kalrayinc.com>

[ Upstream commit ad6639f143a0b42d7fb110ad14f5949f7c218890 ]

When building for the UM arch and neither INDIRECT_IOMEM=y, nor
HAS_IOMEM=y is selected, it will fall back to the implementations from
asm-generic/io.h for IO memcpy. But these fall-back functions just do a
memcpy. So, instead of depending on UML, add dependency on 'HAS_IOMEM ||
INDIRECT_IOMEM'.

Reviewed-by: Yann Sionneau <ysionneau@kalrayinc.com>
Signed-off-by: Julian Vetter <jvetter@kalrayinc.com>
Link: https://patch.msgid.link/20241010124601.700528-1-jvetter@kalrayinc.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/Kconfig b/sound/Kconfig
index 1903c35d799e1..5848eedcc3c9f 100644
--- a/sound/Kconfig
+++ b/sound/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 menuconfig SOUND
 	tristate "Sound card support"
-	depends on HAS_IOMEM || UML
+	depends on HAS_IOMEM || INDIRECT_IOMEM
 	help
 	  If you have a sound card in your computer, i.e. if it can say more
 	  than an occasional beep, say Y.
-- 
2.43.0



