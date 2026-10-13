Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD7D4F054D;
	Tue, 13 Oct 2026 12:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895148; cv=none; b=lTEGzT6F0dLrH50fSeI1KfMpsspcwI859LtHXT4IAxYCl/UvPOlndqlh8bxQO6V7nQM1mZDe5mtatNTGwVk70rMhGJPhRIplOUyZgFMHbBL9RQhgmDaGxvBjQjobXmO5k5zRUCTO0Gs5hMZIdGLL055DO8P5TG/9voJoGig3GPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895148; c=relaxed/simple;
	bh=hGASBD0fU/o4QGkbDOmnSC6vvQBJag+gXIom7NAWnl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPeGzcIeDVORiH+PfZWwrRAS9O1NwPCjHeXQCNj7Q8ZrIrMoNfId3vH85B1Ewa8PE3coCP9dJ8Q5CgI/FBLCl9zelWfw6xBUZ8YHW+Mhg391w6eniX5pdqi2oxmGdHnL2uCBSagF7xM9FlNiFbJ2MnT4wXXgy+15jWbUR1T+gss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4cNi+d5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4cNi+d5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0EE1F000FF;
	Tue, 13 Oct 2026 12:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895146;
	bh=KHqUciFHQKyOMpM7P93ot+uen3sq/AdvOFSWFtzDT7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s4cNi+d5zxLSNNTZ5qwKrspXoJCUejNt7kIQHWeM//zQ4x9apvkFiEC4vz0mNsenq
	 lv43thqsP+bhGcAazb89UMe/0kir1jL8DBQv42gfO9jEPAc+XDJFWcOKXPXreqzZA4
	 99VSF+UwB6iAOZvUsVKqcoUUEnnTsr83eUKzehY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zimeng Li <me@lizi.moe>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 175/497] ASoC: qcom: lpass-cpu: use DAI table index for playback constraints
Date: Tue, 13 Oct 2026 13:35:42 +0200
Message-ID: <20261013112912.044647342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Zimeng Li <me@lizi.moe>

commit ca51771c8efde5df05476ac98dd1b2af4e2b149f upstream.

The DAI ID is a hardware port ID and is not necessarily the index of
the corresponding entry in variant->dai_driver.

When configuring a DAI with LPAIF_I2SCTL_MODE_QUAD01, the probe code
currently uses dai_id to index variant->dai_driver. This is incorrect
for platforms where DAI IDs are sparse. For example, the IPQ806x MI2S
DAI has ID 4 while it is the only entry in the DAI driver table. If
that DAI is configured for QUAD01 and probe reaches this branch, the
code writes beyond that single entry via dai_driver[4] instead of
updating the DAI being processed.

Use the loop index i when updating the current DAI's playback channel
constraints, while retaining dai_id for indexing the hardware-port
specific playback SD-line mode array.

This fixes the incorrect DAI table access for platforms where the DAI
ID does not match its position in the driver table.

Fixes: c223f41c1a52 ("ASoC: qcom: Add four speaker support on MI2S secondary")
Cc: stable@vger.kernel.org
Signed-off-by: Zimeng Li <me@lizi.moe>
Assisted-by: LLM-assisted source analysis
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260927010911.51980-1-me@lizi.moe
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/lpass-cpu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -1234,8 +1234,8 @@ int asoc_qcom_lpass_cpu_platform_probe(s
 		}
 		if (drvdata->mi2s_playback_sd_mode[dai_id] ==
 			LPAIF_I2SCTL_MODE_QUAD01) {
-			variant->dai_driver[dai_id].playback.channels_min = 4;
-			variant->dai_driver[dai_id].playback.channels_max = 4;
+			variant->dai_driver[i].playback.channels_min = 4;
+			variant->dai_driver[i].playback.channels_max = 4;
 		}
 	}
 


