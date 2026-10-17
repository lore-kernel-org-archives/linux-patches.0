Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D56C277026;
	Sat, 17 Oct 2026 16:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255811; cv=none; b=QtHpxSk/Na3636V9qHeK/sCAazxqk1jk0Hda6wj0v4xVu597uzKqENVzGg/qA+jpVm8Z/eUBorAlm99nZ/0ZbP8G6Ex3VY3NjjANnG+UN14VnIDDiiowCH8zU+mL2Jx+sln7BY65T/p7eSH5J+Twz5F6hkokXVnQqFRok4+6sN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255811; c=relaxed/simple;
	bh=cVKnJNx5M41c8lFQkhEkHUoS4mUxROWdnTe4vRYNNyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mwEbG9HmsxjvjUGBoXvOzM09ykGfEUL3yZ/kJK1ruws6DFB9zFQi+GlY3XTeYh/CkyMaOgNzp7grLLAn1GxozpLk84o3ol/xaj3oJCsB3sy0XyH/7k9xn5/GNsf6m8Ih7zYBZZivUWAU8gR0J2ju6uiJE0oI4bCfK61X+tjaV3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBdaLfHY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBdaLfHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868EB1F000C4;
	Sat, 17 Oct 2026 16:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255810;
	bh=nDRMaRcfKSFgcGY3jwiPIReuqgapbUaMF+Vv8++ft5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBdaLfHYTozO35LbDd825sulDjy4tenvM4sFSamy9HF+5OFD5aXAngEzcCUtNTyrm
	 4vViCbwZfQN5FCpGrDRHM5Au34f6Fx4flZWVoXya2CHiWV9mjYSa2DW4r/LkdlP4oM
	 pWWxL9F+HbtlTGuAyOJWBlpskQIUA3CjkoCaxEQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0009/1674] xen/balloon: improve accuracy of initial balloon target for dom0
Date: Sat, 17 Oct 2026 17:38:01 +0200
Message-ID: <20261017160431.379829999@linuxfoundation.org>
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
---
 drivers/xen/balloon.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index a76d5530533ff..1fb5dbce0b66c 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -716,7 +716,8 @@ static int __init balloon_add_regions(void)
 static int __init balloon_init(void)
 {
 	struct task_struct *task;
-	unsigned long current_pages;
+	long current_pages = 0;
+	domid_t domid = DOMID_SELF;
 	int rc;
 
 	if (!xen_domain())
@@ -724,15 +725,21 @@ static int __init balloon_init(void)
 
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
-- 
2.53.0



