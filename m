Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E011511E96;
	Wed, 30 Sep 2026 16:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787208; cv=none; b=L+q7iTnvBXkCEu8KBzX5BCcVzN8nRFd0eR++NVDjhdmk0ePKr4LUsFfpE7t+6c99H3lmx6Wu2MR8AFSZlSjmmCAmHv1zoOKB0zLzjddOIT0Cr9Y9caXnAaJIRYtCdWh07yue3m9/SUR0vPdzBlHWJ7T/ZfPCyvPaqLN5HLncTOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787208; c=relaxed/simple;
	bh=cZF0IvlM4VRaWkU22cuP6fS1x5kVNhRRwGgqmWw/OrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0tgxBJqUiAIk3pqmJk5HjNXN4Cys8Wbbm/v1vWLOZxL19N1d25P/F6tJQ4w9imRETKX62ble2lvqDE62bPvwh7gmEe4qom2oUgnblwZ0CRIRoMf4KNfmFYtAzmrTnYJlnk5aDSRBZMUE6lTPihT50NLAUo8TdiuUtcyv234HPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lICLjVKS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lICLjVKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F7E1F000FF;
	Wed, 30 Sep 2026 16:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787206;
	bh=2s9CBQmEOeggKuItvLaP04+aOzHcQUL1EV9wUcd/Kzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lICLjVKS4PC/hfTi4d7RK+94Y5qJ1FqzTSr7pV9SjbJEXJ+Lctj1wnJTeayg/DgAp
	 +5dLzIYJEUUWJAeQNuTGikuaT7NUyePYeZIKfBiADje4D95j1yXvxqy2RTfEocavu8
	 c5e0uPcwE35qU152byssPSh+wxvaiiC44u8642GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Schmaus <flo@geekplace.eu>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Matthew Leach <matthew.leach@collabora.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 147/457] PM: hibernate: Freeze kernel threads after image preallocation
Date: Wed, 30 Sep 2026 17:24:12 +0200
Message-ID: <20260930152349.225721360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Schmaus <flo@geekplace.eu>

[ Upstream commit 41112a787f9182c7f2d27122817861e3f22ef928 ]

Commit 783c81098445 ("PM: hibernate: call preallocate_image() after freeze
prepare") moved hibernate_preallocate_memory() after dpm_prepare() so
that device drivers have the opportunity to release pinned/unswappable
memory during their ->prepare() callback before memory is preallocated
for the snapshot image.

However, that commit also placed hibernate_preallocate_memory() after
freeze_kernel_threads(). While it was assumed during review that swap
I/O submitted via submit_bio() is synchronous and would not depend on
frozen kernel threads, this does not hold in practice. Calling
hibernate_preallocate_memory() with kernel threads frozen leads to
intermittent deadlocks during hibernation.

Inside hibernate_preallocate_memory(), shrink_all_memory() is invoked with
.may_writepage = 1 and .may_swap = 1 to aggressively reclaim and swap out
pages. Any writeback or swap I/O that relies on freezable kernel threads,
block device helpers, or WQ_FREEZABLE workqueues (such as those in storage
drivers, device mapper, or filesystems) deadlocks waiting on tasks that
are stuck in the refrigerator.

Fix this by reordering hibernation_snapshot():
 1. Call dpm_prepare(PMSG_FREEZE) first, allowing device drivers to
    release pinned resources while kernel threads are still active.
 2. Call hibernate_preallocate_memory() second, performing page
    reclaim and swapout while storage layers, workqueues, and kernel
    threads are alive.
 3. Call freeze_kernel_threads() third, only after all memory
    preallocation and swap I/O have completed.

Additionally, restore the call to swsusp_free() in the cleanup path so
that preallocated image memory is properly freed if freeze_kernel_threads()
fails or if TEST_FREEZER is enabled.

Fixes: 783c81098445 ("PM: hibernate: call preallocate_image() after freeze prepare")
Signed-off-by: Florian Schmaus <flo@geekplace.eu>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Tested-by: Matthew Leach <matthew.leach@collabora.com>
Reviewed-by: Matthew Leach <matthew.leach@collabora.com>
Link: https://patch.msgid.link/20260920-fix-hibernation-v1-1-f9940c2d7d7f@geekplace.eu
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/hibernate.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index d2479c69d71a4..c13f68ab7f6e0 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -408,9 +408,18 @@ int hibernation_snapshot(int platform_mode)
 	if (error)
 		goto Close;
 
+	error = dpm_prepare(PMSG_FREEZE);
+	if (error)
+		goto Complete;
+
+	/* Preallocate image memory before freezing kernel threads and shutting down devices. */
+	error = hibernate_preallocate_memory();
+	if (error)
+		goto Complete;
+
 	error = freeze_kernel_threads();
 	if (error)
-		goto Close;
+		goto Cleanup;
 
 	if (hibernation_test(TEST_FREEZER)) {
 
@@ -422,15 +431,6 @@ int hibernation_snapshot(int platform_mode)
 		goto Thaw;
 	}
 
-	error = dpm_prepare(PMSG_FREEZE);
-	if (error)
-		goto Complete;
-
-	/* Preallocate image memory before shutting down devices. */
-	error = hibernate_preallocate_memory();
-	if (error)
-		goto Complete;
-
 	console_suspend_all();
 	pm_restrict_gfp_mask();
 
@@ -464,10 +464,12 @@ int hibernation_snapshot(int platform_mode)
 	platform_end(platform_mode);
 	return error;
 
- Complete:
-	dpm_complete(PMSG_RECOVER);
  Thaw:
 	thaw_kernel_threads();
+ Cleanup:
+	swsusp_free();
+ Complete:
+	dpm_complete(PMSG_RECOVER);
 	goto Close;
 }
 
-- 
2.53.0



