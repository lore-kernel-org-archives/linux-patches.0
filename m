Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3315A1586D6;
	Mon, 29 Jan 2024 17:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548117; cv=none; b=rMJqb4AzmKrftpeNdvRQJ/E4Zt6IuF0392vwr8wh/jV6I/5dNBQ/dOFklgS0sR0cRablIvo31hBksto3/HuCEJzHeY6rPfFX6CcHHdQr0xqOLYoZC+qYZ8H+8+hL+C4wzs7dCfMKKAYBPVsx2SBP1b6Ug+ZAKkffh4omyqSB2aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548117; c=relaxed/simple;
	bh=/4oQinEXcJ6BfsGMGt1XvaRevdbKapAgLEkPrQ9Svdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kS/D5fIq0Z1rMXSs1B7swJmAfitpn0Zw7jbdDyHvQ8qJCFgCrfDgUHVZZfw4k8hWMu8nVOsIOPkwVDx9EDs5lR+pRpa6cd2dYnUZDqqJZQYeIMt5LPw48s+m28bq5laQ9gfl8OJJKMmGlw3DhWDvtboW8U64g+sYXQA5oP0RAaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVi/vSPO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVi/vSPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0951C433A6;
	Mon, 29 Jan 2024 17:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548117;
	bh=/4oQinEXcJ6BfsGMGt1XvaRevdbKapAgLEkPrQ9Svdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVi/vSPOIoS45BnNDdzHKcSvWp+ws+NFQ0nKtUDrB61WzzB1pEMx1VraBFiyrbe2/
	 k1uRSHQhLDD/i9H+c8RYShRu+A8YtKr6DSaoH1ofQr2coPSBQHg2CQnYTlo96Y7dkh
	 MT7jSCV0/Gnj9b4WQjZD4tO1jnq9XRUBf0bXBa68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Baoquan He <bhe@redhat.com>,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 117/346] kdump: defer the insertion of crashkernel resources
Date: Mon, 29 Jan 2024 09:02:28 -0800
Message-ID: <20240129170019.830208177@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 4a693ce65b186fddc1a73621bd6f941e6e3eca21 upstream.

In /proc/iomem, sub-regions should be inserted after their parent,
otherwise the insertion of parent resource fails.  But after generic
crashkernel reservation applied, in both RISC-V and ARM64 (LoongArch will
also use generic reservation later on), crashkernel resources are inserted
before their parent, which causes the parent disappear in /proc/iomem.  So
we defer the insertion of crashkernel resources to an early_initcall().

1, Without 'crashkernel' parameter:

 100d0100-100d01ff : LOON0001:00
   100d0100-100d01ff : LOON0001:00 LOON0001:00
 100e0000-100e0bff : LOON0002:00
   100e0000-100e0bff : LOON0002:00 LOON0002:00
 1fe001e0-1fe001e7 : serial
 90400000-fa17ffff : System RAM
   f6220000-f622ffff : Reserved
   f9ee0000-f9ee3fff : Reserved
   fa120000-fa17ffff : Reserved
 fa190000-fe0bffff : System RAM
   fa190000-fa1bffff : Reserved
 fe4e0000-47fffffff : System RAM
   43c000000-441ffffff : Reserved
   47ff98000-47ffa3fff : Reserved
   47ffa4000-47ffa7fff : Reserved
   47ffa8000-47ffabfff : Reserved
   47ffac000-47ffaffff : Reserved
   47ffb0000-47ffb3fff : Reserved

2, With 'crashkernel' parameter, before this patch:

 100d0100-100d01ff : LOON0001:00
   100d0100-100d01ff : LOON0001:00 LOON0001:00
 100e0000-100e0bff : LOON0002:00
   100e0000-100e0bff : LOON0002:00 LOON0002:00
 1fe001e0-1fe001e7 : serial
 e6200000-f61fffff : Crash kernel
 fa190000-fe0bffff : System RAM
   fa190000-fa1bffff : Reserved
 fe4e0000-47fffffff : System RAM
   43c000000-441ffffff : Reserved
   47ff98000-47ffa3fff : Reserved
   47ffa4000-47ffa7fff : Reserved
   47ffa8000-47ffabfff : Reserved
   47ffac000-47ffaffff : Reserved
   47ffb0000-47ffb3fff : Reserved

3, With 'crashkernel' parameter, after this patch:

 100d0100-100d01ff : LOON0001:00
   100d0100-100d01ff : LOON0001:00 LOON0001:00
 100e0000-100e0bff : LOON0002:00
   100e0000-100e0bff : LOON0002:00 LOON0002:00
 1fe001e0-1fe001e7 : serial
 90400000-fa17ffff : System RAM
   e6200000-f61fffff : Crash kernel
   f6220000-f622ffff : Reserved
   f9ee0000-f9ee3fff : Reserved
   fa120000-fa17ffff : Reserved
 fa190000-fe0bffff : System RAM
   fa190000-fa1bffff : Reserved
 fe4e0000-47fffffff : System RAM
   43c000000-441ffffff : Reserved
   47ff98000-47ffa3fff : Reserved
   47ffa4000-47ffa7fff : Reserved
   47ffa8000-47ffabfff : Reserved
   47ffac000-47ffaffff : Reserved
   47ffb0000-47ffb3fff : Reserved

Link: https://lkml.kernel.org/r/20231229080213.2622204-1-chenhuacai@loongson.cn
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Fixes: 0ab97169aa05 ("crash_core: add generic function to do reservation")
Cc: Baoquan He <bhe@redhat.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Cc: <stable@vger.kernel.org>	[6.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/crash_core.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -377,7 +377,6 @@ static int __init reserve_crashkernel_lo
 
 	crashk_low_res.start = low_base;
 	crashk_low_res.end   = low_base + low_size - 1;
-	insert_resource(&iomem_resource, &crashk_low_res);
 #endif
 	return 0;
 }
@@ -459,8 +458,19 @@ retry:
 
 	crashk_res.start = crash_base;
 	crashk_res.end = crash_base + crash_size - 1;
-	insert_resource(&iomem_resource, &crashk_res);
 }
+
+static __init int insert_crashkernel_resources(void)
+{
+	if (crashk_res.start < crashk_res.end)
+		insert_resource(&iomem_resource, &crashk_res);
+
+	if (crashk_low_res.start < crashk_low_res.end)
+		insert_resource(&iomem_resource, &crashk_low_res);
+
+	return 0;
+}
+early_initcall(insert_crashkernel_resources);
 #endif
 
 int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_map,


