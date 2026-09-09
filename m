Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2936A4FDE6C;
	Wed,  9 Sep 2026 14:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964146; cv=none; b=Fzju6txfoo86PZbcbtxAabjHdAnBAOCwRR4D/Gk2+0lRWlbQnbi+EylqPQzTm53A692oJfvgtxjpFbBrba2ebqOdBHNewlwFR0wxSpcmWZ+N2K4z10Sj2LJoTm2cyCNV7/OceHX998hJwnhF/LzwHC7Wyrk6QZNuRAk2ySXEK8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964146; c=relaxed/simple;
	bh=LavFtCbHyXmB++LchCGOPMZUfxyywD9HFdVYUKGyFC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6XajYVV8T1yrr0O7Pbu6NvPCULWPYlqaZ7pzbyw6g2dc4iOWc9FWmjAM4oVSTa5od61CoPb/PO7ZYoWCynoQC60PklOVHun51SGaiwKjckYjoEBTIfCCEuOYfBSTiOdc74ZvQRpx4aFJIDUWjiWbIEnGrYbAb9Lq3BGsbxRSKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZoUhvtHG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZoUhvtHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434FB1F00A3A;
	Wed,  9 Sep 2026 14:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964144;
	bh=VJFGWmcIc1unf2jnNNHFNX5/7susedSmiNPYq93PlFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZoUhvtHGqRP38rRs1LrRVQfVsogLVim+4dg8h8qjSdHiZjL0xpGgk4i+aB1xYMMis
	 ZHZCqDYOIUVccafr9AVip3IvwLciJhgCghhzWiZEqi+7mF7+NoTwDVcWtnJCUTn5QU
	 sQQi35Wx2UJXcq3ydXd1AXfpEVFqX8MthFRB+w00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 269/583] LoongArch: Fix acpi_package_ids[] array overflow
Date: Wed,  9 Sep 2026 15:39:14 +0200
Message-ID: <20260909134247.413644044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Bibo Mao <maobibo@loongson.cn>

commit 2a2367d46d7a4ee4122b7a86e57125542dbbe963 upstream.

With LoongArch virt machine, a typical setting is one core per socket,
there will max 256 sockets (packages) on one VM. With PPTT acpi table,
array acpi_package_ids[] will be overflowed.

Here change the array size of acpi_package_ids[] with the max value of
MAX_PACKAGES and KVM_MAX_VCPUS.

Cc: stable@vger.kernel.org # 6.7+
Fixes: 4e8f58620f67 ("LoongArch: Retrieve CPU package ID from PPTT when available")
Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/acpi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/loongarch/kernel/acpi.c
+++ b/arch/loongarch/kernel/acpi.c
@@ -13,6 +13,7 @@
 #include <linux/export.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
+#include <linux/kvm_host.h>
 #include <linux/memblock.h>
 #include <linux/of_fdt.h>
 #include <linux/serial_core.h>
@@ -202,7 +203,7 @@ static void __init acpi_process_madt(voi
 
 int pptt_enabled;
 static int acpi_nr_packages;
-static int acpi_package_ids[MAX_PACKAGES];
+static int acpi_package_ids[MAX(MAX_PACKAGES, KVM_MAX_VCPUS)];
 
 int __init parse_acpi_topology(void)
 {


