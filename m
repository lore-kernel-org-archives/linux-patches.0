Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A131E0DD8;
	Wed, 30 Sep 2026 16:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787512; cv=none; b=uBKNDY1G093xMufEcfc6JnJttlxFvnXOPbg7EWS9gjgpKz5iFlM/BZrFHFTUFpL2K+9YLMNoiBtyaPzIVKNXF1Zr4xoLXE9meDZclC3d2/DlzoJUH5MMKb05hEjcM+ewv195x/0ZcbaWlyCkXLfzSQF0Uzi2DiRHW4o/OPRRPLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787512; c=relaxed/simple;
	bh=nyxu1owk/zVvRpLlwMMlJ4YdIxU7LJn+sgrU1Jqs6HM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFfdArTQCsUxGFbyeQiYOxTIDC8Tfe0Xyx0CXMNZoglTclDeXnTvSwBLnhN84RgV9vL+y22PJNkymQmKWovxwjFlhNxJPpVxYmnCZ3BynNAIS+9OkdXn6iKB9NyTvhKdWDi20kjTJtg0lzWy+4QdlsY5XuhLVCPfB1N7cT0Ovjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jgtRgYYo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jgtRgYYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972EF1F000FF;
	Wed, 30 Sep 2026 16:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787511;
	bh=0UqyExBMVuAlIr6o5f4Mwhl/YbowiNClJj4cXq/QpKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jgtRgYYooa5ue6jJplspKiSC8XhX7YJn7pY/I6Ip7+AnbQNT3RtWSRZK+pSbN9JXn
	 DsVrzahzYSo0zsqkHzG+zQRCE1DOlTJo0H55A7pXGeMj4g3MnV9QtrRpwRSp8I8Olk
	 EsLkIASqOHCoINBSzb1b94apf33wJVjBboQ4IoZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Alessio Belle <alessio.belle@imgtec.com>,
	Brajesh Gupta <brajesh.gupta@imgtec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 201/457] drm/imagination: clamp freelist reconstruction requests
Date: Wed, 30 Sep 2026 17:25:06 +0200
Message-ID: <20260930152350.394427967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 45585c3aa285854face65293acc95eff73063d6d ]

The firmware reconstruction count controls accesses to the request's
fixed freelist ID array and the copy into the fixed response array.
Neither access currently bounds the count to those protocol arrays.

Clamp the count to the request capacity, which is shared by the response
layout, and use that count consistently for reconstruction and response
publication. Keep the firmware recovery exchange instead of dropping an
oversized request without a response, as discussed with the firmware
maintainer.

The issue was found by our static-analysis tool.

Fixes: 6eedddab733b ("drm/imagination: Implement free list and HWRT create and destroy ioctls")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Reviewed-by: Alessio Belle <alessio.belle@imgtec.com>
Link: https://patch.msgid.link/20260920034329.16614-1-hppiscas@163.com
Signed-off-by: Brajesh Gupta <brajesh.gupta@imgtec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imagination/pvr_free_list.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/imagination/pvr_free_list.c b/drivers/gpu/drm/imagination/pvr_free_list.c
index e85cac83834c6..faf5e586d8dc1 100644
--- a/drivers/gpu/drm/imagination/pvr_free_list.c
+++ b/drivers/gpu/drm/imagination/pvr_free_list.c
@@ -8,6 +8,7 @@
 #include "pvr_vm.h"
 
 #include <drm/drm_gem.h>
+#include <drm/drm_print.h>
 #include <linux/slab.h>
 #include <linux/xarray.h>
 #include <uapi/drm/pvr_drm.h>
@@ -612,13 +613,21 @@ pvr_free_list_process_reconstruct_req(struct pvr_device *pvr_dev,
 	};
 	struct rogue_fwif_freelists_reconstruction_data *resp =
 		&resp_cmd.cmd_data.free_lists_reconstruction_data;
+	u32 count = min_t(u32, req->freelist_count,
+			  ARRAY_SIZE(req->freelist_ids));
 
-	for (u32 i = 0; i < req->freelist_count; i++)
+	if (count != req->freelist_count) {
+		drm_warn_once(from_pvr_device(pvr_dev),
+			      "Requested reconstruction of %u freelists, limiting to %u\n",
+			      req->freelist_count, count);
+	}
+
+	for (u32 i = 0; i < count; i++)
 		pvr_free_list_reconstruct(pvr_dev, req->freelist_ids[i]);
 
-	resp->freelist_count = req->freelist_count;
+	resp->freelist_count = count;
 	memcpy(resp->freelist_ids, req->freelist_ids,
-	       req->freelist_count * sizeof(resp->freelist_ids[0]));
+	       count * sizeof(resp->freelist_ids[0]));
 
 	WARN_ON(pvr_kccb_send_cmd(pvr_dev, &resp_cmd, NULL));
 }
-- 
2.53.0



