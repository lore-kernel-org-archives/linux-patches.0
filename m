Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCA31459EA;
	Mon,  4 Aug 2025 00:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267225; cv=none; b=jSYzAYbJPj6ssrJHLw6rMFC/mRZvH9CmWjgJurjlj8JS+SF8eW7r1ghGcWf/1qc3lfxkb0M4fqJEJphIAEVSHUl+euj/IC96MrHGn/h/iGRR7MYm+Kqp4jZ1JrFwIFwVEoSNyFpfvEJKN2yBmDrTHCS9Vx14blbBqeyiV6X9w6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267225; c=relaxed/simple;
	bh=zZd/zCbMDxBP3oR7TmMY31/4Dc5wlwHNMFM61bmlQUI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d0UxB0Zf0GztbRX8xZMHnXwHSrNrvVu/fMeKG3NgdprVfr5FASim9E2JOm+iWhXN1X76BRE9ROZDKdPqmDIikvWNlTGZt6Jr+dLPXG7ZP8FMlvQZU2VVaEdzVVHtbz2q31xd2n3RvU2vctFemEZWTBbIn2k9cog1idXPnXMjcFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hS80PsF8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hS80PsF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89F8C4CEEB;
	Mon,  4 Aug 2025 00:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267225;
	bh=zZd/zCbMDxBP3oR7TmMY31/4Dc5wlwHNMFM61bmlQUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hS80PsF8OEO+6BaI23kV+NNqAIFqEJsPB9xIFpQ9nrwpG+tO7n37IuaP348nWFfxz
	 qd7OiVlSy97vbEtC1It1DwP953XfT/KL1MG4BpiOYblSPJFr1DWIhicSjnY/4zS1UQ
	 jEM3EYROhdZwLaYdBEDPDOHJNpZK+SG2sypMv6hyjXMc0igHHSz3GSi24sgnklZefv
	 XCTZP1hbRCtsjAN8Ol7tIZXfyiAIFI9vz3oQ3h23dqPTYZz+kWFFtLhN3VRVTT1y8a
	 HcAfRADK7aSe9jfcfoUMixTGG4IOz4xc39ltx+Ypx/ocekiUBPjKEYfjdJXK45rUji
	 BD1v6gBJWwakQ==
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
Subject: [PATCH AUTOSEL 6.16 70/85] ASoC: core: Check for rtd == NULL in snd_soc_remove_pcm_runtime()
Date: Sun,  3 Aug 2025 20:23:19 -0400
Message-Id: <20250804002335.3613254-70-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002335.3613254-1-sashal@kernel.org>
References: <20250804002335.3613254-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
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
index 67bebc339148..16bbc074dc5f 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1139,6 +1139,9 @@ static int snd_soc_compensate_channel_connection_map(struct snd_soc_card *card,
 void snd_soc_remove_pcm_runtime(struct snd_soc_card *card,
 				struct snd_soc_pcm_runtime *rtd)
 {
+	if (!rtd)
+		return;
+
 	lockdep_assert_held(&client_mutex);
 
 	/*
-- 
2.39.5

