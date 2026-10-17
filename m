Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E573AEB39;
	Sat, 17 Oct 2026 16:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255751; cv=none; b=XUYzkyAWfuRz27Qd2MPiUbJqqIbyLVVj1c4xnuf1bflR8V1u8Ol6OtatI3uh2VLXsCXyZe+ht8ZiYoDv0t1ZRo/Es3gA9b0H2nxD0Jle/dC2xxxPECZKvCDwoljedvR2gXBde+19wuH6yuGdYd0zVvZGKpPnVC0uknELa/zT6W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255751; c=relaxed/simple;
	bh=ZwivnyES/NpKhhJL0zc/s6rRxfkIAcSAw1qxXl+hBlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kWsF5k5OD90fUw7Lp1j8tV5iowQcP61LTAHTOCWE99ylQbZM94yThKWoBk4neXEoDxJFHJhsv7WI+Odx61SbFe/Hcvl4UVOcsipD3iQHF3IPda+qLlv4OYkK7o7oDI7jNsKcYIcs2dKDxRCljCBQr09PwOrUSY6d5mOx1GdzYek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XymkMxZZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XymkMxZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BA51F000C4;
	Sat, 17 Oct 2026 16:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255750;
	bh=ZVZCv2mSDgDayRcrot7re9aiz8JZsJAiCrrI5eIXDco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XymkMxZZBBNJXzUitPwe3JikHA8EJRO3jQXj+nx7IQ6qAH0+Gd3Tbg1EALfMRe5Wz
	 VVNdzaccwn2MPV7+Qxz48FM17m4SS7Loc/QNsvpxpOzUCtKhM4FIjILvCwsyqSVofH
	 9HN/KFuw8uYnAE1LYgRll7vm7txFroJiIQ2fPFjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger@xenproject.org>,
	Juergen Gross <jgross@suse.com>,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0010/1674] x86/xen: fix init of balloon stats again
Date: Sat, 17 Oct 2026 17:38:02 +0200
Message-ID: <20261017160431.403559201@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Roger Pau Monne <roger@xenproject.org>

[ Upstream commit 5d00a11d484e7b31a358cd81afebccb4602dbe8c ]

The handling of extra memory regions done in balloon_add_regions() is not
correct for PV guests, since the initial target is set to reflect the real
memory the system has, not what's described on the memory map, which can be
higher if memory != maxmem.

Introduce separate logic for addition vs subtraction in
balloon_add_regions() and handle extra regions correctly by adding them to
the total amount of pages, instead of subtracting from the current and
target pages amounts.

In the common case PV domU/dom0 and PVH dom0 will use the addition path,
since the initial target reflects the real assigned memory.  HVM and PVH
domUs use the subtraction path, since the target is set based on the amount
of memory reported in the memory map, without accounting for released
regions.

Fixes: 87af633689ce ("x86/xen: fix balloon target initialization for PVH dom0")
Fixes: 0949c646d646 ("Partial revert "x86/xen: fix balloon target initialization for PVH dom0"")
Signed-off-by: Roger Pau Monné <roger@xenproject.org>
Cc: stable@vger.kernel.org
Reviewed-by: Juergen Gross <jgross@suse.com>
Tested-by: Matthias Goergens <matthias.goergens@gmail.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260805094008.95778-1-roger@xenproject.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/balloon.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 1fb5dbce0b66c..af34de2a8a23d 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -671,7 +671,7 @@ void xen_free_ballooned_pages(unsigned int nr_pages, struct page **pages)
 }
 EXPORT_SYMBOL(xen_free_ballooned_pages);
 
-static int __init balloon_add_regions(void)
+static int __init balloon_add_regions(bool append)
 {
 	unsigned long start_pfn, pages;
 	unsigned long pfn, extra_pfn_end;
@@ -695,19 +695,26 @@ static int __init balloon_add_regions(void)
 			balloon_append(pfn_to_page(pfn));
 
 		/*
-		 * Extra regions are accounted for in the physmap, but need
-		 * decreasing from current_pages and target_pages to balloon
-		 * down the initial allocation, because they are already
-		 * accounted for in total_pages.
+		 * There are two different use-cases depending on how the
+		 * initial memory target is fetched.  For PVH dom0 and PV the
+		 * target is usually set to reflect the domain assigned memory,
+		 * and hence extra regions need adding.
+		 *
+		 * OTOH for HVM and PVH domU the target is set to the amount of
+		 * RAM reported in the memory map, and hence extra regions need
+		 * subtracting to reflect the real memory usage.
 		 */
 		pages = extra_pfn_end - start_pfn;
-		if (pages >= balloon_stats.current_pages ||
-		    pages >= balloon_stats.target_pages) {
+		if (append) {
+			balloon_stats.total_pages += pages;
+		} else if (pages >= balloon_stats.current_pages ||
+		           pages >= balloon_stats.target_pages) {
 			WARN(1, "Extra pages underflow current target");
 			return -ERANGE;
+		} else {
+			balloon_stats.current_pages -= pages;
+			balloon_stats.target_pages -= pages;
 		}
-		balloon_stats.current_pages -= pages;
-		balloon_stats.target_pages -= pages;
 	}
 
 	return 0;
@@ -718,6 +725,7 @@ static int __init balloon_init(void)
 	struct task_struct *task;
 	long current_pages = 0;
 	domid_t domid = DOMID_SELF;
+	bool append = true;
 	int rc;
 
 	if (!xen_domain())
@@ -737,6 +745,7 @@ static int __init balloon_init(void)
 		} else {
 			if (xen_unpopulated_pages >= get_num_physpages())
 				goto underflow;
+			append = false;
 			current_pages = get_num_physpages() -
 			                xen_unpopulated_pages;
 		}
@@ -759,7 +768,7 @@ static int __init balloon_init(void)
 	register_sysctl_init("xen/balloon", balloon_table);
 #endif
 
-	rc = balloon_add_regions();
+	rc = balloon_add_regions(append);
 	if (rc)
 		return rc;
 
-- 
2.53.0



