Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF18C10A35;
	Mon,  4 Mar 2024 21:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587682; cv=none; b=Ylyd/aXptCE2NMUy2X2MkWma2Mcmti/smJI8LPMejLoBRkkHdEGZg7cSYe8gMMycojmtdw9di97gEUcBG+KQV8rW4WtDj8FcFOAssTZrYgmbIlQyEVZZGrH+K7pEHYusc8Y/I7nBWQBT5S5eIjfOZ747ERy8DYxEdz83+c7c6ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587682; c=relaxed/simple;
	bh=jO+SIgPR5yhs4eMEI3u0FyuqhWW3qL/luuoy6xDxkBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nssei0VX0PwjLhMV5KOUByzcxSHTbMOeTm+85FHbVhJixzHwq4m2gxIQpPSMX9fAv3fDl1NbQ+FBX59PtRqGPM66w2sHN/968hqBWhh5mO2QrCMf1zzwx4kAd2KxU/YO2a0EosXr0PBR7d9oNPKBPeDHkDN63iJbsTYJaa5tZHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6mtu0fX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6mtu0fX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FFEC433F1;
	Mon,  4 Mar 2024 21:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587682;
	bh=jO+SIgPR5yhs4eMEI3u0FyuqhWW3qL/luuoy6xDxkBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6mtu0fX802UC/4aLwLgccgp+W9D/JKG8cMHnSQ2qdkyEU1Jc6VaNtAiiWM+2Lqc5
	 +2OuQfk+qLBo+F0an8zV+hSp7dyszflvi2cW7aHvtPER/6jq5KjjFibQ3fPkQVWC40
	 20gHjHsXfPJfsuhcqvHisEwB3/V9p/j19HUBOJ8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 050/162] gpu: host1x: Skip reset assert on Tegra186
Date: Mon,  4 Mar 2024 21:21:55 +0000
Message-ID: <20240304211553.457909241@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 1fa8d07ae1a5fa4e87de42c338e8fc27f46d8bb6 ]

On Tegra186, secure world applications may need to access host1x
during suspend/resume, and rely on the kernel to keep Host1x out
of reset during the suspend cycle. As such, as a quirk,
skip asserting Host1x's reset on Tegra186.

We don't need to keep the clocks enabled, as BPMP ensures the clock
stays on while Host1x is being used. On newer SoC's, the reset line
is inaccessible, so there is no need for the quirk.

Fixes: b7c00cdf6df5 ("gpu: host1x: Enable system suspend callbacks")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240222010517.1573931-1-cyndis@kapsi.fi
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/dev.c | 15 +++++++++------
 drivers/gpu/host1x/dev.h |  6 ++++++
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index 42fd504abbcda..89983d7d73ca1 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -169,6 +169,7 @@ static const struct host1x_info host1x06_info = {
 	.num_sid_entries = ARRAY_SIZE(tegra186_sid_table),
 	.sid_table = tegra186_sid_table,
 	.reserve_vblank_syncpts = false,
+	.skip_reset_assert = true,
 };
 
 static const struct host1x_sid_entry tegra194_sid_table[] = {
@@ -680,13 +681,15 @@ static int __maybe_unused host1x_runtime_suspend(struct device *dev)
 	host1x_intr_stop(host);
 	host1x_syncpt_save(host);
 
-	err = reset_control_bulk_assert(host->nresets, host->resets);
-	if (err) {
-		dev_err(dev, "failed to assert reset: %d\n", err);
-		goto resume_host1x;
-	}
+	if (!host->info->skip_reset_assert) {
+		err = reset_control_bulk_assert(host->nresets, host->resets);
+		if (err) {
+			dev_err(dev, "failed to assert reset: %d\n", err);
+			goto resume_host1x;
+		}
 
-	usleep_range(1000, 2000);
+		usleep_range(1000, 2000);
+	}
 
 	clk_disable_unprepare(host->clk);
 	reset_control_bulk_release(host->nresets, host->resets);
diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
index c8e302de76257..925a118db23f5 100644
--- a/drivers/gpu/host1x/dev.h
+++ b/drivers/gpu/host1x/dev.h
@@ -116,6 +116,12 @@ struct host1x_info {
 	 * the display driver disables VBLANK increments.
 	 */
 	bool reserve_vblank_syncpts;
+	/*
+	 * On Tegra186, secure world applications may require access to
+	 * host1x during suspend/resume. To allow this, we need to leave
+	 * host1x not in reset.
+	 */
+	bool skip_reset_assert;
 };
 
 struct host1x {
-- 
2.43.0



