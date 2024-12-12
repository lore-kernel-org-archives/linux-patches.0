Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E83322EA1B;
	Thu, 12 Dec 2024 16:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019454; cv=none; b=usAf3vvLJqihOluC0XyIGgI2aJu9Q55vsZ4awpCW2pWkpdepBhvV0pKKPyo5sEXEX6Ojbx1rMEhQpxUUTvdfTslRI3SVNTSoWv4qrm742qeWGIx2F/EmS83EN1PlY6evicSzMg3MR3dfPqLXuoO2jmPfadj0Z82FyQxn82CAvds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019454; c=relaxed/simple;
	bh=Lpvm/VUsOTh0ln5TOb7tjgs/MeoWqm5IehebhMbVYzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+KBAVTmZ3jE7a+XPgKqqvrm045rL+nzaBIjh+/Rryr+cFUvj4qaH8As/d59/aGJBHMKuXouzqenKNwiU1awphfl9DFsBSE6NOzCPfhv6QxE5fsFTdVeWiseIpmdDF5+CdQKbb5iLA3f0LRgmflDScTzbSKz7qmiz29goO2Uq0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0wtBh4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0wtBh4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB810C4CECE;
	Thu, 12 Dec 2024 16:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019454;
	bh=Lpvm/VUsOTh0ln5TOb7tjgs/MeoWqm5IehebhMbVYzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0wtBh4QNLUQ+vl7+COqJzZqJsX1NQPSpDgLRQRyMjKosW3mntGAaZ6sxJpHOPtDY
	 DHNACJaiuKpubQE43paGqtDDA5L/fy5FmfZzRocJYB+9LW1RLK+1EzCDwraW66AA9y
	 axo+02W8OdsxD1x/gQAr6dOgL+ys4V69nDzBjsl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Bathini <hbathini@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 211/772] powerpc/fadump: Refactor and prepare fadump_cma_init for late init
Date: Thu, 12 Dec 2024 15:52:36 +0100
Message-ID: <20241212144358.640177395@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

[ Upstream commit adfaec30ffaceecd565e06adae367aa944acc3c9 ]

We anyway don't use any return values from fadump_cma_init(). Since
fadump_reserve_mem() from where fadump_cma_init() gets called today,
already has the required checks.
This patch makes this function return type as void. Let's also handle
extra cases like return if fadump_supported is false or dump_active, so
that in later patches we can call fadump_cma_init() separately from
setup_arch().

Acked-by: Hari Bathini <hbathini@linux.ibm.com>
Reviewed-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/a2afc3d6481a87a305e89cfc4a3f3d2a0b8ceab3.1729146153.git.ritesh.list@gmail.com
Stable-dep-of: 05b94cae1c47 ("powerpc/fadump: Move fadump_cma_init to setup_arch() after initmem_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/fadump.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index 3ff2da7b120b5..4722a9e606e61 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -80,27 +80,23 @@ static struct cma *fadump_cma;
  * But for some reason even if it fails we still have the memory reservation
  * with us and we can still continue doing fadump.
  */
-static int __init fadump_cma_init(void)
+static void __init fadump_cma_init(void)
 {
 	unsigned long long base, size;
 	int rc;
 
-	if (!fw_dump.fadump_enabled)
-		return 0;
-
+	if (!fw_dump.fadump_supported || !fw_dump.fadump_enabled ||
+			fw_dump.dump_active)
+		return;
 	/*
 	 * Do not use CMA if user has provided fadump=nocma kernel parameter.
-	 * Return 1 to continue with fadump old behaviour.
 	 */
-	if (fw_dump.nocma)
-		return 1;
+	if (fw_dump.nocma || !fw_dump.boot_memory_size)
+		return;
 
 	base = fw_dump.reserve_dump_area_start;
 	size = fw_dump.boot_memory_size;
 
-	if (!size)
-		return 0;
-
 	rc = cma_init_reserved_mem(base, size, 0, "fadump_cma", &fadump_cma);
 	if (rc) {
 		pr_err("Failed to init cma area for firmware-assisted dump,%d\n", rc);
@@ -110,7 +106,7 @@ static int __init fadump_cma_init(void)
 		 * blocked from production system usage.  Hence return 1,
 		 * so that we can continue with fadump.
 		 */
-		return 1;
+		return;
 	}
 
 	/*
@@ -127,10 +123,9 @@ static int __init fadump_cma_init(void)
 		cma_get_size(fadump_cma),
 		(unsigned long)cma_get_base(fadump_cma) >> 20,
 		fw_dump.reserve_dump_area_size);
-	return 1;
 }
 #else
-static int __init fadump_cma_init(void) { return 1; }
+static void __init fadump_cma_init(void) { }
 #endif /* CONFIG_CMA */
 
 /* Scan the Firmware Assisted dump configuration details. */
@@ -648,7 +643,7 @@ int __init fadump_reserve_mem(void)
 		pr_info("Reserved %lldMB of memory at %#016llx (System RAM: %lldMB)\n",
 			(size >> 20), base, (memblock_phys_mem_size() >> 20));
 
-		ret = fadump_cma_init();
+		fadump_cma_init();
 	}
 
 	return ret;
-- 
2.43.0



