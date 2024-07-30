Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE6118B472;
	Tue, 30 Jul 2024 17:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358905; cv=none; b=p7XJ+KObaBIQPZ45DqHAdYlBOpDlt0uQXZkwiNXJMkJRzbTudA/rLoIfTu4h/NQLw0oBGX2fUO730B9fwXkzWRR1HuwAut6Od3D8W6fBWuY8bWR74QUAqCLGMLcfp3yRJBGytGxxfQZkiCRPPZK7sn4oJ2LKMwjp9AdeNxm/V6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358905; c=relaxed/simple;
	bh=2fgqSfbBOTumCvgbYhDYcqiVUt0DvR7BxBlV93lbb8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dY/loVFkNh9qYHiwWTuM7RYb3zq4iuE/KFOxxiZowTPGD3iw6Bl4+6ykBaAHZvyU/ba6plOk6LMMa34e32KtdLWi7qEQz4ewTgnBv9weWCnpbGV68BnODDSjWY9ziIeGi9Ei0vr1RwOw60O3chptFb4ku3SvouYmvpcdoGMzXWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jEHS38PL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jEHS38PL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B3BC4AF0C;
	Tue, 30 Jul 2024 17:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358905;
	bh=2fgqSfbBOTumCvgbYhDYcqiVUt0DvR7BxBlV93lbb8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jEHS38PLvlJExLlWN6n9lFfoPHGUUrw4xe5m3L4tEXuMe4qaV7Q+uhWkOQ4nZXZZ3
	 RE1v692L6H5OFwpDqk91fIVwjgEg+2VERHH1Y+gruFtilJBZb5I2dPDtodYdo1Z1sg
	 WVxzrnOk6a2HHPbIVZ3njY8LWAZ7J7wil5o64FOI=
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
Subject: [PATCH 6.1 432/440] ASoC: Intel: use soc_intel_is_byt_cr() only when IOSF_MBI is reachable
Date: Tue, 30 Jul 2024 17:51:05 +0200
Message-ID: <20240730151632.649786026@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



