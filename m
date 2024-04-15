Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB19A762E0;
	Mon, 15 Apr 2024 14:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191914; cv=none; b=A7JfeuHTCcVhTmZPqvmiLokFA9UmmXLJ7HFbt77gK2/mIObE04euQqzXlJOUa9ivr2NgUXbL0IyXQlLko5L8ZKPPzV9Fk0ruBVzRcos1v+KsN4NRTCGx5tllXOPUGKvNncio79tEQKT4b3AGaoR7bBwC6ZHAnDpK5iaSHRUZNdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191914; c=relaxed/simple;
	bh=I6oJYm0hR08TOpTU4NHwTel8Bht/BaFzQS/ybBX9lRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDLbQg2Mi8e/DNpa8FDRmZEVkEha8e/hqbDZO+wNX5WnUn/qBrbYRQousInRQ6aE8evVNlcbyJ7vA5RuC5T+XZoki8+QbtNckki70hJZ403Bm1Sef6Pq6QRJ9khQfxYDAldB0/HO/Q1j7oHxo+TolfVPIXYGxCu4J7+YSukH2u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EUl1AsO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EUl1AsO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C7EC4AF0A;
	Mon, 15 Apr 2024 14:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191914;
	bh=I6oJYm0hR08TOpTU4NHwTel8Bht/BaFzQS/ybBX9lRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EUl1AsO1iGgmino4k7sNUGnwlakmIyHx5CNi8THdP1rnuUUy1DMrhN4JY2Q61OoN9
	 Vz4sAPknuxZhx2jASkS3qLReAC/ERygjr8iXzwnzWoE7bLrioznVPbBS4L1SKC0v7Q
	 5ITwFY4h5s+dZECM337/ZMewQ+ydyAcTRzYjEfDg=
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
Subject: [PATCH 6.6 091/122] drm/ast: Fix soft lockup
Date: Mon, 15 Apr 2024 16:20:56 +0200
Message-ID: <20240415141956.105593520@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 	ast_set_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xE3, (u8) ~AST_DP_VIDEO_ENABLE, on);
@@ -192,6 +193,8 @@ void ast_dp_set_on_off(struct drm_device
 						ASTDP_MIRROR_VIDEO_ENABLE) != video_on_off) {
 			// wait 1 ms
 			mdelay(1);
+			if (++i > 200)
+				break;
 		}
 	}
 }


