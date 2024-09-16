Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D952F158DA0;
	Mon, 16 Sep 2024 12:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488301; cv=none; b=ANx8LazO/obdRZIUpsMunOh+A6uQ3RTecDN4XgytY063wCDAzd6nV/rLZQ4SVUYz4o+A/hP1I29Ql7aLEkkJRvq94fQ9HZENxFDgLRBM3UnLqfkmNm64BjkwglZFkQJ6z0IjSUlKSvY9qJ57F+4PFPWdA+G3NWUbND2GimyINdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488301; c=relaxed/simple;
	bh=bYmTKpKrnGVaz9jHcxUn6NbJmOSaeFpgCJ8orA+bpkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rxqh+/T89LhOxSDhCCwOBTF8stQBgcifax2uhZOn7BzxpW9EmTq6HzLrMEsqPQ1dPCM3e+cY0drEf+dlbb1RVC2ClzXZ6nENZhswzILsYtIZc66GH9GBncT8U5kUravvN31jV5Qpp6zfJpCSmeOA1dCgOv8MOsvOM+8Ulpps5EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqLsRHrA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqLsRHrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEFCC4CEC4;
	Mon, 16 Sep 2024 12:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488301;
	bh=bYmTKpKrnGVaz9jHcxUn6NbJmOSaeFpgCJ8orA+bpkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gqLsRHrANWKB+9qwjHAf6mh7gGDFMjcGquE9hSB+EYQZY3WUg70Fluzakjw/uUUzg
	 IDaSP7mZUboPtD46F98jQlCz3+mnHoPxQdARDjdjdKDcvtzM3I4meFxlaW3lTTFm/5
	 EkhHH4V+SBGCVGliUW1MfAtFqltZVfQFtvUfPhzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 039/121] s390/mm: Pin identity mapping base to zero
Date: Mon, 16 Sep 2024 13:43:33 +0200
Message-ID: <20240916114230.417611803@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 32db401965f165f7c44447d0508097f070c8f576 ]

SIE instruction performs faster when the virtual address of
SIE block matches the physical one. Pin the identity mapping
base to zero for the benefit of SIE and other instructions
that have similar performance impact. Still, randomize the
base when DEBUG_VM kernel configuration option is enabled.

Suggested-by: Vasily Gorbik <gor@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/Kconfig        | 13 +++++++++++++
 arch/s390/boot/startup.c |  3 ++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index c59d2b54df49..4f7ed0cd12cc 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -602,6 +602,19 @@ config RANDOMIZE_BASE
 	  as a security feature that deters exploit attempts relying on
 	  knowledge of the location of kernel internals.
 
+config RANDOMIZE_IDENTITY_BASE
+	bool "Randomize the address of the identity mapping base"
+	depends on RANDOMIZE_BASE
+	default DEBUG_VM
+	help
+	  The identity mapping base address is pinned to zero by default.
+	  Allow randomization of that base to expose otherwise missed
+	  notion of physical and virtual addresses of data structures.
+	  That does not have any impact on the base address at which the
+	  kernel image is loaded.
+
+	  If unsure, say N
+
 config KERNEL_IMAGE_BASE
 	hex "Kernel image base address"
 	range 0x100000 0x1FFFFFE0000000 if !KASAN
diff --git a/arch/s390/boot/startup.c b/arch/s390/boot/startup.c
index 66ee97ac803d..90c51368f933 100644
--- a/arch/s390/boot/startup.c
+++ b/arch/s390/boot/startup.c
@@ -333,7 +333,8 @@ static unsigned long setup_kernel_memory_layout(unsigned long kernel_size)
 	BUILD_BUG_ON(MAX_DCSS_ADDR > (1UL << MAX_PHYSMEM_BITS));
 	max_mappable = max(ident_map_size, MAX_DCSS_ADDR);
 	max_mappable = min(max_mappable, vmemmap_start);
-	__identity_base = round_down(vmemmap_start - max_mappable, rte_size);
+	if (IS_ENABLED(CONFIG_RANDOMIZE_IDENTITY_BASE))
+		__identity_base = round_down(vmemmap_start - max_mappable, rte_size);
 
 	return asce_limit;
 }
-- 
2.43.0



