Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8A6824BB;
	Mon, 15 Apr 2024 14:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191392; cv=none; b=lfJsBHSKoTbc9tNbzfOvyXIsKgYL6cS3NXh1h4rJKqcSx4pRlyghAVGIyukQ62OBNkQskumfzFBZGLPNZmLTeRBlaV3CDMwY63AjwtQnH9+UXmfWp0hfjdAyKXx9wlyG0zzeroXmLVKKnK5LeL6VY9LUan7PrPM8URLrG454O7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191392; c=relaxed/simple;
	bh=2y57751c4o3ZPEuM3UTKDpX3if7IvhZqT6qdXJaUh9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqOJhYOv5kYi156kReCaGT0RSbdcy+kaiPwHkcyy2l8VCs4wRXq1w9YdryRj0WxRGzTGU5HoPCYkZipSPT5J4C6PD+27eGfQjAQiWbKVGt8Gshhp2fUHGZhWxxDftTCGXoVKu2q59pjt/gnN1ZPRSM7EYQeqZrV+WQgjfxm9MWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mi56qNye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mi56qNye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41DC5C113CC;
	Mon, 15 Apr 2024 14:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191392;
	bh=2y57751c4o3ZPEuM3UTKDpX3if7IvhZqT6qdXJaUh9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mi56qNyeaS5XIVE5UoVGbVwo9aCnxO6LIxgd0sOuHo7K3L8ePof9QZMdn8QPtReGg
	 dO/4D1dXY8wohWzcTqTjfkvXZdM18m28Ft5QYahM8YlWpfruFpFhfuZsbh0gMagkST
	 7MxNs+wMgwuwvpVFyG9IC6otfi1zl7TGo2gp1EtU=
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
Subject: [PATCH 6.8 126/172] drm/ast: Fix soft lockup
Date: Mon, 15 Apr 2024 16:20:25 +0200
Message-ID: <20240415142004.213204201@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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
@@ -180,6 +180,7 @@ void ast_dp_set_on_off(struct drm_device
 {
 	struct ast_device *ast = to_ast_device(dev);
 	u8 video_on_off = on;
+	u32 i = 0;
 
 	// Video On/Off
 	ast_set_index_reg_mask(ast, AST_IO_VGACRI, 0xE3, (u8) ~AST_DP_VIDEO_ENABLE, on);
@@ -192,6 +193,8 @@ void ast_dp_set_on_off(struct drm_device
 						ASTDP_MIRROR_VIDEO_ENABLE) != video_on_off) {
 			// wait 1 ms
 			mdelay(1);
+			if (++i > 200)
+				break;
 		}
 	}
 }


