Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB618229690;
	Thu, 12 Dec 2024 16:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022512; cv=none; b=OxI4o7qBHXfSmuUQOzF3rFbdd89zOzFakZZ7pWsBuRtrZ1lqWwWZuyOVlIsEV7PvyJ63TcqKI8Mv/7z2UOqavKcmfhEZabJ45AwpCbRO+YA1cb6MFyxZbn5gQMkRrn9FsVHzD/CU+W9VvpRpTfdo+JQtK6OLxn/YN1cY95ybeTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022512; c=relaxed/simple;
	bh=2WLacbY3ikgI7nR3ElLSDzMCyvOsPg2BUD5H9BunSIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OpYJtgDcwmrk/Ug+JnAjWyCjdS764DdkmtBlB50EevbcAJq++KZHcvsvj6vIypJIrLVfGObcK5tw4noHR6+3oj5wPNfSCk2jM6s6gbjCK1gtTyMq+MjIuvPTrjKixtqK4AZCaYSqGKHnkdAlk32NrJAD7N/drJIWadrc831HMCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZozhzXUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZozhzXUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567ACC4CED0;
	Thu, 12 Dec 2024 16:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022511;
	bh=2WLacbY3ikgI7nR3ElLSDzMCyvOsPg2BUD5H9BunSIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZozhzXUstjumsehSm+M3TuY8P4W8GfZqHAXUOaGYg6sLBRu5+Jl69x95/AwBzNp1H
	 KnAvxyWxRBfK3pMKURzm8p3h/nMVYnfdUSuYjAbvfHsaFzfCdE0ql0wIzJa9XRsGZI
	 M2Gq976OFCQWXLF8Exwtlcd85gWv5uooHzsckITU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 262/565] remoteproc: qcom_q6v5_mss: Re-order writes to the IMEM region
Date: Thu, 12 Dec 2024 15:57:37 +0100
Message-ID: <20241212144321.824779666@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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
index 93eefefd514c7..7fe1f2c5480af 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -1003,6 +1003,9 @@ static int q6v5_mba_load(struct q6v5 *qproc)
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



