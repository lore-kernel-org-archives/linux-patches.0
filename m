Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBE326B973;
	Thu, 28 May 2026 20:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998466; cv=none; b=PbJn+irByw5Fq6tv7w/CwVQF+fK7GPYrIbew0a9XTSpU1cPhOSY7L8ZRqOOUua1wfTE4yCgT7mkCFRWdzn3pawE00WEXQfJTLMoWCbeLqzqpr1ME6XTyuyV9ToNSkj38tKn3EIEMs6nyBikomFUpNFb7Q22N1viLnycqAruVnfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998466; c=relaxed/simple;
	bh=2sHXQL/32MHWdtHSeajvERxFX4BkQVFpsNdHvb47Fr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTKYeK895/9FZ7/9JwIQBZHwmUhGQN5LIcQpr8+LqfG6iDdxE4tC9FNcPoOeXduQ4ASVVzfkwuXkxuAvCzwZyEVZdBZPXm80eLhNHGagxKmE5cj0bTKFiUMkzmQuxnXWxZqqC7vg5WqTxEcDuKBSha7v5iGy9k44BCK/1r7WPaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIYHMH6l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIYHMH6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B455F1F000E9;
	Thu, 28 May 2026 20:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998465;
	bh=ECQ4HOmH/AcEMLT68tG7ugUvGgSaS7xagHvapa0B63E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eIYHMH6lK21MsfrYJrW9PIAPnvNaOiRtS80vCPnwcnBf6zyAXbnwMlYK0nUBbb2Wv
	 bAzUPYYWIISnSSmzhj5ZbMGeunM72vS1NELecWT5Q0G15rLnuYKS57o5j9TzSuqRqu
	 otEQb2K33ZfIzNNpiNDgkxDZwkmoKjo1cSTq5AZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evangelos Petrongonas <epetron@amazon.de>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 183/461] kho: skip KHO for crash kernel
Date: Thu, 28 May 2026 21:45:12 +0200
Message-ID: <20260528194652.373859491@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Evangelos Petrongonas <epetron@amazon.de>

[ Upstream commit a6715d7ec472a476db17787697a4abda62962284 ]

kho_fill_kimage() unconditionally populates the kimage with KHO
metadata for every kexec image type. When the image is a crash kernel,
this can be problematic as the crash kernel can run in a small reserved
region and the KHO scratch areas can sit outside it.
The crash kernel then faults during kho_memory_init() when it
tries phys_to_virt() on the KHO FDT address:

  Unable to handle kernel paging request at virtual address xxxxxxxx
  ...
    fdt_offset_ptr+...
    fdt_check_node_offset_+...
    fdt_first_property_offset+...
    fdt_get_property_namelen_+...
    fdt_getprop+...
    kho_memory_init+...
    mm_core_init+...
    start_kernel+...

kho_locate_mem_hole() already skips KHO logic for KEXEC_TYPE_CRASH
images, but kho_fill_kimage() was missing the same guard. As
kho_fill_kimage() is the single point that populates image->kho.fdt
and image->kho.scratch, fixing it here is sufficient for both arm64
and x86 as the FDT and boot_params path are bailing out when these
fields are unset.

Fixes: d7255959b69a ("kho: allow kexec load before KHO finalization")
Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Link: https://patch.msgid.link/20260410011609.1103-1-epetron@amazon.de
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 479c42e08b74a..d8893f2adce8a 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1556,7 +1556,7 @@ int kho_fill_kimage(struct kimage *image)
 	int err = 0;
 	struct kexec_buf scratch;
 
-	if (!kho_enable)
+	if (!kho_enable || image->type == KEXEC_TYPE_CRASH)
 		return 0;
 
 	image->kho.fdt = virt_to_phys(kho_out.fdt);
-- 
2.53.0



