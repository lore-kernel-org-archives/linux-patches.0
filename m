Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063481;
	b=KyGzYWVbZ2Z1fWR5hoP+WLw36oVrW14JboK+jjf4Hv5lWuj34MS6iRIMbgZW9OrSJfqA
	 hwmSHdl5rca4V2m6k9H+IvWmDSn2JsD7lJn0YPFH/xeO+/iaUiABe969Q8Pjgko2Ek7rn
	 5D0DjYhCgjjX4L3UfxCE5dX66PW3s01HgUcWELSs3nfx6ZufgFwEyGNsnINYI+WKpA4Ae
	 E4zyPH7NlPL1ymLFlMn84FYPOQShWPqnUGQftVVe1j4x4hMkFd9UHT4FBuq+Lk0YC+7fG
	 COq/APVXLGCGEFssrz23cnwXsHt8Jj5BwAJEp2QB241cTzw/Z8f4n/9saZpPOOE317Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063481;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w4/IF/ACwFzjkwhO/+PV+1RmuVhn4SI3oP40L1uYnsc=;
	b=L24J/4jKh6xKG1+ObwMMtmVdJxPH2Wxxklz1bGPlURlOTaCIyBvtY3jI9VwKBIRWHMQr
	 UVfhy68eKN6v1CZM5JXPI8mTJ0JDMTE/1BuoMX2Hit8agrdkvdqQenbdIpLxpJHrsW/my
	 bhJOTBvh4DKYjIiqAMtNPNZyNnu7+dmoMi3BxNkwUCLFfs7bXa0Vih948OsnaQBdYC38y
	 jv2TTssLPtBkslg7BBqd/OZI5Up1ku05OxXcA74DDDHSwry/Q6UZat8+6UTd0yG+QmKr5
	 fLkMsi9sLyzSR1DoRWI7ZFF+3PDWyLRGfTl3MwQsuDVWIHCfDBkXymR/kb2v0WZokYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rr4xOvQC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4D0606A9D2;
	Sat,  7 Nov 2026 14:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rr4xOvQC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A321F0089F;
	Sat,  7 Nov 2026 14:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063480;
	bh=w4/IF/ACwFzjkwhO/+PV+1RmuVhn4SI3oP40L1uYnsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rr4xOvQCazOfoY0v3qhN19/vVcJpdNLO6p+V42Iw9ZIugQYiQmXugjbZzvynpSkEW
	 jiZFtBtPRraZ7m/yqyEvxnD5+1pDW240FA1NLgOWJoeJAlq12XqfbKy+OOLI+KH5pk
	 WuzI7yKbunvLb24p+1h6+G63evEBaVX87WkSpwPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 628/869] alpha: invalidate the local context in flush_tlb_page()
Date: Sat,  7 Nov 2026 08:55:10 -0500
Message-ID: <20261107134914.287360111@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



