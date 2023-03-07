Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2BABA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D6AC433D2;
	Tue,  7 Mar 2023 18:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214236;
	bh=eBfQoSCwSyQNT7icfwzTPAH/CTa1hnwm7S8znkjZEjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7L/QL14LTOHviIqql0MGRv7W8SK9lEED4HyQzea1gmxbt7RTLhlSKkdshHEaYxII
	 nL0mIgyYen9QhB1eFHv9LWMcFkuq2TAixcrA2pqNjKgeX6lhZ3NE0TcGqp1Uf/kn5K
	 qj0zwzliXWF2XhlFqUGXqFYCHXB1D34uIjO5kmfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 736/885] x86/microcode/amd: Remove load_microcode_amd()s bsp parameter
Date: Tue,  7 Mar 2023 18:01:10 +0100
Message-Id: <20230307170033.946279885@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 2355370cd941cbb20882cc3f34460f9f2b8f9a18 upstream.

It is always the BSP.

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230130161709.11615-2-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -553,8 +553,7 @@ void load_ucode_amd_ap(unsigned int cpui
 	apply_microcode_early_amd(cpuid_1_eax, cp.data, cp.size, false);
 }
 
-static enum ucode_state
-load_microcode_amd(bool save, u8 family, const u8 *data, size_t size);
+static enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size);
 
 int __init save_microcode_in_initrd_amd(unsigned int cpuid_1_eax)
 {
@@ -572,7 +571,7 @@ int __init save_microcode_in_initrd_amd(
 	if (!desc.mc)
 		return -EINVAL;
 
-	ret = load_microcode_amd(true, x86_family(cpuid_1_eax), desc.data, desc.size);
+	ret = load_microcode_amd(x86_family(cpuid_1_eax), desc.data, desc.size);
 	if (ret > UCODE_UPDATED)
 		return -EINVAL;
 
@@ -850,8 +849,7 @@ static enum ucode_state __load_microcode
 	return UCODE_OK;
 }
 
-static enum ucode_state
-load_microcode_amd(bool save, u8 family, const u8 *data, size_t size)
+static enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size)
 {
 	struct ucode_patch *p;
 	enum ucode_state ret;
@@ -875,10 +873,6 @@ load_microcode_amd(bool save, u8 family,
 		ret = UCODE_NEW;
 	}
 
-	/* save BSP's matching patch for early load */
-	if (!save)
-		return ret;
-
 	memset(amd_ucode_patch, 0, PATCH_MAX_SIZE);
 	memcpy(amd_ucode_patch, p->data, min_t(u32, p->size, PATCH_MAX_SIZE));
 
@@ -906,12 +900,11 @@ static enum ucode_state request_microcod
 {
 	char fw_name[36] = "amd-ucode/microcode_amd.bin";
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	bool bsp = c->cpu_index == boot_cpu_data.cpu_index;
 	enum ucode_state ret = UCODE_NFOUND;
 	const struct firmware *fw;
 
 	/* reload ucode container only on the boot cpu */
-	if (!refresh_fw || !bsp)
+	if (!refresh_fw)
 		return UCODE_OK;
 
 	if (c->x86 >= 0x15)
@@ -926,7 +919,7 @@ static enum ucode_state request_microcod
 	if (!verify_container(fw->data, fw->size, false))
 		goto fw_release;
 
-	ret = load_microcode_amd(bsp, c->x86, fw->data, fw->size);
+	ret = load_microcode_amd(c->x86, fw->data, fw->size);
 
  fw_release:
 	release_firmware(fw);


