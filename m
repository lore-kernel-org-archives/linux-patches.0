Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCB822D7B9;
	Thu,  2 Jul 2026 16:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011277; cv=none; b=bxmX7aXsnCfTK+HESFFezR1B55UY7PiKoyf39T9QxY9iloKkI5aZ1Zqd6DJX1vgp8z5sFGqgr7yGl1qFPTwCYdmcusZMcRr6ULspjGTgo5Ziwo5O3yooIEXU2cMg9pRDPpGd9bCQIFiNCVh+AHvfqfDE/6UERHVvAXP2xAPz4oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011277; c=relaxed/simple;
	bh=7DyiJqgXn8EwW8wSx2w7iiYNqym1dWIBXExESefp/1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zgc3xQ0EEBHcTLCw3b6N8wX2JDIy2dGU4x7/1+sJnzD/OfA6vy4Qu5cohoQTfcIxCyHEzguHxKw7Mq8/2j37ZtJ8WYOb+IPwTSoLiVnlPHT6WvhvKO9CCmeVKolnm37jvy/KkI3ZyoyryYRN6Eit8fYrAVWsRzF+U2s9p6H//hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=neFh47Pp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="neFh47Pp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672D21F000E9;
	Thu,  2 Jul 2026 16:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011275;
	bh=4MokhmZK6w4D5DqATZNIj8JZlSn3AGVSoNaFn5+0T+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=neFh47Pp66fi/HcrKD9cNrWQaGa/Hh935L2kleWyAYjKskpJUC3cfzUaG7/TxNpQa
	 YLNvaYKtoU7sH0m7bwAnVkmP4jpxcUdXW1W9MQ1REf4QJx2X4IlAn2Qau6d2mArq6a
	 tx+KYN3Ur+asVmO81mTziN3h3fFS1M7Lm7M0uOHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.18 045/108] KVM: arm64: Omit tag sync on stage-2 mappings of the zero page
Date: Thu,  2 Jul 2026 18:20:42 +0200
Message-ID: <20260702155113.040512770@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

commit 2986a625740599fe6e7635b0586fed2a95bcd1f7 upstream.

Commit

   f620d66af316 ("arm64: mte: Do not flag the zero page as PG_mte_tagged")

removed the PG_mte_tagged flag from the zero page, but missed a KVM code
path that may set this flag on the zero page when it is used in a
stage-2 CoW mapping of anonymous memory.

So disregard the zero page explicitly in sanitise_mte_tags().

Fixes: f620d66af316 ("arm64: mte: Do not flag the zero page as PG_mte_tagged")
Cc: stable@vger.kernel.org # 5.10.x
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/mmu.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1444,6 +1444,11 @@ static void sanitise_mte_tags(struct kvm
 	if (!kvm_has_mte(kvm))
 		return;
 
+	if (is_zero_pfn(pfn)) {
+		WARN_ON_ONCE(nr_pages != 1);
+		return;
+	}
+
 	if (folio_test_hugetlb(folio)) {
 		/* Hugetlb has MTE flags set on head page only */
 		if (folio_try_hugetlb_mte_tagging(folio)) {


