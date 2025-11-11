Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EECF252917;
	Tue, 11 Nov 2025 00:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822379; cv=none; b=Btd3joE20oTgfNDDJr/ZxYZeUIqPG/AAWNLRsAAoJvCZow1p0xHaerzwh4hRc9ZEhftwnsLWB0uuOi4DjpoBdIXvIU/mt8CViTmcxg2ZR+4XjdQsA5T7TlBN58mT1wMpwK0rzr+qZqSJlDMnHpE7wIVpD1b1xaGWLwaTIUZoxXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822379; c=relaxed/simple;
	bh=50lV1p5kwxHKvdi0Vislr+haSuhix1rBRO2kvmUflro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZBxK7+Ci6m5E9yJoRRgDpYgpvfZfiGc2g6IWWAPyoTXY+3+KMSWs8iYoWaH/ivpeOsjRzL+GtZrphjuXm6Au/DCjtinRWjeJm3nSvWYzLVygPTwFL8sqpQayWziXW8fbwEBX4n8ZO5EliPoi8bcoPxiL73ksg0HnRTNw5TD08E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TykWENeI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TykWENeI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6CDC16AAE;
	Tue, 11 Nov 2025 00:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822378;
	bh=50lV1p5kwxHKvdi0Vislr+haSuhix1rBRO2kvmUflro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TykWENeIpSJ1sWv9wNBSAm7qwhffmoTnbMv4r52Eq8mdT7ccUrf3r69dl3oiqe/ns
	 njJzWvFJN+0loTBsAjQA8nVvhzE4pOKOYdfBFh+orgs1JFboTdBdywoVEVlDLJHSrb
	 +BCvu4cIbJtYa1oeA8u7KNJTJRoT0hA7LobDdyv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/565] ASoC: fsl_sai: fix bit order for DSD format
Date: Tue, 11 Nov 2025 09:38:14 +0900
Message-ID: <20251111004527.751088796@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit d9fbe5b0bf7e2d1e20d53e4e2274f9f61bdcca98 ]

The DSD little endian format requires the msb first, because oldest bit
is in msb.
found this issue by testing with pipewire.

Fixes: c111c2ddb3fd ("ASoC: fsl_sai: Add PDM daifmt support")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20251023064538.368850-2-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_sai.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 57614c0b711ea..7e4338762f085 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -321,7 +321,6 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 		break;
 	case SND_SOC_DAIFMT_PDM:
 		val_cr2 |= FSL_SAI_CR2_BCP;
-		val_cr4 &= ~FSL_SAI_CR4_MF;
 		sai->is_pdm_mode = true;
 		break;
 	case SND_SOC_DAIFMT_RIGHT_J:
@@ -606,7 +605,7 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
 	val_cr5 |= FSL_SAI_CR5_WNW(slot_width);
 	val_cr5 |= FSL_SAI_CR5_W0W(slot_width);
 
-	if (sai->is_lsb_first || sai->is_pdm_mode)
+	if (sai->is_lsb_first)
 		val_cr5 |= FSL_SAI_CR5_FBT(0);
 	else
 		val_cr5 |= FSL_SAI_CR5_FBT(word_width - 1);
-- 
2.51.0



WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP")
Cc: stable@vger.kernel.org
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -151,7 +151,6 @@ config S390
 	select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
 	select ARCH_WANT_KERNEL_PMD_MKWRITE
 	select ARCH_WANT_LD_ORPHAN_WARN
-	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	select ARCH_WANTS_THP_SWAP
 	select BUILDTIME_TABLE_SORT
 	select CLONE_BACKWARDS2


