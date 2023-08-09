Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FD6174EE
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C250C433C8;
	Wed,  9 Aug 2023 11:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579062;
	bh=NzvNQ4rHH3OuKXeMZR2jbkBBbexHLLDxLzYASHbjgQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JuqVYCPSkHx65yYX7LSNhKcfkMk8U32ePTNtxuR24htntriiyyY01cOXn+iIOYaP0
	 cFzOL2Zwd6/7KWDCRJnewYgVzmvgzN1k3vFHZPzZUJDHaiscxkAAZvXsGSj+4WF6zj
	 p9LjN8R6EXlxLA3PdX/nEiX49zYiMWFGm71Dj4AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 044/204] ALSA: ac97: Fix possible NULL dereference in snd_ac97_mixer
Date: Wed,  9 Aug 2023 12:39:42 +0200
Message-ID: <20230809103644.040997880@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 79597c8bf64ca99eab385115743131d260339da5 ]

smatch error:
sound/pci/ac97/ac97_codec.c:2354 snd_ac97_mixer() error:
we previously assumed 'rac97' could be null (see line 2072)

remove redundant assignment, return error if rac97 is NULL.

Fixes: da3cec35dd3c ("ALSA: Kill snd_assert() in sound/pci/*")
Signed-off-by: Su Hui <suhui@nfschina.com>
Link: https://lore.kernel.org/r/20230615021732.1972194-1-suhui@nfschina.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/ac97/ac97_codec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index d5dfc7349e70f..e37eab3ddc734 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -2026,8 +2026,8 @@ int snd_ac97_mixer(struct snd_ac97_bus *bus, struct snd_ac97_template *template,
 		.dev_disconnect =	snd_ac97_dev_disconnect,
 	};
 
-	if (rac97)
-		*rac97 = NULL;
+	if (!rac97)
+		return -EINVAL;
 	if (snd_BUG_ON(!bus || !template))
 		return -EINVAL;
 	if (snd_BUG_ON(template->num >= 4))
-- 
2.39.2



