Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326725FEFA;
	Tue, 13 Feb 2024 17:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845387; cv=none; b=eXPpzO/1qLGNi+KeN81XL/jYZtrPAwIUiz6valpZTpgT5hZCmsD4MhGIrrREUWkauje8J5Ck1NVbuvUTUFkCKT78wOFn4EESDNcO0ltk1Ywak2kkvLMjwca41H94YQ26DDkh4xIMM3vnkmKaSyVtmpzLJbaVSGffsSwpD2BznxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845387; c=relaxed/simple;
	bh=vaS8YpPlZYytTbVFKFSsZNEnBTAzyernxAfaRyvEOyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kk9BYmlk4p1YpBPgNgMaZCFNezeUaimGX3xvNsah1MmTpYRYvZ2/cVjvsryqkBRzVkAfLkG40INnfBN79CH5qllP/a2AmgiAWdxj7XVDlrbsUeBJPU65pgcglEL/2muwkBEqmqUMh9Xa6sx9gENibf5MLg2/7spQiyWOZthHT1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CkPPWHSP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CkPPWHSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6A0C433C7;
	Tue, 13 Feb 2024 17:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845387;
	bh=vaS8YpPlZYytTbVFKFSsZNEnBTAzyernxAfaRyvEOyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CkPPWHSPmJMlq5EEm/Gid4F2Mje35GSc93sUATJH8Ed42byEWQoOBwuKK3CLYE9Gi
	 g5s6xcNXp8tmnDedYwOw+SIeqynkeDcP+M0E+sDPkPpp10tXKlKiuT97asYfoP2y5v
	 +7OrWXW70goi1eBMYUnHkws+qi16k+Oz1MFjj4Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/121] drm/i915/gvt: Fix uninitialized variable in handle_mmio()
Date: Tue, 13 Feb 2024 18:21:13 +0100
Message-ID: <20240213171854.863854078@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 47caa96478b99d6d1199b89467cc3e5a6cc754ee ]

This code prints the wrong variable in the warning message.  It should
print "i" instead of "info->offset".  On the first iteration "info" is
uninitialized leading to a crash and on subsequent iterations it prints
the previous offset instead of the current one.

Fixes: e0f74ed4634d ("i915/gvt: Separate the MMIO tracking table from GVT-g")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/11957c20-b178-4027-9b0a-e32e9591dd7c@moroto.mountain
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gvt/handlers.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/handlers.c b/drivers/gpu/drm/i915/gvt/handlers.c
index a9f7fa9b90bd..d30f8814d9b1 100644
--- a/drivers/gpu/drm/i915/gvt/handlers.c
+++ b/drivers/gpu/drm/i915/gvt/handlers.c
@@ -2850,8 +2850,7 @@ static int handle_mmio(struct intel_gvt_mmio_table_iter *iter, u32 offset,
 	for (i = start; i < end; i += 4) {
 		p = intel_gvt_find_mmio_info(gvt, i);
 		if (p) {
-			WARN(1, "dup mmio definition offset %x\n",
-				info->offset);
+			WARN(1, "dup mmio definition offset %x\n", i);
 
 			/* We return -EEXIST here to make GVT-g load fail.
 			 * So duplicated MMIO can be found as soon as
-- 
2.43.0



