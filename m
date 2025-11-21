Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1212351FBA;
	Fri, 21 Nov 2025 13:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732247; cv=none; b=cfKUm9d4j7zNoSoXcbKh87qemVl7uV6ggjgUMRLT8Wy/T5GYLDwaonrdZ34poHhbjW6Dc7M5HM6YoUrCurvszxI3SGDdT3/yXdsExdBKYzjNPOnAUsJdkDBv55F+bgEv5dut8ysrAZRJLxnjc5D3ynfxI3woAB0a89Lfm7uknaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732247; c=relaxed/simple;
	bh=156CL9nTebgNYvh9oA9yMApbdYq2o7HjnUz1is/lxd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1mGCXLHxGL2qOtMafR2UrwBYJ0BzQqzY/Eic1XayD4UitHoZI7YYh/9HBVyOJT809PRpy5NYt/BytJLcV0b53ylO+5FLY7K63rl71X73hUXwbwjv+sj/sA373u4bsU5nzj7GumGLuKEzQjnEVWcZ2S5osYf/n7fd53iQ/MRoLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRZhhLXx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRZhhLXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FD9C4CEF1;
	Fri, 21 Nov 2025 13:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732247;
	bh=156CL9nTebgNYvh9oA9yMApbdYq2o7HjnUz1is/lxd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CRZhhLXxS/ZKsEC5tYljW4/4vSsgmN5XP6StoHg6r4KllHN3blQa17KK/9RdyBrcH
	 2Mu9V/PHPvgr0KEgBicXc/5VGed0uniUggeByZWI9Y4pIuOxJn9lJKPgpSd5Qowmtf
	 LHebntT5BouQYlsRg5wZHvFKIBahHpoiS6JLvlM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Capitulino <luizcap@redhat.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.6 053/529] s390: Disable ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
Date: Fri, 21 Nov 2025 14:05:52 +0100
Message-ID: <20251121130232.900855114@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
[ Adjust context ]
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -128,7 +128,6 @@ config S390
 	select ARCH_WANT_DEFAULT_BPF_JIT
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_WANT_KERNEL_PMD_MKWRITE
-	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	select BUILDTIME_TABLE_SORT
 	select CLONE_BACKWARDS2
 	select DMA_OPS if PCI


