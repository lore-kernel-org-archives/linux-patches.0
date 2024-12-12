Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FCF22E9EB;
	Thu, 12 Dec 2024 16:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021609; cv=none; b=d4C3C06Rs7KarpOolADVR4nEF1LHvLe1x51pvbCD7s0XjMpdiHLeL9frAx9WIqDJ/BmNwpE3EKYFScb+PMLK7hvHmRDv9P1aETqc1/hMznROWDJcoOvC/kthhy/dz0qTyDOcn0vr5z1C7SNoInev/AVRvnR5ARNSJVBvMKMOLLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021609; c=relaxed/simple;
	bh=W58mrVLO8UulDpbopUik83t4dKXPPCFHBVLMTZ53PkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgW+aqjf1iNMOGEWnsGTJQYOEyabRUcCAcKecyQCRLcuJ4uqwNt/sK8VSRVWkwS67Fns6mP9/eUCnHGcjAGSLPJbbQMIMYAjp9QbHTifx0YBMWpou7YO5q9EaCDAxLkPhgjEeLW2Tt7/e8G4A/JIqeKu5OmfXMcJ7K/hzq+ekMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxVa/uXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxVa/uXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B4BC4CECE;
	Thu, 12 Dec 2024 16:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021609;
	bh=W58mrVLO8UulDpbopUik83t4dKXPPCFHBVLMTZ53PkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxVa/uXPA/e1+ALCmuysVBRTTaSbVWV1c5M3wh8/1YgM4124CYl7SVJSVXoCAvKoT
	 VU1vV+ZY37xJwV1QbWB4DQW0bQC4TQNcUx3ijEDgtmmoS8NAMd9BcGv7xfJdHdu5d0
	 XTgwEMXpKJdjWiM/mFRcp+jOw9nSXADf2tnN0Uzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MengEn Sun <mengensun@tencent.com>,
	JinLiang Zheng <alexjlzheng@tencent.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 013/565] vmstat: call fold_vm_zone_numa_events() before show per zone NUMA event
Date: Thu, 12 Dec 2024 15:53:28 +0100
Message-ID: <20241212144311.976105298@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1690,6 +1690,7 @@ static void zoneinfo_show_print(struct s
 			   zone_page_state(zone, i));
 
 #ifdef CONFIG_NUMA
+	fold_vm_zone_numa_events(zone);
 	for (i = 0; i < NR_VM_NUMA_EVENT_ITEMS; i++)
 		seq_printf(m, "\n      %-12s %lu", numa_stat_name(i),
 			   zone_numa_event_state(zone, i));


