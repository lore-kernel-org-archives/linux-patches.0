Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAF9344D92;
	Wed, 30 Sep 2026 18:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794451; cv=none; b=u1t8FvYp6f0svf7KvZdrmX2Ktp1r3uh7m/ieRoxFDIwzQ3H3JT4MiQoF9mQQlAs3jjQCAlQkpHkyzRY1+osoDthK6wWWsTWdx0tPrG9tmJMzA1qq6AaVHohAX4uN8pUEm5b9gyNyD7DrjrJNjUvKt7oKsrF965/dXGgxaR7Jh1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794451; c=relaxed/simple;
	bh=8WwhEGQVhFNNdrkAomlvapMtyAWZRrh0TeomVOUqkHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/TIPFYarv4w84IoTuSnXYnZyQBaG4m/B+Ey2LZf3CBVYZZYe0skClCzlh0G8csUezWvoX+fZuQx/HtwHaRQfjlTvlV1gPVHIj7QRMSe9GYIs5/02zVN1tDfKQo0pG4ie6WPgi9aZ9usP4gPSjdQQ7kPLSZ26nCpieGdFaw3cs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YuTBhtFB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YuTBhtFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A5A1F000FF;
	Wed, 30 Sep 2026 18:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794449;
	bh=gyAy8/JNIvWv4YzeXg0EiD8pIE7w+DX+CLjVLjsyogo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YuTBhtFBd1OxNfLqTim3w4TckDsf5FzlQvlZgQYcDDUp6NRo0xTBJf22gFI9Ku8nA
	 RjBnqM/bbmKQPqPbaUy3UpImE6imcf56GepZkUuhF8GibRV5ltMe7eUBrzVGLp3+cF
	 lH1rPTfVx//ZKNztlHrMfYCZrXlUEUzERv2VqAjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0215/1193] ASoC: rockchip: rockchip_pdm: Reorder clock enable sequence
Date: Wed, 30 Sep 2026 17:14:59 +0200
Message-ID: <20260930152438.979102085@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 3168721d6ec3b610edf6a3c22ad190722a27d276 ]

Enable the 'hclk' bus clock before the 'clk' controller clock during
runtime resume.
The bus clock provides the register access interface, so enable it before
the controller clock. This also makes the resume sequence the reverse of
the suspend sequence, which keeps the clock ordering consistent.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260602101608.45137-4-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_pdm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/rockchip/rockchip_pdm.c b/sound/soc/rockchip/rockchip_pdm.c
index 96f77e1c16e32..6b84405314d89 100644
--- a/sound/soc/rockchip/rockchip_pdm.c
+++ b/sound/soc/rockchip/rockchip_pdm.c
@@ -427,16 +427,16 @@ static int rockchip_pdm_runtime_resume(struct device *dev)
 	struct rk_pdm_dev *pdm = dev_get_drvdata(dev);
 	int ret;
 
-	ret = clk_prepare_enable(pdm->clk);
+	ret = clk_prepare_enable(pdm->hclk);
 	if (ret) {
-		dev_err(pdm->dev, "clock enable failed %d\n", ret);
+		dev_err(pdm->dev, "hclock enable failed %d\n", ret);
 		return ret;
 	}
 
-	ret = clk_prepare_enable(pdm->hclk);
+	ret = clk_prepare_enable(pdm->clk);
 	if (ret) {
-		clk_disable_unprepare(pdm->clk);
-		dev_err(pdm->dev, "hclock enable failed %d\n", ret);
+		clk_disable_unprepare(pdm->hclk);
+		dev_err(pdm->dev, "clock enable failed %d\n", ret);
 		return ret;
 	}
 
-- 
2.53.0



