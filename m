Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657991CAA0;
	Sat,  3 Feb 2024 04:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933526; cv=none; b=tcKYl0rri1LI74L3Twd8YUB2T1hKGOVQVamU+RrkUbEl8QfCFEpGm7e7Pye+dkTTPd0wURmnHAJhksRIuy7jFFAO2ge0fCmKbduEolu2xI2KCDlZdndj8StCla/eLXtqXhcg2oubRq+q1+R9m3GWkJdP/aDzdXKKO1zV7YBTLvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933526; c=relaxed/simple;
	bh=teE1M8/M5Ke6ogj2bop939hINL9aiAyEbsOhfuvelWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnnBrUK+bLT8R+fa19KdF4Tphf1J5jyLPTB2yy8TGAlzj2kl523OTjYlsX2uGGxFJQZ2g+NMwrm5GkRTx0ODjNOZDvtk1/3a/UYcAdmhKwCRlltZ8ru+PgyEu2rPUHEoac8izqh1FGyReJhMnDVFY5afiGF9MB/VdV2DLyBqiv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gl9/8NaK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gl9/8NaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D999C43394;
	Sat,  3 Feb 2024 04:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933526;
	bh=teE1M8/M5Ke6ogj2bop939hINL9aiAyEbsOhfuvelWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gl9/8NaKUU4RkHBNJKRHu/say+K/alaTYmhOGX2RvP2d8GwKJib3hmEqOQgcresGh
	 kg/rt8dEr72WQANt8jzQ4+Dbu2uqDxERMkwFqTSR96ECz9kf3iyi8I02hmINv8L5nu
	 iK9Wbzv1IpZErEPCokC4JIZvBdr5RntI/YvvyVRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/322] s390/boot: always align vmalloc area on segment boundary
Date: Fri,  2 Feb 2024 20:02:20 -0800
Message-ID: <20240203035400.480845947@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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
index 7b7521762633..4230144645bc 100644
--- a/arch/s390/boot/ipl_parm.c
+++ b/arch/s390/boot/ipl_parm.c
@@ -272,7 +272,7 @@ void parse_boot_command_line(void)
 			memory_limit = round_down(memparse(val, NULL), PAGE_SIZE);
 
 		if (!strcmp(param, "vmalloc") && val) {
-			vmalloc_size = round_up(memparse(val, NULL), PAGE_SIZE);
+			vmalloc_size = round_up(memparse(val, NULL), _SEGMENT_SIZE);
 			vmalloc_size_set = 1;
 		}
 
diff --git a/arch/s390/boot/startup.c b/arch/s390/boot/startup.c
index d3e48bd9c394..d08db5df6091 100644
--- a/arch/s390/boot/startup.c
+++ b/arch/s390/boot/startup.c
@@ -212,7 +212,8 @@ static unsigned long setup_kernel_memory_layout(void)
 	VMALLOC_END = MODULES_VADDR;
 
 	/* allow vmalloc area to occupy up to about 1/2 of the rest virtual space left */
-	vmalloc_size = min(vmalloc_size, round_down(VMALLOC_END / 2, _REGION3_SIZE));
+	vsize = round_down(VMALLOC_END / 2, _SEGMENT_SIZE);
+	vmalloc_size = min(vmalloc_size, vsize);
 	VMALLOC_START = VMALLOC_END - vmalloc_size;
 
 	/* split remaining virtual space between 1:1 mapping & vmemmap array */
-- 
2.43.0



