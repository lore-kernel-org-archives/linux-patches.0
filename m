Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D401B96D;
	Thu, 18 Jan 2024 10:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575274; cv=none; b=U3PYWV2uxVVO4qkrAh/h/2A8O0SF25+wnPKfjTlCE2SsB9JlQELpszFSCIbi7rPd43afADJMI44WkYJkVbgw9vrtsud8h0LkI6SDpvCt9gMlBGAkMAEHbStANjC8DN6XCSkC87PBE5yvwgSQ+aNw9/g+oTgJ0SzVaTZsBvsYzag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575274; c=relaxed/simple;
	bh=tM91ooD4zYKYHM0HXIi2yJ5Cdvp2a5wyeYt/Ozdl6Ao=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=bmwC95vcxl5R9epe4ByyNAuar+071pSZAbesCRmkoCFN0O8HtP64/6ZW0skFOesu2obUmwyozODOi4Zvvs9VWm7Y690emLCJX4xx9gzoh03cduw0btUD1CNWxbHP/gSx4g3LLzNc9Plv0zyi+Fm/q6iecGIVpx/sAUEgHhyRT3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GanocvJh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GanocvJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778F7C43390;
	Thu, 18 Jan 2024 10:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575273;
	bh=tM91ooD4zYKYHM0HXIi2yJ5Cdvp2a5wyeYt/Ozdl6Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GanocvJhaF9x1eF/AMy3i5HktB0YWyrNrruSfc1hdehL1Re6me6O8eY4jQR0aIHqs
	 7hRofpfwWLWJ3t03U4HgbqUX2U2dY0yhLOb4mrGtyF2ZrfCer1CYrui3xzkiBRpKuK
	 SSRw9VZcfcoWNDK62GsGk1Bz95j/V60DTsqNkmqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4fad2e57beb6397ab2fc@syzkaller.appspotmail.com,
	Ziqi Zhao <astrajoan@yahoo.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/150] drm/crtc: Fix uninit-value bug in drm_mode_setcrtc
Date: Thu, 18 Jan 2024 11:48:16 +0100
Message-ID: <20240118104323.409472885@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Ziqi Zhao <astrajoan@yahoo.com>

[ Upstream commit 3823119b9c2b5f9e9b760336f75bc989b805cde6 ]

The connector_set contains uninitialized values when allocated with
kmalloc_array. However, in the "out" branch, the logic assumes that any
element in connector_set would be equal to NULL if failed to
initialize, which causes the bug reported by Syzbot. The fix is to use
an extra variable to keep track of how many connectors are initialized
indeed, and use that variable to decrease any refcounts in the "out"
branch.

Reported-by: syzbot+4fad2e57beb6397ab2fc@syzkaller.appspotmail.com
Signed-off-by: Ziqi Zhao <astrajoan@yahoo.com>
Reported-and-tested-by: syzbot+4fad2e57beb6397ab2fc@syzkaller.appspotmail.com
Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Link: https://lore.kernel.org/r/20230721161446.8602-1-astrajoan@yahoo.com
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_crtc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index df9bf3c9206e..d718c17ab1e9 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -715,8 +715,7 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 	struct drm_mode_set set;
 	uint32_t __user *set_connectors_ptr;
 	struct drm_modeset_acquire_ctx ctx;
-	int ret;
-	int i;
+	int ret, i, num_connectors;
 
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EOPNOTSUPP;
@@ -851,6 +850,7 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 			goto out;
 		}
 
+		num_connectors = 0;
 		for (i = 0; i < crtc_req->count_connectors; i++) {
 			connector_set[i] = NULL;
 			set_connectors_ptr = (uint32_t __user *)(unsigned long)crtc_req->set_connectors_ptr;
@@ -871,6 +871,7 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 					connector->name);
 
 			connector_set[i] = connector;
+			num_connectors++;
 		}
 	}
 
@@ -879,7 +880,7 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 	set.y = crtc_req->y;
 	set.mode = mode;
 	set.connectors = connector_set;
-	set.num_connectors = crtc_req->count_connectors;
+	set.num_connectors = num_connectors;
 	set.fb = fb;
 
 	if (drm_drv_uses_atomic_modeset(dev))
@@ -892,7 +893,7 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 		drm_framebuffer_put(fb);
 
 	if (connector_set) {
-		for (i = 0; i < crtc_req->count_connectors; i++) {
+		for (i = 0; i < num_connectors; i++) {
 			if (connector_set[i])
 				drm_connector_put(connector_set[i]);
 		}
-- 
2.43.0



