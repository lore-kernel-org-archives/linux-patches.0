Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B671E3C07A;
	Thu, 20 Aug 2026 15:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238652; cv=none; b=PfrE90G6UwbuZluTyYmmgRsosAfa5MLDeCQVaV4H3Yw+dnIWW1axHNizufI2ICCqL02WqsSImnMp8jqdug72bfO3jSoIiBv1fhFi3Wy3lB3087YazB75DI6lbgBsLPriIiY7Oh20Qh5C1tfwbfvzbKBe+V0B6vh4a9Fl8Xwh6p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238652; c=relaxed/simple;
	bh=J+flLuKgwJm6ao60qNtJNYodH9aXi5a0jvaWiSEpAxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VUcbdbg0VrawbFWKwPY0ufuiTCJPm5xs7QUkiGXUzRkkPFSCdQ37JGOLYC1DMbydRdf77qHd4z9b5lgQ8IGvgE4OsEO1McEkvFtHtVm9+KDQgQNYwDkKSad3AuPFy38Z8hR35YEc9zQuH/iNmEl929JgtaNL1u5AvxGoYJS8nVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PAQL6FY4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PAQL6FY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EFC1F000E9;
	Thu, 20 Aug 2026 15:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238651;
	bh=b4LKtKC5+5jdfTmsBWvbSpdlsK+A77rUfjkR6V/Jmwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PAQL6FY4OMJctUgLrndVt7LSI+GBmk9Jr0C6G1Ln+a6fQQ4lrTs93G7BAYXTF9pfu
	 jk9xVFRoYTBTwIg7x+v54kUuNqkerxs3oM7/Pt6K1ZJfMDvjE2f4/FVjVLLoTlpqPk
	 wkT2SaRMhKIkAfompJNoh5i27MiPBweJbF0sB3m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 221/228] drm/xe/oa: Check managed mutex initialization errors
Date: Thu, 20 Aug 2026 16:56:03 +0200
Message-ID: <20260820145251.785410355@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit f110dbbfa2a94c91704bf19806907a98fd73ca14 ]

drmm_mutex_init() can fail while registering its managed cleanup action.
On failure, the reset path destroys the mutex, so continuing OA setup
leaves an unusable lock that later paths may acquire.

Return the error from per-GT OA initialization and abort device-wide OA
initialization if the metrics lock cannot be initialized.

Fixes: a9f905ae7b6f ("drm/xe/oa/uapi: Initialize OA units")
Fixes: cdf02fe1a94a ("drm/xe/oa/uapi: Add/remove OA config perf ops")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Link: https://patch.msgid.link/20260713083053.321091-1-lilinmao@kylinos.cn
(cherry picked from commit 360b293de27bfdd0d07047f8efd5ba8e91fa90b7)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_oa.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index 3ecf4df868eb6..cd23a020be20f 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -2695,9 +2695,7 @@ static int xe_oa_init_gt(struct xe_gt *gt)
 
 	__xe_oa_init_oa_units(gt);
 
-	drmm_mutex_init(&gt_to_xe(gt)->drm, &gt->oa.gt_lock);
-
-	return 0;
+	return drmm_mutex_init(&gt_to_xe(gt)->drm, &gt->oa.gt_lock);
 }
 
 static void xe_oa_print_gt_oa_units(struct xe_gt *gt)
@@ -2837,7 +2835,10 @@ int xe_oa_init(struct xe_device *xe)
 	oa->xe = xe;
 	oa->oa_formats = oa_formats;
 
-	drmm_mutex_init(&oa->xe->drm, &oa->metrics_lock);
+	ret = drmm_mutex_init(&oa->xe->drm, &oa->metrics_lock);
+	if (ret)
+		goto exit;
+
 	idr_init_base(&oa->metrics_idr, 1);
 
 	ret = xe_oa_init_oa_units(oa);
-- 
2.53.0



