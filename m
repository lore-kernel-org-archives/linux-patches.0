Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E1B374A0F;
	Thu, 17 Sep 2026 17:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666211; cv=none; b=QiASKfGm4gZf8smmm1dUyDmX1W91RpcFiXSdvgwHtEiQTsfY5yipfS4uAF5uZmg7So/mpBpY3evN4OPfZ0It3z86WOi59rZ+q6cdKgqrkWpqKpZWY06hzHKhzwTaQ8UIUDmYn/onOmlfssbsCehMlYjhiYsK33mNvsKuCTJS6Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666211; c=relaxed/simple;
	bh=ilTlr3Q7/hxznNmiIlODd3ZOTrAsKOSnOSSLj47WHqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExJEo+DLKXRuuiKK2BlBcaEMZMUbO9nmE5BK41xc0Fc9BKFtgn/tPWXez1T0Q4rJ550tktQVtMm9nvkajgeRiHJIT37wicvrZlTTXCx3w9zul2LbBKbGqFJuKwuZjEvGejJYPhUI1bG4BVCmB/Z2q+9+aIQRYubFtaPMBp2jaWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRg51I3W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRg51I3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9A81F00893;
	Thu, 17 Sep 2026 17:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666209;
	bh=/l2mBeQtkHOg7yXLEznsQjDLCvF52d7QWpLG/uN36bU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vRg51I3Wu+MnX19BOMnHhvFXt4A3oMXGgKmfJ0dyrTeylLkkyT6TS4BV4+PTBCP7/
	 gBnrpaN29QO7EE1/C1o2gCaD71LCgGwC+LQO/RzqqzgJ9havwaBbOe8FsWq8HC1nwH
	 8tToSl0e00pm0x70aBOiThwh9tEi0x8X5vvhBPSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orson Peters <orsonpeters@gmail.com>,
	Vernon Yang <yanglincheng@kylinos.cn>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH 6.18 0961/1250] x86/mm: Fix user-space data loss with MADV_FREE and THP
Date: Thu, 17 Sep 2026 16:12:36 +0100
Message-ID: <20260917151618.062875917@linuxfoundation.org>
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

From: Vernon Yang <yanglincheng@kylinos.cn>

commit f7491d7c81db0e7c304a7bd757a76d2fbeaff80e upstream.

Some of users of Polars (a data analytics library) have lost production
data from this bug. They seem to have just the right combination of
huge pages, MADV_FREE and heavy reclaim pressure.

pmd_modify() masks the old value with (_HPAGE_CHG_MASK & ~_PAGE_DIRTY),
silently discarding the hardware dirty bit.  The subsequent
pmd_mksaveddirty() call is supposed to transfer _PAGE_DIRTY into
_PAGE_SAVED_DIRTY when write-protecting, but the dirty bit was already
stripped from the value, so there is nothing left to transfer.

Contrast with pte_modify(), which keeps _PAGE_DIRTY_BITS in its mask,
and pud_modify(), which keeps _HPAGE_CHG_MASK untouched: pmd_modify()
is the odd one out.  Any pmd_modify() on a writable, dirty PMD loses
the dirty state.

One visible consequence is data loss with MADV_FREE on PMD-mapped THP:

    memset(buf, 0x5A, size);          // PMD-mapped THP, PMD dirty
    madvise(buf, size, MADV_FREE);    // PMD cleaned but left writable,
                                      // folio marked lazyfree
    memset(buf, 0x5A, size);          // hardware sets _PAGE_DIRTY again
    mprotect(buf, size, PROT_READ);   // pmd_modify() drops the dirty bit
    mprotect(buf, size, PROT_READ|PROT_WRITE);
    // ... memory pressure ...

Reclaim (e.g. under memcg pressure) then finds the lazyfree folio with
no dirty bit set anywhere and frees it in
__discard_anon_folio_pmd_locked(), even though the data was rewritten
after MADV_FREE; subsequent reads fault in fresh zero pages.  NUMA
hinting alone can trigger the same loss, as do_huge_pmd_numa_page()
restores the PMD through pmd_modify() as well.

PMD-mapped file THPs are affected too: mprotect()/NUMA hinting dropping
the dirty bit means rewritten data is never written back.

Fix it by keeping _PAGE_DIRTY in the preserved mask, exactly like
pte_modify() and pud_modify() do.  The existing
pmd_mksaveddirty()/pmd_clear_saveddirty() pair then performs the
hardware-dirty <-> saved-dirty transition based on the write bit,
preserving the shadow-stack encoding rules.

Fixes: bb3aadf7d446 ("x86/mm: Start actually marking _PAGE_SAVED_DIRTY")
Closes: https://lore.kernel.org/r/CAJxLxMUGu1-L+O_nAONOwOXnS=cNbNApCWqdthRjd76LThtSPg@mail.gmail.com/
Reported-by: Orson Peters <orsonpeters@gmail.com>
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260903031608.1194238-1-vernon2gm@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -813,7 +813,7 @@ static inline pmd_t pmd_modify(pmd_t pmd
 	pmdval_t val = pmd_val(pmd), oldval = val;
 	pmd_t pmd_result;
 
-	val &= (_HPAGE_CHG_MASK & ~_PAGE_DIRTY);
+	val &= _HPAGE_CHG_MASK;
 	val |= check_pgprot(newprot) & ~_HPAGE_CHG_MASK;
 	val = flip_protnone_guard(oldval, val, PHYSICAL_PMD_PAGE_MASK);
 


