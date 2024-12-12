Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FE82206A5;
	Thu, 12 Dec 2024 17:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024175; cv=none; b=fZcm75mEv/A0co9gMajl4zHs503Z6f6PzXgvUqd8R64b05GaNn6qxpeLcu+wPk3RSXXwG7ehR2T6aRg0TZJsVal86YCilLKtdrM3ryJVGuZKD2y2DK3Y9gVNLWgFfhE8TzSEDKZmv6GVK9uZp8NiZp3HuQFkgOw6eD2YOrv0oD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024175; c=relaxed/simple;
	bh=y/rxPk4C11a34KRfb8Ogb0JErWhGW4REQUgKTnQjrcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/VkXxQ3xJUGpi7reCq/iKW61Lgzkr1LIzst/lamXJv0HWPL7nk/GDz6DK7X8GXQZ1Slxzg2sDGGI+QN87JqU80AgkocSuR3HbwFppElbd4wkIySKWMF6mTF0xBGS7DMb9np+XfhEPimHve7jGfjg9+xmheeFsCZK826Jq7feXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wV0WvLqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wV0WvLqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9998BC4CECE;
	Thu, 12 Dec 2024 17:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024175;
	bh=y/rxPk4C11a34KRfb8Ogb0JErWhGW4REQUgKTnQjrcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wV0WvLqVOYBBCHRMHeOTWjIpAPNARSMUdBA/Jcfhq0R2r1llw8YocnO7D4QLbyCWg
	 ibga0K51XGcYtRH2VWLpTrV4LITocvakSi86kOw71ep+b7tzhP0m6b9ccKrkQCsj0c
	 XsADUvLh0LoXSDPpI+vKXWa8ZRV6CNW/LkWQCJI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 210/459] remoteproc: qcom_q6v5_mss: Re-order writes to the IMEM region
Date: Thu, 12 Dec 2024 15:59:08 +0100
Message-ID: <20241212144301.868179746@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sibi Sankar <quic_sibis@quicinc.com>

[ Upstream commit 7b22b7719fc17d5979a991c918c868ab041be5c8 ]

Any write access to the IMEM region when the Q6 is setting up XPU
protection on it will result in a XPU violation. Fix this by ensuring
IMEM writes related to the MBA post-mortem logs happen before the Q6
is brought out of reset.

Fixes: 318130cc9362 ("remoteproc: qcom_q6v5_mss: Add MBA log extraction support")
Signed-off-by: Sibi Sankar <quic_sibis@quicinc.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20240819073020.3291287-1-quic_sibis@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_mss.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index 3d975ecd93360..876223e6c9291 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -980,6 +980,9 @@ static int q6v5_mba_load(struct q6v5 *qproc)
 		goto disable_active_clks;
 	}
 
+	if (qproc->has_mba_logs)
+		qcom_pil_info_store("mba", qproc->mba_phys, MBA_LOG_SIZE);
+
 	writel(qproc->mba_phys, qproc->rmb_base + RMB_MBA_IMAGE_REG);
 	if (qproc->dp_size) {
 		writel(qproc->mba_phys + SZ_1M, qproc->rmb_base + RMB_PMI_CODE_START_REG);
-- 
2.43.0



