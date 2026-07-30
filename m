Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E317436BF8;
	Thu, 30 Jul 2026 16:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427642; cv=none; b=d2ytQAVFvq3V2xQpr+j4pOmUfSI7N5n0ph5m1jnCABaL1XB4SONzE1cYCc8dDoVVmw881YOGlRdA7NseOx8Mnm2GDTVQZV1f5mbUdf5tuqpXNm3Vv24ietIWtBeH4Tg8KbItyoOUwXtEiELaM/QpML7w+o4yJC2ZR1skAesmrA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427642; c=relaxed/simple;
	bh=AeE3BpSKzS1li4TZT+bUfqBiUzln6Un1p5efDwmhnXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBGcrDkkbXuP4DkbL7m0vbFNtmeyiOwJi/joe6+yKkez2D54SthMKT1plXSmaQnJkJF/sq05UduVXgFTMD+V2d56vB9k/tjMarB+/bfjt2TdH6VaNiXZ5pXlAptH9cBAiWrH9S/u/HEAQCPKRtZ1ju5x7ENwiRdRiepwG/+lwlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQONg7dC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQONg7dC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F5A1F00A3E;
	Thu, 30 Jul 2026 16:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427641;
	bh=lL+wohK9mzUoR4HLtDl7av6G626OU6in89Fe+Luc0kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EQONg7dCtNjsdpHGhsXrY/OhSmANrgxXtUoJalOIyCxc4FlPqGWx4Yc/fxbhib5Tq
	 D4W0G0VFZvQJ1G+TDkQLHPQGW0aG5WwpMfYuLC49pPRLuO438ItYWjDNhaoHFYvx1y
	 9nnIvLyQDH9hfuj9VWOulu+YUC2LK7Ty/vU+sXt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Moon <linux.amoon@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 243/484] media: meson: vdec: Fix memory leak in error path of vdec_open
Date: Thu, 30 Jul 2026 16:12:20 +0200
Message-ID: <20260730141428.762848147@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


