Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346EE33B97F;
	Fri,  9 Jan 2026 11:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959970; cv=none; b=BYdSyuCP4k6dqCuEkW8ejCbJA9LkG0W6JA9k+xwOPXFcASjuK/kwZZhDVGliJNgnMT0UyISHyaeupAzWvWxpRWEjMk7+JZmfdlJa3Fgdl6JaDPPayevhbjWvyC1KmnL2VXUxvtUF7J4WtcvF3VmrHQdAtDFqBT+x5zUXdM9n6mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959970; c=relaxed/simple;
	bh=0/hjEoINBstHlWZLBBfIi8SC4Cj1vE2sfGsWsNqI1yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WBVZo00nQ+gjy0sFbMju6H2b7K1jVC+Wx85LMIjCQoqsm3H0l0sGUqeM9IZwyMBOkdz5y5T+krud4MtnueSTFtRWWLhcFCPBBlMdqxr/WxIXCNfUNNb/3H81PYiRuWFZWUjFPZGOonav1SVbDhx5PE3W5HT2SqcCcV8bURElj8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6lsl39f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6lsl39f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E45C4CEF1;
	Fri,  9 Jan 2026 11:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959970;
	bh=0/hjEoINBstHlWZLBBfIi8SC4Cj1vE2sfGsWsNqI1yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6lsl39f416oFdFkVNyiq95mHigl36mDgiN2ujPcZc7D1ZfYrSPm236ndr4auagsk
	 fpElbZd8MYslVK+EsrfA/7MEejdwlrlmzkZUVCIuJJhfgV8raj4STPfb4/NtJwGSdY
	 TWzr7L0KqMZuz2wPwqZzLw0u38S6rModvAxku688=
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
Subject: [PATCH 6.6 239/737] Reinstate "resource: avoid unnecessary lookups in find_next_iomem_res()"
Date: Fri,  9 Jan 2026 12:36:18 +0100
Message-ID: <20260109112142.988295350@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 67410132b40e1..dca8581eb3992 100644
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



