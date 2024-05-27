Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6134817727;
	Mon, 27 May 2024 19:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838377; cv=none; b=jTXkGeONNrrwlPll8Y2o2yt5jqLwySXT5GMXhVq+T1100IdhcOpFC7vFF13bLW2JWyLgMHiDpP4ME/PxFRCze9+cBXBRMSwS1a33TFP2qHa5QJIDJqDIXHDx5LsXeFO4cCcymu/vqGXV3bd5oOWIoMaY4nsdpexDXDF6dB574VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838377; c=relaxed/simple;
	bh=IriL+G8v5q+V3PPlU7DXMlnTmXTO+cIUMR5SojgGeF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zg/vUCzqsnzrlovHG3Mk9a63THrTthxMHkbz8iR0Xe0joMtJrHlZkSsZJ6y+zhsDWqh+dJ+uVNwV2u0h58NM8Oc13b3OgXvWL+3NZV3lxjvoQvsHbDy5OKfpHoUhEziG3KKCPmOpaJcMbY7mDRZPfYMjbWPsY6daX4AAbnaxlNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RDP6M/68; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RDP6M/68"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD13C2BBFC;
	Mon, 27 May 2024 19:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838377;
	bh=IriL+G8v5q+V3PPlU7DXMlnTmXTO+cIUMR5SojgGeF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RDP6M/68FjBDu09RXCYr6G1QW0ZkZqX2Uk1WNpByk8t9+mLNSe97kmkYbLOS1dlyC
	 60Hz0z9xaFEey3/F/UujthEb3Z4VTwS1136BJzGFMGVUcc78H5lJllSAbavQ1pzL/8
	 APduLHEkUQ2nlb8u5OsGqjEGC5mv2pi/trO8zoYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 352/493] drm/nouveau/dp: Fix incorrect return code in r535_dp_aux_xfer()
Date: Mon, 27 May 2024 20:55:54 +0200
Message-ID: <20240527185641.804634504@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lyude Paul <lyude@redhat.com>

[ Upstream commit 97252d0a4bfbb07079503d059f7522d305fe0f7a ]

I've recently been seeing some unexplained GSP errors on my RTX 6000 from
failed aux transactions:

  [  132.915867] nouveau 0000:1f:00.0: gsp: cli:0xc1d00002 obj:0x00730000
  ctrl cmd:0x00731341 failed: 0x0000ffff

While the cause of these is not yet clear, these messages made me notice
that the aux transactions causing these transactions were succeeding - not
failing. As it turns out, this is because we're currently not returning the
correct variable when r535_dp_aux_xfer() hits an error - causing us to
never propagate GSP errors for failed aux transactions to userspace.

So, let's fix that.

Fixes: 4ae3a20102b2 ("nouveau/gsp: don't free ctrl messages on errors")
Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240315212104.776936-1-lyude@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/disp/r535.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/r535.c b/drivers/gpu/drm/nouveau/nvkm/engine/disp/r535.c
index 6a0a4d3b8902d..027867c2a8c5b 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/r535.c
@@ -1080,7 +1080,7 @@ r535_dp_aux_xfer(struct nvkm_outp *outp, u8 type, u32 addr, u8 *data, u8 *psize)
 	ret = nvkm_gsp_rm_ctrl_push(&disp->rm.objcom, &ctrl, sizeof(*ctrl));
 	if (ret) {
 		nvkm_gsp_rm_ctrl_done(&disp->rm.objcom, ctrl);
-		return PTR_ERR(ctrl);
+		return ret;
 	}
 
 	memcpy(data, ctrl->data, size);
-- 
2.43.0



