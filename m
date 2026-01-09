Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508B933B6E8;
	Fri,  9 Jan 2026 12:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961967; cv=none; b=I/mEx7Vt7MrrOMe8NTpwVsIr7A/QN2Oez2Z4cH662TPQ/OgcjkDsw/TEmKvntgButOUoK3zcGRonL9LoH/5nplOywJi4qzrDWi2z+KCafY5+SVOuk57J0oIeWbuT7TLHlPgsKKJu5En2chZVXIWYd+tZ6ik5r/rqhvPv+0swA78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961967; c=relaxed/simple;
	bh=iHeKR5nG+vILkblRiwWLOztdqo1Kvi89oyoqJqP40LA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cFx9mLdXgvryUjjZZLDFsL63raiN4T2VzYKdNYSYqaSWMuvkMgDR/z0ifQJ5i/GicjrPMFU2sHXCMq1ncmRvQdK3TfQUNqjdgdKHvRriB1eFS7CiJg8dcUcmYVATggOnsnuXxEr7TGiaPzmGhthpi1MJum1otwv6UMs5YTSbTxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3cfXUsL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3cfXUsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCF6C4CEF1;
	Fri,  9 Jan 2026 12:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961967;
	bh=iHeKR5nG+vILkblRiwWLOztdqo1Kvi89oyoqJqP40LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3cfXUsLzk+uInsA9oOc34++tjOB5GO8+XgfjE0a+k0jfBfv9X8dFJ87Ygs5puYFv
	 XQ6BBHpLISZdBoyDgqPuPr1Bvj8N3pJZSjdQeDOPbfnEpLRvp30/ERk65vjzRFtZd3
	 hKF9eGbgk8eCKu7VPhi1BQWgQR5yDnIF+mG8uYX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilias Stamatis <ilstam@amazon.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andriy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Baoquan He <bhe@redhat.com>,
	"Huang, Ying" <huang.ying.caritas@gmail.com>,
	Nadav Amit <nadav.amit@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 172/634] Reinstate "resource: avoid unnecessary lookups in find_next_iomem_res()"
Date: Fri,  9 Jan 2026 12:37:30 +0100
Message-ID: <20260109112123.917411998@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilias Stamatis <ilstam@amazon.com>

[ Upstream commit 6fb3acdebf65a72df0a95f9fd2c901ff2bc9a3a2 ]

Commit 97523a4edb7b ("kernel/resource: remove first_lvl / siblings_only
logic") removed an optimization introduced by commit 756398750e11
("resource: avoid unnecessary lookups in find_next_iomem_res()").  That
was not called out in the message of the first commit explicitly so it's
not entirely clear whether removing the optimization happened
inadvertently or not.

As the original commit message of the optimization explains there is no
point considering the children of a subtree in find_next_iomem_res() if
the top level range does not match.

Reinstating the optimization results in performance improvements in
systems where /proc/iomem is ~5k lines long.  Calling mmap() on /dev/mem
in such platforms takes 700-1500μs without the optimisation and 10-50μs
with the optimisation.

Note that even though commit 97523a4edb7b removed the 'sibling_only'
parameter from next_resource(), newer kernels have basically reinstated it
under the name 'skip_children'.

Link: https://lore.kernel.org/all/20251124165349.3377826-1-ilstam@amazon.com/T/#u
Fixes: 97523a4edb7b ("kernel/resource: remove first_lvl / siblings_only logic")
Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: "Huang, Ying" <huang.ying.caritas@gmail.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/resource.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 1170ed58404fb..f39b9fe738d14 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -336,6 +336,8 @@ static int find_next_iomem_res(resource_size_t start, resource_size_t end,
 			       unsigned long flags, unsigned long desc,
 			       struct resource *res)
 {
+	/* Skip children until we find a top level range that matches */
+	bool skip_children = true;
 	struct resource *p;
 
 	if (!res)
@@ -346,7 +348,7 @@ static int find_next_iomem_res(resource_size_t start, resource_size_t end,
 
 	read_lock(&resource_lock);
 
-	for_each_resource(&iomem_resource, p, false) {
+	for_each_resource(&iomem_resource, p, skip_children) {
 		/* If we passed the resource we are looking for, stop */
 		if (p->start > end) {
 			p = NULL;
@@ -357,6 +359,12 @@ static int find_next_iomem_res(resource_size_t start, resource_size_t end,
 		if (p->end < start)
 			continue;
 
+		/*
+		 * We found a top level range that matches what we are looking
+		 * for. Time to start checking children too.
+		 */
+		skip_children = false;
+
 		/* Found a match, break */
 		if (is_type_match(p, flags, desc))
 			break;
-- 
2.51.0



