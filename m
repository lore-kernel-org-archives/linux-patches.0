Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8605D43634C;
	Tue, 21 Jul 2026 20:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665518; cv=none; b=NnO0FoXkZyDUuDuNptX9dJi6mpaxe+ZHfT4Vf4BsAqF7I36n8HHSCZaR/xwsI0fR7D1BBDiXosA2VEoOfIcsbXJLMNXfLauApGaM4dZxnUXV+4S9xWb77nDonRZgk4uDcL2VRRwdwuZEWrmkbcDT/2pg55j7PBY0lgZf98ibFyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665518; c=relaxed/simple;
	bh=C7QnpUwUW+N1pcxFnSS3KPRJIJ/6mcC+oGQhJKsad4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HyrhA+Rc8BMbhX6VFR4o/QMaXeXAdN4sEfxqlEvwujDNLHHQ7UZ/oqwtAvZgiS2b6yi7kiSW/ts12phs06/x5jsGWsmhZFrKSxQrgbZrWHNefCHRznWeuik/J2a/boALMLFZfukWt97zQlce+l621TYR+a5Y4LZs0TVrc7yvE9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/wQf55e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/wQf55e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD6E1F000E9;
	Tue, 21 Jul 2026 20:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665517;
	bh=oD//nFH62wcEG5LJVBNkWMYrkIyI5jzC4sbwHudJPgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A/wQf55exEhZSdOgjmvo2rdF/La2dRlw7RqNQo8/pAH0TriMVJFDZu70cFdOlY3th
	 zux0fV+IMF4znCGHjSJzlbmLuDIkFMxvXx0CfK1yGAIppU9Ou0HVk2iYqnZ+hWksFA
	 geNNSEGMXvPCrB0fUOw+aUzAfdJmC1YCLg/6k+Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@intel.com>,
	Seth Forshee <sforshee@kernel.org>,
	Eric Hagberg <ehagberg@janestreet.com>,
	Stephen Dolan <sdolan@janestreet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0335/1266] x86/mm: Fix check/use ordering in switch_mm_irqs_off()
Date: Tue, 21 Jul 2026 17:12:52 +0200
Message-ID: <20260721152449.330337538@linuxfoundation.org>
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
---
 arch/x86/mm/tlb.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 20ce6a1bd6c57d..19e995f58d6321 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -612,6 +612,14 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
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
@@ -629,14 +637,6 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
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
 
 	new_lam = mm_lam_cr3_mask(next);
-- 
2.53.0



