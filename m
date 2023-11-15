Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CEA041223
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yO8Aj9ln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF90C433C9;
	Wed, 15 Nov 2023 19:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076425;
	bh=wPq6dEsxuBEF/rrnTRPENnsqOTAGWNTDiZAjzVUh0Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yO8Aj9lnXfYHZ4pzwyTVda+tcQWA6EEpx2mio1slLihoJlvILmQNgbAdZed+BVtrC
	 vVjJmuiguGMTriX7jIIyqldk/e+PLgPmib04iSzUF5qPWGaP7z+HYF6xwWWYZRf0s6
	 e5ZcHbFeQqosEQOXyoqlIO56JpFQ7tcSrMa2Ymcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	"Kunwu.Chan" <chentao@kylinos.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 256/550] drm/amd/pm: Fix a memory leak on an error path
Date: Wed, 15 Nov 2023 14:14:00 -0500
Message-ID: <20231115191618.448977801@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu.Chan <chentao@kylinos.cn>

[ Upstream commit 828f8e31379b28fe7f07fb5865b8ed099d223fca ]

Add missing free on an error path.

Fixes: 511a95552ec8 ("drm/amd/pm: Add SMU 13.0.6 support")
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Kunwu.Chan <chentao@kylinos.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
index dc6104a04dce6..7674ea9611ddd 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
@@ -1977,8 +1977,10 @@ static ssize_t smu_v13_0_6_get_gpu_metrics(struct smu_context *smu, void **table
 
 	metrics = kzalloc(sizeof(MetricsTable_t), GFP_KERNEL);
 	ret = smu_v13_0_6_get_metrics_table(smu, metrics, true);
-	if (ret)
+	if (ret) {
+		kfree(metrics);
 		return ret;
+	}
 
 	smu_cmn_init_soft_gpu_metrics(gpu_metrics, 1, 3);
 
-- 
2.42.0



