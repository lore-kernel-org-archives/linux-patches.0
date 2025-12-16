Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2102F34B424;
	Tue, 16 Dec 2025 11:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886397; cv=none; b=iQvKl67nXBGoJOnK8kpAlFCsNfnbBsNwcp4THCsL+932bvPweNZDOU2zoQFkxB3rx2XOX7ltRUotdS6WrhwJbIWNXO1H08zJdQswpwSaHOZBYxvKwy/ZEbmjb6vj0k0W2UIOKMzV6DTFMw06uT2Q8NA88hkCGdgEyiDmsd7XGLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886397; c=relaxed/simple;
	bh=kCMBEz/zifnymArVKK7DVJYnN0hfvrl84aZFA1IJUIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dLARqkyC7pw0pbWLDLbsTIAWbRj18jhZpK3aL3yL5gdNchPkzJ38bhXAY0g1ZFf9RIBd5XeQxyNEY/SHNQBqdQ+HDHGT6+UOepcrpYjBVXNMQ3uY/pwxo3Pxviz+ToSIFf/UhnzxDdLkGbHfoeP1sLN8ZOre8iUVpZuXIwJvBmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dcsEf1Yv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dcsEf1Yv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B885C4CEF1;
	Tue, 16 Dec 2025 11:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886397;
	bh=kCMBEz/zifnymArVKK7DVJYnN0hfvrl84aZFA1IJUIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dcsEf1Yvu7sAolL5Oa1CkQNI55u8fSpg8ngubqduJU+7tq8njhhhh+jblD2Te/RXf
	 FpLV+QYGIX+xBOZo+OFtHI3vvClFkCOnjzaT8QJEWc8+qDWatureSv4xVb+VwaYBSi
	 rk3wMaPrUmmgHJFEAz6NPoci/WnBWVVMrJDC3F30=
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
Subject: [PATCH 6.17 391/507] Reinstate "resource: avoid unnecessary lookups in find_next_iomem_res()"
Date: Tue, 16 Dec 2025 12:13:52 +0100
Message-ID: <20251216111359.619860822@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index f9bb5481501a3..ff00e563ecead 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -341,6 +341,8 @@ static int find_next_iomem_res(resource_size_t start, resource_size_t end,
 			       unsigned long flags, unsigned long desc,
 			       struct resource *res)
 {
+	/* Skip children until we find a top level range that matches */
+	bool skip_children = true;
 	struct resource *p;
 
 	if (!res)
@@ -351,7 +353,7 @@ static int find_next_iomem_res(resource_size_t start, resource_size_t end,
 
 	read_lock(&resource_lock);
 
-	for_each_resource(&iomem_resource, p, false) {
+	for_each_resource(&iomem_resource, p, skip_children) {
 		/* If we passed the resource we are looking for, stop */
 		if (p->start > end) {
 			p = NULL;
@@ -362,6 +364,12 @@ static int find_next_iomem_res(resource_size_t start, resource_size_t end,
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



