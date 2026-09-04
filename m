Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F62B38E8DD;
	Fri,  4 Sep 2026 05:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499614; cv=none; b=JuEPn/Z0nNdXqXZaUy2CJNlcvSMp7N6LX5AC5BuFsN6RjXQCkm+OpGyCW/FXt5UbQ2U/2EDaMno5vnrQZU352Gfng2cXLpHQUU3VFAWNB9YwyVLL94cMH7soZRm2GdDMPsUtGdHjMI3qJFKkrXkt6wMQ4sYXSUQ3INTOF0sSOZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499614; c=relaxed/simple;
	bh=EGz4/AFCNFAlx2d56uNgvxkP0bdBA3Px//e9iRAVs8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaGPevShnuD9nEP/YYjo75y4Yvc9PU7s0snJhG97LS1Xy+Pwc82Hgf8BIOqL52hnfhN6cun/9LNUyXoA3WeuglH0wo2NNdCOBDs23gkYjMOvBi4TAHWgwY7uX58eqK5TTbD4yrI2nFh4ml8PmdPwdTMys4tvQ44DkruCUYNxrnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wA31wfQO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wA31wfQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4531D1F00A3D;
	Fri,  4 Sep 2026 05:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499612;
	bh=Qt8OruHqoA93zcyG54VJevXcWdF4XmzzeUXjOWH0528=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wA31wfQOAIPxjiXvSAvZMFCHnq+A+ifWvEx2QxYjN3S9zQ0w8/GEVvpDH7F16RPj8
	 aBJCg92zJEDC2IZ6NS4lolM9wLYxOCB5ZAgtWgvT8Sue4kSlkZL23if3PYA3OY7Y+L
	 U+OyhjNAhO1SZOkbgF04P58uLKkZl4mNrUgELZBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Graf <graf@amazon.com>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 7.2 478/713] dma-contiguous: fix truncation of numa_cma / cma_pernuma sizes >= 2G
Date: Fri,  4 Sep 2026 06:57:26 +0200
Message-ID: <20260904045814.539871002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Graf <graf@amazon.com>

commit 1476cca098f6d3a553fcec6fe9b7d86e15c00b59 upstream.

numa_cma=0:4G reserves nothing at all. dma_numa_cma_reserve() copies the
requested size into a local int before handing it to
cma_declare_contiguous_nid(), so 0x100000000 truncates to zero and the
loop skips the node silently. Both parameters are documented in
kernel-parameters.txt as nn[MG], so that is the syntax the documentation
invites.

Which bits survive decides what a request turns into: 4G, 8G and 16G
reserve nothing, 2G, 3G and 6G sign-extend into a size the allocator
rejects with a warning, and 5G quietly reserves 1G.

It reaches further than those parameters. On a CMA_SIZE_PERNUMA kernel
with no per-node parameter, dma_numa_cma_reserve() takes the per-node
size from the default area, so a plain cma=4G on a multi-node machine
feeds that size through the same local and loses every per-node area.

numa_cma_size[] and pernuma_size_bytes are both phys_addr_t, so use it
for the local too, and give early_numa_cma() separate variables for the
node id and the size while in there.

Fixes: d5cae2261b86 ("dma-contiguous: simplify numa cma area handling")
Cc: stable@vger.kernel.org
Assisted-by: Kiro:claude-opus-5
Signed-off-by: Alexander Graf <graf@amazon.com>
Reviewed-by: Feng Tang <feng.tang@linux.alibaba.com>
Link: https://lore.kernel.org/r/20260821224252.70640-1-graf@amazon.com
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/dma/contiguous.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index f754079a287d..66093460584e 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -140,21 +140,22 @@ static bool numa_cma_configured __initdata;
 static int __init early_numa_cma(char *p)
 {
 	int nid, count = 0;
-	unsigned long tmp;
+	unsigned long node;
+	phys_addr_t size;
 	char *s = p;
 
 	while (*s) {
-		if (sscanf(s, "%lu%n", &tmp, &count) != 1)
+		if (sscanf(s, "%lu%n", &node, &count) != 1)
 			break;
 
 		if (s[count] == ':') {
-			if (tmp >= MAX_NUMNODES)
+			if (node >= MAX_NUMNODES)
 				break;
-			nid = array_index_nospec(tmp, MAX_NUMNODES);
+			nid = array_index_nospec(node, MAX_NUMNODES);
 
 			s += count + 1;
-			tmp = memparse(s, &s);
-			numa_cma_size[nid] = tmp;
+			size = memparse(s, &s);
+			numa_cma_size[nid] = size;
 
 			if (*s == ',')
 				s++;
@@ -207,9 +208,10 @@ static void __init dma_numa_cma_reserve(void)
 		pernuma_size_bytes = cma_get_size(dma_contiguous_default_area);
 
 	for_each_node(nid) {
-		int size, ret;
+		phys_addr_t size;
 		char name[CMA_MAX_NAME];
 		struct cma **cma;
+		int ret;
 
 		if (!node_online(nid)) {
 			if (pernuma_size_bytes || numa_cma_size[nid])
-- 
2.55.0



