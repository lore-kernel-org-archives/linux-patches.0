Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CEC7BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1554FC433EF;
	Tue,  7 Mar 2023 17:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209824;
	bh=Ieevzb72Tp4clAm6jd3V2JofjiB9KvCO+j6nF8eOlM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHYnlIPJQHGNLdGuXjtnXh5IcQraJahMPIYZsKQWYbMD/ueiJXjvfoMeKchwUtg+u
	 bW0G7MJD4in9FDbztfU4mX5oy9KnBmGa30Pr+5o3ATHICWG6vVinPSPaolhfhGZ3hy
	 I+rL55xsuADnBuc12fiez6xtLMAInJx1wqLAZoTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Tang <tanghui20@huawei.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0343/1001] drm/msm/dpu: check for null return of devm_kzalloc() in dpu_writeback_init()
Date: Tue,  7 Mar 2023 17:51:55 +0100
Message-Id: <20230307170036.344386568@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hui Tang <tanghui20@huawei.com>

[ Upstream commit 21e9a838f505178e109ccb3bf19d7808eb0326f4 ]

Because of the possilble failure of devm_kzalloc(), dpu_wb_conn might
be NULL and will cause null pointer dereference later.

Therefore, it might be better to check it and directly return -ENOMEM.

Fixes: 77b001acdcfe ("drm/msm/dpu: add the writeback connector layer")
Signed-off-by: Hui Tang <tanghui20@huawei.com>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/512277/
Link: https://lore.kernel.org/r/20221119055518.179937-1-tanghui20@huawei.com
[DB: fixed typo in commit message]
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_writeback.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_writeback.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_writeback.c
index 088ec990a2f26..2a5a68366582b 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_writeback.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_writeback.c
@@ -70,6 +70,8 @@ int dpu_writeback_init(struct drm_device *dev, struct drm_encoder *enc,
 	int rc = 0;
 
 	dpu_wb_conn = devm_kzalloc(dev->dev, sizeof(*dpu_wb_conn), GFP_KERNEL);
+	if (!dpu_wb_conn)
+		return -ENOMEM;
 
 	drm_connector_helper_add(&dpu_wb_conn->base.base, &dpu_wb_conn_helper_funcs);
 
-- 
2.39.2



