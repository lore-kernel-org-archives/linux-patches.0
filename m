Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A50BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48ECC4339B;
	Tue,  7 Mar 2023 18:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215307;
	bh=H78v4yoDsXx60NrZH61rRRVX438mKYVnaUKsRmQUQtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQ3YTaVr5WITQJI9LDQn/wSxzb7t+ChRrVodsOqX2sQxb8x9vEZGNAvdZQ1PVCqGq
	 +Dzz51HML60Uign9HZBVAnplIW6JjJVf67G8RC7DE83Q5rztwJbckGUUgUiHFcv65v
	 i33KxivVQb1t/BHwpFa04IUziHYaxnkW9sS7Do2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 191/567] drm/msm/gem: Add check for kmalloc
Date: Tue,  7 Mar 2023 17:58:47 +0100
Message-Id: <20230307165914.224420105@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit d839f0811a31322c087a859c2b181e2383daa7be ]

Add the check for the return value of kmalloc in order to avoid
NULL pointer dereference in copy_from_user.

Fixes: 20224d715a88 ("drm/msm/submit: Move copy_from_user ahead of locking bos")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/514678/
Link: https://lore.kernel.org/r/20221212091117.43511-1-jiasheng@iscas.ac.cn
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_submit.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index 1f74bab9e231a..83e6ccad77286 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -220,6 +220,10 @@ static int submit_lookup_cmds(struct msm_gem_submit *submit,
 			goto out;
 		}
 		submit->cmd[i].relocs = kmalloc(sz, GFP_KERNEL);
+		if (!submit->cmd[i].relocs) {
+			ret = -ENOMEM;
+			goto out;
+		}
 		ret = copy_from_user(submit->cmd[i].relocs, userptr, sz);
 		if (ret) {
 			ret = -EFAULT;
-- 
2.39.2



