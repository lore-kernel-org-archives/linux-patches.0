Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374192522AC;
	Thu, 17 Apr 2025 18:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914538; cv=none; b=nhyzZOTfkwuMm/akQi1nejaxtrMKQ54nkbS5au6H8bruvNS/F/bid90jDyKYna6VZBIgM9EIXTwsvOKS2sXS+LDx5zmfl2uWHEh4NFjtpffQCzf1NB5WdgnsX/OR1o6I/fBxlszjKRYR5AF6fHxdXPAFTV8/AR2zOUSxt3OGGbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914538; c=relaxed/simple;
	bh=K42SmGnKfqrBVgkAGuK/z4me2Ats2mxO+8UwaLKHum8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SmEbhNnUkxga0EWge97XWEFi5SbdfNPhwkBXqTiapLiefnbc5UJzfqxBN82ivZxDizwXi2mcKDSt24qGy9jVKiZ2atUCANbPXr2wxJtfhqP3JXGizK+f6oy6dKrz6L+Toy41FULpPkKVc99lh0Z29wYs4YBeDgRtsRPavM5gKR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3OCPKSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3OCPKSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B443DC4CEE4;
	Thu, 17 Apr 2025 18:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914538;
	bh=K42SmGnKfqrBVgkAGuK/z4me2Ats2mxO+8UwaLKHum8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l3OCPKSLw9ex5aEnMAvZ/pJvOtTPiT4DKf1ida05erhADii2FmMIfeVhihHWBbDvn
	 VnzTCa2apus4dS5p7AbxavkARjHzh7kN/PnGCMqgeGaBcQ8hOvDt4mq1XVPzNh2H+u
	 v/8sKLZlUSKqRtCEArmWw4ESxs+p0kZcDh/vTFZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Michael Tretter <m.tretter@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 208/414] media: rockchip: rga: fix rga offset lookup
Date: Thu, 17 Apr 2025 19:49:26 +0200
Message-ID: <20250417175119.808382415@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Keeping <jkeeping@inmusicbrands.com>

commit 11de3582675cc0b7136e12f3971f1da3e5a05382 upstream.

The arguments to rga_lookup_draw_pos() are passed in the wrong order,
rotate mode should be before mirror mode.

Fixes: 558c248f930e6 ("media: rockchip: rga: split src and dst buffer setup")
Cc: stable@vger.kernel.org
Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Reviewed-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/rockchip/rga/rga-hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/rockchip/rga/rga-hw.c
+++ b/drivers/media/platform/rockchip/rga/rga-hw.c
@@ -376,7 +376,7 @@ static void rga_cmd_set_dst_info(struct
 	 * Configure the dest framebuffer base address with pixel offset.
 	 */
 	offsets = rga_get_addr_offset(&ctx->out, offset, dst_x, dst_y, dst_w, dst_h);
-	dst_offset = rga_lookup_draw_pos(&offsets, mir_mode, rot_mode);
+	dst_offset = rga_lookup_draw_pos(&offsets, rot_mode, mir_mode);
 
 	dest[(RGA_DST_Y_RGB_BASE_ADDR - RGA_MODE_BASE_REG) >> 2] =
 		dst_offset->y_off;


