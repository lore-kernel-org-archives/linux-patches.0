Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829110;
	b=GJ1wk5+va+6BqR/G65ofvTA9IgTl8TeXCyXvMWlv5eeYjb5is9KY6K3Y2+y+frULQAgj
	 U3oAfsW18S87iDf0wKvcR1Qq5BvQG1h1FFyf8WgRS04v/NmwrSUB8Uk0dUwv/aWIncQG2
	 eAlPlDzjWC7akXCdNzURMK0xO4pinnBbP1nXkM/YAxiPW7AKf9hUM9zihcIgLQWQJVW9i
	 964IrY9KMxpIuGgOeX412u2z/7pMb95vsfaLwnetbqeQnhbiU1ctCXWCk1jJxSUTd6TrV
	 XEZl+wAr4rzGE5OfHp//m/A8+EOWIMuU2RxFVyCt3wTUZSjZK1lmbCJuf4/9ipPKKSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=19VqxPuxk7aOKyJhn8YT1Ce/Gxd7pdLsaojrsNzEMLM=;
	b=sTVf75KeBAkR1qMAlt7c+5G2k+yxtbpKx5Tae1AD1j+30OQvmdd99fUrx1KhNxu76rXa
	 LmPRoojVb6uavA9TgUPKXb/lGzs8wM2VWBH8o6TlHTqitZeAVrGYqaTAv/GKLiI03h1E9
	 CX2OF8PA/qpyw+9X6GUpuPGEVwgIMogMJ7Her07EtRRPIg5eF3pQrLhSUIpDfWu3fH//v
	 An1SYH6lxzhuVCJEWYtlBWbKBKYIdsleLXiPkaHKGDcs/krBYI7AFzcmi5Ma/Quzn8XK/
	 sbgkhyBALjYWJuB3BEfP+Pc61RP+R+o65EG2dwr6InNxWVZpNgIhB5U7O/GT48kpNJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0OzynzaI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7031C6070757;
	Wed,  4 Nov 2026 21:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0OzynzaI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165681F00919;
	Wed,  4 Nov 2026 21:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829110;
	bh=19VqxPuxk7aOKyJhn8YT1Ce/Gxd7pdLsaojrsNzEMLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0OzynzaIUHhtgukllUChLk4EGhFapx4RJp4VMM+PnpgjZJ6sJXFBgSjxdv3/dbqHZ
	 lqY9OdhyywCuLv94etuSP7cyH0ITyQ1byzCEiOcyyw4JNDTF39CeeY9jUCqP83p6io
	 VNRza6QV44j0pY7Ynbael1OKTYMjfudDUalz7Tl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Juergen Gross <jgross@suse.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	syzbot@syzkaller.appspotmail.com,
	Atish Patra <atishp@meta.com>,
	Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH 7.3 452/547] x86/mm/pat: Fix effective RW computation in lookup_address_in_pgd_attr()
Date: Wed,  4 Nov 2026 16:10:36 -0500
Message-ID: <20261104211051.197401969@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

commit ebaf7c9bbb1e16523d7036e7e1225ad2dfcc6482 upstream.

lookup_address_in_pgd_attr() accumulates the effective NX and RW bits of
the walked page table levels so that verify_rwx() can detect mappings that
are both writable and executable.

The RW bits are folded into a bool with

	rw &= pXd_flags(*pXd) & _PAGE_RW;

but _PAGE_RW is 0x2. So consider the accumulation line:

        rw &= pXd_flags(*pXd) & _PAGE_RW;

where rw=0x1 and the right side evaluates down to 0x2. It'll end up doing:

        rw = 0x1 & 0x2

and rw always ends up 0.

This way rw becomes false at the first level walked, regardless of the
actual permissions, and verify_rwx() treats every mapping as non-writable
and never reports a W^X violation.

Add double negation to the right side to normalize the _PAGE_RW flag to
0 or 1.

Assisted-by: Copilot:claude-opus-4.8
Fixes: ceb647b4b529 ("x86/pat: Introduce lookup_address_in_pgd_attr()")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: syzbot@syzkaller.appspotmail.com
Tested-by: Atish Patra <atishp@meta.com>
Tested-by: Nikunj A Dadhania <nikunj@amd.com>
Cc:stable@vger.kernel.org
Link: https://patch.msgid.link/20260813-cpa-fixes-v2-5-39b4ff90f91d@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pat/set_memory.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -754,7 +754,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t
 
 	*level = PG_LEVEL_512G;
 	*nx |= pgd_flags(*pgd) & _PAGE_NX;
-	*rw &= pgd_flags(*pgd) & _PAGE_RW;
+	*rw &= !!(pgd_flags(*pgd) & _PAGE_RW);
 
 	p4d = p4d_offset(pgd, address);
 	if (p4d_none(*p4d))
@@ -765,7 +765,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t
 
 	*level = PG_LEVEL_1G;
 	*nx |= p4d_flags(*p4d) & _PAGE_NX;
-	*rw &= p4d_flags(*p4d) & _PAGE_RW;
+	*rw &= !!(p4d_flags(*p4d) & _PAGE_RW);
 
 	pud = pud_offset(p4d, address);
 	if (pud_none(*pud))
@@ -776,7 +776,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t
 
 	*level = PG_LEVEL_2M;
 	*nx |= pud_flags(*pud) & _PAGE_NX;
-	*rw &= pud_flags(*pud) & _PAGE_RW;
+	*rw &= !!(pud_flags(*pud) & _PAGE_RW);
 
 	pmd = pmd_offset(pud, address);
 	if (pmd_none(*pmd))
@@ -787,7 +787,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t
 
 	*level = PG_LEVEL_4K;
 	*nx |= pmd_flags(*pmd) & _PAGE_NX;
-	*rw &= pmd_flags(*pmd) & _PAGE_RW;
+	*rw &= !!(pmd_flags(*pmd) & _PAGE_RW);
 
 	return pte_offset_kernel(pmd, address);
 }


