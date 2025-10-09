Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE66E2F3C08;
	Thu,  9 Oct 2025 16:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025602; cv=none; b=kstXCsMfVLTT2m7cgkYl+UpDUjp4BQwXgQszkGOTZ/u+DPX60FSszKZ5VKkulsbvKN6B8d91CqygUeBiVvqEEHAiYaWbYEmpEl/WteeaoV5sJ6lManVRD1rBbwdnmit6mFRFY+u6ZVKEVN0OWfFzWvMSbrnJBbG+4NOu2F9XERc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025602; c=relaxed/simple;
	bh=F1FqzWXtuPtaRyeU2V6dAFIZKGQOW+Hcqx9BB7Zc0sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CvJC0fB+cqIS5cw22NuXW3+eTD6mZldt8jtuNLRJ4siC1ads8sAoD5GBSI+I8OoCFDdtYfRiSo60piKWZPPGkEWwR5T16TX9qkwIiniIzYzpBFCIRKxFJlJwiKTUHQiCCVXuz36o6Xw5N31MW+3Dno17bLiyjQ9Mwbx0jO8cz9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cCFAq3nX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cCFAq3nX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4520DC4CEFE;
	Thu,  9 Oct 2025 16:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025602;
	bh=F1FqzWXtuPtaRyeU2V6dAFIZKGQOW+Hcqx9BB7Zc0sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCFAq3nX4HfpIwfR9bjnkCRThrt8pYALPlzrJPtbt+uIVr+OkcGxS0Los4Tv6Ld3B
	 GpfNBVBVNM0N0j6+tqETTemwg25JuSwQmAB9odN52E4qEtodCuS4hwutzJaU+h01vZ
	 od54biIaiv8wXZRcCv+HFUXwZ1JWYe2hBfaM3nI1txtzHI0R3NTi5rfsrq4xLm7lHZ
	 umOsAHY9ZImhJx11e3tTyZ97YRFYljrMQjgyhjiY/ChnQUYM5quNZDi7ewc/M87qMa
	 cX5RW7QelqNTXwDH0yzPCD+br+Y4aWjGWCKJEufB7YEQMGOK0+0H+k+5oht65Ug36W
	 hYrk4Dww1SNug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Icenowy Zheng <uwu@icenowy.me>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	fustini@kernel.org,
	guoren@kernel.org,
	wefu@redhat.com,
	linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17] pmdomain: thead: create auxiliary device for rebooting
Date: Thu,  9 Oct 2025 11:55:35 -0400
Message-ID: <20251009155752.773732-69-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Icenowy Zheng <uwu@icenowy.me>

[ Upstream commit 64581f41f4c4aa1845edeee6bb0c8f2a7103d9aa ]

The reboot / power off operations require communication with the AON
firmware too.

As the driver is already present, create an auxiliary device with name
"reboot" to match that driver, and pass the AON channel by using
platform_data.

Signed-off-by: Icenowy Zheng <uwu@icenowy.me>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- User-visible bugfix: Without this, TH1520 systems cannot register
  platform reboot/poweroff handlers via the AON firmware, so
  reboot/poweroff won’t work even though the AON protocol and the reboot
  driver exist. This commit wires them up by instantiating the auxiliary
  device that the reboot driver matches on.
- Small and contained: Adds a tiny helper and one call in the TH1520 PM
  domain driver; no architectural changes.
- Specific code changes
  - Adds `th1520_pd_reboot_init()` which creates an auxiliary device
    named `reboot` and passes the AON channel through `platform_data` so
    the reboot driver can use it: drivers/pmdomain/thead/th1520-pm-
    domains.c:176
    - `adev = devm_auxiliary_device_create(dev, "reboot", aon_chan);`
  - Hooks it into probe after setting up PM domains and the optional GPU
    pwrseq: drivers/pmdomain/thead/th1520-pm-domains.c:250
    - `ret = th1520_pd_reboot_init(dev, aon_chan);`
  - Error path is correctly routed back to the provider cleanup.
- Correct driver pairing: The created device name matches the existing
  driver’s ID table
  - Reboot driver expects `th1520_pm_domains.reboot` and consumes
    `adev->dev.platform_data` as the `th1520_aon_chan` to issue AON RPCs
    for poweroff/restart: drivers/power/reset/th1520-aon-reboot.c:51 and
    drivers/power/reset/th1520-aon-reboot.c:82
- Risk and scope:
  - TH1520-specific; no impact on other platforms.
  - Only instantiates an auxiliary device; safe if the reboot driver
    isn’t present.
  - No ABI/uAPI changes.
- Important follow-up fix to include: The original change used
  `PTR_ERR_OR_ZERO(adev)` with `devm_auxiliary_device_create()`, which
  returns NULL on failure (not an error pointer). That was fixed by
  “pmdomain: thead: Fix error pointer vs NULL bug in
  th1520_pd_reboot_init()” (bbc3110823eca), which changes the return to
  `-ENODEV` on NULL and returns 0 otherwise:
  drivers/pmdomain/thead/th1520-pm-domains.c:181. For stable
  backporting, include this fix alongside the main commit to avoid
  silently succeeding when the aux device creation fails.
- Stable policy fit:
  - Fixes a real functionality gap (reboot/poweroff) for TH1520 users.
  - Minimal code, clear intent, and contained to the TH1520 PM domain
    driver.
  - No feature creep or architectural refactoring.

Recommendation: Backport this commit together with the follow-up fix
bbc3110823eca to ensure correct error handling.

 drivers/pmdomain/thead/th1520-pm-domains.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/pmdomain/thead/th1520-pm-domains.c b/drivers/pmdomain/thead/th1520-pm-domains.c
index 9040b698e7f7f..5213994101a59 100644
--- a/drivers/pmdomain/thead/th1520-pm-domains.c
+++ b/drivers/pmdomain/thead/th1520-pm-domains.c
@@ -173,6 +173,16 @@ static int th1520_pd_pwrseq_gpu_init(struct device *dev)
 					adev);
 }
 
+static int th1520_pd_reboot_init(struct device *dev,
+				 struct th1520_aon_chan *aon_chan)
+{
+	struct auxiliary_device *adev;
+
+	adev = devm_auxiliary_device_create(dev, "reboot", aon_chan);
+
+	return PTR_ERR_OR_ZERO(adev);
+}
+
 static int th1520_pd_probe(struct platform_device *pdev)
 {
 	struct generic_pm_domain **domains;
@@ -235,6 +245,10 @@ static int th1520_pd_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_clean_provider;
 
+	ret = th1520_pd_reboot_init(dev, aon_chan);
+	if (ret)
+		goto err_clean_provider;
+
 	return 0;
 
 err_clean_provider:
-- 
2.51.0

