Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251A43A3833;
	Wed, 20 May 2026 17:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296974; cv=none; b=uGXYT29YPPGafNI6wPH+BO+pJDQglrk4G4yyHkq5aOsiyDgL1EvdSnVcLG7zmIBngqt3LyJZAz2+/NF5ibmSp7o8cZPhzoYzJz7/Zc4tjmgcrQTx/2XBjaiWxwfSHYzGqLRZ8ai97RdIcPu7ikLYCR2CezmtI0NU02owugmEOaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296974; c=relaxed/simple;
	bh=SKE3dtqfzUkA0iVIUpMokE8/QOw+b1/1Ln8S2xxXzBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwqdYU2xpgxfMWMp6ZyIN5Zb9DUEYiilEguMhget1dbW/+EHn4JEsbpVXRi+xIv/u2HfqZVBBc1iRtcs2hnjQbo/Hm96OWrZIy7TzEUnmJLoEaA45EvFGDezFbL/llFw4Xu/R6RgdVSJKBNg/IUoZKxlJKuB8KtsdiYQxWVEzFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ug3B97wm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ug3B97wm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430F81F000E9;
	Wed, 20 May 2026 17:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296972;
	bh=f4MoHmyDxrKshezubLJWCC/Nd0ywBAuMYIqEZYR5BOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ug3B97wmVnmu/fptcaKJyubKfM05hx2Z8qrO0bPnBED4CBdY57ODkkT3cnHf+ArNT
	 F19Yj77ZWjo1vJ0lYhw4bFUmmyWgs8k0nDZizRNfm5FvRhlfjYHoPN9Rn4m+7vc/CX
	 VPgWEUVyFSo8QxbPrOmowDrB/73XkQojIn/qJtPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0960/1146] s390/mm: Fix phys_to_folio() usage in do_secure_storage_access()
Date: Wed, 20 May 2026 18:20:10 +0200
Message-ID: <20260520162209.958201922@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit b95e0e792822bad8fc9eb33ea3a90005e29e75e9 ]

In case of a Secure-Storage-Access exception the effective aka virtual
address which caused the exception is contained within the TEID.

do_secure_storage_access() incorrectly uses phys_to_folio() instead of
virt_to_folio() to translate the virtual address to the corresponding
folio.

Fix this by using virt_to_folio() instead of phys_to_folio().

Fixes: 084ea4d611a3 ("s390/mm: add (non)secure page access exceptions handlers")
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/fault.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 191cc53caead3..028aeb9c48d6f 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -438,7 +438,7 @@ void do_secure_storage_access(struct pt_regs *regs)
 		panic("Unexpected PGM 0x3d with TEID bit 61=0");
 	}
 	if (is_kernel_fault(regs)) {
-		folio = phys_to_folio(addr);
+		folio = virt_to_folio((void *)addr);
 		if (unlikely(!folio_try_get(folio)))
 			return;
 		rc = uv_convert_from_secure(folio_to_phys(folio));
-- 
2.53.0



