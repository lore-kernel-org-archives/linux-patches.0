Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85E417B505;
	Wed,  5 Feb 2025 15:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768419; cv=none; b=OTP8wWRy+Qmjv1TqXb3exB8V8o1nr/OGYTEHSEP103h11ltJWDhhqbeVXCBSdZUIbDJBTR57Fm0utC8WV4+ngvPrzvG8ha0agY37TbKmPrBRZAsIadmJMK8RHewMH/fPdfL+HH5cyuplbVR7MUtXzdKIEKneQGQxMFNRqI0dBB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768419; c=relaxed/simple;
	bh=PJ4pd5GuNCzt8+zyn9VKfuwaFnZagALatr99q5zF5Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Os+Gv0ahyPTdtNgYEAwWkoSC6iG4YrPUu/aFNhAsMVeMSLwIkj/HlKbDmEOuXWhS/qIIJ7eqqq2rlR3SY2R7SQJ7oj4jcjxifCLsWFsPuGbJGdSkMNw4mtftboU5ArVhFOcgz+dtu7olO1tKy4eaMKTO75OzS8Ob6GXe3Q88Li0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gY4OII6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gY4OII6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9B3C4CED1;
	Wed,  5 Feb 2025 15:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768418;
	bh=PJ4pd5GuNCzt8+zyn9VKfuwaFnZagALatr99q5zF5Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gY4OII6rMdLl8k6oDeHEWJQnC7id6ITeiCP+WBNsEInb5Kr2+pkNHStw1Tkvaiv11
	 PWJHQnW0Yhe1Rsz9m4dKoHmmukn9f+D5gQjFe0wNBuWv8N/0fcxqnlVRix1NczDvAR
	 1wALUcDqLA31XSrNT+NasG6Q7ge6TmNGQMNb9dzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Oreoluwa Babatunde <quic_obabatun@quicinc.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.12 577/590] dma-mapping: save base/size instead of pointer to shared DMA pool
Date: Wed,  5 Feb 2025 14:45:32 +0100
Message-ID: <20250205134517.341036113@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 22293c33738c14bb84b9d3e771bc37150e7cf8e7 upstream.

On RZ/Five, which is non-coherent, and uses CONFIG_DMA_GLOBAL_POOL=y:

    Oops - store (or AMO) access fault [#1]
    CPU: 0 UID: 0 PID: 1 Comm: swapper Not tainted 6.12.0-rc1-00015-g8a6e02d0c00e #201
    Hardware name: Renesas SMARC EVK based on r9a07g043f01 (DT)
    epc : __memset+0x60/0x100
     ra : __dma_alloc_from_coherent+0x150/0x17a
    epc : ffffffff8062d2bc ra : ffffffff80053a94 sp : ffffffc60000ba20
     gp : ffffffff812e9938 tp : ffffffd601920000 t0 : ffffffc6000d0000
     t1 : 0000000000000000 t2 : ffffffffe9600000 s0 : ffffffc60000baa0
     s1 : ffffffc6000d0000 a0 : ffffffc6000d0000 a1 : 0000000000000000
     a2 : 0000000000001000 a3 : ffffffc6000d1000 a4 : 0000000000000000
     a5 : 0000000000000000 a6 : ffffffd601adacc0 a7 : ffffffd601a841a8
     s2 : ffffffd6018573c0 s3 : 0000000000001000 s4 : ffffffd6019541e0
     s5 : 0000000200000022 s6 : ffffffd6018f8410 s7 : ffffffd6018573e8
     s8 : 0000000000000001 s9 : 0000000000000001 s10: 0000000000000010
     s11: 0000000000000000 t3 : 0000000000000000 t4 : ffffffffdefe62d1
     t5 : 000000001cd6a3a9 t6 : ffffffd601b2aad6
    status: 0000000200000120 badaddr: ffffffc6000d0000 cause: 0000000000000007
    [<ffffffff8062d2bc>] __memset+0x60/0x100
    [<ffffffff80053e1a>] dma_alloc_from_global_coherent+0x1c/0x28
    [<ffffffff80053056>] dma_direct_alloc+0x98/0x112
    [<ffffffff8005238c>] dma_alloc_attrs+0x78/0x86
    [<ffffffff8035fdb4>] rz_dmac_probe+0x3f6/0x50a
    [<ffffffff803a0694>] platform_probe+0x4c/0x8a

If CONFIG_DMA_GLOBAL_POOL=y, the reserved_mem structure passed to
rmem_dma_setup() is saved for later use, by saving the passed pointer.
However, when dma_init_reserved_memory() is called later, the pointer
has become stale, causing a crash.

E.g. in the RZ/Five case, the referenced memory now contains the
reserved_mem structure for the "mmode_resv0@30000" node (with base
0x30000 and size 0x10000), instead of the correct "pma_resv0@58000000"
node (with base 0x58000000 and size 0x8000000).

Fix this by saving the needed reserved_mem structure's contents instead.

Fixes: 8a6e02d0c00e7b62 ("of: reserved_mem: Restructure how the reserved memory regions are processed")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Oreoluwa Babatunde <quic_obabatun@quicinc.com>
Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/dma/coherent.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -330,7 +330,8 @@ int dma_init_global_coherent(phys_addr_t
 #include <linux/of_reserved_mem.h>
 
 #ifdef CONFIG_DMA_GLOBAL_POOL
-static struct reserved_mem *dma_reserved_default_memory __initdata;
+static phys_addr_t dma_reserved_default_memory_base __initdata;
+static phys_addr_t dma_reserved_default_memory_size __initdata;
 #endif
 
 static int rmem_dma_device_init(struct reserved_mem *rmem, struct device *dev)
@@ -376,9 +377,10 @@ static int __init rmem_dma_setup(struct
 
 #ifdef CONFIG_DMA_GLOBAL_POOL
 	if (of_get_flat_dt_prop(node, "linux,dma-default", NULL)) {
-		WARN(dma_reserved_default_memory,
+		WARN(dma_reserved_default_memory_size,
 		     "Reserved memory: region for default DMA coherent area is redefined\n");
-		dma_reserved_default_memory = rmem;
+		dma_reserved_default_memory_base = rmem->base;
+		dma_reserved_default_memory_size = rmem->size;
 	}
 #endif
 
@@ -391,10 +393,10 @@ static int __init rmem_dma_setup(struct
 #ifdef CONFIG_DMA_GLOBAL_POOL
 static int __init dma_init_reserved_memory(void)
 {
-	if (!dma_reserved_default_memory)
+	if (!dma_reserved_default_memory_size)
 		return -ENOMEM;
-	return dma_init_global_coherent(dma_reserved_default_memory->base,
-					dma_reserved_default_memory->size);
+	return dma_init_global_coherent(dma_reserved_default_memory_base,
+					dma_reserved_default_memory_size);
 }
 core_initcall(dma_init_reserved_memory);
 #endif /* CONFIG_DMA_GLOBAL_POOL */


