Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA58D22DFB1;
	Mon, 10 Mar 2025 17:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628543; cv=none; b=AKKb6CnWLZVK52vP2FXZgcT7QRsaHbl6AyEsGLnona06eQp+fm5Jo8TDWV0ByrSdid7d0O5vsCTLk808ceBO3iVZTBUSdD26D/ZjtvJwui8NeSjrp9S41lwESLSiNOS132ts6aFY6ahwFKNfQRPcx1lxBHR7/AvVmdLdqtefp9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628543; c=relaxed/simple;
	bh=8TmOCwUd+xcOuj7U3/oHpM+97ScokATSwkhRX3Uwop8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIZumsK26GiwKFCAcF4DBOftSu0liEvBkXss1/7AgJaD7UbuLnQixjN4o5HeVz5TmSsJznrTyM+2qhdI0nnkXMoPas3rOY3LB1ZPamjLQ4B/KQNFWpkt5w2I0veOFz1zGAqT0WgZcIJ3XeBW6Jch8PM/J0RZZh4Cz0fpJ47ZEtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojc+mI1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojc+mI1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2730AC4CEE5;
	Mon, 10 Mar 2025 17:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628543;
	bh=8TmOCwUd+xcOuj7U3/oHpM+97ScokATSwkhRX3Uwop8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojc+mI1M52YrHyaQH+Li6EUANvIb8GAn3r0bK1Q7oFQf24jB3MGh4pGC+0M/LEOLB
	 sVkASrh32EX1FFcJc5FpmcGA/7Th/vTr8O26iD+ifQjCUTlMjHgJAgswm0t485+OEB
	 1svS98gPjmoKeJjz26Cg2M4fXgtpuTHAFd7p3juo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 095/109] Revert "KVM: PPC: e500: Mark "struct page" pfn accessed before dropping mmu_lock"
Date: Mon, 10 Mar 2025 18:07:19 +0100
Message-ID: <20250310170431.340561159@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit d2004572fc3014cae43a0d6374ffabbbab1644d4 which is
commit 84cf78dcd9d65c45ab73998d4ad50f433d53fb93 upstream.

It should not have been applied.

Link: https://lore.kernel.org/r/CABgObfb5U9zwTQBPkPB=mKu-vMrRspPCm4wfxoQpB+SyAnb5WQ@mail.gmail.com
Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/e500_mmu_host.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -498,9 +498,11 @@ static inline int kvmppc_e500_shadow_map
 	kvmppc_mmu_flush_icache(pfn);
 
 out:
+	spin_unlock(&kvm->mmu_lock);
+
 	/* Drop refcount on page, so that mmu notifiers can clear it */
 	kvm_release_pfn_clean(pfn);
-	spin_unlock(&kvm->mmu_lock);
+
 	return ret;
 }
 


