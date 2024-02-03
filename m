Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0568B134D1;
	Sat,  3 Feb 2024 04:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933751; cv=none; b=RIUuUI/VU46KZajDScVSqSe/V2L9JSnsJyQP+jWaHrSKvpwQGx2JivjRVfQ3cuzk8KE9+pYj+xPKXav0FP7LwtU96n4zW+D6x2OkGKSNzTLvwX32cjFDTgrnDnXdwgw88Vc9cwnZsWLCaVFODO2zIyLPHHhTvoNScgbOoJqopiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933751; c=relaxed/simple;
	bh=yZAFzzNQVImpE9npUa+pfQUUHDq32Og8w9jeLKhfPSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8sPmsr5XKnBUlFv27/HJdKe/3CUKAI1ucKMdjC3QvrtMjrfy668pkNJY1ELawcI0+ANGr2+c0HKqLfTGaTN4uy2IkTqu6BIe84pID+cNc//Z5DKzovTBT/v/05dvO0aWXSyRnDEh1MjzRwhDxAWbeM8z9k76Q/udJoPGowAStE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SW4kwfHU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SW4kwfHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C051EC433F1;
	Sat,  3 Feb 2024 04:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933750;
	bh=yZAFzzNQVImpE9npUa+pfQUUHDq32Og8w9jeLKhfPSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SW4kwfHUg22qYRmwOT+EyqIju9BLPMSwc4WI2yzWWouMGUdziYv1nMJLn1yiWSZU9
	 RBGqQOhcziIPS5xyS+Vu2XoxvXXTcum+3nG1zmOoXcTQe46MvEV/6KbiCt6vcbzViX
	 pDCMarmkfGwxvSBL7fqUMIWwDqwTBvap9ehQUGUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 046/353] s390/boot: always align vmalloc area on segment boundary
Date: Fri,  2 Feb 2024 20:02:44 -0800
Message-ID: <20240203035405.267905572@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 65f8780e2d70257200547b5a7654974aa7c37ce1 ]

The size of vmalloc area depends from various factors
on boot and could be set to:

1. Default size as determined by VMALLOC_DEFAULT_SIZE macro;
2. One half of the virtual address space not occupied by
   modules and fixed mappings;
3. The size provided by user with vmalloc= kernel command
   line parameter;

In cases [1] and [2] the vmalloc area base address is aligned
on Region3 table type boundary, while in case [3] in might get
aligned on page boundary.

Limit the waste of page tables and always align vmalloc area
size and base address on segment boundary.

Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/ipl_parm.c | 2 +-
 arch/s390/boot/startup.c  | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/s390/boot/ipl_parm.c b/arch/s390/boot/ipl_parm.c
index 2ab4872fbee1..b24de9aabf7d 100644
--- a/arch/s390/boot/ipl_parm.c
+++ b/arch/s390/boot/ipl_parm.c
@@ -274,7 +274,7 @@ void parse_boot_command_line(void)
 			memory_limit = round_down(memparse(val, NULL), PAGE_SIZE);
 
 		if (!strcmp(param, "vmalloc") && val) {
-			vmalloc_size = round_up(memparse(val, NULL), PAGE_SIZE);
+			vmalloc_size = round_up(memparse(val, NULL), _SEGMENT_SIZE);
 			vmalloc_size_set = 1;
 		}
 
diff --git a/arch/s390/boot/startup.c b/arch/s390/boot/startup.c
index 8104e0e3d188..9cc76e631759 100644
--- a/arch/s390/boot/startup.c
+++ b/arch/s390/boot/startup.c
@@ -255,7 +255,8 @@ static unsigned long setup_kernel_memory_layout(void)
 	VMALLOC_END = MODULES_VADDR;
 
 	/* allow vmalloc area to occupy up to about 1/2 of the rest virtual space left */
-	vmalloc_size = min(vmalloc_size, round_down(VMALLOC_END / 2, _REGION3_SIZE));
+	vsize = round_down(VMALLOC_END / 2, _SEGMENT_SIZE);
+	vmalloc_size = min(vmalloc_size, vsize);
 	VMALLOC_START = VMALLOC_END - vmalloc_size;
 
 	/* split remaining virtual space between 1:1 mapping & vmemmap array */
-- 
2.43.0



