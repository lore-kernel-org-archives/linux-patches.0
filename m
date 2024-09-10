Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC88188A0C;
	Tue, 10 Sep 2024 10:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963050; cv=none; b=J72TCPvkqxUIftQZErImyB5qndDGrLRPsqZMs/j7vnOa6e3yI1iIoeiAwplVNsGuDcVb9U2mCUzw0Zepn0wy0eyLr94uMgSoLQX07aC+h27fBZ/kEcTNQ990JZTvG+SqoyVFDiqyvvhmq6XM/iIeOaF1OuogdsIW3iEL104Ist8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963050; c=relaxed/simple;
	bh=gEtCaaFQ4cpM/tGJVl1dtzTWN+U1YJK01a+1gU+QrVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqZq+y2c+2GdgZgU6l9XJ+9O87jO0TsmGj8Iq6QCvJWyIdo+QRvh6demv9TS3yq8iz4thR6RKw+Gr6QJ2p3TozqRr1n+G3Lr4dAbkgzI7JqaI8gSFFRt9/GJGuetfypk0oUl14hVBxsN+AMgYfg27xLq7zZfA1WrWNPdr0o+pZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdsoQKaZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdsoQKaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18234C4CECD;
	Tue, 10 Sep 2024 10:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963050;
	bh=gEtCaaFQ4cpM/tGJVl1dtzTWN+U1YJK01a+1gU+QrVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VdsoQKaZN3IgTALaiBMkcF2xt1pbnpgPifOWnoI2ygkH8d7L6pGiyPvv5Il2oAPgX
	 RBYcvoENnCTLA37mjZHo3pvFJ7ohlmt2CcJJ5sv7U7gMiw1tJ02SVP9Z3jJ3jvK6yy
	 9o4DlC8pnJBghdcG4GIf1bWRDBW8Soqy12uDFoPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/192] s390/vmlinux.lds.S: Move ro_after_init section behind rodata section
Date: Tue, 10 Sep 2024 11:32:23 +0200
Message-ID: <20240910092602.919868041@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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
index 729d4f949cfe..52d6e5d1b453 100644
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



