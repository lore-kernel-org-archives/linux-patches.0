Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDA734DCCA;
	Tue, 26 Aug 2025 13:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216208; cv=none; b=PyBLpGSpBWF0VEHhXNF2H7gOoKJTgMLifgwqRpynE1BCJ7IWgOf6kU4K4unVPbnDWp4iXE/1OJ4OpCT6REyaMemE6g3nPe8jHTUSn0f95VDcOlnVzIDw4HhTahCMHH3RB+n+DGo6KRk4F5Yeg00+Zq5Ap9I7X77qo8ybeanucnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216208; c=relaxed/simple;
	bh=2S7naFVF1FduKJGVR2TMM0oryEX0nKQpHNxX8/TvAEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPcm5ePhyKySUVJiTHLLZLQjKF0eudXu43WNYoD+dk7/KKCsJMn9h52WTdZ+xd/FQTXxrRQe3sxYwktnP5W28QqtzRghWKHaOafJ8PNpaAf+Qm/5e8g8ds2fcILjapZaax1zZfhLU6Yg+42TDPheP5y0/EEBteKnLCWrllJRi4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UlkPRokj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UlkPRokj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10156C4CEF1;
	Tue, 26 Aug 2025 13:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216208;
	bh=2S7naFVF1FduKJGVR2TMM0oryEX0nKQpHNxX8/TvAEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UlkPRokjXiES/1CGJ42MHm9+IfrJe38uwbfzzfIKg7WtD5w8F6fB+o9QJMae5iQuV
	 tPWPiqIj2ixAQvKMG+lSRRMFd8+oZvAZqGCaNoled7vevRpuO3wUWrf2vT0qbqfuhP
	 EgX+sUzichTqSqVI0aIQHg0KApSuu+YrQDUEY/KE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 325/644] ALSA: intel8x0: Fix incorrect codec index usage in mixer for ICH4
Date: Tue, 26 Aug 2025 13:06:56 +0200
Message-ID: <20250826110954.440527775@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ae285c0a629c..f3df6fe2b7f1 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -2252,7 +2252,7 @@ static int snd_intel8x0_mixer(struct intel8x0 *chip, int ac97_clock,
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



