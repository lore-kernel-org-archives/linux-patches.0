Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058689;
	b=QpOcd0+k+lDImwOguHF7f5w4DGXfwwFQegBYY5U02IdFjqE4EtTJmxp0QrrWvENh8/Z0
	 /urb353Ul8Q0cAfK31NQ+IeJ5KjfGHM8hsXH8Ew/j82OhUMs/Nn/RG54nQagnNcaBvWEz
	 NGZQHXJywWTrODOYgDi7Y/cs/Ujc2gbdOQA0uF4Mekh2aM9mGjB0SAXLrgiQa17aKdUgK
	 8cUGWNfelNisagGvqnXa2VIwxFQFhlcojGDIBF/5hw3MMf8wi5S77fPp+fBYf3CMbaeZu
	 o8lAeKArbbYnAvLLFJ9Ysgr8WhtnqX0kXk72cT4q15MVkSxeFr2TDoZrkFDcetDoRKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058689;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VKgw0pnYrAtmY/b8/WyowgJKkWw/CpC0k7ueDN1F0WI=;
	b=p6J03sNOsfBPYTlpq1X/DkAZPE6/cYprj2zkdQrQz1w/A9Xmfh+T/fQOP+LEy3ucS0Lw
	 bN418VeaUwK/VfP+9/n7+7mUGbGmlhlsMCZmHD8QLxKG19h447YUOpOPjh+dwiEnE5Q5y
	 qbX52ynquKxpMrPSvcBDVrxatAsZbvMALjQWXMSaQOIbO/LbQVGMET09DnsEyWSbkvH92
	 HRngb4C6VVRQHbQKxlhGVDaK4RpsltcviD5mEXRyMD+7tCq5ltn39bfPzQNOycwgXnME8
	 AT2/dZIDmzJ9+lWMRneN1pQXfIsuhGeuV7muCTQVboCXSUgnHirWqVkTdp1feZvKBXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RuqP7nLy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690A4606A320;
	Thu, 19 Nov 2026 03:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RuqP7nLy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9FB1F000C4;
	Thu, 19 Nov 2026 03:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058689;
	bh=VKgw0pnYrAtmY/b8/WyowgJKkWw/CpC0k7ueDN1F0WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RuqP7nLyixe5wM2wndeSZj4INjMIWvIyhM8FFDf0gtms6ZfWz/CR6ZVcbDx1nXFed
	 SN/5U/fyV6nty2JN8eeAIceO7s48GAMpV/Lw+TG0EDSq3OPdOaqN4P/0u+24ehAInv
	 GUd64YwKNJisiuxreIkM7zI5fG7/8ehmZIDP/Ad4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0534/1848] alpha: only use a targeted tbi() when the target mm is really current
Date: Wed, 18 Nov 2026 15:42:52 +0100
Message-ID: <20261118145937.357049764@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cb64e4797d2a8..850974ed65cce 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -679,7 +679,8 @@ ipi_flush_tlb_page(void *x)
 	struct flush_tlb_page_struct *data = (struct flush_tlb_page_struct *)x;
 	struct mm_struct * mm = data->mm;
 
-	if (mm == current->active_mm && !asn_locked())
+	/* A targeted tbi() needs a thread of MM to be current.  */
+	if (mm == current->mm && !asn_locked())
 		flush_tlb_current_page(mm, data->vma, data->addr);
 	else
 		flush_tlb_other(mm);
-- 
2.53.0



