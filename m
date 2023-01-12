Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917D1749D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:04:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A219C433D2;
	Thu, 12 Jan 2023 14:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532286;
	bh=WBJtCJDaMxknpk0Gofvzh1Y9UkDVAQz9yZA/U7Di8Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=033pj3xcgzXr4OXeUIqqLxfJrdzjaX88i3K+bRhjIDVfkh30GLWvrehYcUOQ2/3GS
	 i8J509tM5D5PW8ZAftz6ZdJhmvWf+ndzKV6W31sMmIqmcz5FzmrkrKkN9JD5Hi58TH
	 /RrP1CWMeLqNyKqPosjfb1k2/1QapzHt/RLCGUxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tang Bin <tangbin@cmss.chinamobile.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/783] venus: pm_helpers: Fix error check in vcodec_domains_get()
Date: Thu, 12 Jan 2023 14:47:08 +0100
Message-Id: <20230112135529.392657485@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 710f9a2b132b..f7de02352f1b 100644
--- a/drivers/media/platform/qcom/venus/pm_helpers.c
+++ b/drivers/media/platform/qcom/venus/pm_helpers.c
@@ -764,8 +764,8 @@ static int vcodec_domains_get(struct venus_core *core)
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



