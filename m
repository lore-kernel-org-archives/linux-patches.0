Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036688;
	b=VCHnf0mqDx8UcLXDmM17AE0tbf9KTMbwQiixsetU8/TSAqy1dMwy4iaeJrnTM/xsLYxX
	 lAovWwIEz+gN5PtkVtnuQDdxDcDu/ALSrsnSpIpxfoKVRmM7VEOEX2eIMl/yK3SzLiIxD
	 7dDhbMUObHRXx0No77oHQRPfVrsJ80TGULK+7rGN2OAwjW1Uphhbw0Jm8Ey1+UwnCCDAF
	 ylKIHp7CtjIKzUNUEWO7R4m/ggaRnd1cwVBkUxkxNq4Uza9vykjqIKF2L8eL8cmyhafFf
	 LtXcFjdAYX2byYQi1/rRQNd0KLa5UUbhf1mWetGamyvVIdBdwgb5fb+5bR0iedJVbWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bafAkrEFQ5895eLHvGd4Vdx+sUWuJCyCVPyYc8ysMTM=;
	b=MesQOHdrXG945jbsu/UsRpfKZg4lgq1WwieXuZAlQlDLqytZ2ikOnkBakaff/P7tQr5U
	 7VRqoTEPOjFrbmaSNs68zQG/47BsCCELlwVnA4S9dIr+G9SQu66QSSTbKNhHZlZXU9S0m
	 8T6Kg8O/salPzQ0Bc1pFIJiuDn7nQReXzsSzh7FSJke0B6ie8TuFn0y8VjlDe4wXotEA+
	 XY/ZBFCp752OURVGX4iyVlRMUSLpkBN7a9cXcHilmfyZJai8FBh+tsHuklA3PckWqSIWs
	 tjWFb8BDIkFx+DVOKVGYaoVIC2AsAb1L+aHtGE63zoc1Qc1FRrN/JmJmRnq0dnSJtHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vjeVU8hh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FC9606A31C;
	Wed, 18 Nov 2026 21:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vjeVU8hh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58FE1F000C4;
	Wed, 18 Nov 2026 21:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036688;
	bh=bafAkrEFQ5895eLHvGd4Vdx+sUWuJCyCVPyYc8ysMTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vjeVU8hh8Gshch6B0/pdXTmiw0hOEnSvEHRrfaEGnBVY+5Y/EqmsTFJ8Oxoll91UL
	 4yGb7FFKY8MF0voiL2xWKuhte8C3VlawlIITPCS3qI+g51sdRth776n7z2avtuge/V
	 cW54TWUO5Tr4BXtUMZv2GBz0wRhVNKLX/KVWLiE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1147/3318] alpha: only use a targeted tbi() when the target mm is really current
Date: Wed, 18 Nov 2026 15:29:29 +0100
Message-ID: <20261118150354.490828725@linuxfoundation.org>
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

[ Upstream commit 0d92845ac5dbc79e4ac4810b33c673f4c1c227e3 ]

ipi_flush_tlb_page() gates a targeted tbi() on current->active_mm.
tbi() acts on the address space context currently loaded on the CPU, so
it is only guaranteed to reach an mm's translations when a thread of
that mm is running there. current->active_mm is not sufficient: under
lazy TLB an idle or kernel task keeps an mm as its active_mm while a
different ASN is loaded, so the invalidate is issued against the wrong
context and the stale entry can survive. Nothing retires the old ASN
afterwards either, mm->context[cpu] still being valid, so the resuming
thread can reuse it.

Test current->mm instead and otherwise fall back to flush_tlb_other(),
which clears mm->context[cpu] and forces a fresh ASN at the next switch
whatever is loaded now.

For an mm borrowed through kthread_use_mm(), patch 1 of this series
installs the context before the task can take a shootdown IPI. The
current->mm test therefore covers that case as well.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-4-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/smp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 7439b2377df57..5349c3127f9f4 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -673,7 +673,8 @@ ipi_flush_tlb_page(void *x)
 	struct flush_tlb_page_struct *data = x;
 	struct mm_struct * mm = data->mm;
 
-	if (mm == current->active_mm && !asn_locked())
+	/* A targeted tbi() needs a thread of MM to be current.  */
+	if (mm == current->mm && !asn_locked())
 		flush_tlb_current_page(mm, data->vma, data->addr);
 	else
 		flush_tlb_other(mm);
-- 
2.53.0



