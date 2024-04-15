Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D40A78C74;
	Mon, 15 Apr 2024 14:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192134; cv=none; b=N/e1wcrWcCeWMDw1h3szCgd1olRl4MBwTJnIc1148y7u7hyld5SeWDXsy+eNLFNCDazhUeN8khud1ez3k3u9aKQIEUw5R4ZkV/k6SMyPW0j+hC0vJWkYDTUKFjIn4gzUHspGOyROWkpVjWz4eLmdUgCEupSY473Y4BzNxHSdZhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192134; c=relaxed/simple;
	bh=wqlMZfTwF0e1+/s+EKYgq1CyqhcpOOX1tUWFdpBtfj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cl30nMPxSolwQGmWvhG7egzUER1xCKZl8h//+MJ9bnyATbp6Nfwdz+5fIhCFAAyK/fFAIa9DvpxIfCMBMqUAZloILUUjClavfWtJLUn9cEsVsfcoMLOZyEI16Yeu6pwZcPxIhyLDVSfKPGi4UkZ2ElccPDdvhT1xumFoDvy+ZAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYH1LVdW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYH1LVdW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9B6C4AF11;
	Mon, 15 Apr 2024 14:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192134;
	bh=wqlMZfTwF0e1+/s+EKYgq1CyqhcpOOX1tUWFdpBtfj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mYH1LVdW/z0N0+QGnhkAV40d6avAO5jizA4EaxjqCKXK9owB1PZj99xKRV78e0bmU
	 +MufCmvM5vgpaCo9WoNER2Jf+m05mHr9jcVD8r55Jem1YgjXKB7d9r6TVQbqyuMtFB
	 hMArFyW8IkorwbilkzQAoDp2GMtvo3FcxuBebOMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jammy Huang <jammy_huang@aspeedtech.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>,
	Dave Airlie <airlied@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.1 48/69] drm/ast: Fix soft lockup
Date: Mon, 15 Apr 2024 16:21:19 +0200
Message-ID: <20240415141947.614367351@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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

From: Jammy Huang <jammy_huang@aspeedtech.com>

commit bc004f5038220b1891ef4107134ccae44be55109 upstream.

There is a while-loop in ast_dp_set_on_off() that could lead to
infinite-loop. This is because the register, VGACRI-Dx, checked in
this API is a scratch register actually controlled by a MCU, named
DPMCU, in BMC.

These scratch registers are protected by scu-lock. If suc-lock is not
off, DPMCU can not update these registers and then host will have soft
lockup due to never updated status.

DPMCU is used to control DP and relative registers to handshake with
host's VGA driver. Even the most time-consuming task, DP's link
training, is less than 100ms. 200ms should be enough.

Signed-off-by: Jammy Huang <jammy_huang@aspeedtech.com>
Fixes: 594e9c04b586 ("drm/ast: Create the driver for ASPEED proprietory Display-Port")
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Jocelyn Falempe <jfalempe@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.19+
Link: https://patchwork.freedesktop.org/patch/msgid/20240403090246.1495487-1-jammy_huang@aspeedtech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ast/ast_dp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/ast/ast_dp.c
+++ b/drivers/gpu/drm/ast/ast_dp.c
@@ -190,6 +190,7 @@ void ast_dp_set_on_off(struct drm_device
 {
 	struct ast_private *ast = to_ast_private(dev);
 	u8 video_on_off = on;
+	u32 i = 0;
 
 	// Video On/Off
 	ast_set_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xE3, (u8) ~AST_DP_VIDEO_ENABLE, on);
@@ -202,6 +203,8 @@ void ast_dp_set_on_off(struct drm_device
 						ASTDP_MIRROR_VIDEO_ENABLE) != video_on_off) {
 			// wait 1 ms
 			mdelay(1);
+			if (++i > 200)
+				break;
 		}
 	}
 }


