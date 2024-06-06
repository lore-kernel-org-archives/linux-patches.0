Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9E01A3BCF;
	Thu,  6 Jun 2024 14:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683245; cv=none; b=hnNbxR5m+zK+8PrqHr/v/dHca5lvCQK5FTupDKltL1gNijXtyMd72EbIZ5sB3Nu87XtILUYwKhxFBl3D+od3onE6B+9StVJZZIs5D9d2pTxhehaTVk9W5vrv7xJbDSUuWKRFstoMsQJ2whoc9CAavvCpp2+7w9l3gzPN5nmZVVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683245; c=relaxed/simple;
	bh=6FOzyiDeOfZ8kkM889qK6zYD3S6dR+wogr5jqt9T4kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J52kGCMRxb9RRuloYz0TGpBKCNyE8GBKUsluAU2QfI4ld7nKlpLrRvpwbkis1Ugy77sLcSkE2CLUjtHX27vxxKKm1947ApVP8hkHlnpKtVLL3tWoYbA7wcpRDmBi10jRKzRo5DS4EHZcdk5hPhF6dcm+3BGVW4OOydZxdAjZOsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ueVsCIND; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ueVsCIND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B616C2BD10;
	Thu,  6 Jun 2024 14:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683245;
	bh=6FOzyiDeOfZ8kkM889qK6zYD3S6dR+wogr5jqt9T4kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ueVsCINDCfypK5//qhfbmVY0GRAUqdUYCNbvQ2bYh6/2kpy1Wi9VSEA5oXJ3kOxfj
	 +0HtgDcTLTvUJRxPsPQSXZiYEQU65euE9MQxxbFbWQP8NXqs/Cgo2o5aeCcOMaYNzP
	 gLMvcktsl6nnuEhyZ9Wv1Gg20fq6M2JbHOekjt8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/473] x86/pat: Restructure _lookup_address_cpa()
Date: Thu,  6 Jun 2024 16:00:51 +0200
Message-ID: <20240606131703.970942619@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a26a9e3608cb2..cf721614806b9 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -712,11 +712,14 @@ EXPORT_SYMBOL_GPL(lookup_address);
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



