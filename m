Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A11190696;
	Tue, 10 Sep 2024 10:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963746; cv=none; b=MYImLb/29Prz1qi15pyTBn+v8BPj5LeqXyl0OjVEFAbeVwcyV0cCa1bk0pT20m9Fn0/Ac85myRkjlIvPMusL02Y/L2TBixJ6flIb0ozbDKp7xBPx93d2rzPd7FDN5wkKLFxsqXvSGV2VrAY01tSybjlpmiQbnsN5PVQHtsb/PuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963746; c=relaxed/simple;
	bh=fW7uasRWsIE3UMyES8pmyio0/nIg/IC6h9AWbc3ruwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHFPUd4jNT6oB7EjZRWLKHmAY8SCamHzZqYVkbxLZTM7e5iylAHN+Cczfe6u5XRKCgyR1o8IFV+Sbznpve6/YXtLzS1f8wdauxXOVcjusxmJPm3nJDtyCQYiFGQwqTrpzf5w1MhbY53n4tsSlhBl1jYAItWGuH7TZVNzQp0vpUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2MAJ1/Ae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2MAJ1/Ae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A4FC4CEC3;
	Tue, 10 Sep 2024 10:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963746;
	bh=fW7uasRWsIE3UMyES8pmyio0/nIg/IC6h9AWbc3ruwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2MAJ1/Aek5WS0H42XfJfae25/HchuzPi25y9ILp/3TLowmFqGANDBF5MkrNGSbdjN
	 GVC7fKuo4etmkC49zdC1q2zc9AblSn4/aMMVeKGRvUHLBlzQeLJuW8Pph7syXGVvZG
	 2E1sToK7hDWrzi9f+KbJMMYU0Mqh8t1zp8VIzuu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/214] s390/vmlinux.lds.S: Move ro_after_init section behind rodata section
Date: Tue, 10 Sep 2024 11:33:04 +0200
Message-ID: <20240910092605.316770539@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 853b80770c6d..bf509f6194d0 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -72,6 +72,15 @@ SECTIONS
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



