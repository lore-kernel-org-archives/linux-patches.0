Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6891C4A24;
	Wed, 19 Mar 2025 14:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394968; cv=none; b=F4OEIfy0x7XJFhYdefy53/uorz+7zE0UBmXxQBiedICtGf0ONPBpq4CA9avYOkJMlg0WwFCHs95RbUo8AtP+4UN/2d3ynggdDSF1C/3s81LDF3lpPSWz7eHBUNfAdBe9n/+x1nUZ8gHMHlFtNaPF/4uQecDmCITmplJocIOOMwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394968; c=relaxed/simple;
	bh=H7H4aahbxSseQBVC/tt69OnL8hEfx5iIVTpaF3mAf+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUYFTsDdgKSmOeIAYDhpJ+Geo7vNrCkjCOfQS0Iz6QtqizdusdPN6a8ZS45/pJAyNibvFJs4Lf7vb/b34ZkkFK3jH4AkMr0br27r9cNlnrKR3aMmlhVs2rC4z7V2Rcml3lOL00uFMkuStgbbYj/7CrOXrkQjx1yo5JIt1rLxtes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nyq6lMDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nyq6lMDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E381C4CEE4;
	Wed, 19 Mar 2025 14:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394968;
	bh=H7H4aahbxSseQBVC/tt69OnL8hEfx5iIVTpaF3mAf+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nyq6lMDb3J/SUBPsg5Cwi4Gl4ok3SyP9e9uDRoTFKCkJWY/ZvdZFjxfYbVRQhpXr7
	 ecDABWA5FZ/CjQ1qF3Oo7up1SSRGTnr79EXTpv0SJXytKchjiMhpYbUHOKiPQbd9LC
	 nS7bnySm4xb903eLxvq1/JCYQo7GRXLECqlPB0Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.13 194/241] ASoC: Intel: sof_sdw: Fix unlikely uninitialized variable use in create_sdw_dailinks()
Date: Wed, 19 Mar 2025 07:31:04 -0700
Message-ID: <20250319143032.521701429@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

commit 4363f02a39e25e80e68039b4323c570b0848ec66 upstream.

Initialize current_be_id to 0 to handle the unlikely case when there are
no devices connected to a DAI.
In this case create_sdw_dailink() would return without touching the passed
pointer to current_be_id.

Found by gcc -fanalyzer

Fixes: 59bf457d8055 ("ASoC: intel: sof_sdw: Factor out SoundWire DAI creation")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20250303065552.78328-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/boards/sof_sdw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -945,7 +945,7 @@ static int create_sdw_dailinks(struct sn
 
 	/* generate DAI links by each sdw link */
 	while (sof_dais->initialised) {
-		int current_be_id;
+		int current_be_id = 0;
 
 		ret = create_sdw_dailink(card, sof_dais, dai_links,
 					 &current_be_id, codec_conf);


