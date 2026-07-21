Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC3D46DFF5;
	Tue, 21 Jul 2026 17:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656678; cv=none; b=kh/4XjFExi+mEPJ0iqkajppJScoDz4GIdJK70GxLXPeklyOnwYsW4DbPKzPTqkrqIuG+wfbZTH+PTiwshJSKYxiUtUeTY3UT0/GBgaQEV2YNqV+8ir1qURvwDzSl1BCBhVox4BSvT42xmiAhLSTG/RfUNmE9d2wWhL9pR04RHUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656678; c=relaxed/simple;
	bh=MLsgvtadbjYiz9m1STOugnDnP/m1ZCWH+NB0YxFguE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kall5K6Og7CdPC0Sshi4gr1p0jB9giRsWjOwHvKNPgixfNyCOgsUocCte0w1NzxZpIlv4coqcFIPNINMOfllquQypbLsmmDhcFK+W92IQa4cl04HqRTVffDiMNUH43CZTy8rt7hbC2lhZ8lQZKRoBKue7XIwYKcDYN3pxC+nFeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r2GhCT/v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r2GhCT/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6111E1F000E9;
	Tue, 21 Jul 2026 17:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656673;
	bh=y2lnI+i1sSoh0y7IM+qWSZqF6gjtWcXf3kVQG1QkNTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r2GhCT/vBYK3kwg/dZzPJmeIA5wkyBugszWFPxGc6zD22vFd9Jr3X6ImZrhpXVX5d
	 jco9UJ6QBT94DQ+aIxkSDrt9/1xPmlAflFwY47m3G/GVBoT2pnvagwa3cqn7MrdR1O
	 IxPmcfsTUih5V9dHddlcJZ8zXi6J1FOTvH0adELY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0477/1611] ASoC: SOF: Intel: hda-sdw-bpt: select SND_SOF_SOF_HDA_SDW_BPT properly
Date: Tue, 21 Jul 2026 17:09:53 +0200
Message-ID: <20260721152526.057690260@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 4f27f8c8debf8a..b299bcd80904dd 100644
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
 
@@ -312,6 +310,8 @@ config SND_SOC_SOF_HDA_GENERIC
 	select SND_SOC_SOF_HDA_LINK_BASELINE
 	select SND_SOC_SOF_HDA_PROBES
 	select SND_SOC_SOF_HDA_MLINK if SND_SOC_SOF_HDA_LINK
+	select SND_SOF_SOF_HDA_SDW_BPT if SND_SOC_SOF_INTEL_LNL != n && \
+					  SND_SOC_SOF_INTEL_SOUNDWIRE !=n
 	help
 	  This option is not user-selectable but automagically handled by
 	  'select' statements at a higher level.
-- 
2.53.0



