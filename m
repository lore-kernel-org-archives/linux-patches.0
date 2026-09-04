Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC993AE198;
	Fri,  4 Sep 2026 05:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499291; cv=none; b=BeXgANuGVhko6RZnjU42rvR4vNzYyYNTVvefsE0Q9MSNBVrj5gVPPLD1/oo/lJr/nDjyBwTF2vM0qwqMm/prgUoRMcNY1qgZukBz/kIOoE+yI0mwOEjLWHGpxzNJ30pGwMxlvgb5f3bk4hpTiWrgsVZX1LpFsUcTdbLVy9Tx+uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499291; c=relaxed/simple;
	bh=ca9GtaXsYRzQr+CY0HEm22z1tz0EfYjEhPrdiCFhJJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wvm6FXPAsIXlcUcrWvsuYtAIdsM1UXR4qdtBkIKSF/w6a2t62RRQ6O79KZPFlqIVX6mX7vgt2LHS0aCdNiKZvYftyNUO77Y6F3MbFXioka2cIQEUhO8cYoEHr9FLCm/N+N0BfeccjOP6qVo2lBOv7Hbxj+yPJN3t4A5HQ3RfXZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EGtoZB8B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EGtoZB8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83501F00A3D;
	Fri,  4 Sep 2026 05:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499290;
	bh=pVeCismFCci7FSb+MvneyyiFmHQmOthaYZJLTRyDRy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EGtoZB8BC8pwOfnK0Nk1NWltGITtXBovVXQEme6U6fFawDR/kgrPhoyCuNhMXud4h
	 G8/UxrPKpMBfAwQ4cupey3A1mVwy3kH7JNfzSC8beFWB9RmC/ZxJSYlc3QzWC2+Tqa
	 4Zshy9ilCQB1x5gsfVKGYUe2gaVZl4u6hGQLoq8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Petr Pavlu <petr.pavlu@suse.com>
Subject: [PATCH 7.2 366/713] module/kallsyms: fix nextval for data symbol lookup
Date: Fri,  4 Sep 2026 06:55:34 +0200
Message-ID: <20260904045812.033543725@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <stf_xl@wp.pl>

commit 0e9f090a4e9bfae5a190ccf89eab3bf14f6b0f96 upstream.

The symbol lookup code assumes the queried address resides in either
MOD_TEXT or MOD_INIT_TEXT. This breaks for addresses in other module
memory regions (e.g. rodata or data), resulting in incorrect upper
bounds and wrong symbol size.

Select the module memory region the address belongs to instead of
hardcoding text sections. Also initialize the lower bound to the start
of that region, as searching from address 0 is unnecessary.

Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/module/kallsyms.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- a/kernel/module/kallsyms.c
+++ b/kernel/module/kallsyms.c
@@ -258,17 +258,25 @@ static const char *find_kallsyms_symbol(
 	unsigned int i, best = 0;
 	unsigned long nextval, bestval;
 	struct mod_kallsyms *kallsyms = rcu_dereference(mod->kallsyms);
-	struct module_memory *mod_mem;
+	struct module_memory *mod_mem = NULL;
 
-	/* At worse, next value is at end of module */
-	if (within_module_init(addr, mod))
-		mod_mem = &mod->mem[MOD_INIT_TEXT];
-	else
-		mod_mem = &mod->mem[MOD_TEXT];
+	for_each_mod_mem_type(type) {
+#ifndef CONFIG_KALLSYMS_ALL
+		if (!mod_mem_type_is_text(type))
+			continue;
+#endif
+		if (within_module_mem_type(addr, mod, type)) {
+			mod_mem = &mod->mem[type];
+			break;
+		}
+	}
 
-	nextval = (unsigned long)mod_mem->base + mod_mem->size;
+	if (!mod_mem)
+		return NULL;
 
-	bestval = kallsyms_symbol_value(&kallsyms->symtab[best]);
+	/* Initialize bounds within memory region the address belongs to. */
+	nextval = (unsigned long)mod_mem->base + mod_mem->size;
+	bestval = (unsigned long)mod_mem->base - 1;
 
 	/*
 	 * Scan for closest preceding symbol, and next symbol. (ELF


