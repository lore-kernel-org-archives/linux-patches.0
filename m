Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D957440A13;
	Mon, 17 Aug 2026 15:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979468; cv=none; b=cAidDxXpxtfnRbdRoogpoOj3FVwyE8h/OonPTe5g2pHLmLCfVg+T+ReHXa8twLH6lCRivi3qYJSBvfmcOtH9WzUHxKA7ynd/Tljq6cH5mNibHNWVag1i+oAO+Ynfu+kpwf5qUujm8FsU83oX9meRKlnIQlF2aR9ZHra+IHaYv7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979468; c=relaxed/simple;
	bh=QuDbqg6ULuWI9z5J9ryoOp+g4Izfen0qcEPvkaXh92A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxaAYcxLSNFBCrpdzGBt+O2U2XkrM9oQFNY9dktrt1F0KE7hWu0nyL9Qb+FnLwdGMdwt+FM5blfchZf3kCVV0FX014WdDj2y6XEoq3LstaUvXO2vq9DINNrxkWNrh+MnkjZxfltxBwDNAuiVM5v3+l3dGhG0O22qP52/Kjhw41w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/uZSGqG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/uZSGqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3693A1F000E9;
	Mon, 17 Aug 2026 15:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979466;
	bh=kkBBfShp44DZ4O27WU7xjxxi4kiVovCidOZIQt82E3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c/uZSGqGoXBks5ACY+ObKPKlgHcY5ToZKpIRLt8TzeHuU1zPDN124sLuSsGiod/YW
	 faToQ/5TM85NJE/rG0ChNKFzFL1aa1yzU8RH6nacxN3jqdNJonenZZ5aaql+4oaL7k
	 FIs3yV7vJEOUQH6lNVSAXogIocUhAGcrpgO1ZZIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Moon <linux.amoon@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 197/609] media: meson: vdec: Fix memory leak in error path of vdec_open
Date: Mon, 17 Aug 2026 15:28:13 +0200
Message-ID: <20260817132550.691809309@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Anand Moon <linux.amoon@gmail.com>

commit 940f161f734b25f175a95d2684c2021f6323693a upstream.

The vdec_open() function previously jumped directly to
err_m2m_release when vdec_init_ctrls() failed, skipping
release of the m2m context. This caused a resource leak.

Fix it by introducing a proper err_m2m_ctx_release label
that calls v4l2_m2m_ctx_release(sess->m2m_ctx) before
releasing the m2m device.

This was identified via kmemleak:
unreferenced object 0xffff0000205d6878 (size 8):
  comm "v4l_id", pid 5289, jiffies 4294938580
  hex dump (first 8 bytes):
    40 d2 49 18 00 00 ff ff                          @.I.....
  backtrace (crc d3204599):
    kmemleak_alloc+0xc8/0xf0
    __kvmalloc_node_noprof+0x60c/0x850
    v4l2_ctrl_handler_init_class+0x1b4/0x2e8 [videodev]
    vdec_open+0x1f4/0x788 [meson_vdec]
    v4l2_open+0x144/0x460 [videodev]
    chrdev_open+0x1ac/0x500
    do_dentry_open+0x3f0/0xfe8
    vfs_open+0x68/0x320
    do_open+0x2d8/0x9a8
    path_openat+0x1d0/0x4f0
    do_filp_open+0x190/0x380
    do_sys_openat2+0xf8/0x1b0
    __arm64_sys_openat+0x13c/0x1e8
    invoke_syscall+0xdc/0x268
    el0_svc_common.constprop.0+0x178/0x258
    do_el0_svc+0x4c/0x70

Fixes: 3e7f51bd9607 ("media: meson: add v4l2 m2m video decoder driver")
Cc: stable@vger.kernel.org
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/meson/vdec/vdec.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/staging/media/meson/vdec/vdec.c
+++ b/drivers/staging/media/meson/vdec/vdec.c
@@ -897,7 +897,7 @@ static int vdec_open(struct file *file)
 
 	ret = vdec_init_ctrls(sess);
 	if (ret)
-		goto err_m2m_release;
+		goto err_m2m_ctx_release;
 
 	sess->pixfmt_cap = formats[0].pixfmts_cap[0];
 	sess->fmt_out = &formats[0];
@@ -922,6 +922,8 @@ static int vdec_open(struct file *file)
 
 	return 0;
 
+err_m2m_ctx_release:
+	v4l2_m2m_ctx_release(sess->m2m_ctx);
 err_m2m_release:
 	v4l2_m2m_release(sess->m2m_dev);
 err_free_sess:


