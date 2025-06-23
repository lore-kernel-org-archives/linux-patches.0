Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03B419049B;
	Mon, 23 Jun 2025 21:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715638; cv=none; b=Bk5YBuh6+YlonkjWxLzaCuzjm2KbRgujuIZB68PBCkHTkPXwEf41QSCEGDDiy7pUQ9alr4H4pkExVWukFIXoy6oqreO1KG7RdKYhvuRWAtlSCdLueu/b7Q4VMRvZPFJG395PjsT9NDk69Pi2OhHzD1V7Gq5ZDHd6eJXcLhlXlsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715638; c=relaxed/simple;
	bh=Se58K0ai9N83XnbqaQ84PcIsS6aoPHZw+AoBOTNAq1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+rdKBthrt8MgYGYPaHbm9Lhecn/xoQ0bv6K0iJN2UcgD6BcxBs5YvIbAApHnuWdrttF9vfHaH7+UpbTYnOIB26zCkYAY2wgv5SZTf/luty3jNOWbpGLehqtzGqfzXEHO+ATKGwZq9MhfUxvwWKX1kaMqJPBS712Id51xovmbxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qo6Ehrc9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qo6Ehrc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CB8C4CEEA;
	Mon, 23 Jun 2025 21:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715638;
	bh=Se58K0ai9N83XnbqaQ84PcIsS6aoPHZw+AoBOTNAq1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qo6Ehrc9akS3Zw1TuRYbJzVeRITgCbzk7wnRfy3x8lsINcsPxvDFS8nSnIPcJXMoj
	 +Q685yc+Ueacg6sDlpDd53AutlA0Sssz1SQg8+cTUAcY5ACUTl70YPLhx8lXY9x77o
	 w/Nvi42n0FhVWRYP5skEu9GiSc+mvJjErjXr2KLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.15 471/592] x86/mm/pat: dont collapse pages without PSE set
Date: Mon, 23 Jun 2025 15:07:09 +0200
Message-ID: <20250623130711.635882104@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

commit 1dbf30fdb5e57fb2c39f17f35f2b544d5de34397 upstream.

Collapsing pages to a leaf PMD or PUD should be done only if
X86_FEATURE_PSE is available, which is not the case when running e.g.
as a Xen PV guest.

Fixes: 41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250528123557.12847-3-jgross@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pat/set_memory.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 46edc11726b7..8834c76f91c9 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1257,6 +1257,9 @@ static int collapse_pmd_page(pmd_t *pmd, unsigned long addr,
 	pgprot_t pgprot;
 	int i = 0;
 
+	if (!cpu_feature_enabled(X86_FEATURE_PSE))
+		return 0;
+
 	addr &= PMD_MASK;
 	pte = pte_offset_kernel(pmd, addr);
 	first = *pte;
-- 
2.50.0



