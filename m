Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774644;
	b=Df3uSToDQR3GYGjW5JSt7YVDDnyod16pm3KxzCUVZVir3+S01IZJj/UrAbAIHndheTVK
	 H4p8GHs8+mXbGkaCY4318Aa6EZGizIVUlu81XjD1E2cDeVsvdVoyeA8Vfs5fDbVijFx7S
	 aWjQRpMUYQ/JQMHLbSCI21X8xy/2icZRxsKgpaq1UHtJp3I1vQZnCzHHaHEodBcuL/HUS
	 n8gn5/BBs2ksndyfLNMzT7rFvWEzD6ZV3gd5dnllMtFLqbTcMEo/lymf4Hkk21XLSmDx4
	 dHjvMnXjLTDkaTj9LtDAKCtGsm+Cg6NKqjJBS/l4xtYCZZkkKKm76hK2T57qlvvUFQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2ddEKx4FghHZinrwnxb2jvPyey7LUowZFkzpDRa38ak=;
	b=17YcvlVf5U1kgaxfGh2Tk/yxOdf8kxETdck8q15SyTA9CNqgi5KijUxjYXDe5hGW1+P7
	 6lzQmNT68B9hQqlvAWZs95eRTtq0iDnpXFMyxS7D8v5qfsHyGoGjAGJNr+D+uT/nogSVy
	 iznpaqt6uxlke61B6NFyxwQ5P6FpTmiSicvCJ25pl3cfaDLJfeqixASF+wf3RhtKKvPnE
	 OpUeW9hPoZd1CXEkYEEBh6ThLv9pz3IoyJfbHV1OeOIqUMUQgf+CQrVPS7UoSLJyIxBBq
	 7sRBfI4Z5Xflz3YwFLQKhCRZLqIQycglC36Uzh7el8B2FGyyFCtpfd/XJKxHScWEqWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0cYQ2KzU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F0A606A31B;
	Fri, 23 Oct 2026 16:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0cYQ2KzU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94DF1F01825;
	Fri, 23 Oct 2026 16:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774644;
	bh=2ddEKx4FghHZinrwnxb2jvPyey7LUowZFkzpDRa38ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0cYQ2KzU4t/TRKbWUloqEndc1zuFMT+HWEOK179zt/ZDgJP4LFDkp7pvdQnE1wagK
	 Jnt6EMsr0HQMEKyUaiZUcUIWPs3Bg5dcDvJpUpy/G05mluCl912AIOf4aK1YFRnr3Y
	 hYpHu8flEfVxslgxemcQsi06c3H5B/YAgfhqxCFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.2 110/242] KVM: SEV: Fix page dirtying in sev_gmem_post_populate()
Date: Fri, 23 Oct 2026 18:39:12 +0200
Message-ID: <20261023163716.382198168@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 97818b2fa7082e940ddd36dab12a68615300e798 upstream.

set_page_dirty() requires that the caller holds some kind of lock to
ensure that the page's mapping does not concurrently go away.
That is not the case for a random page we got from get_user_pages_fast(),
so use set_page_dirty_lock().

Fixes: 97cd21d57e9b ("KVM: SEV: Mark source page dirty when writing back CPUID data on failure")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://patch.msgid.link/20260810-x86-kvm-setpagedirty-v1-1-85f180892d4f@google.com
[sean: tag for stable]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2431,7 +2431,7 @@ static int sev_gmem_post_populate(struct
 		void *dst_vaddr = kmap_local_pfn(pfn);
 
 		memcpy(src_vaddr, dst_vaddr, PAGE_SIZE);
-		set_page_dirty(src_page);
+		set_page_dirty_lock(src_page);
 
 		kunmap_local(dst_vaddr);
 		kunmap_local(src_vaddr);


