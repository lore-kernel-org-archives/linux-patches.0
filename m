Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F8F6FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052BCC433D2;
	Tue, 10 Jan 2023 18:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374814;
	bh=8rnJlCwIYxnFWDcM4ROEXf3YBCxWGh6E9eh4mtDcy5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vi4DoB32d2pKZgCmJAdc8z02ZxrPbLoYZSj4fs7rM8uZasrLqqQqdkkTunA0RsQNp
	 pt/RjkJ9QhsNpmFRMtgOi7wtwOcop+Na0/YYRMyVEedLoaticBdBl6OexAUI0lpkGR
	 +4F+hgTkUozUCE/WElI/L/iVpl97j14LlaYt7AVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Rammhold <andreas@rammhold.de>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 6.1 143/159] of/fdt: run soc memory setup when early_init_dt_scan_memory fails
Date: Tue, 10 Jan 2023 19:04:51 +0100
Message-Id: <20230110180023.010953645@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andreas Rammhold <andreas@rammhold.de>

commit 2a12187d5853d9fd5102278cecef7dac7c8ce7ea upstream.

If memory has been found early_init_dt_scan_memory now returns 1. If
it hasn't found any memory it will return 0, allowing other memory
setup mechanisms to carry on.

Previously early_init_dt_scan_memory always returned 0 without
distinguishing between any kind of memory setup being done or not. Any
code path after the early_init_dt_scan memory call in the ramips
plat_mem_setup code wouldn't be executed anymore. Making
early_init_dt_scan_memory the only way to initialize the memory.

Some boards, including my mt7621 based Cudy X6 board, depend on memory
initialization being done via the soc_info.mem_detect function
pointer. Those wouldn't be able to obtain memory and panic the kernel
during early bootup with the message "early_init_dt_alloc_memory_arch:
Failed to allocate 12416 bytes align=0x40".

Fixes: 1f012283e936 ("of/fdt: Rework early_init_dt_scan_memory() to call directly")
Cc: stable@vger.kernel.org
Signed-off-by: Andreas Rammhold <andreas@rammhold.de>
Link: https://lore.kernel.org/r/20221223112748.2935235-1-andreas@rammhold.de
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/ralink/of.c |    2 +-
 drivers/of/fdt.c      |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/arch/mips/ralink/of.c
+++ b/arch/mips/ralink/of.c
@@ -64,7 +64,7 @@ void __init plat_mem_setup(void)
 	dtb = get_fdt();
 	__dt_setup_arch(dtb);
 
-	if (!early_init_dt_scan_memory())
+	if (early_init_dt_scan_memory())
 		return;
 
 	if (soc_info.mem_detect)
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1099,7 +1099,7 @@ u64 __init dt_mem_next_cell(int s, const
  */
 int __init early_init_dt_scan_memory(void)
 {
-	int node;
+	int node, found_memory = 0;
 	const void *fdt = initial_boot_params;
 
 	fdt_for_each_subnode(node, fdt, 0) {
@@ -1139,6 +1139,8 @@ int __init early_init_dt_scan_memory(voi
 
 			early_init_dt_add_memory_arch(base, size);
 
+			found_memory = 1;
+
 			if (!hotpluggable)
 				continue;
 
@@ -1147,7 +1149,7 @@ int __init early_init_dt_scan_memory(voi
 					base, base + size);
 		}
 	}
-	return 0;
+	return found_memory;
 }
 
 int __init early_init_dt_scan_chosen(char *cmdline)


