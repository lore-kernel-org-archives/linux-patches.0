Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F6F3B42CE;
	Tue, 21 Jul 2026 20:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665852; cv=none; b=VVUnVmSFVp/cY45xx6BjbgReGSP2cW2lVOnwnFYeRStg6TOtCkSQT/QGquGRpuFNfznzCAjqJrhy6cczOlf+W3Gbn4OaT6yj8ixry2CgM2LzRKrThlcgcExWe0TleUIA6fLcFvOXO3NlYrNB91fbdC+wSgxPTu8wvxuTsFQ6u08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665852; c=relaxed/simple;
	bh=pDqWPavMvGuoN5U8DzdPgq+J4e06zvtF+znj1l5G0Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hB6wuamEyIjIw/nbiXbw1EirDCjcgB/rvLQ4mYWXYo/Kp9Ra6JklMgJaw+cSLTSLmFE8omcEy9tra4Cc8Za4/lQcmsAYFgJq1rdofMuLh2VogzK+Dk9rbaUkrwitISck83syvFJGxOwY4u++Ps4UvXUZlfYinHE6/obo6n1Uu5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4JWN9Y5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4JWN9Y5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978E21F000E9;
	Tue, 21 Jul 2026 20:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665851;
	bh=RfNYOg1oCdTzyVRsvVzTjxzLgMUsg9boLpplh7knCLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q4JWN9Y54iJUDuuIYtyMH2iUivvLP8kyCaqV0MZTzFUM5wLVVwT5jWDBy98kVPBZw
	 BX7HY2zyqMdLx2who0KZVW3dL0lMRXK4IfEGYetuh6wpGSLHILYnRZeXCuQocAJqZg
	 HZgl64cBa2XLQaIohAZntQUHwcdUTeNMkurr73LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	=?UTF-8?q?Sven=20P=C3=BCschel?= <s.pueschel@pengutronix.de>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0417/1266] media: rockchip: rga: fix too small buffer size
Date: Tue, 21 Jul 2026 17:14:14 +0200
Message-ID: <20260721152451.169342038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Püschel <s.pueschel@pengutronix.de>

[ Upstream commit 65017e26c065d1240b0512c15867ef1128034fd8 ]

Fix the command buffer size being only a quarter of the actual size.
The RGA_CMDBUF_SIZE macro was potentially intended to specify the length
of the cmdbuf u32 array pointer. But as it's used to specify the size of
the allocation, which is counted in bytes. Therefore adjust the macro
size to bytes as it better matches the variable name and adjust it's
users accordingly.

As the command buffer is relatively small, it probably didn't caused
an issue due to being smaller than a single page.

Fixes: f7e7b48e6d79 ("[media] rockchip/rga: v4l2 m2m support")
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Sven Püschel <s.pueschel@pengutronix.de>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rga/rga-hw.c | 2 +-
 drivers/media/platform/rockchip/rga/rga-hw.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rockchip/rga/rga-hw.c b/drivers/media/platform/rockchip/rga/rga-hw.c
index aaa96f256356b0..bdfb9bc3eb3f6d 100644
--- a/drivers/media/platform/rockchip/rga/rga-hw.c
+++ b/drivers/media/platform/rockchip/rga/rga-hw.c
@@ -379,7 +379,7 @@ static void rga_cmd_set(struct rga_ctx *ctx)
 {
 	struct rockchip_rga *rga = ctx->rga;
 
-	memset(rga->cmdbuf_virt, 0, RGA_CMDBUF_SIZE * 4);
+	memset(rga->cmdbuf_virt, 0, RGA_CMDBUF_SIZE);
 
 	rga_cmd_set_src_addr(ctx, rga->src_mmu_pages);
 	/*
diff --git a/drivers/media/platform/rockchip/rga/rga-hw.h b/drivers/media/platform/rockchip/rga/rga-hw.h
index e8917e5630a48d..03990fd30f158c 100644
--- a/drivers/media/platform/rockchip/rga/rga-hw.h
+++ b/drivers/media/platform/rockchip/rga/rga-hw.h
@@ -6,7 +6,7 @@
 #ifndef __RGA_HW_H__
 #define __RGA_HW_H__
 
-#define RGA_CMDBUF_SIZE 0x20
+#define RGA_CMDBUF_SIZE 0x80
 
 /* Hardware limits */
 #define MAX_WIDTH 8192
-- 
2.53.0



