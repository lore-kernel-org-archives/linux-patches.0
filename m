Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A57F46EF88;
	Tue, 21 Jul 2026 20:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665075; cv=none; b=tFtChV9ZumjHUolYiUsPeP0b1hQhozDkW1cn/MUnIyrT3KpFOUBmAXBBFHZ4SQWUogsxjfTy6ONxd7YUgvLD021Z6h9ZWFZ3nYryz3VhxvhnzUc0NyXYyY7twNcSp+1uCrnVn2JfFmYSnwCuy3/BtvQb4K2JOQywq1mhFIycBRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665075; c=relaxed/simple;
	bh=jXbZPa6YapHVYgEJEL6Dic7wQLer6z46hqMPPRDIFvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqinwRcBjXDvWFAOJBgHk5s7K7VgMz8rkfBdZosI6TFJefunTy0wf6CgkBr8VvzjMefCvY2rWGbN2daogpui9DVqpn2eghkxPVDCITc/9ATw8idytzYaZ6hXLw/2fGSIVnMv70W/k2TsvHlgzkUq7OwxZcty/N5jYV/ByAIphnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mkSiFkqQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mkSiFkqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD881F000E9;
	Tue, 21 Jul 2026 20:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665074;
	bh=tpikDl8Ipl4qqcVOS8zMUFxtwzo8W7OdliaVZ0kiGhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mkSiFkqQZ3pwJAIBrOOmeWTMDp38hh3RSDApn8x1p1xRLC9XyBMeRz4E9PVpw44Dy
	 jTzvlq6JcSd/0FJ23YvdTqVsLzvE1j/mT/p1DH9lk1z0b+19AA+oVSNY0t2OMT5TQb
	 tLV+93+7i33wVFeOFJt7lzNHr0+xx2bSgq2Rs96Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 0166/1266] mm: shrinker: fix NULL pointer dereference in debugfs
Date: Tue, 21 Jul 2026 17:10:03 +0200
Message-ID: <20260721152445.521073409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qi Zheng <zhengqi.arch@bytedance.com>

commit e30453c61e185e914fde83c650e268067b140218 upstream.

shrinker_debugfs_add() creates both "count" and "scan" debugfs files
unconditionally.

That assumes every shrinker implements both count_objects() and
scan_objects(), which is not guaranteed.  For example, the xen-backend
shrinker sets count_objects() but leaves scan_objects() NULL, so writing
to its scan file calls through a NULL function pointer and panics the
kernel:

BUG: kernel NULL pointer dereference, address: 0000000000000000
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
Call Trace:
 <TASK>
 shrinker_debugfs_scan_write+0x12e/0x270
 full_proxy_write+0x5f/0x90
 vfs_write+0xde/0x420
 ? filp_flush+0x75/0x90
 ? filp_close+0x1d/0x30
 ? do_dup2+0xb8/0x120
 ksys_write+0x68/0xf0
 ? filp_flush+0x75/0x90
 do_syscall_64+0xb3/0x5b0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

The count path has the same issue in principle if a shrinker omits
count_objects().

To fix it, only create "count" and "scan" debugfs files when the
corresponding callbacks are present.

Link: https://lore.kernel.org/20260617090052.27325-1-qi.zheng@linux.dev
Fixes: bbf535fd6f06 ("mm: shrinkers: add scan interface for shrinker debugfs")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shrinker_debug.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/shrinker_debug.c
+++ b/mm/shrinker_debug.c
@@ -198,10 +198,12 @@ int shrinker_debugfs_add(struct shrinker
 	}
 	shrinker->debugfs_entry = entry;
 
-	debugfs_create_file("count", 0440, entry, shrinker,
-			    &shrinker_debugfs_count_fops);
-	debugfs_create_file("scan", 0220, entry, shrinker,
-			    &shrinker_debugfs_scan_fops);
+	if (shrinker->count_objects)
+		debugfs_create_file("count", 0440, entry, shrinker,
+				    &shrinker_debugfs_count_fops);
+	if (shrinker->scan_objects)
+		debugfs_create_file("scan", 0220, entry, shrinker,
+				    &shrinker_debugfs_scan_fops);
 	return 0;
 }
 


