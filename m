Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4036D4EA374;
	Fri,  9 Oct 2026 14:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557085; cv=none; b=OUrJ8n/fhGdn2wYP00WId8DoSKXl44lcy4xC/f/D483GG+lyM7rtOgZ1w4+s/v+P+9m1jRTagNcCMGSwFo8WSNDTP7+NimV0iYd9gNPqe7nYIWnHIC9MK6Q3wxIxaBx2hgKRZRf2tELiIqMGmem93AvkRBo1qjW+3aQW0I8vteI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557085; c=relaxed/simple;
	bh=0RffEvu/A9onSM4oi1k69Ae88Fk2Z4M94OkEZqA08TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEdH7zB25hzYrgcwg0tnkZq5Puu9qIa1oUajV1gvIey2NNfwICQaMmbFmDpXhq6LAoY/kL9jxLuFutG0/VMIX4mLBa9xZ+ltt8d6O+Y7ZFNmzcZNGEqnOe3tg5MHmW/BOAx2nbjkThvA9TY9J1onXfRZEugY+AwgCSnkHojRuvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4Y8BJJh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4Y8BJJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F181F000FF;
	Fri,  9 Oct 2026 14:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557084;
	bh=OXJeKXz/uitKcY+L1E6pibBRtUljfnNKjUsiTE1WK7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k4Y8BJJhKfQdNvaIiDDyJ6LvTHoyvhTUDTjjQQu3jj97eKB9ugwEgBx54pUFEKiob
	 NOXf+Uo8gPOQd2/+mDEv53Sq8Yvh8ThZRPKxDLadNfiU655eZh6IhcD1ew416qCd3Q
	 /j5srYw1uBB3y4bTLs4tVqzdvrEXv0ggqNEX5z20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@intel.com>,
	Laurent Wandrebeck <l.wandrebeck@quelquesmots.fr>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 7.2 293/428] x86/mm: Dont apply va_align to hugetlb mappings on AMD F15h
Date: Fri,  9 Oct 2026 16:10:30 +0200
Message-ID: <20261009140952.543776709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Wandrebeck <l.wandrebeck@quelquesmots.fr>

commit d2457a7e2727dc747a61a50d65c2f259afce8c45 upstream.

get_align_mask() returns huge_page_mask_align() for hugetlbfs, but get_align_bits()
adds va_align.bits regardless, so vm_unmapped_area() returns an address off the huge
page boundary and __unmap_hugepage_range() hits BUG_ON(start & ~huge_page_mask(h)) at
teardown.

This can be triggered on Carrizo and FX-8370E, both hstates.

Pass the file to get_align_bits() and skip the randomisation for hugetlbfs.

  [ bp: Massage commit message. ]

Fixes: 1317a5e7f7b1 ("arch/x86: teach arch_get_unmapped_area_vmflags to handle hugetlb mappings")
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Laurent Wandrebeck <l.wandrebeck@quelquesmots.fr>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org # 6.13+
Link: https://patch.msgid.link/20260922085032.46144-1-l.wandrebeck@quelquesmots.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/sys_x86_64.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -50,9 +50,16 @@ static unsigned long get_align_mask(stru
  * value before calling vm_unmapped_area() or ORed directly to the
  * address.
  */
-static unsigned long get_align_bits(void)
+static unsigned long get_align_bits(struct file *filp)
 {
-	return va_align.bits & get_align_mask(NULL);
+	/*
+	 * va_align.bits is smaller than the huge page size and will
+	 * lead to misaligned huge pages. Ignore it for huge mappings.
+	 */
+	if (is_file_hugepages(filp))
+		return 0;
+
+	return va_align.bits & get_align_mask(filp);
 }
 
 static int __init control_va_addr_alignment(char *str)
@@ -157,7 +164,7 @@ arch_get_unmapped_area(struct file *filp
 	}
 	if (filp) {
 		info.align_mask = get_align_mask(filp);
-		info.align_offset += get_align_bits();
+		info.align_offset += get_align_bits(filp);
 	}
 
 	return vm_unmapped_area(&info);
@@ -222,7 +229,7 @@ get_unmapped_area:
 
 	if (filp) {
 		info.align_mask = get_align_mask(filp);
-		info.align_offset += get_align_bits();
+		info.align_offset += get_align_bits(filp);
 	}
 	addr = vm_unmapped_area(&info);
 	if (!(addr & ~PAGE_MASK))


