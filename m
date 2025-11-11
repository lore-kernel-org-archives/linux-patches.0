Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D44344022;
	Tue, 11 Nov 2025 01:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823574; cv=none; b=IbVWnUr9cmuIAA58lNcnoA+EpdQ0vFVAwS6X/toLQx7pGyc80yBt1q+SXz0KuELWQ9F1voJzE38kjAZ8PdwUxLbnjzKSkgxklyAsw8AUHvm6kdOZCc2JU4FYlOqui0/HALGdpzkSRO2sE9rdZxpoRlnULlQfMrcXhHTQOlDODbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823574; c=relaxed/simple;
	bh=yyCAhvgK0kJMA1ire3/cY22q4w/yHkN6Cdy5N4mi/QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+IDnMQFlrcwenquZKtxkv/31WSkiikJRkG5JFDhUCByNBcZeEHgA27ihNxb/mpZ74FdB75zPeZCl76blEFnk2E8YmvLLPsAO+mGgGb+5Va8w/QpPtSVzHDZW3b/iaG9PegKkEN82deB6xatli6OKT56zAsr+UMYUiNzKQgEdWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cs5yWDlO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cs5yWDlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AB9C4CEFB;
	Tue, 11 Nov 2025 01:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823574;
	bh=yyCAhvgK0kJMA1ire3/cY22q4w/yHkN6Cdy5N4mi/QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cs5yWDlOwQuY1xlCtf+0esXgyjVLJJDxwBItdz8SQTi30jFhO1iWxylfWt99eExQJ
	 tuy+iPBUNSrwnwVVpjL4ba3ToPsGaCISSYOKFrhMu5G+v8c0M5H9ZMV+fyHHiVOy2s
	 hzFAeLmAjD28qTMX8rJpxtyParRJ/bPqt4NideGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Richter <Simon.Richter@hogyros.de>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 326/849] drm/xe: Make page size consistent in loop
Date: Tue, 11 Nov 2025 09:38:16 +0900
Message-ID: <20251111004544.298095576@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Richter <Simon.Richter@hogyros.de>

[ Upstream commit b85bb2d677153d990924d31be9416166d22382eb ]

If PAGE_SIZE != XE_PAGE_SIZE (which is currently locked behind
CONFIG_BROKEN), this would generate the wrong number of PDEs.

Since these PDEs are consumed by the GPU, the GPU page size needs to be
used.

Signed-off-by: Simon Richter <Simon.Richter@hogyros.de>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://lore.kernel.org/r/20250818064806.2835-1-Simon.Richter@hogyros.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_migrate.c b/drivers/gpu/drm/xe/xe_migrate.c
index 9b1e3dce1aea3..2a627ed64b8f8 100644
--- a/drivers/gpu/drm/xe/xe_migrate.c
+++ b/drivers/gpu/drm/xe/xe_migrate.c
@@ -291,7 +291,7 @@ static int xe_migrate_prepare_vm(struct xe_tile *tile, struct xe_migrate *m,
 	}
 
 	/* Write PDE's that point to our BO. */
-	for (i = 0; i < map_ofs / PAGE_SIZE; i++) {
+	for (i = 0; i < map_ofs / XE_PAGE_SIZE; i++) {
 		entry = vm->pt_ops->pde_encode_bo(bo, (u64)i * XE_PAGE_SIZE);
 
 		xe_map_wr(xe, &bo->vmap, map_ofs + XE_PAGE_SIZE +
-- 
2.51.0



