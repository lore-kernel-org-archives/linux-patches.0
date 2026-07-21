Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C0B415F12;
	Tue, 21 Jul 2026 18:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659705; cv=none; b=qmoyQQZVImoaGFL+odidV6ZhqN6To8xetBxRW6nqrGm8tUqvBDcFMet7/8RatvxWTXeIFRz4o36jDksaH/2K0EsU+hXqa8fkyYc1xhUg/lT6JhUsxEVkhYJG+i0MvBT2T+nniZgb9tZIdl/qrL8amg9rUXkEHQeoxlnEF2DzTkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659705; c=relaxed/simple;
	bh=e7sCeLeV6grRC1zbXm5EcUZEdMWivzlk1iR77PZyumY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfN0eKJy+j4i2z/yUyIGD+LxaV90837stcFVfwcPLp5Fcs8t2j7vldis39fiJh9kz1xOycZdwRyBxwpOjkbXdrAyIRqNIjBSHltwvFUpcbweyZgkcOin9y05Ou/YAD0BVluWQLUHqwSXGLbnUQOvbe8l5YIbd10VBG6IfwJlhdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDxF/hwe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDxF/hwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2471F00A3A;
	Tue, 21 Jul 2026 18:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659701;
	bh=/qNmh/ODO5Xh8CHkZB/ZKeU93qfI9/Qsz30qqm7b8Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CDxF/hwePf/ezu25NGHBBt6ONyFZb2fFNSv7EVbhOkoQYeXK9JVKoUZVZsnfm3Umg
	 UtSsPZgoKzrawDjxLiEr8U4AcSrRhDLRtyB5RPjcKy0QDijVw+6MMd6ip1Up7py3xx
	 Ah39u5oCKcb/qaccDl430XRNv6wXIGvs6ckRsAEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0702/2077] ASoC: SOF: Intel: hda-sdw-bpt: select SND_SOF_SOF_HDA_SDW_BPT properly
Date: Tue, 21 Jul 2026 17:06:15 +0200
Message-ID: <20260721152609.352895192@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 999ec4c29d73ac85b639a31bbc85ad2ec00eb9d7 ]

When SND_SOC_SOF_INTEL_LNL is set, SND_SOF_SOF_HDA_SDW_BPT must also
be enabled, in order to let the soundwire support call into it.

However, there are configurations with SND_SOF_SOF_HDA_SDW_BPT=m
and SND_SOF_SOF_HDA_SDW_BPT=m but SOUNDWIRE_INTEL=y, which still
lead to a link failure:

aarch64-linux-ld: drivers/soundwire/intel_ace2x.o: in function `intel_ace2x_bpt_wait':
intel_ace2x.c:(.text+0xfc8): undefined reference to `hda_sdw_bpt_wait'
aarch64-linux-ld: drivers/soundwire/intel_ace2x.o: in function `intel_ace2x_bpt_send_async':
intel_ace2x.c:(.text+0x1ff8): undefined reference to `hda_sdw_bpt_get_buf_size_alignment'

Address this by moving the 'select SND_SOF_SOF_HDA_SDW_BPT' into
SND_SOC_SOF_HDA_GENERIC.

Fixes: 614d416dd8ae ("ASoC: SOF: Intel: hda-sdw-bpt: fix SND_SOF_SOF_HDA_SDW_BPT dependencies")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260611132310.137688-2-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/intel/Kconfig b/sound/soc/sof/intel/Kconfig
index 9ddf14e7946aab..915abbef398d54 100644
--- a/sound/soc/sof/intel/Kconfig
+++ b/sound/soc/sof/intel/Kconfig
@@ -266,10 +266,8 @@ config SND_SOC_SOF_METEORLAKE
 
 config SND_SOC_SOF_INTEL_LNL
 	tristate
-	select SOUNDWIRE_INTEL if SND_SOC_SOF_INTEL_SOUNDWIRE != n
 	select SND_SOC_SOF_HDA_GENERIC
 	select SND_SOC_SOF_INTEL_SOUNDWIRE_LINK_BASELINE
-	select SND_SOF_SOF_HDA_SDW_BPT if SND_SOC_SOF_INTEL_SOUNDWIRE != n
 	select SND_SOC_SOF_IPC4
 	select SND_SOC_SOF_INTEL_MTL
 
@@ -331,6 +329,8 @@ config SND_SOC_SOF_HDA_GENERIC
 	select SND_SOC_SOF_HDA_PROBES
 	select SND_SOC_SDW_UTILS if SND_SOC_SOF_INTEL_SOUNDWIRE !=n
 	select SND_SOC_SOF_HDA_MLINK if SND_SOC_SOF_HDA_LINK
+	select SND_SOF_SOF_HDA_SDW_BPT if SND_SOC_SOF_INTEL_LNL != n && \
+					  SND_SOC_SOF_INTEL_SOUNDWIRE !=n
 	help
 	  This option is not user-selectable but automagically handled by
 	  'select' statements at a higher level.
-- 
2.53.0



