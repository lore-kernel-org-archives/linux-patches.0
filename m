Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B3F15B10D;
	Mon, 28 Oct 2024 06:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097884; cv=none; b=bzmW2I4D800T39yty2YULmK1zF8ZIWlU6UHNeiFV4mEyMDzxp8MQH9vl1Q8pQbhFVvYwE1To0VvDhMf1UmskD7TQumljynrW7BEA8a20DJHuUpb3cTqHqCYkKE/YtpXvBduiPCVKa34O5mmByHN0cG/NIUcyEZ6g+dvyPIm14kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097884; c=relaxed/simple;
	bh=0Q4flkUCATTTqcxLc4Rl42dDo/ANYRe/8VceqEYXhVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYGEM5abrPa/wt/LtdGkmaHediPnR94lAdrlSenn5H70hZ/qjvkFjl9sM+g2EBo57CPQ1JXHgyprTLmrbmsqTtyc0tcWvRek+1DXCnYnkWyTkBMmoa/IgiEFg1m90ubEvzwtZmxpIPPSEZSZ8rxxpOzwEZnJseHLFonQChekZFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDC8o3k/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDC8o3k/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EEBC4CEC3;
	Mon, 28 Oct 2024 06:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097884;
	bh=0Q4flkUCATTTqcxLc4Rl42dDo/ANYRe/8VceqEYXhVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDC8o3k/GqVxyYH0j9Ag2KYgO19F43/J3j5dzqS1xCZb0gqRlVV1IVDAvZwAmK1et
	 odbXXWoU+yQ/f46OMzode7kR04Boi8mA0iQyDmStEo+lllegvYwcpER5oUTc+qh6q2
	 YAakxYPWnPBDqPbA3JWqIpW+IdjfmrmNCSBVPBnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Li <lichao@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 191/208] LoongArch: Get correct cores_per_package for SMT systems
Date: Mon, 28 Oct 2024 07:26:11 +0100
Message-ID: <20241028062311.335376401@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -24,6 +24,10 @@ struct loongson_board_info {
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
@@ -55,6 +55,7 @@
 #define SMBIOS_FREQHIGH_OFFSET		0x17
 #define SMBIOS_FREQLOW_MASK		0xFF
 #define SMBIOS_CORE_PACKAGE_OFFSET	0x23
+#define SMBIOS_THREAD_PACKAGE_OFFSET	0x25
 #define LOONGSON_EFI_ENABLE		(1 << 3)
 
 #ifdef CONFIG_EFI
@@ -129,7 +130,7 @@ static void __init parse_cpu_table(const
 	cpu_clock_freq = freq_temp * 1000000;
 
 	loongson_sysconf.cpuname = (void *)dmi_string_parse(dm, dmi_data[16]);
-	loongson_sysconf.cores_per_package = *(dmi_data + SMBIOS_CORE_PACKAGE_OFFSET);
+	loongson_sysconf.cores_per_package = *(dmi_data + SMBIOS_THREAD_PACKAGE_OFFSET);
 
 	pr_info("CpuClock = %llu\n", cpu_clock_freq);
 }


