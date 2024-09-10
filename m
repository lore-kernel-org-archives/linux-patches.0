Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7EA18DF99;
	Tue, 10 Sep 2024 10:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964520; cv=none; b=FuKPZkx70ESClRd0/IYXoXUHg/aedl7LVC4J8Poh/0OxUSCzCUZL/Gf0CMNvqhZ/pfHJDPgs62xLSVi0AGemLfVcqwpBnTEINFOM3B4YelsqMg5URirVGq1FygZm0fY+7lOoaiwA+AST89hlF3A0mKk7y8PmWpYgnSAcqJWBhsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964520; c=relaxed/simple;
	bh=s7nAmrtQzImERpgjUVsyJPW8v61QYNXxzDB0zapdd7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mM7oPgQo08NOT5a0TwBKx62/M1rciiQARkjCWVPNq7nBWs/v8oJOlcgbQQRPUgN/dhbhFpRYSqsVo83gT1rT3Eoe33diPj0nrtt7ghM+zPdCrq92zKabzWQ7ZhCqLvr/kVS3IXwS4c3sG88bXyNdwZ8exfpPmxEY5vey9N5hyiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0xOL3pGe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0xOL3pGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830C1C4CEC3;
	Tue, 10 Sep 2024 10:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964519;
	bh=s7nAmrtQzImERpgjUVsyJPW8v61QYNXxzDB0zapdd7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0xOL3pGerIkvyPxOkOyA1NRrKcdFvTblt5OG3ICZ8zZ54Ej4dTHp1rGJsdtC64yKu
	 dLv5PTBXQZ9TZQEaDnwk9Vyhp65sDzrlOaXRHh2/JyVlRsFk9Mquh6+sfYp5hjen8b
	 z4adSyexmVOnCSo4F7mFS+GagawCORMXjiYSYsmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 183/269] s390/vmlinux.lds.S: Move ro_after_init section behind rodata section
Date: Tue, 10 Sep 2024 11:32:50 +0200
Message-ID: <20240910092614.659715593@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 75c10d5377d8821efafed32e4d72068d9c1f8ec0 ]

The .data.rel.ro and .got section were added between the rodata and
ro_after_init data section, which adds an RW mapping in between all RO
mapping of the kernel image:

---[ Kernel Image Start ]---
0x000003ffe0000000-0x000003ffe0e00000        14M PMD RO X
0x000003ffe0e00000-0x000003ffe0ec7000       796K PTE RO X
0x000003ffe0ec7000-0x000003ffe0f00000       228K PTE RO NX
0x000003ffe0f00000-0x000003ffe1300000         4M PMD RO NX
0x000003ffe1300000-0x000003ffe1331000       196K PTE RO NX
0x000003ffe1331000-0x000003ffe13b3000       520K PTE RW NX <---
0x000003ffe13b3000-0x000003ffe13d5000       136K PTE RO NX
0x000003ffe13d5000-0x000003ffe1400000       172K PTE RW NX
0x000003ffe1400000-0x000003ffe1500000         1M PMD RW NX
0x000003ffe1500000-0x000003ffe1700000         2M PTE RW NX
0x000003ffe1700000-0x000003ffe1800000         1M PMD RW NX
0x000003ffe1800000-0x000003ffe187e000       504K PTE RW NX
---[ Kernel Image End ]---

Move the ro_after_init data section again right behind the rodata
section to prevent interleaving RO and RW mappings:

---[ Kernel Image Start ]---
0x000003ffe0000000-0x000003ffe0e00000        14M PMD RO X
0x000003ffe0e00000-0x000003ffe0ec7000       796K PTE RO X
0x000003ffe0ec7000-0x000003ffe0f00000       228K PTE RO NX
0x000003ffe0f00000-0x000003ffe1300000         4M PMD RO NX
0x000003ffe1300000-0x000003ffe1353000       332K PTE RO NX
0x000003ffe1353000-0x000003ffe1400000       692K PTE RW NX
0x000003ffe1400000-0x000003ffe1500000         1M PMD RW NX
0x000003ffe1500000-0x000003ffe1700000         2M PTE RW NX
0x000003ffe1700000-0x000003ffe1800000         1M PMD RW NX
0x000003ffe1800000-0x000003ffe187e000       504K PTE RW NX
---[ Kernel Image End ]---

Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/vmlinux.lds.S | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 2ae201ebf90b..de5f9f623f5b 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -71,6 +71,15 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	__end_ro_after_init = .;
 
+	.data.rel.ro : {
+		*(.data.rel.ro .data.rel.ro.*)
+	}
+	.got : {
+		__got_start = .;
+		*(.got)
+		__got_end = .;
+	}
+
 	RW_DATA(0x100, PAGE_SIZE, THREAD_SIZE)
 	BOOT_DATA_PRESERVED
 
-- 
2.43.0



