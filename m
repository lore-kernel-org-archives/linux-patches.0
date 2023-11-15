Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730B1364AB
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFfVXiFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2168BC433C8;
	Wed, 15 Nov 2023 20:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078422;
	bh=oZhXiH29TNDB15V3GyVywwt66wovK4u2RfJixqA9Agc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JFfVXiFlCB7CikOdZNH7LvrhZySCSayjxgN0z/Nn4GsGhYt+ukOzszdZgkGXfG+RM
	 7renHbpMPkYWp2HpyPNGiJGS1nabdcBPX7IpgJDQybdNl8WaWMDhFp6XFdGhq2fW38
	 PgAzAWEWlcjSbxRZdLg+WN16w9NECWelCVgL0XUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Adam Ford <aford173@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 314/379] media: hantro: Check whether reset op is defined before use
Date: Wed, 15 Nov 2023 14:26:29 -0500
Message-ID: <20231115192703.725871450@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 88d4b23a629ebd34f682f770cb6c2116c851f7b8 ]

The i.MX8MM/N/P does not define the .reset op since reset of the VPU is
done by genpd. Check whether the .reset op is defined before calling it
to avoid NULL pointer dereference.

Note that the Fixes tag is set to the commit which removed the reset op
from i.MX8M Hantro G2 implementation, this is because before this commit
all the implementations did define the .reset op.

Fixes: 6971efb70ac3 ("media: hantro: Allow i.MX8MQ G1 and G2 to run independently")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Tested-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/verisilicon/hantro_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/verisilicon/hantro_drv.c b/drivers/media/platform/verisilicon/hantro_drv.c
index 8cb4a68c9119e..08840ba313e7a 100644
--- a/drivers/media/platform/verisilicon/hantro_drv.c
+++ b/drivers/media/platform/verisilicon/hantro_drv.c
@@ -125,7 +125,8 @@ void hantro_watchdog(struct work_struct *work)
 	ctx = v4l2_m2m_get_curr_priv(vpu->m2m_dev);
 	if (ctx) {
 		vpu_err("frame processing timed out!\n");
-		ctx->codec_ops->reset(ctx);
+		if (ctx->codec_ops->reset)
+			ctx->codec_ops->reset(ctx);
 		hantro_job_finish(vpu, ctx, VB2_BUF_STATE_ERROR);
 	}
 }
-- 
2.42.0



