Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DA8142E8E;
	Wed,  3 Jul 2024 10:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003899; cv=none; b=Rd3baZzvjPch+x5g7N69vJ8KvskjTBoB+ZuavlWM2Nk54nvwv8wzGwD1lXu6ALFao+yNNYRatjpPNeBTolFC9rJH01FH9L9d78ZjryzSWNbdZQPA16P4ZThuEp80PmnH4maI7t9E+u0stPW4JruWNhpfax5DIKIrUeZpLREbA2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003899; c=relaxed/simple;
	bh=7/rv+dD1xS8VdjnrCxxy8DBCZN3z33Np6ox65AXV2Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFuTGQ7UP+s/Ie3i0WjgTAQNIRsOdiOOGy+aDtaRt6w45UBBn1+LGDjRgBKGVz+0VSRMZ+2dXT7r0LCSZQ2ZuddnzCUzk1pR3To6bXGRWtgAXhh06g54JRSZy/5EgypEKw83izC7WtzNsph8zvqbknj7LI7S9t0LOuuQL8f93UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrmLGr+f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrmLGr+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1D3C2BD10;
	Wed,  3 Jul 2024 10:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003899;
	bh=7/rv+dD1xS8VdjnrCxxy8DBCZN3z33Np6ox65AXV2Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrmLGr+fg7olNT9z2mQKvp+wVNJSPUXBsWkmZ0jVK4cWcqLd1Ma8dfQbJL8zESbhK
	 V66jL1mjZdaO9KNUIv3lX6L2bCzzhploqS+ht18Y3dEu9AtzzZyJJGtEvgYXQpO4DZ
	 W+UEQgtrzHZPsIlui/VgLfmHJjef81w9QYHHqsN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/189] ASoC: ti: davinci-mcasp: Use platform_get_irq_byname_optional
Date: Wed,  3 Jul 2024 12:38:07 +0200
Message-ID: <20240703102842.494412669@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit 372c4bd11de1793667e11d19c29fffc80495eeca ]

Depending on the integration of McASP either the 'common' or the
'rx' and 'tx' or only the 'tx' interrupt number is valid, provided.

By switching to platform_get_irq_byname_optional() we can clean up the
bootlog from messages like:

davinci-mcasp 2ba0000.mcasp: IRQ common not found

The irq number == 0 is not valid, fix the check at the same time.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20201106072551.689-2-peter.ujfalusi@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: d18ca8635db2 ("ASoC: ti: davinci-mcasp: Fix race condition during probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/davinci-mcasp.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/ti/davinci-mcasp.c b/sound/soc/ti/davinci-mcasp.c
index b08948ffc61d0..7860382a17a28 100644
--- a/sound/soc/ti/davinci-mcasp.c
+++ b/sound/soc/ti/davinci-mcasp.c
@@ -2174,8 +2174,8 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 
 	mcasp->dev = &pdev->dev;
 
-	irq = platform_get_irq_byname(pdev, "common");
-	if (irq >= 0) {
+	irq = platform_get_irq_byname_optional(pdev, "common");
+	if (irq > 0) {
 		irq_name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%s_common",
 					  dev_name(&pdev->dev));
 		if (!irq_name) {
@@ -2195,8 +2195,8 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 		mcasp->irq_request[SNDRV_PCM_STREAM_CAPTURE] = ROVRN;
 	}
 
-	irq = platform_get_irq_byname(pdev, "rx");
-	if (irq >= 0) {
+	irq = platform_get_irq_byname_optional(pdev, "rx");
+	if (irq > 0) {
 		irq_name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%s_rx",
 					  dev_name(&pdev->dev));
 		if (!irq_name) {
@@ -2214,8 +2214,8 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 		mcasp->irq_request[SNDRV_PCM_STREAM_CAPTURE] = ROVRN;
 	}
 
-	irq = platform_get_irq_byname(pdev, "tx");
-	if (irq >= 0) {
+	irq = platform_get_irq_byname_optional(pdev, "tx");
+	if (irq > 0) {
 		irq_name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%s_tx",
 					  dev_name(&pdev->dev));
 		if (!irq_name) {
-- 
2.43.0



