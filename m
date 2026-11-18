Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041447;
	b=a6zN3DBoZYsYtXkS4ELlC+QvmxkTLkvlBAvlINH9i8kGN8RZCSlKdb1toYigLm/0Cj+W
	 /v5EWNJLm3G2T0VwWuLyY7OhwaQHtUlpXV3YjXSPu7nyV42VU2Io7KKhihIbm6INyz/mb
	 QU3I5EeUjvcafHI9UTEe3aEMdI7ph/5blT9p8M9FFWjBmtV+te+ZAY9bWJoh6KbeeJt67
	 wLF4pLuKjHgXY2m70pddovFsLKIsKy0+lK2T801lSBj9rm2DGb2KzYqdIKTjEhD22mj5q
	 m7oqn9gnTrocATqrs9cProFK2cgJ56RL4PEzI5AYHb0mXYHRTXOUbnu/Z8gVdOdshWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=33SmYUzeYQudlDA3BnWVkZ5JwMFhVuVJRLRxSxtmewY=;
	b=Xlp7HY5LBr97tb8hKhFvwscq7By/O4bwcMhJlmesbc6Qv69jFKQigmU3BZHYsvkOvGlY
	 kfJMidyK5GHLGdQg4D1D69JhdvPoaTaDanTJu65VaSQQiZN9zwhMdPYWiX29MBTMOaTAT
	 mu9b5K1qZ35ThXmJi31yKyBj64hwIFH6/5mOf4OvEQYEMTbZqcjwLzZvBL9x7xAeyBEL5
	 TB5vgeyTxqqOpOwSeUygSDOJ1sBhSsTjeFBmPrtnfkga5gd7w0tQtGuqDyWQCtasA/zSs
	 4lzSRsudA4UQATnposKFTJVmRLJlhQYpHU4Fzdu5SFHQ9cDJTE4RM/KhxYuxHKeo18g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NtPK9nP0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8649606A996;
	Wed, 18 Nov 2026 22:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NtPK9nP0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FD01F000D0;
	Wed, 18 Nov 2026 22:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041447;
	bh=33SmYUzeYQudlDA3BnWVkZ5JwMFhVuVJRLRxSxtmewY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NtPK9nP0V1qnILAueaOuiH6GeMqP2ietKi+89bV4Ktl95L5RCsEw465F7K7S7otYr
	 9s6G8OapE5qLNUZ2rgF8oGdXdh1YpLFcz5sMudP/n1sJzPVYJ0/lb6FPQAcBqh51Q3
	 TYAILyC3vZvywCwNqiiblRNaEfGU/VWNZA3twEl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2818/3318] ASoC: amd: acp: Fix .close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:57:20 +0100
Message-ID: <20261118150445.191282439@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 2c3400aa9f397da48a6760f5e84438973e01a00c ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp_dma_open(). ASoC only marks the component as opened when
.open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 623621a9f9e1 ("ASoC: amd: Add common framework to support I2S on ACP SOC")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp/acp-platform.c b/sound/soc/amd/acp/acp-platform.c
index f516daf6fef41..219651786e5e6 100644
--- a/sound/soc/amd/acp/acp-platform.c
+++ b/sound/soc/amd/acp/acp-platform.c
@@ -204,7 +204,7 @@ static int acp_dma_open(struct snd_soc_component *component, struct snd_pcm_subs
 	list_add_tail(&stream->list, &adata->stream_list);
 	spin_unlock_irq(&adata->acp_lock);
 
-	return ret;
+	return 0;
 }
 
 static int acp_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



