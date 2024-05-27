Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EA317E90E;
	Mon, 27 May 2024 19:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837124; cv=none; b=lj2WL6wLZ+U7vqRCrq6XVPgyVqcJagbmDX+ZYSRapl6ee+KPcNsYf5MhtOn6pPxsb/H9PgnLBx0Zb0u/GuT1VbNgnSRRDlBVsmy2jptF5dCNAIFYBW7c5py2VfLm/hCh6aZ37hDySbqNTQZgc0re0XWLBzEIz8W+zKLVfwOyq8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837124; c=relaxed/simple;
	bh=o9nx1tzujl53h542GoVMld2G3uY6zHskK7ZowzKwK/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFQ3T8LVxdMKHfNNTZvpdVu4iD33WYeYHDogA7nZZEQO7bIDpnmBAGgtI8UVqb5OA7otZArs/dcWMLLjfWXWLh0bAQc0KuTL/CH9JRGv/Y3QPMfzU5LR5cE7qWyqRYCAZV3nRa7aJdF0J/kLtF+1JbEUPIqPaeHB7QGBEiOqfkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6TdRrdK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6TdRrdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24C4C2BBFC;
	Mon, 27 May 2024 19:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837124;
	bh=o9nx1tzujl53h542GoVMld2G3uY6zHskK7ZowzKwK/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6TdRrdKLVXD9Kiw5PDPuYOYz6HOLD8OAhD5OqMo6POKoMnL9SPXLYgE5khBALpHu
	 yxzlhzNmm3ac5au2NAhSSFQ7sGrLxnCgklnqR65JIHAWe8dj6vH9BsYvg/X2oXUXw1
	 YDwC25gWYsdSb0oT8Ra3p+MMSdqfYZldGF4bUgK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 277/427] drm/nouveau/dp: Fix incorrect return code in r535_dp_aux_xfer()
Date: Mon, 27 May 2024 20:55:24 +0200
Message-ID: <20240527185628.395522847@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



