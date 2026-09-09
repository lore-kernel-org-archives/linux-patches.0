Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2ED52ED5E;
	Wed,  9 Sep 2026 14:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962591; cv=none; b=LNTst0IhnjEias+UV+AKfLN8H9qkekZvFTuU+4CovMmZ4K1M8UI4loCnx3ViJQi2lgCQwDMD8q3np5pB+VdYMdYGArkUmFr4APxyQA2jY3uVwmTuDW2OG6lVkOhnS/EVIQqfj71gqi5VdtgjitzJfu2QYHQWV5JNDJR77gqSztA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962591; c=relaxed/simple;
	bh=8/j/Ja+Dci1LEhXKDk7X2tTD4VU2JxW42fyvmHqYOwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NC0sRj47BONMWr1hn9IZVI1hkx6XL1PBuTfG8yeSKN+PelIBLShfUUueCEU2ouf65ijLM88CckxPbz6eeAONoTovJ3OpkrA9d+C4bk24w1nO5XKEa54md1rr7+d9U33AnLOZlWVkDgkOUqOOCjXXZVm79RMm5F4Sg7k1wlysx78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uw1yyYLE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uw1yyYLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F50E1F00A3A;
	Wed,  9 Sep 2026 14:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962590;
	bh=BHXHv18RHpWXTW8BN0x7FY6xoRGpo5/D2QZqJTcg2jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uw1yyYLEF0RneVjoDg+6oTaOJQyvuhXI0gawD4kweQGov2EO6nai98N54hK4hGeYX
	 EJrJ33oLSgVRhdY+2+UhrxpjHLAUzChe72VLRZfTMz6mkvpEXnqDmRaIwa/FoLDPjJ
	 /JnSZnxfehZeHrFPCe/+anME2mbkhEaMM079VSWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.2 341/556] LoongArch: Fix acpi_package_ids[] array overflow
Date: Wed,  9 Sep 2026 15:40:21 +0200
Message-ID: <20260909134242.651896335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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


