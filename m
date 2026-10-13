Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E10F348C4B;
	Tue, 13 Oct 2026 12:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895662; cv=none; b=ksYlbUqkIB1GBBlsjjFTEvUJvCbOEpzaLYTpjabd+3FXe/IbnQWmori31I5uqKp56UWS9UNDVQmpFEOUDYCKrOABkYxRXlBfdmfIuIawnGV3HFr2LapC0yIvJ8qgglUw0ZFu3OS/XL1aRl1a/05Il9Rmp+USfHq3h0MWgrt7qdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895662; c=relaxed/simple;
	bh=Onvs2IuvEzVMPJTKt25igScIxPkUdzgASkqceVz2/70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzfn3fhnPhvMcbvy3u7VN9Awk5aU3I3kZvRQksOQVq1Z2fGONygQvYFjJTim74OxrmMFz3lkw9113GGlqJuEVI7rRd2pkLWIPuzeDOpoNGtgSnNLPefi9CStBGP+jH9iCJDXUPdHHSwhrIWjVpB7ESrSpcffwAu0f2o1ohiARE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulWB9bqY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulWB9bqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BFE1F000FF;
	Tue, 13 Oct 2026 12:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895661;
	bh=5l8ty9h2HGinmIQwvPChIKcYh4qEl0lpNLuV5z2i6FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ulWB9bqY6hVqTSEgXXHOPiFHQFqzfYArH0Zw3+CxgN20IGeiwE6HJmqlQoMCfIFCo
	 2YtGUdTbdHcE0PRMuEK6dTAhKgX+5RTG9za0W/+P6ljWRPDqWNfgNddSu3r5cmeS0t
	 u94ievkIgPrm0UZjHFVWEzLYHuVmpGDfUzfKiHHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liew Rui Yan <aethernet65535@gmail.com>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 349/497] mm/damon/core: fix unconditionally skip last region
Date: Tue, 13 Oct 2026 13:38:36 +0200
Message-ID: <20261013112916.189301261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Liew Rui Yan <aethernet65535@gmail.com>

[ Upstream commit b3723b596b548c837a766aae3553c14a7b15af2b ]

Once quota set, the charge_{target,addr}_from unconditionally skips and
resets at the last region of the tracked target, so the last region can be
skipped even when it has not been processed.

Example:

    1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
    2. Quota is configured to process only 100 bytes per window.
    3. Window 1: Processes R1 (0-100).  Quota is full.  charge_{target,
       addr}_from is saved at (Target, 100).
    4. Window 2: The loop reaches R2.  Because R2 is
       damon_last_region(t), the old code unconditionally returns true,
       skipping R2 entirely and resetting the charge_{target,addr}_from.

    Result: R2 is permanently skipped even though it has never been
    processed.

However, it is important to note that this is a very minor issue.  This is
because it is triggered only when the previous window saved/kept
charge_{target,addr}_from, and in the next window, all regions except the
last region were skipped by damos_skip_charged_region().

Fix this by only resetting the charge_{target,addr}_from when last region
is reached, only skipping when it is applied or cannot split.

Link: https://lore.kernel.org/20260908134739.96919-1-sj@kernel.org
Fixes: 50585192bc2e ("mm/damon/schemes: skip already charged targets and regions")
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org> # v5.16.x
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4c96582d827f8..81d44e41de210 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1323,36 +1323,39 @@ static bool damos_skip_charged_region(struct damon_target *t,
 {
 	struct damos_quota *quota = &s->quota;
 	unsigned long sz_to_skip;
+	bool skip = false;
 
 	/* Skip previously charged regions */
 	if (quota->charge_target_from) {
 		if (t != quota->charge_target_from)
 			return true;
-		if (r == damon_last_region(t)) {
-			quota->charge_target_from = NULL;
-			quota->charge_addr_from = 0;
-			return true;
-		}
 		if (quota->charge_addr_from &&
-				r->ar.end <= quota->charge_addr_from)
-			return true;
+				r->ar.end <= quota->charge_addr_from) {
+			skip = true;
+			goto out;
+		}
 
 		if (quota->charge_addr_from && r->ar.start <
 				quota->charge_addr_from) {
 			sz_to_skip = ALIGN_DOWN(quota->charge_addr_from -
 					r->ar.start, DAMON_MIN_REGION);
 			if (!sz_to_skip) {
-				if (damon_sz_region(r) <= DAMON_MIN_REGION)
-					return true;
+				if (damon_sz_region(r) <= DAMON_MIN_REGION) {
+					skip = true;
+					goto out;
+				}
 				sz_to_skip = DAMON_MIN_REGION;
 			}
 			damon_split_region_at(t, r, sz_to_skip);
-			return true;
+			skip = true;
 		}
+	}
+out:
+	if (r == damon_last_region(t)) {
 		quota->charge_target_from = NULL;
 		quota->charge_addr_from = 0;
 	}
-	return false;
+	return skip;
 }
 
 static void damos_update_stat(struct damos *s,
-- 
2.53.0



