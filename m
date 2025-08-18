Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA2A31AF2D;
	Mon, 18 Aug 2025 12:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521864; cv=none; b=RsXI9ZBAbhj18Ibtpuwc7xEIRBhes3U1HS5XCpcej37O4ex5quRe6asgdhTwm/VYjQAQIarjfiS3aFgkXd5d7e1j29qD+9ENR7AszW7gBZvnik8V9V+DWV71F26K8esZjYjHWfvIPjuPN14ChQG8XptF9iz26CIziaewUoTIf4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521864; c=relaxed/simple;
	bh=LGa45sBthclR3bqOELsNJGsGasVYvhkiX+FZqVVRiiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzOs85yoF1DUIDFsFSj0UuLce97robornMwAIW4+TAXiz1dYfbgMXf8BHZQC02ywIFrIcep7I6s6o5skzQ80tTljxf+pVODMOqNYkhKRs1LvYTiDPuACKJhUAebm/c2/Xh9lxiwSBjPgeM1zaoN76hUVstm0RBXBwzpXGZFCrso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbZ8Mzd2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbZ8Mzd2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC7BC4CEF1;
	Mon, 18 Aug 2025 12:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521864;
	bh=LGa45sBthclR3bqOELsNJGsGasVYvhkiX+FZqVVRiiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wbZ8Mzd2UgJl+dxpIbdiU0k+Gr8Zn1dPn49rDJljaJLN5RWfz+XmBp4+Ld3HUEuY+
	 lHU6IwdVAJ7XPbPcEv6v+6LTsT9GYx5anAjzsi6onk7lpJvfv90a4Z+Rfm2aZPGTTj
	 G3HmB1ROIhbpeTOFFr+yVMWLlbPVvxXNNAj16VLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 144/444] ALSA: intel8x0: Fix incorrect codec index usage in mixer for ICH4
Date: Mon, 18 Aug 2025 14:42:50 +0200
Message-ID: <20250818124454.314705261@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e4bb99f71c2c..95f0bd2e1532 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -2249,7 +2249,7 @@ static int snd_intel8x0_mixer(struct intel8x0 *chip, int ac97_clock,
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



