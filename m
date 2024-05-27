Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1059E15EFC3;
	Mon, 27 May 2024 19:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836683; cv=none; b=n3eIKrCuqGKcH95Eqc0djmQveOjaoiY41qMnXFhAUjMFB30vYd0lfkr+UcRI8q9diV98BeXRI43lpfrhDKHgXAXaKGr88obCf3vJtq5aywCxj2Ai7PWQ3Ic+ydpnHCEa4ttUTnQyAgJGOcOHJXBlzLkxWIra6E8DnCDzVPqQZD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836683; c=relaxed/simple;
	bh=bwrnExqbh2GnXfNZ1nM7EL9MRrCBDOoy/IoCFMR4zEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbIZ7KrCSTrGLS1L0sXpNNCWRrkANSgyACStL7mALd0ah24sdFo86xs1M4dA/4Y9WJA+3MbmDhv7FjkXF7zMIMASyVNYJ88r38beWCD6uAaGsD2Gv7yCA13KDfThkyudmPGUAHMuTptGJOwTBoLJKWMJ3/51OtrbxQfBupMbq6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OWOEKYWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OWOEKYWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B30AC2BBFC;
	Mon, 27 May 2024 19:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836682;
	bh=bwrnExqbh2GnXfNZ1nM7EL9MRrCBDOoy/IoCFMR4zEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OWOEKYWgBHLaq9C3E6cAcx2miiAWeveHLQCggMZXu8Fcrw4SbOlpchmxejnUl2ok/
	 lDrGtv7yMF5yqlXUNdW5WvZbuotYjQIJhR+6JHNC/DUPP/8dH4AZheuWTL0r4d/+gQ
	 Pklia8aGKHF0xdhqriw7hyTkP5QVcqN/FHNcmYDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 148/427] x86/pat: Restructure _lookup_address_cpa()
Date: Mon, 27 May 2024 20:53:15 +0200
Message-ID: <20240527185615.800077642@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 02eac06b820c3eae73e5736ae62f986d37fed991 ]

Modify _lookup_address_cpa() to no longer use lookup_address(), but
only lookup_address_in_pgd().

This is done in preparation of using lookup_address_in_pgd_attr().

No functional change intended.

Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20240412151258.9171-4-jgross@suse.com
Stable-dep-of: 5bc8b0f5dac0 ("x86/pat: Fix W^X violation false-positives when running as Xen PV guest")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index bfa0aae45d48c..4ebccaf29bf2a 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -744,11 +744,14 @@ EXPORT_SYMBOL_GPL(lookup_address);
 static pte_t *_lookup_address_cpa(struct cpa_data *cpa, unsigned long address,
 				  unsigned int *level)
 {
-	if (cpa->pgd)
-		return lookup_address_in_pgd(cpa->pgd + pgd_index(address),
-					       address, level);
+	pgd_t *pgd;
+
+	if (!cpa->pgd)
+		pgd = pgd_offset_k(address);
+	else
+		pgd = cpa->pgd + pgd_index(address);
 
-	return lookup_address(address, level);
+	return lookup_address_in_pgd(pgd, address, level);
 }
 
 /*
-- 
2.43.0



