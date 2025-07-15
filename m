Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEA3193077;
	Tue, 15 Jul 2025 13:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585465; cv=none; b=diGbODAjzMw9an86qg1geJ5IyxIxSnYuC9YATaZqj32k2lp6NB3s4WKs11RybbPQKEUOMAG29ykFgKP+QCiy/CoR3v8Cw+xSSZTNP2i1kFa6LGfsLzpvLomfzp/KqqbrWCJmZUL5m0R4S5+vfRlc3CYUvdZKv0nmLRhxLzNnzcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585465; c=relaxed/simple;
	bh=5oJ4vO3o6daH/UtrHktA/8DIUa3shE6lDS9KpyDgYBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nM/a3kWIgIqsP0AVUQc9NIybfJXoan37eQRthHbo9waqwWM2yA1+CLiAJAX+Li3tI5oehFY5cs8sOyHLa7DeMFT+GfG/uqxIHVRBpyYZuuw7LYopd4WVBGUi1QCoTko9lTTBvzVU0s1K/y+eE4pL6IloZTUPGhk8trKaOctEd7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5o5CPJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5o5CPJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4176AC4CEF1;
	Tue, 15 Jul 2025 13:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585465;
	bh=5oJ4vO3o6daH/UtrHktA/8DIUa3shE6lDS9KpyDgYBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5o5CPJQFIx433LQHQ077+bC4wXpMgAJx4R5+/pQ4kIZsHbiB673bm511ROzcidKm
	 y3cpr87C4FX+Z6rv7dkdWts3nFgIp7dqPuqdEs9UeGsh5MOXYd+qfTc43IGfCrQy28
	 whhj2HmSE80RVGrbDULavDzqUs6DLcyC1PaivGCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/163] ASoC: cs35l56: probe() should fail if the device ID is not recognized
Date: Tue, 15 Jul 2025 15:11:27 +0200
Message-ID: <20250715130809.539434877@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 195841a567c3d..9007484b31c71 100644
--- a/sound/soc/codecs/cs35l56-shared.c
+++ b/sound/soc/codecs/cs35l56-shared.c
@@ -811,7 +811,7 @@ int cs35l56_hw_init(struct cs35l56_base *cs35l56_base)
 		break;
 	default:
 		dev_err(cs35l56_base->dev, "Unknown device %x\n", devid);
-		return ret;
+		return -ENODEV;
 	}
 
 	cs35l56_base->type = devid & 0xFF;
-- 
2.39.5



