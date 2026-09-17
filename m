Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E885519E03;
	Thu, 17 Sep 2026 17:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667106; cv=none; b=ORb176otMmUrijl4qvDLeVyPnheLWpLCRZkGdLvgxIYVLNzCmaG2HM18MWMB+vqiASAtbhH2qHgXATwe/73Rq8JKjkZAgziGp/1dAYAAU7ya7EpjkE05FfIee7Z8eKDNEx3DLz2blOwtTEnI4ComIuR91annmb3rIeX/u6wBG8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667106; c=relaxed/simple;
	bh=v1CG7IzhGqKAegl2Uesd/r6T70OI1JqjlYPQ4c1JX6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSJJOdvCBBiSjk57YPWWU5QxgDuyUvhhqPkLXYqnENo2d0NN6PikKi/D4IpJx0PGUiM94MaUCa8HHa1xXZcN6LgC4hZePleGUH8fm/vfyO8Sek2DNpPo4dHW3dQQ48X9Hd8b2fes8oexclFE2l0Em4mX7i/4Q8nGm6GRP3JsoFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGcyOFQy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGcyOFQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204521F000FF;
	Thu, 17 Sep 2026 17:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667104;
	bh=Fm+FUmkrScck8uL9rP+y7btiER7YpX7lhRMo/VutFQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iGcyOFQygcCDDYm/SPmwMSjHNto6lmFus3WWlhLyqWlgelfifTVPQCUkPo+jwuW1t
	 m3QKlqSUNc1DUddqWG6qQlxWi8v8II/YnnTJGLyT3j02NkBQTyUo8caC7ZJgnPMVI5
	 enZuTEO2Dnayyk8kHM8/meq+mwD2OAXOFBFl4FpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@intel.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1193/1250] x86/mm/pat: Dont gate cpa_lock on debug_pagealloc_enabled()
Date: Thu, 17 Sep 2026 16:16:28 +0100
Message-ID: <20260917151624.620358319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

[ Upstream commit 5fce67641a3ed9a0782eaa228ddece526461a367 ]

The splitting and merging of kernel page table mappings between small and
large is protected by cpa_lock. The merging is relatively new but the
splitting is ancient.

The splitting has a locking optimization: since DEBUG_PAGEALLOC forces all
mappings to 4k, there are no large pages to split. So the code that *might*
cause a split can just skip the locking (and a few other things).

This is entertaining, but it adds complexity and makes for weird locking
rules. Plus it's all for a debugging feature which makes the kernel super
slow in the first place. Optimizing something which is already super slow
and not used in production is not the best way to spend our complexity
budget.

Stop gating cpa_lock on debug_pagealloc_enabled() to simplify the code
and the locking rules.

[ dhansen: flesh out changelog ]

Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://patch.msgid.link/20260715144519.934289-1-rppt@kernel.org
Link: https://lore.kernel.org/all/aab44f08-89f8-47fe-bee4-0ab6b25968c6@intel.com/
Stable-dep-of: 9e4a3ec3411b ("x86/mm/pat: Allocate split page tables as kernel page tables")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pat/set_memory.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -63,10 +63,9 @@ enum cpa_warn {
 static const int cpa_warn_level = CPA_PROTECT;
 
 /*
- * Serialize cpa() (for !DEBUG_PAGEALLOC which uses large identity mappings)
- * using cpa_lock. So that we don't allow any other cpu, with stale large tlb
- * entries change the page attribute in parallel to some other cpu
- * splitting a large page entry along with changing the attribute.
+ * Serialize cpa() using cpa_lock so that we don't allow any other cpu, with
+ * stale large tlb entries, to change the page attribute in parallel to some
+ * other cpu splitting a large page entry along with changing the attribute.
  */
 static DEFINE_SPINLOCK(cpa_lock);
 
@@ -1248,11 +1247,9 @@ static int split_large_page(struct cpa_d
 {
 	struct ptdesc *ptdesc;
 
-	if (!debug_pagealloc_enabled())
-		spin_unlock(&cpa_lock);
+	spin_unlock(&cpa_lock);
 	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
-	if (!debug_pagealloc_enabled())
-		spin_lock(&cpa_lock);
+	spin_lock(&cpa_lock);
 	if (!ptdesc)
 		return -ENOMEM;
 
@@ -2024,11 +2021,9 @@ static int __change_page_attr_set_clr(st
 		if (cpa->flags & (CPA_ARRAY | CPA_PAGES_ARRAY))
 			cpa->numpages = 1;
 
-		if (!debug_pagealloc_enabled())
-			spin_lock(&cpa_lock);
+		spin_lock(&cpa_lock);
 		ret = __change_page_attr(cpa, primary);
-		if (!debug_pagealloc_enabled())
-			spin_unlock(&cpa_lock);
+		spin_unlock(&cpa_lock);
 		if (ret)
 			goto out;
 


