Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672A526A08F;
	Tue, 16 Dec 2025 11:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884669; cv=none; b=mCedA+4k8EftkMd8VUyewE/m97UtHBqJbrNzFbAZuwdLw8WVHkRkbn14GkXf3wRScPq/puckL+WtRl+NNQBKcvTZ6N9aMcgcbKefgQdd9y5seNNkGi9hHXEPNA0SJhysE30Rsj+Jic7p0tolLm3algHb2uBRGXETxzc8EVNC5Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884669; c=relaxed/simple;
	bh=Cpqs6HUB8xHDsCfUV10H+vyd5Z3uZJka+b9F4qYnWi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHrrC7Zn4FwG739wPJNGhMhMHhhf0BK6VdSNR0sPhT3TZZiZkZ6xzjuI1SX1D7J1rsXNc5DubzJMeNYdqyAEbU6hQzKcK4Hn6uH465tecE6WITy24gTTUgINCSd/H7PhdCMn3JlIbOQiIHVnHVO/b44G5ooC2y1VMxhA2jENWwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZ9ttM3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZ9ttM3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6285C4CEF1;
	Tue, 16 Dec 2025 11:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884669;
	bh=Cpqs6HUB8xHDsCfUV10H+vyd5Z3uZJka+b9F4qYnWi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZ9ttM3yOPo4v/ke8P1BXs3S+VOs75o9g7S0t9aAINwMxO0PA8BugSaZ+cioMDjAe
	 QZmsLwQR+RpDPs3tLAgKNKs0oXbIw+b1Oj8RPVXhZaETfZ38F+7caIPKPlMMSj8ZAS
	 K67jD0vPRrm6omTfp0AWdzeMUwaWP/dhkuth6Yr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 263/354] resource: introduce is_type_match() helper and use it
Date: Tue, 16 Dec 2025 12:13:50 +0100
Message-ID: <20251216111330.445504297@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit ba1eccc114ffc62c4495a5e15659190fa2c42308 ]

There are already a couple of places where we may replace a few lines of
code by calling a helper, which increases readability while deduplicating
the code.

Introduce is_type_match() helper and use it.

Link: https://lkml.kernel.org/r/20240925154355.1170859-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 6fb3acdebf65 ("Reinstate "resource: avoid unnecessary lookups in find_next_iomem_res()"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/resource.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index c3e00365f8e37..03b6b8de58bfb 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -297,6 +297,11 @@ int release_resource(struct resource *old)
 
 EXPORT_SYMBOL(release_resource);
 
+static bool is_type_match(struct resource *p, unsigned long flags, unsigned long desc)
+{
+	return (p->flags & flags) == flags && (desc == IORES_DESC_NONE || desc == p->desc);
+}
+
 /**
  * find_next_iomem_res - Finds the lowest iomem resource that covers part of
  *			 [@start..@end].
@@ -339,13 +344,9 @@ static int find_next_iomem_res(resource_size_t start, resource_size_t end,
 		if (p->end < start)
 			continue;
 
-		if ((p->flags & flags) != flags)
-			continue;
-		if ((desc != IORES_DESC_NONE) && (desc != p->desc))
-			continue;
-
 		/* Found a match, break */
-		break;
+		if (is_type_match(p, flags, desc))
+			break;
 	}
 
 	if (p) {
@@ -540,7 +541,7 @@ static int __region_intersects(struct resource *parent, resource_size_t start,
 	int type = 0; int other = 0;
 	struct resource *p, *dp;
 	struct resource res, o;
-	bool is_type, covered;
+	bool covered;
 
 	res.start = start;
 	res.end = start + size - 1;
@@ -548,9 +549,7 @@ static int __region_intersects(struct resource *parent, resource_size_t start,
 	for (p = parent->child; p ; p = p->sibling) {
 		if (!resource_intersection(p, &res, &o))
 			continue;
-		is_type = (p->flags & flags) == flags &&
-			(desc == IORES_DESC_NONE || desc == p->desc);
-		if (is_type) {
+		if (is_type_match(p, flags, desc)) {
 			type++;
 			continue;
 		}
@@ -570,9 +569,7 @@ static int __region_intersects(struct resource *parent, resource_size_t start,
 		for_each_resource(p, dp, false) {
 			if (!resource_overlaps(dp, &res))
 				continue;
-			is_type = (dp->flags & flags) == flags &&
-				(desc == IORES_DESC_NONE || desc == dp->desc);
-			if (is_type) {
+			if (is_type_match(dp, flags, desc)) {
 				type++;
 				/*
 				 * Range from 'o.start' to 'dp->start'
-- 
2.51.0



