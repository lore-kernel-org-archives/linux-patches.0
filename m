Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D5D8474
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6231C433EF;
	Tue, 28 Mar 2023 14:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680014666;
	bh=v/3LkMJ6Yj03+kGGsAzqvp9UoXGUKgnXcpHymRpBQrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWu3j/JUw2ESJUlpID2jb1CpAnSQ+7/hg6gMX2IlVmQkY0b66WUWHr6/rGGbg5pZf
	 lXiOM20IOivvlTyTYOjeBX4h8VDJ7OKPzyXZ6F9b+G3u4P02Zw29LrGVjqV+SEZj8O
	 Oowbolg9DJqxctcTMlWXPOKIzvPxAiS+ULz2kW70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 001/240] interconnect: qcom: osm-l3: fix icc_onecell_data allocation
Date: Tue, 28 Mar 2023 16:39:24 +0200
Message-Id: <20230328142619.710865759@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit f77ebdda0ee652124061c2ac42399bb6c367e729 ]

This is a struct with a trailing zero-length array of icc_node pointers
but it's allocated as if it were a single array of icc_nodes instead.

Fortunately this overallocates memory rather then allocating less memory
than required.

Fix by replacing devm_kcalloc() with devm_kzalloc() and struct_size()
macro.

Fixes: 5bc9900addaf ("interconnect: qcom: Add OSM L3 interconnect provider support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230105002221.1416479-2-dmitry.baryshkov@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/osm-l3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/interconnect/qcom/osm-l3.c b/drivers/interconnect/qcom/osm-l3.c
index 3a1cbfe3e481f..1bafb54f14329 100644
--- a/drivers/interconnect/qcom/osm-l3.c
+++ b/drivers/interconnect/qcom/osm-l3.c
@@ -236,7 +236,7 @@ static int qcom_osm_l3_probe(struct platform_device *pdev)
 	qnodes = desc->nodes;
 	num_nodes = desc->num_nodes;
 
-	data = devm_kcalloc(&pdev->dev, num_nodes, sizeof(*node), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, struct_size(data, nodes, num_nodes), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-- 
2.39.2



