Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16694DEC26;
	Wed, 30 Sep 2026 18:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792526; cv=none; b=B9DUuG0IvesUxy5befYE2qcbmXNyaU+gES9y2kSU1fBjOcxSQvABEiqzP4UrbF64uEt2dUAo/XQhzQtSGztsndb2X7x95sRjTTd2uZGPlA3LOSOP1yhH2vKv9dlJz3+Jd9c9T/zkLeOKkRV4xS/NqfIZjnASDT2UdKIcVkq7dj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792526; c=relaxed/simple;
	bh=1KlVoyZCNRXtLCOwaJQfmvqKWkPaPFvvlJGKVZ5Shsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6sqLKq3ARCE/zsk8L0CZupH5fpkPU8rv4+NOoHmfDRZLfWdENHVEJeL5e0cSxDiLgyGn1aad+zuKFu5qn4TD3X4y7cB/7sGQnfH4L+bki+IgB6FW1y+Sk+Wh83Tz/fsZsmTam0YoxPR5P3hKNZp4bC9mPVMG6F8TIMHiRZokMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pFIoeX9v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pFIoeX9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193AD1F000FF;
	Wed, 30 Sep 2026 18:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792525;
	bh=kJn5p+HW69KUarmji2EnoIVbG6gWEWECyICF/PB4Kyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pFIoeX9vytV4vaP/aXZuj/VW8uDYO7pBwvy/n1AoU8msf1xNrCohsSs2w/i7uu5I6
	 QE0N+iF6gnLReUtcXDGD4Bpg7eYnbapa78rS2OftrQgOhGxx6BuQTGbX0hbKLDiG4U
	 nhlraJs//QfB3PvIqrYYhigcKScw/TxDPnE2ZT18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lai Jiangshan <laijs@linux.alibaba.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Kenta Akagi <k@mgml.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 685/752] KVM: X86: Calculate quadrant when !role.gpte_is_8_bytes
Date: Wed, 30 Sep 2026 17:29:15 +0200
Message-ID: <20260930152413.063688682@linuxfoundation.org>
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

From: Lai Jiangshan <laijs@linux.alibaba.com>

commit b46a13cb7ea1137b2e01dfaafcacd5cd79db8390 upstream.

role.quadrant is only valid when gpte size is 4 bytes and only be
calculated when gpte size is 4 bytes.

Although "vcpu->arch.mmu->root_level <= PT32_ROOT_LEVEL" also means
gpte size is 4 bytes, but using "!role.gpte_is_8_bytes" is clearer

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Message-Id: <20211118110814.2568-15-jiangshanlai@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kenta Akagi <k@mgml.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f6ad81b5e6377..62e9a7db01830 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2094,7 +2094,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	role.level = level;
 	role.direct = direct;
 	role.access = access;
-	if (!direct_mmu && vcpu->arch.mmu->root_level <= PT32_ROOT_LEVEL) {
+	if (!direct_mmu && !role.gpte_is_8_bytes) {
 		quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
 		role.quadrant = quadrant;
-- 
2.53.0



