Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00115479893;
	Sat, 12 Sep 2026 11:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213704; cv=none; b=GJUwZ9zmZGRBjYbm+47QkflXMYxl+tjfxGTH9JREWvMaNaJXhIN6mQP2ksSA+SoUD6TFb/lY7ygDzCgb3HB79PGITqdPQsr7WcVVpIKGcbQ9TXggcSkXXUO2rrnQd2//sJTB5NU0tSaoywabB88zBODncSGViMrnYdICBm5Rk4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213704; c=relaxed/simple;
	bh=JLYmpG32t6TZGY2rl/ZFokH0MzHSGdEAIC5MLA6a/U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utgGjAZiCUVK+lICsQ3r8GFn0HzUtX2TRjT9ckMM8ZlYhpBYOknyd+1LbEhd5xOdemiPjS9rf3h8FkwGU5NU3AKVxV6mYdVZ1eOtvCX5jzUnpVcQnAb/7pwfT8jUAO+MifTIUw2VjdGJClv6Qw2OD4kceLd1ZKq59GyOqKLul0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWAeaP7z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWAeaP7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E271F000FF;
	Sat, 12 Sep 2026 11:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213702;
	bh=9T21waQXoYZq7SuF3/O2Wm5IJAuQpyvB+DvhLfNaJt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pWAeaP7zlGIHYMx5/vUcmtArfFLu4GdpXYntwvz8hwaeEn75uVBxV/Sr2icAVc71U
	 DmW29GHnD+AyvZerGhKUdNIV9Udq+P8NEVEF0mFag7wPyvtXzwjrU3dd1+EvBQtlwF
	 8JMIll9Eo/+Dg0hTeMAlq0wEBk78HxPfFpYsg09c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 0175/1376] LoongArch: Fix acpi_package_ids[] array overflow
Date: Sat, 12 Sep 2026 08:43:21 +0200
Message-ID: <20260912065611.449414459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -12,6 +12,7 @@
 #include <linux/efi-bgrt.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
+#include <linux/kvm_host.h>
 #include <linux/memblock.h>
 #include <linux/of_fdt.h>
 #include <linux/serial_core.h>
@@ -201,7 +202,7 @@ static void __init acpi_process_madt(voi
 
 int pptt_enabled;
 static int acpi_nr_packages;
-static int acpi_package_ids[MAX_PACKAGES];
+static int acpi_package_ids[MAX(MAX_PACKAGES, KVM_MAX_VCPUS)];
 
 int __init parse_acpi_topology(void)
 {


