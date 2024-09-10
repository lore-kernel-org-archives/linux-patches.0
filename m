Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6413217A589;
	Tue, 10 Sep 2024 10:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965134; cv=none; b=OMpMomjTPyRFph/iuEXY3cSFGKEPkJC4xqpzvI0rE3XUGx6Ot2rVZ7P4vWZ7zjpBxqbYVHPG6KyFxlrKyvf6NTyK2Ajtj+2c4Hu3FZeSzeowRbpnwhk9KbUdIksgRGAw6oh86jpW9xCdkMlq+VY5AQUmQGqaN+qMY2IdaDqzERY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965134; c=relaxed/simple;
	bh=9FIMi/lSVXmrHASRyPiRd2Rngb6W+O3A44i6Lo42F3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrtECU+FaXn2qxXTE7cAGjD647kbeAt/l5oMdVVqN5wp0P7MCmNlThZyZPS7nklkqCiQY7hXc2i9xlFsBpMRun85o/tWiGH7y1SP4Icwkj7uL2pk3IVUueg9jyOsrAg1P5SnWP4bPH/c3mjnAc/lOG+DwdqGPLxws89QZ8EJseA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GiFPWrE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GiFPWrE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF140C4CEC3;
	Tue, 10 Sep 2024 10:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965134;
	bh=9FIMi/lSVXmrHASRyPiRd2Rngb6W+O3A44i6Lo42F3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GiFPWrE5FljRJ0uKnuVhvhliyL3w5X0REU3qD67bnxXu8EXVAoPMkZ4b0fRwCLurp
	 XUdu6G++zGnwQw0b4sT1GvY3UVROw5KkGZWuruFZxmnhO5QNSz8SX0fXkETRqdV6i7
	 uofvbaK1KFFpQR+TfFCdwlJwgMT283Evzm39GmNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 148/186] s390/vmlinux.lds.S: Move ro_after_init section behind rodata section
Date: Tue, 10 Sep 2024 11:34:03 +0200
Message-ID: <20240910092600.698314049@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1c65c38ec9a3..c4bf95371f49 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -69,6 +69,15 @@ SECTIONS
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



