Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036700;
	b=x6EWVSh26Ys4/9zgsOvqXgP2Rvcj6mcgj4d0csBthd6JGJCiZFKxo32/qf9/3SX9dNJd
	 PV4vlVBroNSrgdjaceMF8YApgph7iGpOx/acsgT+DOexS9b+dE9q8wZE8FmWXDiGb5uhd
	 4VDqQI/Vnk41i4T9wLHzF5QCE0CkUMEqnj91ammWX2xH02fSFvUF3XMedY7V2FgkuLzQA
	 o+lfrej8/fN6ONbjmDR/uZf5gYUkgM+/6/9j9xqlRvJsxO/q7+77MIsjUtH7iwEG63JHC
	 4dgJgOo2TB8kSSIH+D3FDzUsPBruCzmofpZRbEKHkSynw6bUro2Jq5UTGEZTIN62hMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/SkHcf5uc8t3UL5bLLCCI7MBQRVhIDTB3EuOMPos2FA=;
	b=toUjgL0rhWQ259Go1E24bllSyxnk5aVd06pI9ksPCOgW+Ln3XHDsXoZ6O/TOm/XDwM5+
	 mCdSobYXyISJ3LRtUKHlwAxgviSECKitznuSKpT9pOLWWX1YXZXC9H7Geomf3Y3d9G7fr
	 LNwam1c9fGkjGypnT/bXnKTHUxHs+U7O8OmpvUdRzLAdTqkhqBRsuJL20CiRc13Nc1hxi
	 Wp0cyj+AsckDOrjxVnQTMev3r5Ws1qx8mBhNWf+lkxrzHc3hGHTF5swSFqodcrXP+nvFZ
	 ovi85g9U2/P8DiV/qkad9dZJPld5zt7T55O0I8YiRi7ObMcwcFFWHMoNot1t2MLGfJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pfZvPTKU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71B4606A320;
	Wed, 18 Nov 2026 21:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pfZvPTKU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E641F000C4;
	Wed, 18 Nov 2026 21:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036699;
	bh=/SkHcf5uc8t3UL5bLLCCI7MBQRVhIDTB3EuOMPos2FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pfZvPTKU9UPQCTiSfi9yWN5h7CtwY5oLd6y0OQqZBYyJDJ6Konev40fr+14N7FmS9
	 C9qfLi6nrJOlDi5wXEsL/9MrIJjDXJLkjk5OrDabm6679E+GW/5q1QcRgBuiBXbCKY
	 X2eEzny2TVZXLZc616+lKzRq5lfFLLu9mjww8hgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1151/3318] alpha: invalidate the local context in flush_tlb_mm()
Date: Wed, 18 Nov 2026 15:29:33 +0100
Message-ID: <20261118150354.621490549@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit 721bb7a129771f0ff9cef1dd5abfc106ef65feba ]

flush_tlb_mm() has the same caller-CPU omission that was fixed in
flush_tlb_page(): when the target mm is not the calling CPU's active_mm
nothing happens locally, and smp_call_function() handles only the other
CPUs, so this CPU may later reuse the old ASN together with the
translations it still holds.

The active_mm test itself is left alone here. That path calls
flush_tlb_current(), which loads a fresh context through
__load_new_mm_context() rather than issuing a targeted tbi() against
whatever ASN happens to be loaded, so it does not depend on which context
is current.

The uniprocessor implementation in asm/tlbflush.h already has the missing
branch. Counted over a fork-heavy run, flush_tlb_mm() was entered with the
mm not this CPU's active_mm 2934 times, and 632 times while otherwise idle.

The proposed Alpha hugetlb support routes hugetlb invalidations through
flush_tlb_range(), which calls this function. Unmapping or migrating a
hugetlb folio from another context will also need this local invalidate.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-8-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/smp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index be463ed9a3fb0..354a188fc2770 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -653,6 +653,9 @@ flush_tlb_mm(struct mm_struct *mm)
 			preempt_enable();
 			return;
 		}
+	} else {
+		/* smp_call_function() does not call back into this CPU.  */
+		flush_tlb_other(mm);
 	}
 
 	smp_call_function(ipi_flush_tlb_mm, mm, 1);
-- 
2.53.0



