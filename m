Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46164101FA;
	Sat,  3 Feb 2024 04:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933916; cv=none; b=l7nr5PHR2NV2L9m5/fCCcn9tvLScN1mEtR9gccO0p4tyNlynVaKeo7yskgG+EL+c06CERlPyMh8xOih2GMvcr1pJPfc0ieWhtU+ZN5ZW52cls/2dog660VffNL4PjJJsl+ehxmFIeVIPoD5xvAc65wryu5FEcHynh1vfqjQSm8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933916; c=relaxed/simple;
	bh=hAggIo4Pz/Tp2jQg+xzX/qd3Q8CcW4kbz9pBjFe/t4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPtYQGClUmn86qUPM7N/Iz1+8T92d8ZETmbAUyyzo+x1rvzhOuGhV0M6IZfosOGITp5B39WoOvfeKNvk709mMVrSDjuqWrBZmVeGH05ULzcwqQRy+MeOJPz8dqF2wKGMEUE8xo/P+IwTLnpXzaYSyrroN858tbc8DTLHTw0TK40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frH/0ohk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frH/0ohk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10090C43399;
	Sat,  3 Feb 2024 04:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933916;
	bh=hAggIo4Pz/Tp2jQg+xzX/qd3Q8CcW4kbz9pBjFe/t4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frH/0ohkBPzJ7QrRk6kxXJQYvbsGQcejSF+K6Y4eMldpaeXB/EM/Vt/35R59MG2ZS
	 rMkUu8/Hv9C4v5ZPV0Awt3p8rGRkxm5ameib45o31zAC5/DrsQHYxRYRtDru8NNhFj
	 3U4uE04NHbgpkoO8ZYTQFgm7Gvbw/kR6Pt3f3UrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChiYuan Huang <cy_huang@richtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 270/353] ASoC: codecs: rtq9128: Fix PM_RUNTIME usage
Date: Fri,  2 Feb 2024 20:06:28 -0800
Message-ID: <20240203035412.300722071@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

From: ChiYuan Huang <cy_huang@richtek.com>

[ Upstream commit 35040410372ca27a33cec8382d42c90b6b6c99f6 ]

If 'pm_runtime_resume_and_get' is used, must check the return value to
prevent the active count not matched problem.

Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Link: https://msgid.link/r/bebd9e2bed9e0528a7fd9c528d785da02caf4f1a.1703813842.git.cy_huang@richtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rtq9128.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rtq9128.c b/sound/soc/codecs/rtq9128.c
index c22b047115cc..bda64f9eeb62 100644
--- a/sound/soc/codecs/rtq9128.c
+++ b/sound/soc/codecs/rtq9128.c
@@ -391,7 +391,11 @@ static int rtq9128_component_probe(struct snd_soc_component *comp)
 	unsigned int val;
 	int i, ret;
 
-	pm_runtime_resume_and_get(comp->dev);
+	ret = pm_runtime_resume_and_get(comp->dev);
+	if (ret < 0) {
+		dev_err(comp->dev, "Failed to resume device (%d)\n", ret);
+		return ret;
+	}
 
 	val = snd_soc_component_read(comp, RTQ9128_REG_EFUSE_DATA);
 
-- 
2.43.0



