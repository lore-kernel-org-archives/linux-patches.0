Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A90359F8D;
	Fri,  9 Jan 2026 12:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961936; cv=none; b=fll5Pll45AJLo70RO271bLCEvS+QASTelSjiYEa5jbBoMOXWRe64fF0HB4ZDTovshpxsUY5VpvhrOX4Do+sDz1RqGlHKh1KFckv7sv1kK5AXJ8Gnhp8MFQ2SkvmIKqr2Rxn4GZX4XzDgJi1HtjBfACddtUGCiXSZHIOCOLoW7dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961936; c=relaxed/simple;
	bh=Q7oAXds72TqiSn6o9RPZAUECs2/t8vmOkcSn3/Lruyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3K7Ijy1dOG6GZ1Z1rc9Mn4Wy3DAZT0X4pJduhMM8HSOvhBKQhJfGVQJnxjn8E7fKemlS3Q2VaGb7y2DzUtOznRPClGcSP7aIDNjEZkc8oKIFtPp0bJuZQsPTgw1k/IQRrhHkegKWNhUSwkEoZ0LS0q5/Or6G7ELiTmJXourlsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TsVwcfh6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TsVwcfh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6530C4CEF1;
	Fri,  9 Jan 2026 12:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961936;
	bh=Q7oAXds72TqiSn6o9RPZAUECs2/t8vmOkcSn3/Lruyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TsVwcfh6a2GqVg1/Ri6wXnJmAV29bvPYLimumhOJHlN9AY6CtlPRk22kvlu6/7xMC
	 XpNLoffHQ+aVdFvRbxpViSu/xQk3lyUFl8Omft+loLO+BUxDpVVt93WluqmLnw/87K
	 rdZDRU8kClDdhIetYnfarGJe1X7IA39QcLtuFYBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 171/634] resource: introduce is_type_match() helper and use it
Date: Fri,  9 Jan 2026 12:37:29 +0100
Message-ID: <20260109112123.880385128@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 20cb54f387e71..1170ed58404fb 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -310,6 +310,11 @@ int release_resource(struct resource *old)
 
 EXPORT_SYMBOL(release_resource);
 
+static bool is_type_match(struct resource *p, unsigned long flags, unsigned long desc)
+{
+	return (p->flags & flags) == flags && (desc == IORES_DESC_NONE || desc == p->desc);
+}
+
 /**
  * find_next_iomem_res - Finds the lowest iomem resource that covers part of
  *			 [@start..@end].
@@ -352,13 +357,9 @@ static int find_next_iomem_res(resource_size_t start, resource_size_t end,
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
@@ -501,7 +502,7 @@ static int __region_intersects(struct resource *parent, resource_size_t start,
 	int type = 0; int other = 0;
 	struct resource *p, *dp;
 	struct resource res, o;
-	bool is_type, covered;
+	bool covered;
 
 	res.start = start;
 	res.end = start + size - 1;
@@ -509,9 +510,7 @@ static int __region_intersects(struct resource *parent, resource_size_t start,
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
@@ -531,9 +530,7 @@ static int __region_intersects(struct resource *parent, resource_size_t start,
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



