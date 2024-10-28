Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFD818E37C;
	Mon, 28 Oct 2024 06:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097427; cv=none; b=o7mMD4WXGmaRfqT2/a7/tmcEpvNJ5X8m6Kls0kwrLtpkMr49ib2+5C5vdDS1sFzZNYlR58byj9TSskOHZFulWuY0DSZzemiwi5yLBR0qXa4I+VGBZf2VHg3EBOaQV+dTdOvgPGBzEUdzt2CGZrDumtHa5ux1fTQebnw2qGHMooo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097427; c=relaxed/simple;
	bh=wwEp01AktQ2cWgKV/oliU255UISx2JwXwCMzlQdToVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GxY7AYyPO0d3yvPrjkynzw2eE4A5hu23eQDQe5Dr5Q3ayhCvsO7E4CZSV3BsY9Jb11myCPKaIcvWJYRPpnyBdIC7uCt8TqwVuSekMLvfRciCF+4jMnpFaVWx6HO6kivKV5SyQEVI9CFb/DoRu0C9YgyVAXWXWb/GAiKEAfQwujg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJ3jZIN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJ3jZIN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F0EC4CEC3;
	Mon, 28 Oct 2024 06:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097427;
	bh=wwEp01AktQ2cWgKV/oliU255UISx2JwXwCMzlQdToVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJ3jZIN0JSluTy+Wm9sZdipL+Eg3VA8CbeYhhfKxVloBevu0J/t3EMOIYmcLM9mqk
	 s8srRUJIXN3pi89vVr/4hAujS58i6KGed1RgNa8YhyXQPUzL7EKhb/l1Zx0HCmhBtv
	 jWBULxWNltynnZW6DBoFJ3Kyx83ikEJhdtE/SdHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Li <lichao@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 126/137] LoongArch: Get correct cores_per_package for SMT systems
Date: Mon, 28 Oct 2024 07:26:03 +0100
Message-ID: <20241028062302.225574944@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit b7296f9d5bf99330063d4bbecc43c9b33fed0137 upstream.

In loongson_sysconf, The "core" of cores_per_node and cores_per_package
stands for a logical core, which means in a SMT system it stands for a
thread indeed. This information is gotten from SMBIOS Type4 Structure,
so in order to get a correct cores_per_package for both SMT and non-SMT
systems in parse_cpu_table() we should use SMBIOS_THREAD_PACKAGE_OFFSET
instead of SMBIOS_CORE_PACKAGE_OFFSET.

Cc: stable@vger.kernel.org
Reported-by: Chao Li <lichao@loongson.cn>
Tested-by: Chao Li <lichao@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/bootinfo.h |    4 ++++
 arch/loongarch/kernel/setup.c         |    3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/arch/loongarch/include/asm/bootinfo.h
+++ b/arch/loongarch/include/asm/bootinfo.h
@@ -25,6 +25,10 @@ struct loongson_board_info {
 	const char *board_vendor;
 };
 
+/*
+ * The "core" of cores_per_node and cores_per_package stands for a
+ * logical core, which means in a SMT system it stands for a thread.
+ */
 struct loongson_system_configuration {
 	int nr_cpus;
 	int nr_nodes;
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -49,6 +49,7 @@
 #define SMBIOS_FREQHIGH_OFFSET		0x17
 #define SMBIOS_FREQLOW_MASK		0xFF
 #define SMBIOS_CORE_PACKAGE_OFFSET	0x23
+#define SMBIOS_THREAD_PACKAGE_OFFSET	0x25
 #define LOONGSON_EFI_ENABLE		(1 << 3)
 
 struct screen_info screen_info __section(".data");
@@ -115,7 +116,7 @@ static void __init parse_cpu_table(const
 	cpu_clock_freq = freq_temp * 1000000;
 
 	loongson_sysconf.cpuname = (void *)dmi_string_parse(dm, dmi_data[16]);
-	loongson_sysconf.cores_per_package = *(dmi_data + SMBIOS_CORE_PACKAGE_OFFSET);
+	loongson_sysconf.cores_per_package = *(dmi_data + SMBIOS_THREAD_PACKAGE_OFFSET);
 
 	pr_info("CpuClock = %llu\n", cpu_clock_freq);
 }


