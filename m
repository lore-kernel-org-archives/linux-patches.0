Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793391494D9;
	Fri,  6 Dec 2024 14:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496108; cv=none; b=ZBl92cZMFxIplBEZyEP8SJtNNG7Y/foUMx5diFPPHv1hAUli421Cwh858Rtgo+/F52s1UhLMKDgpBMlQ3NY5ya7WetpmBcgjLJdqfnWwL7wVuZxx/sLEFoELo6/wgRqWevCOQbb7oWi/dzTWpEygf531+gq/O0xyMdy0/HYbCys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496108; c=relaxed/simple;
	bh=bHWPgMhuH93nYpJC976ZNomkG7unt/JD3aV/DoLXXLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZSIol0rRUfP3Y9Nb7+MpmEu17+fmrgtVRli2kogevhFhT3+KJ00B6jDkN1B5TKU3AGlctmQo1WmAvd4DF/vRK1EuIZ22C9RT9IuE5/ney8YhJOZgTPNNU0xhCUs7YMiFnRq67PFeanBgs1h6TE/l6Nwbul7l95eoq+qIyvYr4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4dzoqnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4dzoqnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FAEC4CED1;
	Fri,  6 Dec 2024 14:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496108;
	bh=bHWPgMhuH93nYpJC976ZNomkG7unt/JD3aV/DoLXXLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4dzoqnb+KjTXmC1hEKAq2j5h9oFO4P3H+lkDwcSp1mNjPVkkpxmfvFJFfz+Y9ySF
	 zaYkFw/7LHzG+aUgduCKyqbv79aikEnDTGpxAqsbwhvPtUi3Qp0JWLSWpVNiVZbF2P
	 VxTMyaTdrqnN6meHqgUgfxPRB6vo6BEHEYIMVxhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MengEn Sun <mengensun@tencent.com>,
	JinLiang Zheng <alexjlzheng@tencent.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 046/146] vmstat: call fold_vm_zone_numa_events() before show per zone NUMA event
Date: Fri,  6 Dec 2024 15:36:17 +0100
Message-ID: <20241206143529.437637374@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: MengEn Sun <mengensun@tencent.com>

commit 2ea80b039b9af0b71c00378523b71c254fb99c23 upstream.

Since 5.14-rc1, NUMA events will only be folded from per-CPU statistics to
per zone and global statistics when the user actually needs it.

Currently, the kernel has performs the fold operation when reading
/proc/vmstat, but does not perform the fold operation in /proc/zoneinfo.
This can lead to inaccuracies in the following statistics in zoneinfo:
- numa_hit
- numa_miss
- numa_foreign
- numa_interleave
- numa_local
- numa_other

Therefore, before printing per-zone vm_numa_event when reading
/proc/zoneinfo, we should also perform the fold operation.

Link: https://lkml.kernel.org/r/1730433998-10461-1-git-send-email-mengensun@tencent.com
Fixes: f19298b9516c ("mm/vmstat: convert NUMA statistics to basic NUMA counters")
Signed-off-by: MengEn Sun <mengensun@tencent.com>
Reviewed-by: JinLiang Zheng <alexjlzheng@tencent.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmstat.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1780,6 +1780,7 @@ static void zoneinfo_show_print(struct s
 			   zone_page_state(zone, i));
 
 #ifdef CONFIG_NUMA
+	fold_vm_zone_numa_events(zone);
 	for (i = 0; i < NR_VM_NUMA_EVENT_ITEMS; i++)
 		seq_printf(m, "\n      %-12s %lu", numa_stat_name(i),
 			   zone_numa_event_state(zone, i));


