Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F67E2F44;
	Thu, 12 Dec 2024 16:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020469; cv=none; b=irP+JzoG8rW6BlHXEPXApvwEeaCkEFQOZ4PinGyl95foJhXOk5DI8T8ICrS14QpnVoz0QiMyjTqYUM7lTIMGykPH4NIXCOSGa7mfTj/K4O2PubE+4xLnLd+FqPV6QpKkOthlCrH1+O+RJBUIyfXYe/Jyi0KQJmkKrjPyZgQkPNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020469; c=relaxed/simple;
	bh=uEDOHpqFAqPHkV/lqkrwpdiJA8McsSj23gz+5K8GLLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUZeO4sZkjNXxS+7dj28K8CDLQh0k7mod1IWXC84KBYf27JXliEfJlUXdXQxIqVCf61Xtx4p8d1uqaz+pffYBGSLe6GcP+ydQiNiiS17GS+zexABZL1GXfa3LexdWYXrlwDbx1+GzjkI7ooWT8JlMqYITE4WO0yO/YyQlZlnVTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Svznatio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Svznatio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1088C4CECE;
	Thu, 12 Dec 2024 16:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020469;
	bh=uEDOHpqFAqPHkV/lqkrwpdiJA8McsSj23gz+5K8GLLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SvznatiomX2Uk474C6rFJQxeBKivScZQPbcC39ezUtf00/AwJY++mjeVOPfAWyO4O
	 eRGzgjATw+HOemIaqxHgxGKvJfTYS2croRBkuV5NdBCgmkuZzw+nGReMFxrHtBlXo1
	 U4dD3rf/LRpDCBC8MPiczWfhFhMEpKD6nGP0DJ9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MengEn Sun <mengensun@tencent.com>,
	JinLiang Zheng <alexjlzheng@tencent.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 474/772] vmstat: call fold_vm_zone_numa_events() before show per zone NUMA event
Date: Thu, 12 Dec 2024 15:56:59 +0100
Message-ID: <20241212144409.521240989@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1711,6 +1711,7 @@ static void zoneinfo_show_print(struct s
 			   zone_page_state(zone, i));
 
 #ifdef CONFIG_NUMA
+	fold_vm_zone_numa_events(zone);
 	for (i = 0; i < NR_VM_NUMA_EVENT_ITEMS; i++)
 		seq_printf(m, "\n      %-12s %lu", numa_stat_name(i),
 			   zone_numa_event_state(zone, i));


