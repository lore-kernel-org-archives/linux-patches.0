Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE1C502D5A;
	Wed, 30 Sep 2026 18:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792552; cv=none; b=msfpMoZs7Vt4GV1ezPdgNQv9QaOWxqnOQjnIE8e4qz3h2HIbgt5PSOOvdg2p8JJpsEPcHJOskYw1ErNzIOgeVI66FeWGLQnlYPlWuxc4DWzMIf7OVr7SU3mxW4G8SYowKbQgJAB9hthqf9Df0Jhc9OW2RzRKVUT0/mF3kfY///g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792552; c=relaxed/simple;
	bh=5dWU1h0E7OBYKjmiQHPDafgJSxgOuPJsLt6WkP7prGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PY5POodUoIq3twm953GLl05K0YIMZZ9+VpxrID+Fsmi8i1YZET/dGj8CdWltfPZTzSRPZYTRR/sr/Me22g9jQ7nhzfsbXvPcBPznxhVKuFAqCdqIzbMh9qw43zj5Fy2RJjct4Z9PX6Tj6DiHAWfj7TknAdMeqPAISqOF86tV44g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=guW48CxU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="guW48CxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9A71F000FF;
	Wed, 30 Sep 2026 18:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792551;
	bh=557UmblKVQiQBKOfzmiipYADxRMjsUOGFWsEXNvvsQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=guW48CxUDZB73y0LWz1nk9o9LGfWmy0m8N7ChnDwW6feTXJIJ82FOaGMsa+a3mNkb
	 VRS8L4yLrn3vPzouIMDX3VreTryqCptv8+l77tuyP5CVYSjd8zIXs/R0lQPwQUvNG3
	 GysMjWDhA7hmNzAwXPRXp2uvoo8BbKrzlP8CR6RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@intel.com>,
	Seth Forshee <sforshee@kernel.org>,
	Eric Hagberg <ehagberg@janestreet.com>,
	Stephen Dolan <sdolan@janestreet.com>,
	Sasha Levin <sashal@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.15 693/752] x86/mm: Fix check/use ordering in switch_mm_irqs_off()
Date: Wed, 30 Sep 2026 17:29:23 +0200
Message-ID: <20260930152413.232630046@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Dolan <sdolan@janestreet.com>

This is a stable-specific fix. There is no single upstream commit to
cherry-pick; the equivalent mainline fix is commit 83b0177a6c48
("x86/mm: Fix SMP ordering in switch_mm_irqs_off()"), which is in
v6.18 but does not apply to these trees because the surrounding code
was refactored.

The backports of commit fea4e317f9e7 ("x86/mm: Eliminate window where
TLB flushes may be inadvertently skipped") -- the fix for
CVE-2025-37964 -- to the 6.1, 6.6 and 6.12 trees ended up with two
code blocks in the wrong order relative to mainline. The fix depends
on setting cpu_tlbstate.loaded_mm to LOADED_MM_SWITCHING *before*
reading tlb_gen, so that a concurrent TLB shootdown either sees
LOADED_MM_SWITCHING and sends the IPI, or the switching CPU sees the
updated tlb_gen. In the stable trees the write of LOADED_MM_SWITCHING
was placed after the tlb_gen read, so the race window fea4e317f9e7 was
meant to close is still open and CVE-2025-37964 is unfixed there:
a process can be left running with stale TLB entries, which typically
manifests as rare, hard-to-bisect memory corruption or segfaults.

This has been confirmed by several independent parties:

  - reproduced on 6.1.y/6.6.y/6.12.y with the test program in [1],
    and confirmed fixed by this patch
  - Seth Forshee saw segfaults on 6.12.y within ~30 minutes of running
    a test workload; with this patch it ran 18 hours cleanly [2]
  - Greg Thelen reports 6.6.y- and 6.12.y-based test failures fixed by
    this patch [3]

Dave Hansen acked the patch [4] and has no objection to it going into
stable [5].

The patch below is against 6.12.y; the identical change applies to
6.1.y and 6.6.y. (The cpumask_test_cpu()/smp_mb() portion of the
mainline fix is not needed here because commit 209954cbc7d0
("x86/mm/tlb: Update mm_cpumask lazily") was never backported to these
trees.)

[1] https://lore.kernel.org/lkml/CAHDw0oGd0B4=uuv8NGqbUQ_ZVmSheU2bN70e4QhFXWvuAZdt2w@mail.gmail.com/
[2] https://lore.kernel.org/lkml/aZYWXe739XUJrBld@do-x1carbon/
[3] https://lore.kernel.org/lkml/CAHH2K0brx9omC9QYyB6Lio3t_1Lf8v=VaFoiaG23UgQ-aec89Q@mail.gmail.com/
[4] https://lore.kernel.org/lkml/281e8018-5506-4a79-8775-e0de7e58b95f@intel.com/
[5] https://lore.kernel.org/lkml/86421ee5-5332-46c2-bb48-d40310b818be@intel.com/

Fixes: fea4e317f9e7 ("x86/mm: Eliminate window where TLB flushes may be inadvertently skipped")  # 6.1.y/6.6.y/6.12.y backports
Acked-by: Dave Hansen <dave.hansen@intel.com>
Tested-by: Seth Forshee <sforshee@kernel.org>
Tested-by: Eric Hagberg <ehagberg@janestreet.com>
Signed-off-by: Stephen Dolan <sdolan@janestreet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[Lee: The v5.15.y backport of fea4e317f9e7 (12f703811af0) placed the
      LOADED_MM_SWITCHING write after the tlb_gen read too, so v5.15.y
      suffers from the same issue.  Applies cleanly]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/tlb.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 11a43d373baee..f6e541c24ae2d 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -596,6 +596,14 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
 		 */
 		cond_mitigation(tsk);
 
+		/*
+		 * Indicate that CR3 is about to change. nmi_uaccess_okay()
+		 * and others are sensitive to the window where mm_cpumask(),
+		 * CR3 and cpu_tlbstate.loaded_mm are not all in sync.
+		 */
+		this_cpu_write(cpu_tlbstate.loaded_mm, LOADED_MM_SWITCHING);
+		barrier();
+
 		/*
 		 * Stop remote flushes for the previous mm.
 		 * Skip kernel threads; we never send init_mm TLB flushing IPIs,
@@ -615,14 +623,6 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
 		next_tlb_gen = atomic64_read(&next->context.tlb_gen);
 
 		choose_new_asid(next, next_tlb_gen, &new_asid, &need_flush);
-
-		/*
-		 * Indicate that CR3 is about to change. nmi_uaccess_okay()
-		 * and others are sensitive to the window where mm_cpumask(),
-		 * CR3 and cpu_tlbstate.loaded_mm are not all in sync.
- 		 */
-		this_cpu_write(cpu_tlbstate.loaded_mm, LOADED_MM_SWITCHING);
-		barrier();
 	}
 
 	if (need_flush) {
-- 
2.53.0



