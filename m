Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062435;
	b=saA1dzP6XTU+WFpG/W2HazHSOcLYGeXGj2sYAOH6rrGCgOMxX6GmdLSi+lmJtmrYCKRu
	 Ev2029RUzUnTs3fXmQDdwJyru5awxPgG6+klfGAxoptURtiVObbevXucN2+mKNIFlD27R
	 6EEBaXmMfOCvNkvSIdcTw8H2+U+sFMOBIBqL6IBi/0cCLEQssfyii6dSV2bn0mHvUmMye
	 yjpOj/P7se7uAIgxUevpnnAfZlwNm6y0t+g5eGkdvrZhcZHGks+l7GLljNfqsceFe574I
	 ktwoaPs3O0IN+gVvOSro92MU6TKHfTEn11P2qNc+S4I9lfDm4jkM/inmHqo9QY+5rvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gj4ZMaeB2QKDkJrmbp4c9L94i1MxR+Y4rzGuNS125Jc=;
	b=gRcScp+dWFoH9Vcn9rfDzRIj6oXleZ1K0NRmHsP3gTnLkbgm9oQZwcEbJi5gFYw1UYvr
	 Vp4TREoZsaeQEgYC3vn3JBHtTs9ZAumJaeqYgLHdVrzu5SIhsS/r+Mis1f0KofLavqLMv
	 Kikk0/VVe8zQdS71mxnfoRnSbJarA9IUmT7Moe5qxlsg8vUCDgIJx85ggP81lhMAR8iP4
	 Jq+CshBopxzx2aMeo+c2nfcUhlLjCo7qNOusul0ET02mMamgcFbU71z2t1gKemto1krec
	 s5LaUSftNsVCInEZH7uWSe3eF8IpLaROq0EOcertSJa0dy5QBa2gFFFksrTfFppfyUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kOhHTT2Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3543F606EE9F;
	Sat,  7 Nov 2026 14:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kOhHTT2Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF221F0089F;
	Sat,  7 Nov 2026 14:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062434;
	bh=gj4ZMaeB2QKDkJrmbp4c9L94i1MxR+Y4rzGuNS125Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kOhHTT2ZZG2Al5jj1FoigPh6A//D3G48RNLs+71KtIZrOfeY7VbrUGZ62CLmf9SDz
	 NkBlNDbkoDL4OOoqcRxoxLxCXLZeircdD3cebvAFu7r6ro7LMBPlBAA8FKe2SkVLSp
	 Oybulf9FD6tovRSezZiHzM2zMONh5vSQTLehKEag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1346/1536] alpha: invalidate the local context in flush_tlb_page()
Date: Sat,  7 Nov 2026 08:56:02 -0500
Message-ID: <20261107135035.626674917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit c0db730bf05eb3c10c1fae64b19f6913dce129fc ]

When the target mm is not the calling CPU's active_mm, flush_tlb_page()
does nothing locally, and smp_call_function() reaches only the other CPUs.
This CPU may still hold translations for the mm and can later reuse the
old ASN together with them.

Add the missing else branch. flush_tlb_other() clears mm->context[cpu] so
a fresh ASN is taken at the next switch. Add this before changing the
current->active_mm test to current->mm: that change will also send lazy
callers here, so their local invalidate must already be in place.

The uniprocessor implementations of flush_tlb_mm() and
flush_icache_user_page() in asm/tlbflush.h and asm/cacheflush.h already
contain exactly this branch.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-5-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/smp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 1ad448105201f..e4ba0aab8a669 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -697,6 +697,9 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 			preempt_enable();
 			return;
 		}
+	} else {
+		/* smp_call_function() does not call back into this CPU.  */
+		flush_tlb_other(mm);
 	}
 
 	data.vma = vma;
-- 
2.53.0



