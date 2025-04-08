Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EEE2265602;
	Tue,  8 Apr 2025 11:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112801; cv=none; b=fBkZMt8V2YAov+6UopXjdkZ/4r95YwSqZ6tti5kup49kJ9KweV6X28V0b/2pqteo8r1XGzlYIaQwtJ5UrKI1FdEzOpBhM9aQROSvbx4e5q3PObRIJhnCzfUO/Phu23IUUkBsSL5DD44esxDcuacaOW1/f2ztLsoIdZQZHseWIe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112801; c=relaxed/simple;
	bh=XqTTD1mYr1Gw9WxbQiyzJzukRu6IhxreV/A4R5pYCLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XeL+oPjF30H1vGpgno2xWrCbOhxYeGD+/DDMzdUYkfhhczTGNif2OQqJAQYp91XOWD9rJjPhOD//N1B/0Gwj87ClBiJGZ+gl5EJOHCuF+rsXR/0xhaLDnHSmC9qxi8ltI9eHhGXIQyqVRm8btnnjl1tlDgqyc8fqCS4c7RKC1+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B7TFiMSs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B7TFiMSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923C5C4CEE5;
	Tue,  8 Apr 2025 11:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112800;
	bh=XqTTD1mYr1Gw9WxbQiyzJzukRu6IhxreV/A4R5pYCLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B7TFiMSsWf86RbZYm7jivjxt/Xzw7bO3FcxB2Nn3t7556S/ptZGFSuJiIR1g3hyr2
	 GQYP0+KNSGWK3hbz12qqvjPdHbXzd4hsdhK7B19TKbn6OTyEBabXwxtU/evd/rQ03o
	 MucO9JrAHEoVVzgLo+L3moqK5YR0F33SBvTYNCTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Baoquan He <bhe@redhat.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mahesh Salgaonkar <mahesh@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 201/279] kexec: initialize ELF lowest address to ULONG_MAX
Date: Tue,  8 Apr 2025 12:49:44 +0200
Message-ID: <20250408104831.762587928@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sourabh Jain <sourabhjain@linux.ibm.com>

[ Upstream commit 9986fb5164c8b21f6439cfd45ba36d8cc80c9710 ]

Patch series "powerpc/crash: use generic crashkernel reservation", v3.

Commit 0ab97169aa05 ("crash_core: add generic function to do reservation")
added a generic function to reserve crashkernel memory.  So let's use the
same function on powerpc and remove the architecture-specific code that
essentially does the same thing.

The generic crashkernel reservation also provides a way to split the
crashkernel reservation into high and low memory reservations, which can
be enabled for powerpc in the future.

Additionally move powerpc to use generic APIs to locate memory hole for
kexec segments while loading kdump kernel.

This patch (of 7):

kexec_elf_load() loads an ELF executable and sets the address of the
lowest PT_LOAD section to the address held by the lowest_load_addr
function argument.

To determine the lowest PT_LOAD address, a local variable lowest_addr
(type unsigned long) is initialized to UINT_MAX.  After loading each
PT_LOAD, its address is compared to lowest_addr.  If a loaded PT_LOAD
address is lower, lowest_addr is updated.  However, setting lowest_addr to
UINT_MAX won't work when the kernel image is loaded above 4G, as the
returned lowest PT_LOAD address would be invalid.  This is resolved by
initializing lowest_addr to ULONG_MAX instead.

This issue was discovered while implementing crashkernel high/low
reservation on the PowerPC architecture.

Link: https://lkml.kernel.org/r/20250131113830.925179-1-sourabhjain@linux.ibm.com
Link: https://lkml.kernel.org/r/20250131113830.925179-2-sourabhjain@linux.ibm.com
Fixes: a0458284f062 ("powerpc: Add support code for kexec_file_load()")
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Acked-by: Hari Bathini <hbathini@linux.ibm.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kexec_elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kexec_elf.c b/kernel/kexec_elf.c
index d3689632e8b90..3a5c25b2adc94 100644
--- a/kernel/kexec_elf.c
+++ b/kernel/kexec_elf.c
@@ -390,7 +390,7 @@ int kexec_elf_load(struct kimage *image, struct elfhdr *ehdr,
 			 struct kexec_buf *kbuf,
 			 unsigned long *lowest_load_addr)
 {
-	unsigned long lowest_addr = UINT_MAX;
+	unsigned long lowest_addr = ULONG_MAX;
 	int ret;
 	size_t i;
 
-- 
2.39.5



