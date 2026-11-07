Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062439;
	b=Wma+BD7lfiMrSYTBuCHpHVijyc/hC8s1jSu6YNc1QhYhkH5oQRTdmkmVXXD5TTrHV3cQ
	 go5xlnSURsnuL03D1HtCUQyKOEhU/T61UHOKmpBWohk+jxJDQ1uhrnsRo5VeXI0P2/Lkz
	 8VkBDRC/2CVa40zNt4S+o1lko+c3qsgHj06jm2dSFjxLNYQV4E9EVr+acUlNpE6tOxFcU
	 amfSZjiROxQxrYx944okt1du/fm4JzoRW1jE36iQ8fHl+FA/ZnzANS6a4BBBHaBPCC3Bz
	 rlLZ7n5FwVvaXfQ2cDotj5dRDJAf+9p1GSyrjpuYjT0d7tTyDzWKuo76VjqiJNxrGPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xhez4W/RUTCHDu/2tTj8mbiTE04Ob3W1YlH0Y0/jUvE=;
	b=QLpZQSaugn43pC3m0sniSEtqM3KxML367brwZ2nX99SRaW8lkNuks6HFgA+hdyOYi0Hy
	 HAZ/XKFY34sdWUoqYZvxixn/IXC7hxIhegm98k8m9VwydSgGmwlhWMT34CPR/p8/wDGZw
	 wxg3ZZUJ8AoX770D2NTbcUqv6S7vpyeIhM22xkh5+v0Vt3rY6A96qJq03o9UxethzqVr0
	 fpD+UmLbYjmRp4uGjFiHXPghA1LP1BNteKN38WP3/734EFWpT/3UkVZBEAyeBi/vO22fE
	 CQDmttk6raFZA6GC1j7vQUuY/nNEtrdDYBXjg4yAA2O7RfYDySY3ODiTX3bi9pndgUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pHbLxp4F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6B0606EE8D;
	Sat,  7 Nov 2026 14:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pHbLxp4F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544121F0089F;
	Sat,  7 Nov 2026 14:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062438;
	bh=xhez4W/RUTCHDu/2tTj8mbiTE04Ob3W1YlH0Y0/jUvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pHbLxp4FCzRIVBIataW5zckI95Lv66l2BcnWmGsSH4fIMz7f4aHTqeON7u9pB4n4/
	 DUB4qXXsd18QcrE2Yctut+308/jP7iwQlitKJvZRU934OnFhfDFAcirQlljjxGFQnF
	 Fg+/cYf7Xf0okdkV5pwBlEpCgGPLWRL3Ma79b+so=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1348/1536] alpha: fix the local TLB invalidate in the UP flush_tlb_page()
Date: Sat,  7 Nov 2026 08:56:04 -0500
Message-ID: <20261107135035.683815960@linuxfoundation.org>
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

[ Upstream commit c825bf802a7a43fd302c879ef25c975e067a2e94 ]

The uniprocessor flush_tlb_page() in asm/tlbflush.h has the same wrong
test as the SMP one: a targeted tbi() is only guaranteed to invalidate
the intended translations when the target mm's context is loaded, but
the gate is current->active_mm, which a lazily borrowed mm also
satisfies.

Test current->mm instead. The else branch it falls to already exists
here, so unlike the SMP side this is the whole fix.
arch/alpha/kernel/smp.c is not built with CONFIG_SMP=n, so this is how
the same defect reaches a uniprocessor, where the flusher kworker
necessarily shares the only CPU with the writer.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-7-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/include/asm/tlbflush.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/include/asm/tlbflush.h b/arch/alpha/include/asm/tlbflush.h
index 0c8529997f54e..9ae1902faf8ec 100644
--- a/arch/alpha/include/asm/tlbflush.h
+++ b/arch/alpha/include/asm/tlbflush.h
@@ -87,7 +87,8 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 {
 	struct mm_struct *mm = vma->vm_mm;
 
-	if (mm == current->active_mm)
+	/* A targeted tbi() needs a thread of MM to be current.  */
+	if (mm == current->mm)
 		flush_tlb_current_page(mm, vma, addr);
 	else
 		flush_tlb_other(mm);
-- 
2.53.0



