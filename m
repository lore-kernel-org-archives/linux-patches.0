Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539B135AC03;
	Fri,  4 Sep 2026 05:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501046; cv=none; b=LVNb3i7uMX76ejbDLWM6rEzb3xrKo3YwOIQmazMLvM/sWIgz0Sw/K1aD/5JMny8PvCyhQM6q3HOEqicVoT8eNYbQeYcmr2Nrcr0/3XaWntpqx3dsVm6o1kK2EfUQ8OsRfBUim3/cPCM/aQsF/v0xx0NDZfMPD/nwFsPWl5U9fEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501046; c=relaxed/simple;
	bh=lcTj8+ej5jZsAq3IicJ3GzCzHMSsQpimqmg9ss9+krA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqyHsn9NxZhX3qNhemdZJQEIYd2oPm4/wE6MQwjeTmmGnTMsoF/qmpXC4hrHOKxiB3w6+PqXJO1HKJl3InmJiKgKmyxYCieT/p+gOCE3UDYlPVLmdMuebF4lctoRyaaezPUgl+pmzblKIfXp5xf/QI4I280JjR+wDeesRF/+ejA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNfVSLnC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNfVSLnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD01C1F00A3D;
	Fri,  4 Sep 2026 05:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501045;
	bh=lOmdBhvBcvQaPFAgO8HI7fS8P/onVOTu4y7e+1Bchr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QNfVSLnCUi4fdNW5qzX4cLSdsQHJcji5NFCueAIVjPZUubZnOfO9LCc7VeNf+4e8u
	 gUlEB/N6JgQsmO8wPvoi97/Rp5/LKU5wlZHUsF4oipbehcCT9y0hH/wuTBB7u+3o0E
	 9eSvP25Sy2HeRBBaCJcn/sHzl8yFTczR+rfUN150=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Petr Pavlu <petr.pavlu@suse.com>
Subject: [PATCH 6.18 272/552] module/kallsyms: fix nextval for data symbol lookup
Date: Fri,  4 Sep 2026 06:57:09 +0200
Message-ID: <20260904045756.142832268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


