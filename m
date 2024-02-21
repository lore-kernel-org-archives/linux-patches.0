Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655B77866C;
	Wed, 21 Feb 2024 13:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522688; cv=none; b=mObUr0SSknhSBOsu6puPwkAhkfr8Wj1dbDfqc3MUSypqQZw2JCJo4LfUvR2mux3cO/cMRsLzjGcQPs9oHTAJX/TGBP0Ow9jDW6NiER3uf6fQId3AjMH15cxbLD5B/al0NlJZo+A/vb46/kUStw6rdWohFdVejqnTdQTAec2NxIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522688; c=relaxed/simple;
	bh=7Q1buyOKDVQ/fKrjnaU4DABMAAB5fmDw+o0Hk8ESkA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YugYhsHIwCRHI+n2GJB4HgnNsA+z5lKLcExDMm811sWSZKhxDsp475nwGe8AKPevGzKW6E472gib9xpeeNUW3H0U0BLiTAs/ZLcwKG8uDJs7vwn3Sd8EyQ6fr6qspoduHSdsVsa2ulmy51LrG8eJpjZtwRLMtCACk4fqiM8NALg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G8IS/A2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G8IS/A2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C59C433C7;
	Wed, 21 Feb 2024 13:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522688;
	bh=7Q1buyOKDVQ/fKrjnaU4DABMAAB5fmDw+o0Hk8ESkA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G8IS/A2fWF+E48FeuN7Lc9qeDgj7c2J29v/F88Nd0C31XJTvgRJJqmxEKxVqEB+KL
	 mj7K4mhmaOh+JWQs76GWpgfXssXHBXsEn3fZQ1y2RojxU/Muoyz6+xZp+hTXjwZeuP
	 uqszAEp7muy2na9okH976IZ+3I/yClTcKs08botc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 231/476] clk: hi3620: Fix memory leak in hi3620_mmc_clk_init()
Date: Wed, 21 Feb 2024 14:04:42 +0100
Message-ID: <20240221130016.420376303@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit bfbea9e5667cfa9552c3d88f023386f017f6c308 ]

In cases where kcalloc() fails for the 'clk_data->clks' allocation, the
code path does not handle the failure gracefully, potentially leading
to a memory leak. This fix ensures proper cleanup by freeing the
allocated memory for 'clk_data' before returning.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Link: https://lore.kernel.org/r/20231210165040.3407545-1-visitorckw@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/hisilicon/clk-hi3620.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/hisilicon/clk-hi3620.c b/drivers/clk/hisilicon/clk-hi3620.c
index a3d04c7c3da8..eb9c139babc3 100644
--- a/drivers/clk/hisilicon/clk-hi3620.c
+++ b/drivers/clk/hisilicon/clk-hi3620.c
@@ -467,8 +467,10 @@ static void __init hi3620_mmc_clk_init(struct device_node *node)
 		return;
 
 	clk_data->clks = kcalloc(num, sizeof(*clk_data->clks), GFP_KERNEL);
-	if (!clk_data->clks)
+	if (!clk_data->clks) {
+		kfree(clk_data);
 		return;
+	}
 
 	for (i = 0; i < num; i++) {
 		struct hisi_mmc_clock *mmc_clk = &hi3620_mmc_clks[i];
-- 
2.43.0



