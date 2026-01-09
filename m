Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F04433A712;
	Fri,  9 Jan 2026 11:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959964; cv=none; b=r9u3m/gJQG0nzEDXhu19UZ7Etzbh68g6JQ/ILbQF4ZKEKrmZ1huVsxM4FzEr23T3O5W0Gg+F2mIigtb24JPy1GHZ65wX1/b3hvIgqAP4diGaYVvjD/9d7gfDqj4hKrnSGs8hcgZ6L6r4RMecmxJ/4U5ij9BF1327O1cXVDP9xMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959964; c=relaxed/simple;
	bh=IOqWqT2ydh5Jflf6NiBnc8//F+cHwDo95jkUXXl6250=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMKj0+1lhS5xanFA2UVftt25B+b1Lc/sF5xlGIgQhgr/Rpfdt4ACGZO3h9fpCRTX3BXFBHO19leTsXt8NH1pezayn0bqeeYnfXjpWMok52LFANwYex4vR0o2ajsLuM8+TlHMrey8TXrdHgt+VyqzFUVnJF74Wu34vwr1FuWec0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/QlSMWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/QlSMWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C190C16AAE;
	Fri,  9 Jan 2026 11:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959964;
	bh=IOqWqT2ydh5Jflf6NiBnc8//F+cHwDo95jkUXXl6250=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/QlSMWhe6UhZvJxk5Asaa/LZ2fDfq37ZVsp+q7LPXwMddkPKbttBUU9wR3NfM6YY
	 DGTEN9p1LMyHQU9Lo4sWW0FGT8O7b+oKyU2PxkyAv7qdK3ne5UFimczQD+q7J1+4No
	 WAZDYLzIUctDECg7PYmoHHxEmVrOZQ2TYk8V/i9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 237/737] resource: replace open coded resource_intersection()
Date: Fri,  9 Jan 2026 12:36:16 +0100
Message-ID: <20260109112142.913847401@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5c1edea773c98707fbb23d1df168bcff52f61e4b ]

Patch series "resource: A couple of cleanups".

A couple of ad-hoc cleanups since there was a recent development of
the code in question. No functional changes intended.

This patch (of 2):

__region_intersects() uses open coded resource_intersection().  Replace it
with existing API which also make more clear what we are checking.

Link: https://lkml.kernel.org/r/20240925154355.1170859-1-andriy.shevchenko@linux.intel.com
Link: https://lkml.kernel.org/r/20240925154355.1170859-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 6fb3acdebf65 ("Reinstate "resource: avoid unnecessary lookups in find_next_iomem_res()"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/resource.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 79fba72cb7d2e..dcc3b564c0537 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -498,17 +498,16 @@ static int __region_intersects(struct resource *parent, resource_size_t start,
 			       size_t size, unsigned long flags,
 			       unsigned long desc)
 {
-	resource_size_t ostart, oend;
 	int type = 0; int other = 0;
 	struct resource *p, *dp;
+	struct resource res, o;
 	bool is_type, covered;
-	struct resource res;
 
 	res.start = start;
 	res.end = start + size - 1;
 
 	for (p = parent->child; p ; p = p->sibling) {
-		if (!resource_overlaps(p, &res))
+		if (!resource_intersection(p, &res, &o))
 			continue;
 		is_type = (p->flags & flags) == flags &&
 			(desc == IORES_DESC_NONE || desc == p->desc);
@@ -529,8 +528,6 @@ static int __region_intersects(struct resource *parent, resource_size_t start,
 		 * |-- "System RAM" --||-- "CXL Window 0a" --|
 		 */
 		covered = false;
-		ostart = max(res.start, p->start);
-		oend = min(res.end, p->end);
 		for_each_resource(p, dp, false) {
 			if (!resource_overlaps(dp, &res))
 				continue;
@@ -539,17 +536,17 @@ static int __region_intersects(struct resource *parent, resource_size_t start,
 			if (is_type) {
 				type++;
 				/*
-				 * Range from 'ostart' to 'dp->start'
+				 * Range from 'o.start' to 'dp->start'
 				 * isn't covered by matched resource.
 				 */
-				if (dp->start > ostart)
+				if (dp->start > o.start)
 					break;
-				if (dp->end >= oend) {
+				if (dp->end >= o.end) {
 					covered = true;
 					break;
 				}
 				/* Remove covered range */
-				ostart = max(ostart, dp->end + 1);
+				o.start = max(o.start, dp->end + 1);
 			}
 		}
 		if (!covered)
-- 
2.51.0



