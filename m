Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A34F1F4CB3;
	Tue, 15 Jul 2025 13:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585830; cv=none; b=EvK9TLeREmCehtlnxFm48Og+NjJftMrf9NbJ3HAZlYlAqe0HTnKZdr3Qny+XFkuFArrILqNdbM5O+DGPQDazlFc0IaQnr0Ain2iZlLxtcyvSThVLv6K+WhF2UTLzHm7lmH46ESYQQ9nRLGJe0wXkraKNJNxeIEdGjw0qEnAWd3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585830; c=relaxed/simple;
	bh=d0IZcdwCqx4w+9iku7gGUaXgAIeNW+EY1mzJMlF4q44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6VRXYlLOipH/wYq/PTNFL6UPJC/p1Y9Bju9tnAZi0Rc4kTw47ftDqwFEp4XFEo4oFhiOB0mFrSo5zffMEzkAq6wZjjSS/YhAMlLuPpvObsfAREpeJO0/zeSGrCA8RYDRDE9NvaRjRdyB0Js6vELzMw7bpU3/FK0X9Hg7z+mD0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iRX9HEGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iRX9HEGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4544C4CEE3;
	Tue, 15 Jul 2025 13:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585830;
	bh=d0IZcdwCqx4w+9iku7gGUaXgAIeNW+EY1mzJMlF4q44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iRX9HEGQnuuMKYyGW8tdwOeD6a5a82zpYh+CTM9RinCTqO+5wTwAHlleO4D349Knc
	 BJLk86M92TfUnb04kX9EoEqiw600J+r+5IYbSnW2dZ1ibbxhH4+7ElX6xPNOCFuwxm
	 taTgYq1gGbBksU4yXaC7JlYhTHTrLr7RUN/m8J4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/109] ASoC: cs35l56: probe() should fail if the device ID is not recognized
Date: Tue, 15 Jul 2025 15:12:22 +0200
Message-ID: <20250715130759.129329241@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 3b3312f28ee2d9c386602f8521e419cfc69f4823 ]

Return an error from driver probe if the DEVID read from the chip is not
one supported by this driver.

In cs35l56_hw_init() there is a check for valid DEVID, but the invalid
case was returning the value of ret. At this point in the code ret == 0
so the caller would think that cs35l56_hw_init() was successful.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 84851aa055c8 ("ASoC: cs35l56: Move part of cs35l56_init() to shared library")
Link: https://patch.msgid.link/20250703102521.54204-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56-shared.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs35l56-shared.c b/sound/soc/codecs/cs35l56-shared.c
index d3db89c93b331..25ee7477709e7 100644
--- a/sound/soc/codecs/cs35l56-shared.c
+++ b/sound/soc/codecs/cs35l56-shared.c
@@ -661,7 +661,7 @@ int cs35l56_hw_init(struct cs35l56_base *cs35l56_base)
 		break;
 	default:
 		dev_err(cs35l56_base->dev, "Unknown device %x\n", devid);
-		return ret;
+		return -ENODEV;
 	}
 
 	ret = regmap_read(cs35l56_base->regmap, CS35L56_DSP_RESTRICT_STS1, &secured);
-- 
2.39.5



