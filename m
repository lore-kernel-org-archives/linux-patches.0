Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD50F2248A5;
	Tue, 26 Aug 2025 11:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207517; cv=none; b=LBzcaKHCnpcYvGU2q2PNsCudIp28yFziGxY2/5T4lGsJy6D60UMHaX5YO8DuA1tDwQ5Y1wcrw7VP6I/QuEng3Rg7q3wyXYiasqsydVurNT65BOi2ulQqb8KAwRADXQ5JLtnsq99lFPSEVcIhf1DTdzmaXwp1Z7XDnf/wuziLKwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207517; c=relaxed/simple;
	bh=ov55nVNNwVeMROSEGkoQ9mEJdlP1htV+SYVttTDfWIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQlevJ0STH0XFv5GYONEiJ9cn1e7KuqDF2pUF6W++FVk5nG6ZHKRlUWeRpXTuMTHF7LARtXa7GmsHoXU1UN3mSypwPR8Np8ecL3GYcugfk4oCLBs7cKG7+OHdkg61QWirfIfXmP5w/iDKUSEbwsA5S2/cWlqv0cA6qpxnt0h1TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=POyM9Z9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="POyM9Z9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC7DC4CEF1;
	Tue, 26 Aug 2025 11:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207517;
	bh=ov55nVNNwVeMROSEGkoQ9mEJdlP1htV+SYVttTDfWIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=POyM9Z9PfyZaUqP4V6zDYSVs0BbEu4Wrgk7wDDYfV2efJa8NwA0g3rFz6k9mSGk79
	 dbAh6xNI8NVWfz+KZZUSb98CKBxDzJBnH+4+4pqegglY5gUfLOSFtDtCVbOSCiYJsh
	 ALIYi9bJGQcVCZQ3x9Xi5IKXhFwe1U2nVZQbq6hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Honggyu Kim <honggyu.kim@sk.com>,
	Hyeongtak Ji <hyeongtak.ji@sk.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 211/457] mm/damon/ops-common: ignore migration request to invalid nodes
Date: Tue, 26 Aug 2025 13:08:15 +0200
Message-ID: <20250826110942.578024640@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 7e6c3130690a01076efdf45aa02ba5d5c16849a0 upstream.

damon_migrate_pages() tries migration even if the target node is invalid.
If users mistakenly make such invalid requests via
DAMOS_MIGRATE_{HOT,COLD} action, the below kernel BUG can happen.

    [ 7831.883495] BUG: unable to handle page fault for address: 0000000000001f48
    [ 7831.884160] #PF: supervisor read access in kernel mode
    [ 7831.884681] #PF: error_code(0x0000) - not-present page
    [ 7831.885203] PGD 0 P4D 0
    [ 7831.885468] Oops: Oops: 0000 [#1] SMP PTI
    [ 7831.885852] CPU: 31 UID: 0 PID: 94202 Comm: kdamond.0 Not tainted 6.16.0-rc5-mm-new-damon+ #93 PREEMPT(voluntary)
    [ 7831.886913] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-4.el9 04/01/2014
    [ 7831.887777] RIP: 0010:__alloc_frozen_pages_noprof (include/linux/mmzone.h:1724 include/linux/mmzone.h:1750 mm/page_alloc.c:4936 mm/page_alloc.c:5137)
    [...]
    [ 7831.895953] Call Trace:
    [ 7831.896195]  <TASK>
    [ 7831.896397] __folio_alloc_noprof (mm/page_alloc.c:5183 mm/page_alloc.c:5192)
    [ 7831.896787] migrate_pages_batch (mm/migrate.c:1189 mm/migrate.c:1851)
    [ 7831.897228] ? __pfx_alloc_migration_target (mm/migrate.c:2137)
    [ 7831.897735] migrate_pages (mm/migrate.c:2078)
    [ 7831.898141] ? __pfx_alloc_migration_target (mm/migrate.c:2137)
    [ 7831.898664] damon_migrate_folio_list (mm/damon/ops-common.c:321 mm/damon/ops-common.c:354)
    [ 7831.899140] damon_migrate_pages (mm/damon/ops-common.c:405)
    [...]

Add a target node validity check in damon_migrate_pages().  The validity
check is stolen from that of do_pages_move(), which is being used for the
move_pages() system call.

Link: https://lkml.kernel.org/r/20250720185822.1451-1-sj@kernel.org
Fixes: b51820ebea65 ("mm/damon/paddr: introduce DAMOS_MIGRATE_COLD action for demotion")	[6.11.x]
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Hyeongtak Ji <hyeongtak.ji@sk.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/paddr.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -476,6 +476,10 @@ static unsigned long damon_pa_migrate_pa
 	if (list_empty(folio_list))
 		return nr_migrated;
 
+	if (target_nid < 0 || target_nid >= MAX_NUMNODES ||
+			!node_state(target_nid, N_MEMORY))
+		return nr_migrated;
+
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	nid = folio_nid(lru_to_folio(folio_list));


