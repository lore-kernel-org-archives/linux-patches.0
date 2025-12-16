Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA09133BBC8;
	Tue, 16 Dec 2025 11:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884672; cv=none; b=BM6nUIxov2z7Gz5coScV7i/uRnd2Q+XlwkpdTruV9K0F0ZcKgSdkSiGeAVV3l8zYq3FiPmxURNC2Ixxmi6k+pev6I9xI7Syr3cJs4AVIYhqY9sRHIQfEcfVdawpTl2ZnUjp41B3ghRBiw68womFbp2JX0DylHI2+GyJU0sqOEgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884672; c=relaxed/simple;
	bh=IAm2lAeECfHCgj/Xu1f91g1Yx0kxOW4JQ+DCcsnRzRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OXVvXesJVsak3VsoCe9S0X00tqIxbgNbEkNy7J58ugv1RVg4vB3nO1IuldEpqnhSFuPX+QAr0bL6sdaDwmTBEPpMjY0xOnFucbM5DfFym4LeL8U9mIPoV6k4UBXXuyKudnbJjoxrjrVm8Tws2aEdRSq90c9fhg573sNORa3tri0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BvjKXrG5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BvjKXrG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262DCC4CEF5;
	Tue, 16 Dec 2025 11:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884672;
	bh=IAm2lAeECfHCgj/Xu1f91g1Yx0kxOW4JQ+DCcsnRzRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BvjKXrG5xabW5Db7FmnfHNBe3I5LL2ByOYpfH4iUqOFqLHUBIVKop+a16zxEUflJq
	 3N/5SqUTjx7yhmjmsC+8pDyVmNATVworaYLvSjx7BU+aG5iylqcUNywMYsGt/gqOpN
	 86GCLs7zjrAdnvC2Tuobzk36io4PgzE3txcS2Mew=
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
Subject: [PATCH 6.12 264/354] Reinstate "resource: avoid unnecessary lookups in find_next_iomem_res()"
Date: Tue, 16 Dec 2025 12:13:51 +0100
Message-ID: <20251216111330.481433602@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 03b6b8de58bfb..2182854dde68e 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -323,6 +323,8 @@ static int find_next_iomem_res(resource_size_t start, resource_size_t end,
 			       unsigned long flags, unsigned long desc,
 			       struct resource *res)
 {
+	/* Skip children until we find a top level range that matches */
+	bool skip_children = true;
 	struct resource *p;
 
 	if (!res)
@@ -333,7 +335,7 @@ static int find_next_iomem_res(resource_size_t start, resource_size_t end,
 
 	read_lock(&resource_lock);
 
-	for_each_resource(&iomem_resource, p, false) {
+	for_each_resource(&iomem_resource, p, skip_children) {
 		/* If we passed the resource we are looking for, stop */
 		if (p->start > end) {
 			p = NULL;
@@ -344,6 +346,12 @@ static int find_next_iomem_res(resource_size_t start, resource_size_t end,
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



