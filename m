Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA743E00A3;
	Sat, 17 Oct 2026 17:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258425; cv=none; b=UkZ4FxPcf0LsdfVlMAB2HeAoRDDZE6WngH+8xpkXMXx9A/YqqOYOSOHj++vzMLhRmkhttiYIY/49x2Ygx22xcEmdYOEoZt1tVurO1hr+kSkutlw9+5BMeMNv61gOsZ1Af0GK639+oBdr/uychuMGjDVo0JVHnJmu636IQv2ZBm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258425; c=relaxed/simple;
	bh=uqMWAVEOm+ByU2v8c//pZopbU30NVAWEKbMABt/mzD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZOXxNhH7H7HNa0NR80EGd6tImHIFFfi6ytUK28s2jM7vZyB6hgXhUTK5FvKAoAfxP7NPgHnKOQ6IyEoRwilPLO/ElA0fLGeXjGlj4S6mjq1wkeuFqcV+fu245a77+SsmOu6lq4cZ+Dm00Tr/v9AZmmXhe+fW2SElLprPguN+YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZWeZhe7R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZWeZhe7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036C51F000C4;
	Sat, 17 Oct 2026 17:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258424;
	bh=DlGSusvNsHsXghP2HBEQQYGDYzwKxXFSH29dbSgrPYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZWeZhe7Rn0lG0t42f7tgJRGD88KJ/yMMh6zdsJbJ1XQ8JJ9f0uzNu8p86o/9nmPyt
	 /R7F5KaFNr/kWrMK/tQ49uYZ5KRL6jEb7NDoVJ9XB0zxBEsoFf8rr2GFA70dkBGjhz
	 cHBDzlZX1MHjGsqQ0CJSFXlssd+V8FryxTXX8qNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0879/1674] s390/mm: Add missing secure storage access fixups for donated memory
Date: Sat, 17 Oct 2026 17:52:31 +0200
Message-ID: <20261017160453.678808581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janosch Frank <frankja@linux.ibm.com>

[ Upstream commit b00be77302d7ec4ad0367bb236494fce7172b730 ]

There are special cases where secure storage access exceptions happen
in a kernel context for pages that don't have the PG_arch_1 bit
set. That bit is set for non-exported guest secure storage (memory)
but is absent on storage donated to the Ultravisor since the kernel
isn't allowed to export donated pages.

Prior to this patch we would try to export the page by calling
arch_make_folio_accessible() which would instantly return since the
arch bit is absent signifying that the page was already exported and
no further action is necessary. This leads to secure storage access
exception loops which can never be resolved.

With this patch we unconditionally try to export and if that fails we
fixup.

Fixes: 084ea4d611a3 ("s390/mm: add (non)secure page access exceptions handlers")
Reported-by: Heiko Carstens <hca@linux.ibm.com>
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/fault.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 23a891fb41343..9bafb1dbfafd7 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -656,10 +656,17 @@ void do_secure_storage_access(struct pt_regs *regs)
 		page = phys_to_page(addr);
 		if (unlikely(!try_get_page(page)))
 			break;
-		rc = arch_make_page_accessible(page);
+		rc = uv_convert_from_secure(page_to_phys(page));
+		if (!rc)
+			clear_bit(PG_arch_1, &page->flags);
 		put_page(page);
+		/*
+		 * There are some valid fixup types for kernel
+		 * accesses to donated secure memory. zeropad is one
+		 * of them.
+		 */
 		if (rc)
-			BUG();
+			do_no_context(regs, VM_FAULT_BADACCESS);
 		break;
 	default:
 		do_fault_error(regs, VM_FAULT_BADMAP);
-- 
2.53.0



