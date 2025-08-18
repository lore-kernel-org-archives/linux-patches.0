Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4DE320CD4;
	Mon, 18 Aug 2025 13:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523436; cv=none; b=HqPsuAGXDyvCT52K7FJBHrTlF/HmYcKf8JxZC2ufFdmjNWA59tYS40aacq8R+ZB4nSn6yUbIbkAgWSD7cFVHRM4iHybcI/hKNydFBBf6iMkuoXmVzSbRMTiNQGtrfbmdgsKTE5zgfusfFXNRMJUkeulyuYgxW+7lp2lyNtoI7WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523436; c=relaxed/simple;
	bh=4xTrgjRcc+dzukaVkdiTUTHkrgIUZtaaZcv4TcS4qkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/Sj6TZQbnkmQ0Yvjw6U1B2zCqTD8gIiqKEWQUIk4BepFWmUfyVJq8r+FXghvwmLDxORzToLv3AVUnxDKFPIXRV5B01IiHGsJ8rOGW5rIjxN2czxO0+DsBp1PXgq0uu80PsVyosliH864EoZhvzeJve5ACM2qz3ZRjCVQBiCUr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fomSicjT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fomSicjT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06EFC4CEEB;
	Mon, 18 Aug 2025 13:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523436;
	bh=4xTrgjRcc+dzukaVkdiTUTHkrgIUZtaaZcv4TcS4qkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fomSicjTpA5fyQ82YRYAeTnHzYiAXknXCRohbmzHyT4xWo7K+S6B+3An8NfqR1Lsb
	 4deAk3kUrzxXB5uzm99auSgwz1Y4WSz9dAm/vjLgEeWdGwZjYJbszkanq6MfRdlot1
	 8enslYmHhb6comW3QZMEN6FtvKTnJ488MW1Uk4Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 170/515] ALSA: intel8x0: Fix incorrect codec index usage in mixer for ICH4
Date: Mon, 18 Aug 2025 14:42:36 +0200
Message-ID: <20250818124504.913009401@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



