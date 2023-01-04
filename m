Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3164AD49
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C10C433EF;
	Wed,  4 Jan 2023 16:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849059;
	bh=dDJYnmAudk12nIt6HSKQqvvnhNuuMKTHRYY+o5qb4ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VcavuSixl4354BHzWFPSNYh5cQAl+9evjyA/n7weUy716kQUbnLfF1n0eAefEADDl
	 E7MUutZCzkY96zoZ+5c1qm/DYlpV4K49UEXYldIQtwjem95PI3xZdtLAizCUlPesVa
	 UZYQrNzmg2XEKOFNKyoF6pFqGvyElmUaWsv5kp80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Maydell <peter.maydell@linaro.org>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 6.0 057/177] of/kexec: Fix reading 32-bit "linux,initrd-{start,end}" values
Date: Wed,  4 Jan 2023 17:05:48 +0100
Message-Id: <20230104160509.372959309@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rob Herring <robh@kernel.org>

commit e553ad8d7957697385e81034bf76db3b2cb2cf27 upstream.

"linux,initrd-start" and "linux,initrd-end" can be 32-bit values even on
a 64-bit platform. Ideally, the size should be based on
'#address-cells', but that has never been enforced in the kernel's FDT
boot parsing code (early_init_dt_check_for_initrd()). Bootloader
behavior is known to vary. For example, kexec always writes these as
64-bit. The result of incorrectly reading 32-bit values is most likely
the reserved memory for the original initrd will still be reserved
for the new kernel. The original arm64 equivalent of this code failed to
release the initrd reserved memory in *all* cases.

Use of_read_number() to mirror the early_init_dt_check_for_initrd()
code.

Fixes: b30be4dc733e ("of: Add a common kexec FDT setup function")
Cc: stable@vger.kernel.org
Reported-by: Peter Maydell <peter.maydell@linaro.org>
Link: https://lore.kernel.org/r/20221128202440.1411895-1-robh@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/kexec.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/of/kexec.c
+++ b/drivers/of/kexec.c
@@ -281,7 +281,7 @@ void *of_kexec_alloc_and_setup_fdt(const
 				   const char *cmdline, size_t extra_fdt_size)
 {
 	void *fdt;
-	int ret, chosen_node;
+	int ret, chosen_node, len;
 	const void *prop;
 	size_t fdt_size;
 
@@ -324,19 +324,19 @@ void *of_kexec_alloc_and_setup_fdt(const
 		goto out;
 
 	/* Did we boot using an initrd? */
-	prop = fdt_getprop(fdt, chosen_node, "linux,initrd-start", NULL);
+	prop = fdt_getprop(fdt, chosen_node, "linux,initrd-start", &len);
 	if (prop) {
 		u64 tmp_start, tmp_end, tmp_size;
 
-		tmp_start = fdt64_to_cpu(*((const fdt64_t *) prop));
+		tmp_start = of_read_number(prop, len / 4);
 
-		prop = fdt_getprop(fdt, chosen_node, "linux,initrd-end", NULL);
+		prop = fdt_getprop(fdt, chosen_node, "linux,initrd-end", &len);
 		if (!prop) {
 			ret = -EINVAL;
 			goto out;
 		}
 
-		tmp_end = fdt64_to_cpu(*((const fdt64_t *) prop));
+		tmp_end = of_read_number(prop, len / 4);
 
 		/*
 		 * kexec reserves exact initrd size, while firmware may


