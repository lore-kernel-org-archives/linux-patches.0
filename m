Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B24335BC4;
	Mon, 18 Aug 2025 13:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525190; cv=none; b=YEiUFrnbunXu4wCt6Eu29uE0AOAtVDu6L8Czn13Ie8Joeyuc8B/ajeZ+geoD6xm+jrNGXQuU5q49YPd5eZL3vZSNRUZ0XXOoO827LUGNlnZZ+CNpGWfT1XQDBiZyr9xTNzVn7FtcFYKSMvQ31cnwb4PDSqgefGg+/pCbgOSAZEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525190; c=relaxed/simple;
	bh=gn1cBEhVlpdiZKC+L4/HARCHr0x0lHPPLqMfjEeZhoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puoCSCQ/NXTYX0Ap7CFjEWiflMEgkfqD/4/++NNawUK787icKsLHqcd4RHU6MPLctOy+PWVMYDGWfBH/bR5gfzDSxA+QdyEJbiENF42qdZXOkFqjworoXQiN+1OBlj1NreAYrrZr6p1evTcdk5EU5CWhAavQ7WjE8K1H3j5PlEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtvrABUu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtvrABUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319D6C4CEEB;
	Mon, 18 Aug 2025 13:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525190;
	bh=gn1cBEhVlpdiZKC+L4/HARCHr0x0lHPPLqMfjEeZhoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtvrABUuMV61p8A2btZpSBFh6Oj8ZRo/kFvpX+WLYhBE8Y1/Wtw7JN4FSt1Z1xRUz
	 yVWj0O26OvMV5SdeSNttVK505zudj2uukkQ5CWBUxXsCFuLCD+73aDYHXWaDUBLdWd
	 xeU1JlrxQZdCU5B/NMmWcrY6dsQjzXfST7qTy50Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 186/570] ALSA: intel8x0: Fix incorrect codec index usage in mixer for ICH4
Date: Mon, 18 Aug 2025 14:42:53 +0200
Message-ID: <20250818124512.975866351@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 51e7f1f1a48e..b521cec20333 100644
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



