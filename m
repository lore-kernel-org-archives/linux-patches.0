Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C0343F4BC;
	Thu, 17 Sep 2026 19:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671682; cv=none; b=JOhQwoXLf70+p2AM6g1deDL++ZdO3yHE8n3a0KbtS4SH2PNxfgcVsGjgLyClq9ZnAprK2iFOU76RSQNiVwhQj1hB4Edl5O5wIPWkA5/ak3YU79r8zwe9CnVMr5f6kzTftCYR5RklYQYNjC13lbe2i4YnPNMZU0/4nHAh55E+my8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671682; c=relaxed/simple;
	bh=JlKKpck2d44+dRzIswD2AzuSvaGqBcNtiLbgCcR1bYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fAULnhGpwsIthMDmJKtnphXg8hjpwZW5lX8hX7ydQeHvabZDvTzXhCa+SD1C6HrbckVwVCI1QiDMxQweHDyi4YUNHuDXVeJitqrhKk4sDSskLFdY6vJNTYmKESN0ieTPKGm0LD3A/md2bRaHmRyg29c/CdjvJLusx6My/hXEhqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yeu2WZGH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yeu2WZGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379141F008A1;
	Thu, 17 Sep 2026 19:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671666;
	bh=xeUiQzDLF4i8l4by4dSrqo6oNlbfRHqiZ5spndEOtNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yeu2WZGHx8jSPRk9+5AiHM2CQ0L9t2WxDode0+PA91Rcu+9bPdQlueDk36WVkbsA6
	 hGLhhZZlRvOItRP/s7n+XhTsovfPoEmDw6KabKX2c0ufwbDUMsOQaLZzrg0qDuLCBe
	 oV5y6cOZ5HiqwtNZO0PTaOFl2wEbm7M2OWhrO5XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1003/1102] xen/balloon: improve accuracy of initial balloon target for dom0
Date: Thu, 17 Sep 2026 16:15:46 +0100
Message-ID: <20260917151605.923331830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Roger Pau Monne <roger.pau@citrix.com>

[ Upstream commit b13cd24c15d74f6dfcddf0d53ae6efb58d3f0461 ]

The dom0 balloon target set by the toolstack is the value returned by
XENMEM_current_reservation.  Do the same in the kernel balloon driver and
set the current allocation to the value returned by
XENMEM_current_reservation.  On my test system this causes the kernel
balloon driver target to exactly match the value set by the toolstack in
xenstore.

Note this approach can be used by both PV and PVH dom0s, as the toolstack
always uses XENMEM_current_reservation to set the initial target regardless
of the dom0 type.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260128110510.46425-3-roger.pau@citrix.com>
Stable-dep-of: 5d00a11d484e ("x86/xen: fix init of balloon stats again")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/balloon.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -720,7 +720,8 @@ static int __init balloon_add_regions(vo
 static int __init balloon_init(void)
 {
 	struct task_struct *task;
-	unsigned long current_pages;
+	long current_pages = 0;
+	domid_t domid = DOMID_SELF;
 	int rc;
 
 	if (!xen_domain())
@@ -728,15 +729,21 @@ static int __init balloon_init(void)
 
 	pr_info("Initialising balloon driver\n");
 
-	if (xen_pv_domain()) {
-		if (xen_released_pages >= xen_start_info->nr_pages)
-			goto underflow;
-		current_pages = min(xen_start_info->nr_pages -
-		                    xen_released_pages, max_pfn);
-	} else {
-		if (xen_unpopulated_pages >= get_num_physpages())
-			goto underflow;
-		current_pages = get_num_physpages() - xen_unpopulated_pages;
+	if (xen_initial_domain())
+		current_pages = HYPERVISOR_memory_op(XENMEM_current_reservation,
+		                                     &domid);
+	if (current_pages <= 0) {
+		if (xen_pv_domain()) {
+			if (xen_released_pages >= xen_start_info->nr_pages)
+				goto underflow;
+			current_pages = min(xen_start_info->nr_pages -
+			                    xen_released_pages, max_pfn);
+		} else {
+			if (xen_unpopulated_pages >= get_num_physpages())
+				goto underflow;
+			current_pages = get_num_physpages() -
+			                xen_unpopulated_pages;
+		}
 	}
 
 	balloon_stats.current_pages = current_pages;


