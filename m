Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48B92571CB;
	Mon, 24 Feb 2025 14:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408843; cv=none; b=L2b3pgYtD9rgLYiq1Ga1KBfkgW0KNneHKDJL1Hu1jK7AiklGmuey5VEDyk0GQkDzQSaTDgy0PMTQprYlUgA96JwqScdDMbtz8rZvaAU8icseZQInbsruUqcpusrPx0LK4c/tCm5rJWNHQes/ocVNkQzZ10DqBlZmvgSqAZtPVBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408843; c=relaxed/simple;
	bh=OngfjGcfhBoyAnbhzGotD5FuNHVc2RyyVsi/WhOw5Cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YR/UGXuFJpPw11LjBdFA4gM+fU6iUvE4aBo1dtpgMQLlhH2pFlEqYjYvXYjAbx+PT5WDE80XYDeWBIqAy+r+Z80XyEji1817UvWtIBP85lI50Xrihub3JtQ36EEH76fDGYW8K62x2I51r2icXh0n0cP+uI6UUHxHCmr8+64fHVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZyGISA+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZyGISA+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313BEC4CED6;
	Mon, 24 Feb 2025 14:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408842;
	bh=OngfjGcfhBoyAnbhzGotD5FuNHVc2RyyVsi/WhOw5Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZyGISA+JFHxQKOcpqSbCsP6P5FNnHKOTjwiUjijRIVNP/iOCmYe925YvqmdQXfE8F
	 1bKWUZRHWoU9M8jzwB+PssB/bINXzgnSuoJHX41aMv58i1QaYD6s+f1QNrBlC+Dg2e
	 JXoj3l0CGHHpma5kIvxa3ojqcqdLvhWCj651EHDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 021/138] ASoC: SOF: ipc4-topology: Harden loops for looking up ALH copiers
Date: Mon, 24 Feb 2025 15:34:11 +0100
Message-ID: <20250224142605.301252562@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 6fd60136d256b3b948333ebdb3835f41a95ab7ef ]

Other, non DAI copier widgets could have the same  stream name (sname) as
the ALH copier and in that case the copier->data is NULL, no alh_data is
attached, which could lead to NULL pointer dereference.
We could check for this NULL pointer in sof_ipc4_prepare_copier_module()
and avoid the crash, but a similar loop in sof_ipc4_widget_setup_comp_dai()
will miscalculate the ALH device count, causing broken audio.

The correct fix is to harden the matching logic by making sure that the
1. widget is a DAI widget - so dai = w->private is valid
2. the dai (and thus the copier) is ALH copier

Fixes: a150345aa758 ("ASoC: SOF: ipc4-topology: add SoundWire/ALH aggregation support")
Reported-by: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>
Link: https://github.com/thesofproject/sof/pull/9652
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20250206084642.14988-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-topology.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index b55eb977e443d..70b7bfb080f47 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -765,10 +765,16 @@ static int sof_ipc4_widget_setup_comp_dai(struct snd_sof_widget *swidget)
 		}
 
 		list_for_each_entry(w, &sdev->widget_list, list) {
-			if (w->widget->sname &&
+			struct snd_sof_dai *alh_dai;
+
+			if (!WIDGET_IS_DAI(w->id) || !w->widget->sname ||
 			    strcmp(w->widget->sname, swidget->widget->sname))
 				continue;
 
+			alh_dai = w->private;
+			if (alh_dai->type != SOF_DAI_INTEL_ALH)
+				continue;
+
 			blob->alh_cfg.device_count++;
 		}
 
@@ -2061,11 +2067,13 @@ sof_ipc4_prepare_copier_module(struct snd_sof_widget *swidget,
 			list_for_each_entry(w, &sdev->widget_list, list) {
 				u32 node_type;
 
-				if (w->widget->sname &&
+				if (!WIDGET_IS_DAI(w->id) || !w->widget->sname ||
 				    strcmp(w->widget->sname, swidget->widget->sname))
 					continue;
 
 				dai = w->private;
+				if (dai->type != SOF_DAI_INTEL_ALH)
+					continue;
 				alh_copier = (struct sof_ipc4_copier *)dai->private;
 				alh_data = &alh_copier->data;
 				node_type = SOF_IPC4_GET_NODE_TYPE(alh_data->gtw_cfg.node_id);
-- 
2.39.5



