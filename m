Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF3D2D2394;
	Wed,  9 Sep 2026 14:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964538; cv=none; b=k0opTGVTedNIuh/l0z+D6BPNvz5FFnauDaMe+i6SpQKuUeEpksbdi3PWs6/MWgAfPXrJFBhXvyl1rMNRoAt5jGvJ9b2xu/ygiRs78C/GHfEMabu1hwnjhHXVwRNr8Af8q+zX5XnDVD2Lra+D1aJmXpexp/uuGjqz6dFtVhD0iJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964538; c=relaxed/simple;
	bh=S1c4Sv6Z7dALZMufAg1L8w0AAT5vJbressR6m5CFo2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N2cePEQ7Z/obqJTbJ59CKimsChrIPWybIGMF/+Sigys2H3TXfevY0cbLErcl3jwBWtZ59I1j8YjftWbfoSyweyZ0O71dhLLcWmAboqyIQSql/22vUA5hyTd2xIftWuXMYW85Lh4aQLoZ81Kd3KPYYnHFN5wmJR3HmQTMLENztYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lxhq9w58; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lxhq9w58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9842D1F00A3E;
	Wed,  9 Sep 2026 14:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964537;
	bh=j07Wu2jMeLBwbq0GyS6Z7lEk9fE3FHa6LKHsiJ6bOAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lxhq9w58hJl5F3+WvLbntwtRHjfJidVD8OjcYy0kgMdDXWNuqsfDn7foCUFCM9yUm
	 ucZUMPCL+t8DmBWkrl/OIiVw8SvOd3O6PxZrtCoL9P6EjZC0jDzixlw+hN0BcID4WG
	 A4XljOWYT2nv4+hqINzbigfer9UE8KunScGRJfWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger@xenproject.org>,
	Juergen Gross <jgross@suse.com>,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 457/583] x86/xen: fix init of balloon stats again
Date: Wed,  9 Sep 2026 15:42:22 +0200
Message-ID: <20260909134253.762341789@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/balloon.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -679,7 +679,7 @@ void xen_free_ballooned_pages(unsigned i
 }
 EXPORT_SYMBOL(xen_free_ballooned_pages);
 
-static int __init balloon_add_regions(void)
+static int __init balloon_add_regions(bool append)
 {
 	unsigned long start_pfn, pages;
 	unsigned long pfn, extra_pfn_end;
@@ -703,19 +703,26 @@ static int __init balloon_add_regions(vo
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
@@ -726,6 +733,7 @@ static int __init balloon_init(void)
 	struct task_struct *task;
 	long current_pages = 0;
 	domid_t domid = DOMID_SELF;
+	bool append = true;
 	int rc;
 
 	if (!xen_domain())
@@ -745,6 +753,7 @@ static int __init balloon_init(void)
 		} else {
 			if (xen_unpopulated_pages >= get_num_physpages())
 				goto underflow;
+			append = false;
 			current_pages = get_num_physpages() -
 			                xen_unpopulated_pages;
 		}
@@ -767,7 +776,7 @@ static int __init balloon_init(void)
 	register_sysctl_init("xen/balloon", balloon_table);
 #endif
 
-	rc = balloon_add_regions();
+	rc = balloon_add_regions(append);
 	if (rc)
 		return rc;
 


