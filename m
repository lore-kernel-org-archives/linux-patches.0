Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A672C8489
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0BBC433D2;
	Fri, 10 Mar 2023 14:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457851;
	bh=PEYtR3k5ihRlOcnc7O2fQZPh+FS5KW/orCTC35TWCIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y2VMzydr35ygO96/2CDx/NFhkttn9xr8DDFlq6+YpcThRyh+UXapkcvlzUGB0QO4f
	 gSp07JrcQzBBN/4BqjDs9LDQ7/L3K3CUNQOQRlSKtQhusP8oz2UueL8E6FJuEVC8b1
	 uT1VOVHDYX0SxKRacmblieQQXTEbCqyjhd/8AaXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 079/252] gpu: host1x: Dont skip assigning syncpoints to channels
Date: Fri, 10 Mar 2023 14:37:29 +0100
Message-Id: <20230310133721.217199527@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit eb258cc1fd458e584082be987dbc6ec42668c05e ]

The code to write the syncpoint channel assignment register
incorrectly skips the write if hypervisor registers are not available.

The register, however, is within the guest aperture so remove the
check and assign syncpoints properly even on virtualized systems.

Fixes: c3f52220f276 ("gpu: host1x: Enable Tegra186 syncpoint protection")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/hw/syncpt_hw.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/host1x/hw/syncpt_hw.c b/drivers/gpu/host1x/hw/syncpt_hw.c
index a23bb3352d029..b40a537884dde 100644
--- a/drivers/gpu/host1x/hw/syncpt_hw.c
+++ b/drivers/gpu/host1x/hw/syncpt_hw.c
@@ -113,9 +113,6 @@ static void syncpt_assign_to_channel(struct host1x_syncpt *sp,
 #if HOST1X_HW >= 6
 	struct host1x *host = sp->host;
 
-	if (!host->hv_regs)
-		return;
-
 	host1x_sync_writel(host,
 			   HOST1X_SYNC_SYNCPT_CH_APP_CH(ch ? ch->id : 0xff),
 			   HOST1X_SYNC_SYNCPT_CH_APP(sp->id));
-- 
2.39.2



