Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266D2231842;
	Wed, 20 May 2026 17:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297000; cv=none; b=SlSKlQkwGgXy+hNjAA0Fm+34meMsImzeefZxLmREUXLWOL/lAivoXIdn2Dxnxskza4HmhT/6OFYcducI0DnWmhdf6Dxmd8p/xsFmGi0oKQQrU7GN1cUPtMZJ7YCG12bdSjdOgnMKPLVrO5sisayVD1iZlipQSmJK8SxtSWYfSU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297000; c=relaxed/simple;
	bh=pvWVyCgITwPfq79Df5C4+uAORuaaYOVZGtQeHR1UjTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXETsyK7TBxLjzGWeJtis2xv4+Cso8pTq+xsDSPwitVT1eWAEoxGzbdSPSDZZ+Rne6xGmkv0A3aP1Q2CfKLJgfonG7S715jHckkjTFqvKcK/k0T1p8Y1OdX+S8tu3JIHk2DyAHMTtUSliZQ7LImZXoQdkYxvql51UKPvdgCjlkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RctTBsZs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RctTBsZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4121F000E9;
	Wed, 20 May 2026 17:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296999;
	bh=59wJONalGrw5Cgdka3fLGznEnf4u6MFnNd2f6VXckYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RctTBsZs/tSYZ921cro5RaIoFBn7zsMPEpk3tXGCtK2cx0l+k6oaE0fLAWh1L9v2H
	 kM5i8JWqXy6dUb3AYok/4Xu5aA3MFSuHwVDEy/ioz0UiUph/UpEb9sJutBEAYsYYWm
	 mmgglA11NrD6VXMQDKIw9zWRmtPPg00j3imo2L2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Chegondi <harish.chegondi@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1013/1146] drm/xe/eustall: Fix drm_dev_put called before stream disable in close
Date: Wed, 20 May 2026 18:21:03 +0200
Message-ID: <20260520162211.158048658@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit dc2d9842c67d883d3200ae33b9c3859dd9492408 ]

In xe_eu_stall_stream_close(), drm_dev_put() is called before the
stream is disabled and its resources are freed. If this drops the
last reference, the device structures could be freed while the
subsequent cleanup code still accesses them, leading to a
use-after-free.

Fix this by moving drm_dev_put() after all device accesses are
complete. This matches the ordering in xe_oa_release().

Fixes: 9a0b11d4cf3b ("drm/xe/eustall: Add support to init, enable and disable EU stall sampling")
Cc: Harish Chegondi <harish.chegondi@intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Harish Chegondi <harish.chegondi@intel.com>
Link: https://patch.msgid.link/20260415225428.3399934-1-shuicheng.lin@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 35aff528f7297e949e5e19c9cd7fd748cf1cf21c)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_eu_stall.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_eu_stall.c b/drivers/gpu/drm/xe/xe_eu_stall.c
index 39723928a0199..7da14854f688e 100644
--- a/drivers/gpu/drm/xe/xe_eu_stall.c
+++ b/drivers/gpu/drm/xe/xe_eu_stall.c
@@ -869,14 +869,14 @@ static int xe_eu_stall_stream_close(struct inode *inode, struct file *file)
 	struct xe_eu_stall_data_stream *stream = file->private_data;
 	struct xe_gt *gt = stream->gt;
 
-	drm_dev_put(&gt->tile->xe->drm);
-
 	mutex_lock(&gt->eu_stall->stream_lock);
 	xe_eu_stall_disable_locked(stream);
 	xe_eu_stall_data_buf_destroy(stream);
 	xe_eu_stall_stream_free(stream);
 	mutex_unlock(&gt->eu_stall->stream_lock);
 
+	drm_dev_put(&gt->tile->xe->drm);
+
 	return 0;
 }
 
-- 
2.53.0



