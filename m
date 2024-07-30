Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6991A76B5;
	Tue, 30 Jul 2024 17:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359947; cv=none; b=iD1pz9BFrtD6X4WFA9gArGAnlOBmaJX30vZooeQloWGRlw49v8xHTgyAxKC54MKPL6UCqvg2dQPfZYAZpis0mNbM/8qU7u4i05EeWZPdgoPbogiM0F3w/N92tKaDA8qwyQiLENFwMlQDSyU3Xn6/B4mq1Sge+9E5TgLpbElt9lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359947; c=relaxed/simple;
	bh=InCK6j8FR8x+hQI2J3P85YSpa8KAMxiR2FNECuNhTBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CC5eVEliskuPSu3ut7kjDSvHvPQcjuK5Vq4f1hW6SSJspiYF8XdDX7d3rHdXv7lQr06dPYKhBJT7ohTEneTd5ueRi5/noqDTTcr30oSYaaz/eMekOVr2fB0GiUPTiiHqmgB9qgbgR4Tu1tnYP4zfSVuzLlFqCsL0aohSBfxNt3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTr70+zW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTr70+zW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EBCC32782;
	Tue, 30 Jul 2024 17:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359947;
	bh=InCK6j8FR8x+hQI2J3P85YSpa8KAMxiR2FNECuNhTBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTr70+zWP+bBtmyokk3yI6gK9ft4FzQsOtZi3KhCBQ8g0ZS9UHJxikJhc5yb/5TFK
	 DNbT6nhB55ieDZAMzUfXqDecXsycN9A44P4GGmbZodPRQGs/A6eIdnZJHhU8yHcFzI
	 GJ5SF0G2nY94eSq8zliNN5vrc2+LOu+ehxoAbhyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 559/568] ASoC: Intel: use soc_intel_is_byt_cr() only when IOSF_MBI is reachable
Date: Tue, 30 Jul 2024 17:51:06 +0200
Message-ID: <20240730151702.005629386@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 9931f7d5d251882a147cc5811060097df43e79f5 ]

the Intel kbuild bot reports a link failure when IOSF_MBI is built-in
but the Merrifield driver is configured as a module. The
soc-intel-quirks.h is included for Merrifield platforms, but IOSF_MBI
is not selected for that platform.

ld.lld: error: undefined symbol: iosf_mbi_read
>>> referenced by atom.c
>>>               sound/soc/sof/intel/atom.o:(atom_machine_select) in archive vmlinux.a

This patch forces the use of the fallback static inline when IOSF_MBI is not reachable.

Fixes: 536cfd2f375d ("ASoC: Intel: use common helpers to detect CPUs")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202407160704.zpdhJ8da-lkp@intel.com/
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20240722083002.10800-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/common/soc-intel-quirks.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/common/soc-intel-quirks.h b/sound/soc/intel/common/soc-intel-quirks.h
index de4e550c5b34d..42bd51456b945 100644
--- a/sound/soc/intel/common/soc-intel-quirks.h
+++ b/sound/soc/intel/common/soc-intel-quirks.h
@@ -11,7 +11,7 @@
 
 #include <linux/platform_data/x86/soc.h>
 
-#if IS_ENABLED(CONFIG_X86)
+#if IS_REACHABLE(CONFIG_IOSF_MBI)
 
 #include <linux/dmi.h>
 #include <asm/iosf_mbi.h>
-- 
2.43.0



