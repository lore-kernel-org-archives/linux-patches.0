Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18044155C81;
	Mon, 27 May 2024 19:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837577; cv=none; b=At5BwqYN3WZRM2ePzM/a+bauEEz9YxCBWwGObK4JW4DgulykxSKVsOysTpwwyiAn4ihTpAsywCXcK85HEhmsny589FKz/HUs7JMWrIX9s2gbiGa0Z3k6slrb86tHttRG9YsFER5f0CByN4svA3jpyu9urKAu5xY0/yrygqABZl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837577; c=relaxed/simple;
	bh=D2DMctfSqDfVJjNPXg5D2g6KFA6YksbTFQttr7HU8bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFSxstjbY9cqga68/1w8izk1+TEmwAaILoHsafWW897sNVM24qIDzBqb7Rr6/jw1fw4dvYjAQPR+0grY5Qypm0uscLcxU722pOXUpOOHitTt7+AsDaZRDWcIexekVwIbOkDfOcrRvdg+gtJNiEAod/i7F4NY4bOg27gxAGpW4ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KeCn0lUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KeCn0lUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A168CC2BBFC;
	Mon, 27 May 2024 19:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837577;
	bh=D2DMctfSqDfVJjNPXg5D2g6KFA6YksbTFQttr7HU8bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KeCn0lUvnRlGQdNcJuLkfg3T/h1P6G6+bGoL3Q9oiaIQNq97+dcUzxIMeVxbVDvHZ
	 YfHdNVtWQ2UnP7jkri+yxt9ZWe1lSut4n5dJ8guHatVPIZhZ83wHegcp08B86f+ZKe
	 WtSCFeaOLelAgis3Q7uMCkdDuZJYgaWQ/xxtEuzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 064/493] ALSA: hda: cs35l56: Exit cache-only after cs35l56_wait_for_firmware_boot()
Date: Mon, 27 May 2024 20:51:06 +0200
Message-ID: <20240527185631.714965217@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 73580ec607dfe125b140ed30c7c0a074db78c558 ]

Adds calls to disable regmap cache-only after a successful return from
cs35l56_wait_for_firmware_boot().

This is to prepare for a change in the shared ASoC module that will
leave regmap in cache-only mode after cs35l56_system_reset(). This is
to prevent register accesses going to the hardware while it is
rebooting.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://msgid.link/r/20240408101803.43183-3-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l56_hda.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index 43a445bd961fb..de58a953b48d2 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -629,6 +629,8 @@ static int cs35l56_hda_fw_load(struct cs35l56_hda *cs35l56)
 		ret = cs35l56_wait_for_firmware_boot(&cs35l56->base);
 		if (ret)
 			goto err_powered_up;
+
+		regcache_cache_only(cs35l56->base.regmap, false);
 	}
 
 	/* Disable auto-hibernate so that runtime_pm has control */
@@ -978,6 +980,8 @@ int cs35l56_hda_common_probe(struct cs35l56_hda *cs35l56, int id)
 	if (ret)
 		goto err;
 
+	regcache_cache_only(cs35l56->base.regmap, false);
+
 	ret = cs35l56_set_patch(&cs35l56->base);
 	if (ret)
 		goto err;
-- 
2.43.0



