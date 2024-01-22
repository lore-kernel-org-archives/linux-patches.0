Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636FA3FFE;
	Tue, 23 Jan 2024 00:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970918; cv=none; b=H1ZM4JpTIBDXBeMFzQolvYCvLXIoRIZrg9PCYOx2hTGSjH9q06866m3XLV0s+sCnvVj+YqI4ne/Dgc3R3XiLNxlTTOBeN5GJDTZaflEQibxSFaLH/iW8s/n256DvZ22VbRN6jWFzFUb8V/Cxsx8lQbk7KbXfrdY//gujFRh9zfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970918; c=relaxed/simple;
	bh=yJkGm2r+MyYFQS9aXZHBjQjAB9LPgfbkPvyQ331LU44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNSBhCRMFFbKMY7VaOFpfI0uSGI3xFs3wj/NfVdRQebX2R3zyoSNXnz9P85p5UO19CwBTJXvA1pplGGxuQrk5GpAnx9Ax1spQvI09v0I5md7Omvrlrh2BvKnnld5RoobWH6MichmBdBRwW+lJ26BFozTUGSMe3lmILJBPMjhWcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rc12XXLl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rc12XXLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F406CC433C7;
	Tue, 23 Jan 2024 00:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970918;
	bh=yJkGm2r+MyYFQS9aXZHBjQjAB9LPgfbkPvyQ331LU44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rc12XXLlPcX0egao1eqgTDgy+jIKkfUhpGMWeKCBe3q8PGHBq9MMlhEzMhE+KZrVV
	 sUcFGZ6ZDNEmZG9kaSmCq0PBKQmTPvJx2ZCBEQovvsFgbCQSuYM377iZIiUj1H+7S1
	 ixW5RAwz+kZaSkCHarv7hP3e8ZBovmvTOL+QyJao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4fad2e57beb6397ab2fc@syzkaller.appspotmail.com,
	Ziqi Zhao <astrajoan@yahoo.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/286] drm/crtc: Fix uninit-value bug in drm_mode_setcrtc
Date: Mon, 22 Jan 2024 15:55:29 -0800
Message-ID: <20240122235732.918144736@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index aecdd7ea26dc..b3c0a9ea8c6f 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -562,8 +562,7 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 	struct drm_mode_set set;
 	uint32_t __user *set_connectors_ptr;
 	struct drm_modeset_acquire_ctx ctx;
-	int ret;
-	int i;
+	int ret, i, num_connectors;
 
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EOPNOTSUPP;
@@ -701,6 +700,7 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 			goto out;
 		}
 
+		num_connectors = 0;
 		for (i = 0; i < crtc_req->count_connectors; i++) {
 			connector_set[i] = NULL;
 			set_connectors_ptr = (uint32_t __user *)(unsigned long)crtc_req->set_connectors_ptr;
@@ -721,6 +721,7 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 					connector->name);
 
 			connector_set[i] = connector;
+			num_connectors++;
 		}
 	}
 
@@ -729,7 +730,7 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 	set.y = crtc_req->y;
 	set.mode = mode;
 	set.connectors = connector_set;
-	set.num_connectors = crtc_req->count_connectors;
+	set.num_connectors = num_connectors;
 	set.fb = fb;
 
 	if (drm_drv_uses_atomic_modeset(dev))
@@ -742,7 +743,7 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 		drm_framebuffer_put(fb);
 
 	if (connector_set) {
-		for (i = 0; i < crtc_req->count_connectors; i++) {
+		for (i = 0; i < num_connectors; i++) {
 			if (connector_set[i])
 				drm_connector_put(connector_set[i]);
 		}
-- 
2.43.0



