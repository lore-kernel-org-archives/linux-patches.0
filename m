Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55EB1E1A17;
	Mon,  4 Aug 2025 00:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754268010; cv=none; b=aDYarjvRhZMFqcdoP2QtXp2qeF3Lvo6Fm7S0MzQfeIQ8lydCebsij7c5shFy07p6fVYTwskMU7GmFNY+LMjqo0pfKsZIRGF1PIgTZb9pgZ5lRUTE29yBGJYq8WW1iiGjcrKfCFdT9kdb3E/p82+Lq3CQd8oHw17azE459gBs6cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754268010; c=relaxed/simple;
	bh=KiuLL8U0icW71MAiIQQcgFu0fQpnpJy6yGYbn3W4hAk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rQiAGFfPuIe4TzyY7OlHPNPu/gD8PQMxi4wqX7lFs4jXXJThPa2zHU2O+mGYBjYFIAv/b/KnfnDECNjWr1VuwkuS36HbAnJ/UEQOGIHcSlfjd6YQ+x3LCf0Dzw92912KYZsfiv4T6flIL8yfMaIQ8NEfG8tU2GVw/r/GJYKrsMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VBIkEoWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VBIkEoWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4D7C4CEF8;
	Mon,  4 Aug 2025 00:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754268009;
	bh=KiuLL8U0icW71MAiIQQcgFu0fQpnpJy6yGYbn3W4hAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBIkEoWuouaDSEEs+zGlADco3jqcsLIPWL4Bdl7m9WtyHCdQxjB+rDuOyxlxM9YlP
	 L6vIZ23qMMkjx54uVCWF/lFcCvmT26zagoUzGXaXqtTEBMdxR8sq9ChkR599gmDNgF
	 LC+qC7RQmwAE5B3p7LFJuAAJuWPv9hFS69tgSYCS+egm7xKvDnNvOisNbBOHQjJKRb
	 dWNZnTJaWm59LTiUrgs+45qrlTFj+9sX1c6BOzWxnt+qNZpDfkMJuivadGNtJXWEUH
	 b1X9eYTf1gLRTtApG3xa3BmFawQj80G+ZpJNX7NqBziVpiJg8XrhHyx2c7l5Wy8fVk
	 hYHYAZRS94rmg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	linux-sound@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 33/44] ASoC: core: Check for rtd == NULL in snd_soc_remove_pcm_runtime()
Date: Sun,  3 Aug 2025 20:38:38 -0400
Message-Id: <20250804003849.3627024-33-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003849.3627024-1-sashal@kernel.org>
References: <20250804003849.3627024-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.189
Content-Transfer-Encoding: 8bit

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 2d91cb261cac6d885954b8f5da28b5c176c18131 ]

snd_soc_remove_pcm_runtime() might be called with rtd == NULL which will
leads to null pointer dereference.
This was reproduced with topology loading and marking a link as ignore
due to missing hardware component on the system.
On module removal the soc_tplg_remove_link() would call
snd_soc_remove_pcm_runtime() with rtd == NULL since the link was ignored,
no runtime was created.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://patch.msgid.link/20250619084222.559-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees. The analysis
reveals this is a critical NULL pointer dereference fix that prevents
kernel crashes.

**Key reasons for backporting:**

1. **Fixes a Real Crash**: The commit adds a NULL check to prevent a
   kernel panic that occurs when `snd_soc_remove_pcm_runtime()` is
   called with `rtd == NULL`. The code change shows this clearly:
```c
+   if (!rtd)
+       return;
```
Without this check, the subsequent line
`snd_soc_card_remove_dai_link(card, rtd->dai_link)` would dereference
NULL.

2. **Minimal and Safe Fix**: The change is extremely small (3 lines) and
   defensive - it simply adds a NULL check with early return. This
   follows the stable kernel rule of minimal, contained fixes.

3. **Affects Production Systems**: The commit message indicates this
   occurs during topology loading when hardware components are missing -
   a real-world scenario. The issue manifests on module removal when
   `soc_tplg_remove_link()` calls the function with NULL.

4. **Well-Reviewed**: The commit has 5 Reviewed-by tags from Intel ASoC
   maintainers, indicating thorough review and consensus on the fix.

5. **No Side Effects**: The fix has no architectural changes or new
   features - it purely adds defensive programming to prevent crashes.
   The function already had EXPORT_SYMBOL_GPL, indicating it's part of
   the kernel API that could be called from various contexts.

This is exactly the type of commit stable trees want: a small, obvious
fix for a real crash scenario with no risk of regression.

 sound/soc/soc-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 1c4d8b96f77b..d28261ef1d4c 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -959,6 +959,9 @@ static int soc_dai_link_sanity_check(struct snd_soc_card *card,
 void snd_soc_remove_pcm_runtime(struct snd_soc_card *card,
 				struct snd_soc_pcm_runtime *rtd)
 {
+	if (!rtd)
+		return;
+
 	lockdep_assert_held(&client_mutex);
 
 	/* release machine specific resources */
-- 
2.39.5

