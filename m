Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A9A186E4B;
	Tue, 10 Sep 2024 09:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962008; cv=none; b=Ox8rSBW0NuajOPT62DDn925HcuYwyVYT8Zim3wuAv809wqmNbmPKKQ82cpoMif6jOm1yz8quVgf6MYnaidr11B5IkqAhI+aXRJyQCIa7Mvu6hD+aH4d+W/sKr2ztnX9Xmpsok/gGU/gxVoGLx2mcU1U9UjynrP9JdivaqKynyCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962008; c=relaxed/simple;
	bh=H0WDz2MIhDOR7IB1T+6v5dNIMIoKfdF+ZwS6QVtIvxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P950xpRlWEsRbRBWyn4brCGmKG7ul9vfZ8zq0cbtS9vE1X4OwyAWXin5nroi/MkIFyOZG5qHNcvQ/3OW+nEbGs0ZidxdxZFgobsbvot0WcC0dn2bUy38KCpYS+ZNSPyiolHRCS5llraLkjmxzA/Q+62S6aEqrNezp3FRnyO6y8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjm+yxk4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjm+yxk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99C8C4CECD;
	Tue, 10 Sep 2024 09:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962008;
	bh=H0WDz2MIhDOR7IB1T+6v5dNIMIoKfdF+ZwS6QVtIvxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjm+yxk47ENlbj9nP90Iavi1D1+XealCceoWeozxMHR5zlkOw8iQT5SsD2c2q4Iq+
	 bdCmxvCjEhzcAjxmxMYJvGqTfIlnQDDS8+ovdovIx3vgpwTy0Yo05Vl6swJfu4ut1u
	 tAX0VjyamzhiXEiPvu4SfJSYNCgWsrqwRLcyUlFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 264/375] s390/vmlinux.lds.S: Move ro_after_init section behind rodata section
Date: Tue, 10 Sep 2024 11:31:01 +0200
Message-ID: <20240910092631.423594721@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 arch/s390/kernel/vmlinux.lds.S | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 52bd969b2828..779162c664c4 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -59,14 +59,6 @@ SECTIONS
 	} :text = 0x0700
 
 	RO_DATA(PAGE_SIZE)
-	.data.rel.ro : {
-		*(.data.rel.ro .data.rel.ro.*)
-	}
-	.got : {
-		__got_start = .;
-		*(.got)
-		__got_end = .;
-	}
 
 	. = ALIGN(PAGE_SIZE);
 	_sdata = .;		/* Start of data section */
@@ -80,6 +72,15 @@ SECTIONS
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
 	.data.rel : {
 		*(.data.rel*)
-- 
2.43.0



