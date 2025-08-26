Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F7D2A1BF;
	Tue, 26 Aug 2025 14:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217709; cv=none; b=ENzT81GVo/J4r4CQgDci9FXwwIQnuqlsqr92LwJjHbvAYfIkh53GfuTwCO5mkhB8GR8U0bkkWCDsYNgvs6RFT3qxKtWKSKdnNhDolILHYSl1CKxv/ohOmYxhTaspxeP0YQEUUN/6uTlIZw6YgW+pj+ufTLTRj3EJ5FIKs4sxlq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217709; c=relaxed/simple;
	bh=ambn1atNnR4yWBbgz0lyPUfP/9sNTEdAoiAfOb4LTbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXvmh9rzQ/DAv6/EguaxHOFzytVEJkJtFAQG/fG25V3KF2KzcOFpyb5GwxvHHTExOcttiFzsemznaOVVgbjSmCAqFOma81OzDJqI5kGMjG4GXHAS+VDH4il6WqBWUNwtuQPRplaMoATknEhZLAKa2xGwdfQioAnbzzi09QZE5PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TebL0818; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TebL0818"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6AF4C113CF;
	Tue, 26 Aug 2025 14:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217709;
	bh=ambn1atNnR4yWBbgz0lyPUfP/9sNTEdAoiAfOb4LTbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TebL0818poSHhu0Ewq1b7GsITRcw59al2ncgzBMUOqGm0LkcO9Kw4xSQ2lDhGlGlP
	 moa66WOq+u/xNQoHRQQBpQvVMRy59CqPwzhQ01GTQKnQnNPf3+9V9NshGFGv2mplW5
	 /oEqNyQd3Pr32Andlz2o5iPUPriCLuBCBd8fZfN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 246/523] ALSA: intel8x0: Fix incorrect codec index usage in mixer for ICH4
Date: Tue, 26 Aug 2025 13:07:36 +0200
Message-ID: <20250826110930.503253411@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 87aafc8580acf87fcaf1a7e30ed858d8c8d37d81 ]

code mistakenly used a hardcoded index (codec[1]) instead of
iterating, over the codec array using the loop variable i.
Use codec[i] instead of codec[1] to match the loop iteration.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250621185233.4081094-1-alok.a.tiwari@oracle.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/intel8x0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index 3707dc27324d..324d9df7f111 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -2270,7 +2270,7 @@ static int snd_intel8x0_mixer(struct intel8x0 *chip, int ac97_clock,
 			tmp |= chip->ac97_sdin[0] << ICH_DI1L_SHIFT;
 			for (i = 1; i < 4; i++) {
 				if (pcm->r[0].codec[i]) {
-					tmp |= chip->ac97_sdin[pcm->r[0].codec[1]->num] << ICH_DI2L_SHIFT;
+					tmp |= chip->ac97_sdin[pcm->r[0].codec[i]->num] << ICH_DI2L_SHIFT;
 					break;
 				}
 			}
-- 
2.39.5



