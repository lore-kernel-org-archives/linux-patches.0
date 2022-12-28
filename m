Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399481863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32AAC433D2;
	Wed, 28 Dec 2022 15:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241069;
	bh=QXKYNsCDpUrKazSGPEpHhKiCAaR7nZBQXGmDtT9xWz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qaAoIpFBZYFbGaLMPBmNrQ7mMqAhgelFCnG2gQqgn1FUb3vvum1GHLmMxE54lJZk9
	 AWp48B3u2Ds2rHcUooz/7odzS7I7b0jCUvfW5k3yLJP4ZCkr9alHiVxJxQK1YUVYAR
	 Uk7Re+KZHxfVm9LqdF2KR4856oJ7SAIM/xHkatHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tang Bin <tangbin@cmss.chinamobile.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0236/1073] venus: pm_helpers: Fix error check in vcodec_domains_get()
Date: Wed, 28 Dec 2022 15:30:24 +0100
Message-Id: <20221228144334.437611464@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tang Bin <tangbin@cmss.chinamobile.com>

[ Upstream commit 0f6e8d8c94a82e85e1b9b62a7671990740dc6f70 ]

In the function vcodec_domains_get(), dev_pm_domain_attach_by_name()
may return NULL in some cases, so IS_ERR() doesn't meet the
requirements. Thus fix it.

Fixes: 7482a983dea3 ("media: venus: redesign clocks and pm domains control")
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/pm_helpers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/pm_helpers.c b/drivers/media/platform/qcom/venus/pm_helpers.c
index c93d2906e4c7..48c9084bb4db 100644
--- a/drivers/media/platform/qcom/venus/pm_helpers.c
+++ b/drivers/media/platform/qcom/venus/pm_helpers.c
@@ -869,8 +869,8 @@ static int vcodec_domains_get(struct venus_core *core)
 	for (i = 0; i < res->vcodec_pmdomains_num; i++) {
 		pd = dev_pm_domain_attach_by_name(dev,
 						  res->vcodec_pmdomains[i]);
-		if (IS_ERR(pd))
-			return PTR_ERR(pd);
+		if (IS_ERR_OR_NULL(pd))
+			return PTR_ERR(pd) ? : -ENODATA;
 		core->pmdomains[i] = pd;
 	}
 
-- 
2.35.1



