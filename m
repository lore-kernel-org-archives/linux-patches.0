Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578E01E47B7;
	Mon,  4 Aug 2025 00:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267786; cv=none; b=e4AZG8h6cp9X/ZD1AL8fdpJWkTRgy+oJaxSnzuYngDaAiUkZx78vBb0pL5xnmnafVQjl4wlCRCZyK389VKjw3cA6xxZprkQMdv7RJxzXRjQ5YFgq/8w28lHJIVGYAC9zJ7FN9iLLyG2mAuQie1hxz5RmYhUgEVfSUp21jSAprGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267786; c=relaxed/simple;
	bh=9sljXV/Uv3jJlmtyAPR8z7AKf/I6WudGmWTboi1XuSo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tNNAppA1KAm/sLj9V+Dxyrqlb8k4DpN+7EcbgHC0mZOZUys0ykK3mXTO9Uf6YG4owGaqC8H8wG8Ly4BFNJluTLNkvQJ8E1XoMUIOJ5HrIgk3aOZR6xq8Yup8GfCmSYqXvmmKRv8tcnghcXy8PeBlgdvuPnNCBQSb5Eznp/FgHfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JsBHer5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JsBHer5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB1AC4AF09;
	Mon,  4 Aug 2025 00:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267786;
	bh=9sljXV/Uv3jJlmtyAPR8z7AKf/I6WudGmWTboi1XuSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JsBHer5di5L4u04pU9mFr6UC0CYPouFv6b3ccI0aC53cdz8e5UjqG2navhKZGByPv
	 nnZrCwAbZkPuwgSlDqVQtqAWloKp84xo9vjTBHFSbJbD2waWRyY6PYsFvW5Bfks7lZ
	 /wTFCxFG/e+5M/XfMcyM/3JZvB3SORqm+IFgL84xiXWmpA03t0rtVrnZ9VM8j73rbf
	 16M4KxIuijQXAf6RPCRWXPNiAtsCaOLuVj8wZG4gMY83K7+emPnOYw8ScZ7GYMM26E
	 r32mStnppPZ0WBgy8EpwwxM6Cw1S5xB6hJqBEH4JQJ3ViAGkzFZsg7QDtGPLx3q+8x
	 LE2H8PdMwWAAA==
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
Subject: [PATCH AUTOSEL 6.6 53/59] platform/chrome: cros_ec_typec: Defer probe on missing EC parent
Date: Sun,  3 Aug 2025 20:34:07 -0400
Message-Id: <20250804003413.3622950-53-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003413.3622950-1-sashal@kernel.org>
References: <20250804003413.3622950-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.101
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
index 66fdc6fa73ec..76807ceb313a 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -1179,8 +1179,8 @@ static int cros_typec_probe(struct platform_device *pdev)
 
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

