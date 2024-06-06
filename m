Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA6819EEA4;
	Thu,  6 Jun 2024 14:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683119; cv=none; b=niIV+Lkg0gZoyHn+7wcP+PlhUBSMifV+DyhD2NgAGGFB2VqaPNz/ppoOSSiYYGYOoAinQZ65EIAgTtDWyReY0KIxfm82b6nyRsNphPpCvGjP+2VGbCDJ+MTKrU3PA0A4XUl7ZoM96LDx0YBNwCj0Njd6giGZoEyP3n2Fcy0jHdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683119; c=relaxed/simple;
	bh=eNpnojzrY/lm1Y/5o1M1qN+v3X1uUkbzcGOV+8nP76s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTVvAYbBfH81U7U+en5kxsFqdmHmz8FeTo6GBCFT+OeHcjbGzQqJP0inUX0Ypsvl0qfyhfcLbD3yoLlNgrSWqlrRmXtUgXDbnZ7Zi+XprSIudFtswscyC/9tIr3eCVUFuvtHKD53F4zFYShFbcwLHIWFxb4l0OUt7/UPBeW3xEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPD7e+KN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPD7e+KN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23A8C2BD10;
	Thu,  6 Jun 2024 14:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683118;
	bh=eNpnojzrY/lm1Y/5o1M1qN+v3X1uUkbzcGOV+8nP76s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPD7e+KNOYQk2XPKG/8KY82blMt1hAa3GtamKuKRTFpJKhHxXqEK/gezMxqvuNVJ4
	 QoCb4gTuxSDdELtBc/NAgEZKe0MyVpzGRiU5GqSMgkEJC0ZetJfBfLrfqvia7EC8Gw
	 TNJp554OAnxNxbVjQVGvBuH67KP2EkgyqV/zLsTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/744] ALSA: hda: cs35l56: Exit cache-only after cs35l56_wait_for_firmware_boot()
Date: Thu,  6 Jun 2024 15:55:27 +0200
Message-ID: <20240606131734.194151361@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index 27848d6469636..05b1412868fc0 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -603,6 +603,8 @@ static int cs35l56_hda_fw_load(struct cs35l56_hda *cs35l56)
 		ret = cs35l56_wait_for_firmware_boot(&cs35l56->base);
 		if (ret)
 			goto err_powered_up;
+
+		regcache_cache_only(cs35l56->base.regmap, false);
 	}
 
 	/* Disable auto-hibernate so that runtime_pm has control */
@@ -942,6 +944,8 @@ int cs35l56_hda_common_probe(struct cs35l56_hda *cs35l56, int id)
 	if (ret)
 		goto err;
 
+	regcache_cache_only(cs35l56->base.regmap, false);
+
 	ret = cs35l56_set_patch(&cs35l56->base);
 	if (ret)
 		goto err;
-- 
2.43.0



