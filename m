Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D38E47B435;
	Tue, 20 Jan 2026 19:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768937707; cv=none; b=J/4NSzrjI2SBCzNTFKZawgeBFFyCFmW+yLg8sO4/cCW0o4CRpQR4bOk8El4mF7gEtGbsFqQUeZslg4t60ww92+dEffrgQ22Fgm3RcObUXCCRKQDH+PK3v4lrnWQl0751Qai/coyuNprfeJBnrPy4mXQ1JnaMapKsm7vsUzuXPUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768937707; c=relaxed/simple;
	bh=1hxHwzroqjTxAQ7XR3r6k7CvanenCdiWBe8WbgrL4Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S2Y32DqzkhcMhcpVAc31arAhiRWXGoSPVslHsHlNeF2ZuhiFljq5p31lGoConpyMDbjIcEp5lER3KoBX+1R3jPcwHb58RtWWfqLMoJ9vCwZxpoD2r9v7UkhwzPz0pCk/+MMtO/VGvLXgP1oHYVOf5N+d8j2flLdENLykOanr60g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iiZKVuQf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iiZKVuQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9B6C16AAE;
	Tue, 20 Jan 2026 19:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768937707;
	bh=1hxHwzroqjTxAQ7XR3r6k7CvanenCdiWBe8WbgrL4Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iiZKVuQfjOWz6vqosPLWGwVZZNPz26GbAYz9QINQTjTN+MXnOquFNStbokkpDAA0T
	 qYj0PCwxhq8Ny5uNFiDrDmczK5SnodWTq/TPI309deFJPNl1e+WhcjLHl91owvvHCP
	 ODBYUnco6mi4DfKHnkgBnPcqfafjN/gm21lG65jNt2RbiH/eb+WDYr5hW7/otg0d9G
	 9tEyRdZM5bL/E4zfj2bVMlOXtmWoade3c+ObhBQjQZjrcAE2NN/b4ybzPdajBObS65
	 yAe/FA8sTT/RZJodkGIQ9+FeG3TvAnBHfpObhlJ+4s9p7U16nCc1Zxeg/o1QYYKRmT
	 8CAtAKDT1JjaQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kery Qi <qikeyu2017@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	peter.ujfalusi@gmail.com,
	linux-sound@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ASoC: davinci-evm: Fix reference leak in davinci_evm_probe
Date: Tue, 20 Jan 2026 14:34:49 -0500
Message-ID: <20260120193456.865383-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260120193456.865383-1-sashal@kernel.org>
References: <20260120193456.865383-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kery Qi <qikeyu2017@gmail.com>

[ Upstream commit 5b577d214fcc109707bcb77b4ae72a31cfd86798 ]

The davinci_evm_probe() function calls of_parse_phandle() to acquire
device nodes for "ti,audio-codec" and "ti,mcasp-controller". These
functions return device nodes with incremented reference counts.

However, in several error paths (e.g., when the second of_parse_phandle(),
snd_soc_of_parse_card_name(), or devm_snd_soc_register_card() fails),
the function returns directly without releasing the acquired nodes,
leading to reference leaks.

This patch adds an error handling path 'err_put' to properly release
the device nodes using of_node_put() and clean up the pointers when
an error occurs.

Signed-off-by: Kery Qi <qikeyu2017@gmail.com>
Link: https://patch.msgid.link/20260107154836.1521-2-qikeyu2017@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

So the `device_get_match_data()` change landed in v6.10. For stable
trees 6.9 and earlier, the code would use the older `of_match_device()`
pattern, which might require a slightly different patch.

Let me analyze the full technical aspects of this fix:

## Technical Analysis

### The Bug
The `davinci_evm_probe()` function calls `of_parse_phandle()` twice:
1. `dai->codecs->of_node = of_parse_phandle(np, "ti,audio-codec", 0);`
2. `dai->cpus->of_node = of_parse_phandle(np, "ti,mcasp-controller",
   0);`

`of_parse_phandle()` returns a device node with an incremented reference
count. The kernel's device tree code uses reference counting to track
how many pointers refer to each node. If references are not released
with `of_node_put()`, the nodes can never be freed, causing a memory
leak.

### Error Paths with the Leak
In the original code, if any of these fail after acquiring one or both
nodes:
- Second `of_parse_phandle()` call fails → codecs->of_node leaked
- `snd_soc_of_parse_card_name()` fails → both nodes leaked
- `devm_clk_get()` returns `-EPROBE_DEFER` → both nodes leaked
- `devm_kzalloc()` fails → both nodes leaked
- `of_property_read_u32()` fails without mclk → both nodes leaked
- `devm_snd_soc_register_card()` fails → both nodes leaked

### The Fix
The fix:
1. Converts all early returns to `goto err_put`
2. Adds proper cleanup label that calls `of_node_put()` on both nodes
3. Nullifies the pointers after release (defensive programming)

### Impact Assessment
- **Severity**: Low to Medium. This is a memory leak, not a crash or
  data corruption. The leak only occurs on error paths during probe.
- **Scope**: The TI DAVINCI EVM audio driver. This is an older driver
  for TI DaVinci SoC platforms, a relatively niche embedded hardware.
- **Trigger**: The leak happens when probe fails - i.e., when there's
  something wrong with the device tree or when resources are
  unavailable.
- **User Impact**: Repeated probe failures (e.g., due to
  misconfiguration or module load/unload cycles) could accumulate leaked
  memory over time.

### Risk Assessment
- **Low risk**: The change is surgical - it only adds error handling
  paths
- **Well-understood pattern**: of_node_put() cleanup is a very common
  kernel pattern
- **Doesn't change success path behavior**: The normal successful probe
  path is unchanged except for adding `return ret;` instead of falling
  through

### Backport Considerations
- For stable kernels >= 6.10: The patch should apply cleanly (uses
  `device_get_match_data()`)
- For stable kernels < 6.10: The patch would need adjustment since those
  use `of_match_device()` pattern instead

**Conclusion:**

This is a legitimate bug fix that addresses a memory leak in error
paths. The fix is:
1. Small and contained
2. Uses a well-understood kernel pattern
3. Fixes a real resource leak bug
4. Low risk (only affects error paths)
5. Properly tested (merged by maintainer Mark Brown)

However, the bug is relatively minor:
- Only affects niche TI DAVINCI EVM hardware
- Only leaks memory on probe failure (error paths)
- The leak is small (device tree node references)

This type of reference leak fix is commonly backported to stable trees.
The pattern is well-established and the fix is straightforward. The main
concern is whether it will apply cleanly to older stable trees that
don't have the `device_get_match_data()` change, but that's a backport
logistics issue, not a reason to reject it.

**YES**

 sound/soc/ti/davinci-evm.c | 39 ++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/sound/soc/ti/davinci-evm.c b/sound/soc/ti/davinci-evm.c
index 2a2f5bc95576e..a55a369ce71c2 100644
--- a/sound/soc/ti/davinci-evm.c
+++ b/sound/soc/ti/davinci-evm.c
@@ -193,27 +193,32 @@ static int davinci_evm_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	dai->cpus->of_node = of_parse_phandle(np, "ti,mcasp-controller", 0);
-	if (!dai->cpus->of_node)
-		return -EINVAL;
+	if (!dai->cpus->of_node) {
+		ret = -EINVAL;
+		goto err_put;
+	}
 
 	dai->platforms->of_node = dai->cpus->of_node;
 
 	evm_soc_card.dev = &pdev->dev;
 	ret = snd_soc_of_parse_card_name(&evm_soc_card, "ti,model");
 	if (ret)
-		return ret;
+		goto err_put;
 
 	mclk = devm_clk_get(&pdev->dev, "mclk");
 	if (PTR_ERR(mclk) == -EPROBE_DEFER) {
-		return -EPROBE_DEFER;
+		ret = -EPROBE_DEFER;
+		goto err_put;
 	} else if (IS_ERR(mclk)) {
 		dev_dbg(&pdev->dev, "mclk not found.\n");
 		mclk = NULL;
 	}
 
 	drvdata = devm_kzalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
-	if (!drvdata)
-		return -ENOMEM;
+	if (!drvdata) {
+		ret = -ENOMEM;
+		goto err_put;
+	}
 
 	drvdata->mclk = mclk;
 
@@ -223,7 +228,8 @@ static int davinci_evm_probe(struct platform_device *pdev)
 		if (!drvdata->mclk) {
 			dev_err(&pdev->dev,
 				"No clock or clock rate defined.\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_put;
 		}
 		drvdata->sysclk = clk_get_rate(drvdata->mclk);
 	} else if (drvdata->mclk) {
@@ -239,8 +245,25 @@ static int davinci_evm_probe(struct platform_device *pdev)
 	snd_soc_card_set_drvdata(&evm_soc_card, drvdata);
 	ret = devm_snd_soc_register_card(&pdev->dev, &evm_soc_card);
 
-	if (ret)
+	if (ret) {
 		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n", ret);
+		goto err_put;
+	}
+
+	return ret;
+
+err_put:
+	dai->platforms->of_node = NULL;
+
+	if (dai->cpus->of_node) {
+		of_node_put(dai->cpus->of_node);
+		dai->cpus->of_node = NULL;
+	}
+
+	if (dai->codecs->of_node) {
+		of_node_put(dai->codecs->of_node);
+		dai->codecs->of_node = NULL;
+	}
 
 	return ret;
 }
-- 
2.51.0

