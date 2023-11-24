Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561AD381D7;
	Fri, 24 Nov 2023 18:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHzwhuTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C29BC433C7;
	Fri, 24 Nov 2023 18:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849523;
	bh=m3CEQzDXTplOg4fhUZuw/e6WzN+4lVdRfwUrB0+GEzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vHzwhuTvqLNzoSIq31rbNC9ItU0/L1lCg5sE6tdC5UrknM33xjQ6MdTpy6m5N1KAq
	 UJemiXL+5fJA9OvoJxv3225rH2U9V+UaUu4omsNJb+Ck6LglBiXtEq1AatgBcSiOsH
	 IjM7p3VEnQqKxxJC7jpj8wVY0b2hZQb4oNljrdEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonglong Liu <liuyonglong@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 191/530] net: hns3: fix out-of-bounds access may occur when coalesce info is read via debugfs
Date: Fri, 24 Nov 2023 17:45:57 +0000
Message-ID: <20231124172033.882565838@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit 53aba458f23846112c0d44239580ff59bc5c36c3 ]

The hns3 driver define an array of string to show the coalesce
info, but if the kernel adds a new mode or a new state,
out-of-bounds access may occur when coalesce info is read via
debugfs, this patch fix the problem.

Fixes: c99fead7cb07 ("net: hns3: add debugfs support for interrupt coalesce")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index b8508533878be..4f385a18d288e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -500,11 +500,14 @@ static void hns3_get_coal_info(struct hns3_enet_tqp_vector *tqp_vector,
 	}
 
 	sprintf(result[j++], "%d", i);
-	sprintf(result[j++], "%s", dim_state_str[dim->state]);
+	sprintf(result[j++], "%s", dim->state < ARRAY_SIZE(dim_state_str) ?
+		dim_state_str[dim->state] : "unknown");
 	sprintf(result[j++], "%u", dim->profile_ix);
-	sprintf(result[j++], "%s", dim_cqe_mode_str[dim->mode]);
+	sprintf(result[j++], "%s", dim->mode < ARRAY_SIZE(dim_cqe_mode_str) ?
+		dim_cqe_mode_str[dim->mode] : "unknown");
 	sprintf(result[j++], "%s",
-		dim_tune_stat_str[dim->tune_state]);
+		dim->tune_state < ARRAY_SIZE(dim_tune_stat_str) ?
+		dim_tune_stat_str[dim->tune_state] : "unknown");
 	sprintf(result[j++], "%u", dim->steps_left);
 	sprintf(result[j++], "%u", dim->steps_right);
 	sprintf(result[j++], "%u", dim->tired);
-- 
2.42.0



