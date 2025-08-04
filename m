Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559561E521D;
	Mon,  4 Aug 2025 00:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754268132; cv=none; b=epRzTW6BUBGcgre9FdItzDmin7A1kUqLU9+9AHW/7nQ/o6isiY+RBCRSVVTGVJlHkfPCnnzH/2Vr+uj2Ql+ZP3UfT3/RLGP12XV9G7sBPrTZOnOEk11E4a6r0lZTfDwmRpM4tR/KwqCcnahTpcO4fJ2tjymAFyIJ9JmRV0915cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754268132; c=relaxed/simple;
	bh=Umdm6+qlSHN+W/57WC3HQcCREyFa5LW7FPfx0GpqRLY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=THbg0mq0LP/2hlrcFOmv+uF6k5LiOQ/KnAGBoSTc3BwOTEIumo9qJXRBkYlkZurJMlO50Vjg2vy3303lbOvYQoJrm3Ppxlhk0r96m5k2im+SzGmRukXQxVdQ05X5q6vsjISmd7I4e8P73Q2v6CHYZVYSAd8EWPRZ3CY5zIQ2Y+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eBdpXFv5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eBdpXFv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8BAC4CEF0;
	Mon,  4 Aug 2025 00:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754268132;
	bh=Umdm6+qlSHN+W/57WC3HQcCREyFa5LW7FPfx0GpqRLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBdpXFv5DUlMDnMoZSUG8S8wGrF7tnGjE41/0V0k6GUyFA9MC7QUWGc0m2gaUdIXW
	 gvA5A0UhQm1+hFivkfQQjBaKMxgIYb99nbNAktCd0cfVWrFrUerYAoZaeVpsmlDuo9
	 JekgZWiP+/HtvmP1GLKqE/O4xKavlfDxd5MBwTGey7w0UzrZBUSwUTh4S/K543+Hcp
	 uW6rj2TNfb9o3na9rcKKoRt2NFkCya9b//LAzpQGNGdNLpzTbpX198UN2sL0M01nR7
	 xY8lBJn4EtgPcOvjy/b9cSz59vu8P1xMo1A3IaBiBYcj/6rYELeqE2HswrFD0AmH2k
	 o+bQRZ9h3PapA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tomasz Michalec <tmichalec@google.com>,
	Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	bleung@chromium.org,
	jthies@google.com,
	akuchynski@chromium.org,
	chrome-platform@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 34/39] platform/chrome: cros_ec_typec: Defer probe on missing EC parent
Date: Sun,  3 Aug 2025 20:40:36 -0400
Message-Id: <20250804004041.3628812-34-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804004041.3628812-1-sashal@kernel.org>
References: <20250804004041.3628812-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.240
Content-Transfer-Encoding: 8bit

From: Tomasz Michalec <tmichalec@google.com>

[ Upstream commit 8866f4e557eba43e991f99711515217a95f62d2e ]

If cros_typec_probe is called before EC device is registered,
cros_typec_probe will fail. It may happen when cros-ec-typec.ko is
loaded before EC bus layer module (e.g. cros_ec_lpcs.ko,
cros_ec_spi.ko).

Return -EPROBE_DEFER when cros_typec_probe doesn't get EC device, so
the probe function can be called again after EC device is registered.

Signed-off-by: Tomasz Michalec <tmichalec@google.com>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Link: https://lore.kernel.org/r/20250610153748.1858519-1-tmichalec@google.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real user-facing bug**: The commit addresses a module
   loading race condition where `cros_ec_typec.ko` can fail to probe if
   loaded before the EC bus layer modules (`cros_ec_lpcs.ko`,
   `cros_ec_spi.ko`). This causes the Type-C functionality to completely
   fail on affected systems.

2. **Small and contained fix**: The change is minimal - only 2 lines of
   actual code changes:
   - Changes `dev_err()` to `dev_warn()` (cosmetic improvement)
   - Changes return value from `-ENODEV` to `-EPROBE_DEFER`

3. **Follows established kernel patterns**: The fix uses the standard
   `-EPROBE_DEFER` mechanism which is the proper way to handle driver
   dependencies in the Linux kernel. The driver already uses
   `-EPROBE_DEFER` in another location (line 1289) for a similar EC
   device check.

4. **No architectural changes**: This is a simple probe deferral fix
   that doesn't introduce new features or change any existing
   functionality. It merely allows the driver to retry probing later
   when dependencies are satisfied.

5. **Minimal regression risk**: Returning `-EPROBE_DEFER` instead of
   `-ENODEV` is a safe change that only affects the probe retry
   behavior. The driver will still fail eventually if the EC device
   never appears.

6. **Fixes a regression**: Looking at commit ffebd9053272
   ("platform/chrome: cros_ec_typec: Check for EC device"), the check
   for parent EC device was added to handle older Chromebooks. However,
   it inadvertently broke systems where module loading order could vary,
   creating a race condition.

7. **Similar pattern in the subsystem**: Other Chrome platform drivers
   already use `-EPROBE_DEFER` for similar dependency handling (as seen
   in commit 13aba1e532f0).

The fix properly handles the asynchronous nature of driver loading in
modern Linux systems where module loading order is not guaranteed,
making it an important fix for system reliability.

 drivers/platform/chrome/cros_ec_typec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index 983daa220ee3..137f99c1848e 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -716,8 +716,8 @@ static int cros_typec_probe(struct platform_device *pdev)
 
 	typec->ec = dev_get_drvdata(pdev->dev.parent);
 	if (!typec->ec) {
-		dev_err(dev, "couldn't find parent EC device\n");
-		return -ENODEV;
+		dev_warn(dev, "couldn't find parent EC device\n");
+		return -EPROBE_DEFER;
 	}
 
 	platform_set_drvdata(pdev, typec);
-- 
2.39.5

