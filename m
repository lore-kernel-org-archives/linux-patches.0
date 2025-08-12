Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49EF2FA0DB;
	Tue, 12 Aug 2025 18:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025057; cv=none; b=Xe1/WzL05Xc7SMS5OkmjxPzMk1j1EtsKTTaZnqZSyNK3qQgZ3xC9GmiY3B9p4bw946zaNOrTYVZwRqfDWlf2U2tnCd0bS5tDrdzXfdfI0B6AVkOQbY1KcGdwcksZCgqFXXFRrHGxAkIVaQdNIaFsWhefL+DP8PNujP2eBzHeqlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025057; c=relaxed/simple;
	bh=0MoBiz9XS87pufUSv5lGg7M6WXjyh8WW6+18sQ3sX40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+urVXj+jpbcU5IcuuW+5snRdOyh5CiXexkCGpYnv/Jyg/zZgAT25h/xMZD1vIn3kAEf6wVosTrEBMNu2u+6WEBDaELpIsrSt3v3uaWCOZD5M7Hn9B2Qg5TgSh+E8ucFJk+uyQegUc07ctVBfwSf39s41efLnkQvkiYrWsWiBLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KknHsTVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KknHsTVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4487BC4CEF0;
	Tue, 12 Aug 2025 18:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025057;
	bh=0MoBiz9XS87pufUSv5lGg7M6WXjyh8WW6+18sQ3sX40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KknHsTVdCmxO715O48F1dX0yYCyTDHV00kks5gAl95ohiWZ2jAw1yilB+9GcpsDiP
	 tY1RSmSu1AX1qtDaYvEV/Mt41DDi/E4sV/XzYveMbATOQVC8FoR9NXC/E+VPb6nYIb
	 Boc0Gl/1NCowbDIyQbYoSc8yRz7geRaguCIsw+yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 556/627] ASoC: SOF: Intel: hda-sdw-bpt: fix SND_SOF_SOF_HDA_SDW_BPT dependencies
Date: Tue, 12 Aug 2025 19:34:11 +0200
Message-ID: <20250812173453.051051093@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 614d416dd8aee2675fb591c598308a901a660db8 ]

The hda-sdw-bpt code links against the soundwire driver, but that fails when
trying to link from built-in code into loadable module:

x86_64-linux-ld: vmlinux.o: in function `intel_ace2x_bpt_close_stream.isra.0':
intel_ace2x.c:(.text+0x137a531): undefined reference to `hda_sdw_bpt_close'
x86_64-linux-ld: vmlinux.o: in function `intel_ace2x_bpt_send_async':
intel_ace2x.c:(.text+0x137aa45): undefined reference to `hda_sdw_bpt_open'
x86_64-linux-ld: intel_ace2x.c:(.text+0x137ab67): undefined reference to `hda_sdw_bpt_close'
x86_64-linux-ld: intel_ace2x.c:(.text+0x137ac30): undefined reference to `hda_sdw_bpt_send_async'
x86_64-linux-ld: vmlinux.o: in function `intel_ace2x_bpt_wait':
intel_ace2x.c:(.text+0x137aced): undefined reference to `hda_sdw_bpt_wait'

Ensure that both SOUNDWIRE_INTEL and SND_SOF_SOF_HDA_SDW_BPT are selected
at the same time by SND_SOC_SOF_INTEL_LNL, and that this happens even if
SND_SOC_SOF_INTEL_SOUNDWIRE is a loadable module but SND_SOC_SOF_INTEL_LNL
is built-in.

This follows the same logic as commit c5a61db9bf89 ("ASoC: SOF: fix
intel-soundwire link failure").

Fixes: 5d5cb86fb46e ("ASoC: SOF: Intel: hda-sdw-bpt: add helpers for SoundWire BPT DMA")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20250805160451.4004602-1-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/Kconfig b/sound/soc/sof/intel/Kconfig
index dc1d21de4ab7..4f27f8c8debf 100644
--- a/sound/soc/sof/intel/Kconfig
+++ b/sound/soc/sof/intel/Kconfig
@@ -266,9 +266,10 @@ config SND_SOC_SOF_METEORLAKE
 
 config SND_SOC_SOF_INTEL_LNL
 	tristate
+	select SOUNDWIRE_INTEL if SND_SOC_SOF_INTEL_SOUNDWIRE != n
 	select SND_SOC_SOF_HDA_GENERIC
 	select SND_SOC_SOF_INTEL_SOUNDWIRE_LINK_BASELINE
-	select SND_SOF_SOF_HDA_SDW_BPT if SND_SOC_SOF_INTEL_SOUNDWIRE
+	select SND_SOF_SOF_HDA_SDW_BPT if SND_SOC_SOF_INTEL_SOUNDWIRE != n
 	select SND_SOC_SOF_IPC4
 	select SND_SOC_SOF_INTEL_MTL
 
-- 
2.39.5



