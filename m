Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B54632D420;
	Wed,  3 Dec 2025 16:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780547; cv=none; b=eCmTZIQGM7EK0xku/cc6ZLnFZlUz4YsX1dhLLEEez6D7ljqKZ6HPg36ecz8+jDADxLm6jWg7dNFGEDqk7ivXZNEyK2cuSJHC2xuC9LunVdfroS2yQswsGOSsB+F8RlScEKFJZiA3E6R9aL6nHkFqsIjwd1F33uADBkkZioi/UKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780547; c=relaxed/simple;
	bh=HVEZthPdF2VAEyxkRh5P01znPddS8WWQ1ivb1YQCRWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uX2+V8mLwa+j0PuMlmJZHvABtw4PqinlKKrlGSUuzdSqoyUjdzR90QUwhP2Wyqs00pSdPt+9bJROEd/2HcSFgo9CP7Ixrjob8YROTBBV/5ti6xGN9sVP/SsWvFhg+HGfqoDwDgQ+AtfkQi84oF73fO17TTNVblSTUrAyi+2C6pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GRH7vK0a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GRH7vK0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DABC4CEF5;
	Wed,  3 Dec 2025 16:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780543;
	bh=HVEZthPdF2VAEyxkRh5P01znPddS8WWQ1ivb1YQCRWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GRH7vK0aJuCM0pariVy1wzke8TMgeWZjP2fCakLAoI4eE6tZDrhZHKXDKZ6laZ7En
	 nSxYP+lnGp2UpAxdVA0jEgjGVHPVYJ4smLXnm/pcBQB2VDPeQbvZ9zQIo2W8pcNMZz
	 cvDiRGcJO81zo6qqtxN1MODRT84bi6qPZ0fS5fsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Harish Chegondi <harish.chegondi@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/132] drm/xe: Fix conversion from clock ticks to milliseconds
Date: Wed,  3 Dec 2025 16:28:17 +0100
Message-ID: <20251203152343.972130155@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harish Chegondi <harish.chegondi@intel.com>

[ Upstream commit 7276878b069c57d9a9cca5db01d2f7a427b73456 ]

When tick counts are large and multiplication by MSEC_PER_SEC is larger
than 64 bits, the conversion from clock ticks to milliseconds can go bad.

Use mul_u64_u32_div() instead.

Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Harish Chegondi <harish.chegondi@intel.com>
Suggested-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Fixes: 49cc215aad7f ("drm/xe: Add xe_gt_clock_interval_to_ms helper")
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://patch.msgid.link/1562f1b62d5be3fbaee100f09107f3cc49e40dd1.1763408584.git.harish.chegondi@intel.com
(cherry picked from commit 96b93ac214f9dd66294d975d86c5dee256faef91)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_clock.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_clock.c b/drivers/gpu/drm/xe/xe_gt_clock.c
index 86c2d62b4bdc3..fa66295695c01 100644
--- a/drivers/gpu/drm/xe/xe_gt_clock.c
+++ b/drivers/gpu/drm/xe/xe_gt_clock.c
@@ -82,11 +82,6 @@ int xe_gt_clock_init(struct xe_gt *gt)
 	return 0;
 }
 
-static u64 div_u64_roundup(u64 n, u32 d)
-{
-	return div_u64(n + d - 1, d);
-}
-
 /**
  * xe_gt_clock_interval_to_ms - Convert sampled GT clock ticks to msec
  *
@@ -97,5 +92,5 @@ static u64 div_u64_roundup(u64 n, u32 d)
  */
 u64 xe_gt_clock_interval_to_ms(struct xe_gt *gt, u64 count)
 {
-	return div_u64_roundup(count * MSEC_PER_SEC, gt->info.reference_clock);
+	return mul_u64_u32_div(count, MSEC_PER_SEC, gt->info.reference_clock);
 }
-- 
2.51.0



