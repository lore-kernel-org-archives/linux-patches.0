Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECBF435536;
	Thu, 30 Jul 2026 15:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425229; cv=none; b=QFPwKqYVmAgW2dPCv/KMvQhEAgxLEW50R4tTkooTXh7ZTK0mCFYcNItpAJjc6Uir/OSQvKjQ7jzRwbcKD1Lf09kgFsRoqwgZXn673IIBESyFWixJB1s1xAj8TXBLBIKbXf10mvth3l91JVZH25fZOamPLeQAZ21h5vobB2G+0/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425229; c=relaxed/simple;
	bh=+7kpYTP31j+lUh6KFTDRAtjA7WmAKIDbGEWMXzQW/oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dd7RusDPxmpzLu/wXgHZ/1XnYsorZW5Om1/BxHKWkyZmjB/s9+W1Wgk2Hu4c2DEGSul6Gyt7JEJyHsUD1p0itAyW2vuaIKchCXhx0hZQs6YhjEvXIpW/uGmBH7WvkFoGq53ZCuEcFR+PMFwWNIP3vNHjtBV0ufcvV2qD71qSxfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOXTk0I3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOXTk0I3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2F91F000E9;
	Thu, 30 Jul 2026 15:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425228;
	bh=0qpj6/RIk9gURuhi1PfpNPEasPhUWluiC1S8i+zBT44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YOXTk0I3j4v4jBRnnxRbYwLuVDdNiiTKSnPfGmZzQu1WoA/6hc4aXgwjKx/T9SkQb
	 VrrYPeNfItmQCGNfc6A0a06Cd7D/EVT2ME9ZcDXCgjA7JMIig9K04zHdns0k6CdJq1
	 Lt8Jv4SH3RdWgp++Ag+IVLrPYzWe6Y9g9/NAHUHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 668/675] mm/damon/core: disallow overlapping input ranges for damon_set_regions()
Date: Thu, 30 Jul 2026 16:16:38 +0200
Message-ID: <20260730141459.357219503@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

commit 954157679ec34661c2e87e7eb796104a797c32db upstream.

damon_set_regions() assumes the input ranges are sorted by the address and
don't overlap each other.  Hence the assumption was initially to be
explicitly validated.  But commit 97d482f4592f ("mm/damon/sysfs: reuse
damon_set_regions() for regions setting") has mistakenly removed the
validation.

This can make DAMON behave in unexpected ways.  At the best, the
monitoring results snapshot will just look weird since there will be
overlapping regions.  DAMOS will also work weirdly, applying the same
action multiple times for overlapping regions, and make DAMOS quota weird.
More seriously, depending on the setup and regions updates sequence,
negative size regions can be made.  It will trigger WARN_ONCE() if the
kernel is built with CONFIG_DAMON_DEBUG_SANITY=y.  Depending on the
monitoring results, the negative size region can further trigger division
by zero in damon_merge_two_regions().

Note that some of the consequences including the WARN_ONCE() and the
divide by zero depend on commits that were introduced after the root cause
commit 97d482f4592f ("mm/damon/sysfs: reuse damon_set_regions() for
regions setting").

Fix the problems by checking the assumption and returning an error if
the input ranges don't meet the assumption.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260703165610.92894-1-sj@kernel.org
Link: https://lore.kernel.org/20260630041806.151124-1-sj@kernel.org [1]
Fixes: 97d482f4592f ("mm/damon/sysfs: reuse damon_set_regions() for regions setting")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -213,12 +213,19 @@ int damon_set_regions(struct damon_targe
 {
 	struct damon_region *r, *next;
 	unsigned int i;
+	unsigned long last_end;
 	int err;
 
 	for (i = 0; i < nr_ranges; i++) {
-		if (ALIGN_DOWN(ranges[i].start, min_sz_region) >=
-				ALIGN(ranges[i].end, min_sz_region))
+		unsigned long start, end;
+
+		start = ALIGN_DOWN(ranges[i].start, min_sz_region);
+		end = ALIGN(ranges[i].end, min_sz_region);
+		if (start >= end)
+			return -EINVAL;
+		if (i > 0 && last_end > start)
 			return -EINVAL;
+		last_end = end;
 	}
 
 	/* Remove regions which are not in the new ranges */


