Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EED4C97;
	Tue, 11 Nov 2025 00:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822694; cv=none; b=n+kMZ8vqT3EWkoQWXrNEI8XrARRpnGdZ3dtVFItBNa1UvViUOiBOujNuvM1e+yBWUndo65TesToLOzGUak100SiAss068Uf8mTxvJSJ40bQMieiYvCEqQaxCdLjGmwzNWOzrkrjfNbs5T9TWDC0iefM0Xgs4BmVSZBOUjj03GPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822694; c=relaxed/simple;
	bh=Kj0iL01oUYaqP0hsZJdPyeRuuFU4d/ibAgtx0H8e3tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2JQSyxOFdn0YXX89MZG4cxbubdsGmYvfxHjqBG27ezijll6gxLUL7vrXGkyIjR33i+UqdrH5Z7CfxRXi9/0UupQJp49XwmDu1Lya1QCvIbbZ2IomgIuVeJi/51dap/w0xovlghgEbzPGSBBGfU8o8yxDk9LdYm3ojTt6GGL31E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hv3vADfU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hv3vADfU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAE3C4CEFB;
	Tue, 11 Nov 2025 00:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822694;
	bh=Kj0iL01oUYaqP0hsZJdPyeRuuFU4d/ibAgtx0H8e3tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hv3vADfUJcSXNvqz7ZTbjeNF/pW2Qt0qNZJryTc9TGxZkHjFqLXj4+cqVSS48xmTx
	 nqvx6TL0QZwhwu1BcKPmJj91oJpALm1yPNc2HHhy1EpXXuksn8ubDpY+iGADNgYtQD
	 tpQbZq8/iei6PzSQhipobp5zNpK5wsWLxm4lyQAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Capitulino <luizcap@redhat.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/565] s390: Disable ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
Date: Tue, 11 Nov 2025 09:39:03 +0900
Message-ID: <20251111004528.926371765@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 64e2f60f355e556337fcffe80b9bcff1b22c9c42 ]

As reported by Luiz Capitulino enabling HVO on s390 leads to reproducible
crashes. The problem is that kernel page tables are modified without
flushing corresponding TLB entries.

Even if it looks like the empty flush_tlb_all() implementation on s390 is
the problem, it is actually a different problem: on s390 it is not allowed
to replace an active/valid page table entry with another valid page table
entry without the detour over an invalid entry. A direct replacement may
lead to random crashes and/or data corruption.

In order to invalidate an entry special instructions have to be used
(e.g. ipte or idte). Alternatively there are also special instructions
available which allow to replace a valid entry with a different valid
entry (e.g. crdte or cspg).

Given that the HVO code currently does not provide the hooks to allow for
an implementation which is compliant with the s390 architecture
requirements, disable ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP again, which is
basically a revert of the original patch which enabled it.

Reported-by: Luiz Capitulino <luizcap@redhat.com>
Closes: https://lore.kernel.org/all/20251028153930.37107-1-luizcap@redhat.com/
Fixes: 00a34d5a99c0 ("s390: select ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP")
Cc: stable@vger.kernel.org
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -135,7 +135,6 @@ config S390
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_WANT_KERNEL_PMD_MKWRITE
 	select ARCH_WANT_LD_ORPHAN_WARN
-	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	select BUILDTIME_TABLE_SORT
 	select CLONE_BACKWARDS2
 	select DCACHE_WORD_ACCESS if !KMSAN


