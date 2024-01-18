Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8F11B96D;
	Thu, 18 Jan 2024 10:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575124; cv=none; b=ns20MnNocpzgRc7foivveWJXLSrt83xssV1D7LQAOmyYv+k7oSEMi1jvtANjg4+pL1wmTnyJIpjUb/BjR18eyE7skF5qUJtLp4O2BC5J8E39K1XfoakvGvemXEmUu+c6aj//ef3EILlGGqmOJkN7aQv1c6pBgO6PWp6oqelyo7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575124; c=relaxed/simple;
	bh=12Y6PpZuckzJpz03tNd7sFfAnGwg1Ll3nCz0T+cTycc=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=X6jd+WHc8Kz0ng+nl7aXw1WHFTLoUkt7R5DzABDzUNmaW04RDEUSWTGFEoznpdjJdrQAcYO/m9Z8Mj0obSL+Un4CLhQyAYF7mrBDa8ABotCxrkKe6B97EvSjB1vaOwj+DzAxJuBEFlk49huF0d7ui88kBgMegrOLFkttO4AhBAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2YP6KZd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2YP6KZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7178BC433C7;
	Thu, 18 Jan 2024 10:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575123;
	bh=12Y6PpZuckzJpz03tNd7sFfAnGwg1Ll3nCz0T+cTycc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f2YP6KZdVZkdVam7hcQ/xuQxo3FgPprePRCZsiT9LlpVg9G15LmPOmMn7kF6mpXAr
	 +E8ZJLMIWAWjq8+UE9FVbcb2M5ZpaDDJ+jDVYxyqHNRYJcp9OABdXR21K2ouC5aDZT
	 MVIuZWDQs1+9eO/xmbdYCfOG7jV4o46vokhhvbhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Chester Lin <clin@suse.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/150] pinctrl: s32cc: Avoid possible string truncation
Date: Thu, 18 Jan 2024 11:47:04 +0100
Message-ID: <20240118104320.147257659@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chester Lin <clin@suse.com>

[ Upstream commit 08e8734d877a9a0fb8af1254a4ce58734fbef296 ]

With "W=1" and "-Wformat-truncation" build options, the kernel test robot
found a possible string truncation warning in pinctrl-s32cc.c, which uses
an 8-byte char array to hold a memory region name "map%u". Since the
maximum number of digits that a u32 value can present is 10, and the "map"
string occupies 3 bytes with a termination '\0', which means the rest 4
bytes cannot fully present the integer "X" that exceeds 4 digits.

Here we check if the number >= 10000, which is the lowest value that
contains more than 4 digits.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311030159.iyUGjNGF-lkp@intel.com/
Signed-off-by: Chester Lin <clin@suse.com>
Link: https://lore.kernel.org/r/20231107141044.24058-1-clin@suse.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/nxp/pinctrl-s32cc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/nxp/pinctrl-s32cc.c b/drivers/pinctrl/nxp/pinctrl-s32cc.c
index 7daff9f186cd..f0cad2c501f7 100644
--- a/drivers/pinctrl/nxp/pinctrl-s32cc.c
+++ b/drivers/pinctrl/nxp/pinctrl-s32cc.c
@@ -843,8 +843,8 @@ static int s32_pinctrl_probe_dt(struct platform_device *pdev,
 	if (!np)
 		return -ENODEV;
 
-	if (mem_regions == 0) {
-		dev_err(&pdev->dev, "mem_regions is 0\n");
+	if (mem_regions == 0 || mem_regions >= 10000) {
+		dev_err(&pdev->dev, "mem_regions is invalid: %u\n", mem_regions);
 		return -EINVAL;
 	}
 
-- 
2.43.0



