Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6761D54FA;
	Sat, 14 Feb 2026 01:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031139; cv=none; b=sHFotp3MYirSten+UCGas9fTKIJLvzWXY2sHDGS2irwhtsdGEe0Z1EvjcR4w6pcRRc5u4xWGiMH4u54JBhtrwoes8o4VlCsR6s3QdzSn+Nq/dVx3g7+MUEp3CPhmbdt0U1peYNr7hul8EiDtsbH9ZQCzolvRuLapvtu+ygwUNPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031139; c=relaxed/simple;
	bh=tg6CNqv7bton5bP15oOHOmQR0BoV3gpuUhtzClj4LIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l/fBF6gYnzOLhd+MQs0bUnWwPiZcQjLKS9dx1FWv7I88BbXQy0BlzNw+E7fSG4CSvxftFHf5ifGsMK5w3/Hy0+J2x4rvrpVnK7LV4o+ZnGVuf7Qu340hIlI0zQi/84CbpiibVOTqZVBmkOKCTL7HKXsQMcLLVegzpjf5WrRV2lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O2iynG7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O2iynG7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09812C16AAE;
	Sat, 14 Feb 2026 01:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031139;
	bh=tg6CNqv7bton5bP15oOHOmQR0BoV3gpuUhtzClj4LIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O2iynG7JShKrEd31Wvnx3LO1RrTGPjQV8ttw3qFuvDSs0lBZIBY8sRt1jTVc3s0Ld
	 kbm5CyhxB5q5fN7c2HU8ypfMoJJAAzm/N2pyq3gdrQVnKqYzbHxMU788SoQVynlORb
	 saA4HMKcEhZzXK9Dmmf4vwypalzmXZf6g38ZczrYKweQ15C1Y+lqgwyG2TSSPnhBe3
	 vpbDsv6/PwszN/7u8WF85YORK0caDxbXu+yzW8nl/fvGjW1PjxMhx+Xeb1MGDEwGxC
	 VXbZqmR5oLEwMkqm/ZMAMpuGhtHYiW7FG0ge60+ng3qQlT7UQdXLF1By/FWWFiRlEB
	 jHUdkx78KAF5g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mateusz Redzynia <mateuszx.redzynia@intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	yelangyan@huaqin.corp-partner.google.com,
	thorsten.blum@linux.dev
Subject: [PATCH AUTOSEL 6.19-6.12] ASoC: SOF: Intel: hda: Fix NULL pointer dereference
Date: Fri, 13 Feb 2026 19:59:17 -0500
Message-ID: <20260214010245.3671907-77-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit 16c589567a956d46a7c1363af3f64de3d420af20 ]

If there's a mismatch between the DAI links in the machine driver and
the topology, it is possible that the playback/capture widget is not
set, especially in the case of loopback capture for echo reference
where we use the dummy DAI link. Return the error when the widget is not
set to avoid a null pointer dereference like below when the topology is
broken.

RIP: 0010:hda_dai_get_ops.isra.0+0x14/0xa0 [snd_sof_intel_hda_common]

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Mateusz Redzynia <mateuszx.redzynia@intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260204081833.16630-10-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

All the callers that I can see already check for `!ops` and return
`-EINVAL`. The fix is safe — returning NULL from `hda_dai_get_ops` is
the established convention and callers handle it properly.

Note there's a secondary concern: `dai_to_sdev()` at line 216 also calls
`snd_soc_dai_get_widget()` and would have the same NULL widget issue.
But that's a separate path — this commit fixes the most critical crash
in `hda_dai_get_ops`.

### Classification

- **Bug type**: NULL pointer dereference (crash/oops)
- **Trigger**: Mismatch between DAI links in machine driver and topology
  (can happen with loopback capture/echo reference)
- **Consequence**: Kernel oops — hard crash
- **Fix type**: Add NULL check before dereference

### Stable Kernel Criteria Assessment

| Criterion | Assessment |
|---|---|
| Obviously correct and tested | Yes — simple NULL check, reviewed by 3
engineers |
| Fixes a real bug | Yes — actual crash with RIP trace provided |
| Important issue | Yes — kernel oops/NULL pointer dereference |
| Small and contained | Yes — ~20 lines in one file |
| No new features | Correct — purely defensive fix |
| Applies cleanly | Likely yes — the function existed before |

### Risk vs. Benefit

- **Benefit**: Prevents kernel oops when there's a DAI link/topology
  mismatch on Intel HDA audio hardware (SOF). This affects real users
  with Intel audio (a very common platform).
- **Risk**: Minimal. The change only adds a NULL check and reorders
  existing variable assignments. No behavioral change for the normal
  (non-NULL) path.

### Dependencies

The fix is self-contained. It modifies a single function to add a NULL
check. No other patches are needed.

### Conclusion

This is a textbook stable backport candidate: a small, surgical NULL
pointer dereference fix in a widely-used audio subsystem (Intel
HDA/SOF), with a clear bug description, actual crash trace, and multiple
reviews from Intel engineers. The risk is negligible and the benefit is
preventing a kernel crash.

**YES**

 sound/soc/sof/intel/hda-dai.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/intel/hda-dai.c b/sound/soc/sof/intel/hda-dai.c
index 883d0d3bae9ec..3c742d5351333 100644
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -70,12 +70,22 @@ static const struct hda_dai_widget_dma_ops *
 hda_dai_get_ops(struct snd_pcm_substream *substream, struct snd_soc_dai *cpu_dai)
 {
 	struct snd_soc_dapm_widget *w = snd_soc_dai_get_widget(cpu_dai, substream->stream);
-	struct snd_sof_widget *swidget = w->dobj.private;
+	struct snd_sof_widget *swidget;
 	struct snd_sof_dev *sdev;
 	struct snd_sof_dai *sdai;
 
-	sdev = widget_to_sdev(w);
+	/*
+	 * this is unlikely if the topology and the machine driver DAI links match.
+	 * But if there's a missing DAI link in topology, this will prevent a NULL pointer
+	 * dereference later on.
+	 */
+	if (!w) {
+		dev_err(cpu_dai->dev, "%s: widget is NULL\n", __func__);
+		return NULL;
+	}
 
+	sdev = widget_to_sdev(w);
+	swidget = w->dobj.private;
 	if (!swidget) {
 		dev_err(sdev->dev, "%s: swidget is NULL\n", __func__);
 		return NULL;
-- 
2.51.0

