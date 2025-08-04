Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E4C188A3A;
	Mon,  4 Aug 2025 00:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267248; cv=none; b=QztiGZ8t6csUbO784K5n0TsM2cIxl1YU82pUyMdJLrMuP9NJOGpCnZH9GR856UYLD4wghuzfgHJdWREsZy6/WqT2uS2X4pljuFbdV0IGp9qvqY6jx7Esi/6fJDz4Bh5TuI9MccYo9K2IwZ2qDAnu+VnJnLi/dqql7Ga8FkFlQso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267248; c=relaxed/simple;
	bh=tn3dNj2bljfPeiAqSn/RHvdbvA0Pq0r7RiDgugZ8Cag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FxMFdcp+/DQMrsrbNX1SLFjdhc7PzZ0YEm7xJ4sGndkUj4MkntBlMT0c7pP05Cf8aQpe6ZvZ3E0YlJKaUTUAMnJw7MoKjUqpltTCPuNtunCR7E6DV3EL2bnD2sQb0DfgjjxkyWy9Aw0N5xHc87c//SLPBVHFBntGztT+SCStnmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PuJwr78+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PuJwr78+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556ECC4CEEB;
	Mon,  4 Aug 2025 00:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267248;
	bh=tn3dNj2bljfPeiAqSn/RHvdbvA0Pq0r7RiDgugZ8Cag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PuJwr78+YBXpet0qDqeuTwBj7UhNBM86UyPvu8+BiZPyJAVpy+ZhIKK32DeOwabvm
	 YmfwS8r3oSCpfhqKrpsOuPjFUYEHhaQILHBsMGLUs0h9kq/RCU+mwAYBwkw2QSWWbk
	 8EYyX+OEHCoMbs+alPRmBBie/65l/Y2mILVAPgaumdQQ3aX97+zDR0mEMIZtNbxU7M
	 wXEH7iu9YiYeaGxK13yU0MtjAMk5TVePHkc2MU5LzYWEwag07nSF12iLKXmTdcwGfW
	 zALovnmTfHyBr5fN0bh1tdzhDWx+NZBsK4a3SU3otF3SvaquqMEcIPk+a48qJTT6cG
	 SUDLxzc4Jmmcw==
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
Subject: [PATCH AUTOSEL 6.16 79/85] platform/chrome: cros_ec_typec: Defer probe on missing EC parent
Date: Sun,  3 Aug 2025 20:23:28 -0400
Message-Id: <20250804002335.3613254-79-sashal@kernel.org>
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
index 7678e3d05fd3..f437b594055c 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -1272,8 +1272,8 @@ static int cros_typec_probe(struct platform_device *pdev)
 
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

