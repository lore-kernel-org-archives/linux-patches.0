Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542D3194A60;
	Thu,  5 Sep 2024 09:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529418; cv=none; b=Z+aNCAOMnvbw+H1cmYGrCvZCsZoWL1fziS5P2LoUTRqTXlwNf6zWT/mqP7tBtg1qrFUbOebCCDkdIB5R2zyrc9V+roIVo9NpbwEDu42P7fRE/3OY5n+vY7UJ448Zv80yFNlI4VegLa8tq3OPjsBKL2fGxyikQgLkJfcjto3EHE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529418; c=relaxed/simple;
	bh=l2TjYWYCRLlVLT3bHJ887ALNtDB4PuBTYbgb5mtxBwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOaJPFAUuSvi241fppMwmOdtAnq4F/2MlVlLIKJWSAgftpjZCNlddzunH1zbBrXwPwfkLRAhyT65QkP2+xjCFA8kVCJW8SXneSQb84toNuKQ2DzF3/+fefDQHYWBdYBs6hk80KLl4ZaUYejpPBiaxvMx1h6UU9eMZtF0NLLRwzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lbfBiXqn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lbfBiXqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE4FC4CEC3;
	Thu,  5 Sep 2024 09:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529418;
	bh=l2TjYWYCRLlVLT3bHJ887ALNtDB4PuBTYbgb5mtxBwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lbfBiXqnrWLPy9XAIbdqarj9M6EtxYMTmCfUaZ3E4aWbVX/w5B6LbkIN47RM6CcR2
	 GsVBbMx11IGgIjzuwW9hJfnBLse8iLNBCditU874bGevBXEzNG1KE3NmXs2mYw1qFx
	 6ksGMn8S+sNdeXTnxfqFHcmTaCEtBr2PtrHVVXc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 007/184] ALSA: hda/conexant: Mute speakers at suspend / shutdown
Date: Thu,  5 Sep 2024 11:38:40 +0200
Message-ID: <20240905093732.528536511@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 4f61c8fe35202702426cfc0003e15116a01ba885 ]

Use the new helper to mute speakers at suspend / shutdown for avoiding
click noises.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1228269
Link: https://patch.msgid.link/20240726142625.2460-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 4472923ba694b..f030669243f9a 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -205,6 +205,8 @@ static void cx_auto_shutdown(struct hda_codec *codec)
 {
 	struct conexant_spec *spec = codec->spec;
 
+	snd_hda_gen_shutup_speakers(codec);
+
 	/* Turn the problematic codec into D3 to avoid spurious noises
 	   from the internal speaker during (and after) reboot */
 	cx_auto_turn_eapd(codec, spec->num_eapds, spec->eapds, false);
-- 
2.43.0



