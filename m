Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94B61993A9;
	Thu,  6 Jun 2024 14:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683230; cv=none; b=jl8olb/N3cy91JY6BtxQtlGYh6TDHFzB3L/SHNzNSHXDhascEg7NSAgeHqK6reL2EngHVWNl2vN9zGDfHJ6YU7+UeqvQ1uIpQiwE7FmSKcYbH4OrSZNlSGIyK7KbOX5E8DK52xJb32/4NUe5Sw1Fw7m9oYM3UQs47SYS7Io4294=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683230; c=relaxed/simple;
	bh=PYdCiIZvqayt4088Y8cTgnbtKrUZ1g/wEE2AyfI6g5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HobrOFREQUDxn/vtsWmCPsqylzAeET7GIrHXo9oI/aWK3llfMdyF8mYnYEUqY24ebP2o+b3vGUdSQw0TUl5AlKWn+Kk+U2LG8adMfVOHnyQmoy0PDV8FJMNXagAq1ck7bTZBgUmUkYlScMEEW4wIRslTsOXXAn1v2EQuKF23f/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9wVESmb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9wVESmb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E88C2BD10;
	Thu,  6 Jun 2024 14:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683229;
	bh=PYdCiIZvqayt4088Y8cTgnbtKrUZ1g/wEE2AyfI6g5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h9wVESmbQbihh2MgPM/sYrgr7AnMdcwtPwlACHZRngqGubkMYKdpMRw6FE3CMTYV7
	 dE7vjlZjkUTH+CY0ye79/E6qNFxEiwJ/wz3pmQHNeD3VC3jIrWkV6Ym6zmXGRbeCrF
	 VlqOLygZ8PhnOiN+oYTswUhWukvyNF/+G7OUINgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/744] x86/pat: Restructure _lookup_address_cpa()
Date: Thu,  6 Jun 2024 15:57:23 +0200
Message-ID: <20240606131737.906525945@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1132d222ade82..a2dd773b1cd29 100644
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



