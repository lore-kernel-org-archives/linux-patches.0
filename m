Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F0826ED41;
	Fri,  9 Jan 2026 12:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960996; cv=none; b=MQeDS/mTJW2Z7PAXypW1JaQQGL1OPnzgyrUKdCvyDuTeLtKeB/MKEhGQwnsEdpWCIejLGjLd7EKoEc2zg1/CZxblMALeyZG/I04L6dN1Q2nZjCTxV1hE/79tAjA7xhK2bKMFz099OBun30tzl63J5RwFqMQBsrtYzEh662VwSp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960996; c=relaxed/simple;
	bh=TWWKPLIDqpGjeajLXEH3s55ZTXFUkxCfjeNQJKONAOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5kl2Fm84Zbgog6An9/c5PdjLShys06DIhpmGJ4Cfn+kz0xyaHhTP75C3NuljMvBy2o06aDVCsXcH3kcYv6JJZP01v/4fJbk4kPz4JTeBt8yLaHaaKCknLPIhyutth1KahgOcL9+bpGhrl+WuXQ5YD/mVWuXuevKvaY7l3SG39U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gRSvP0lt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gRSvP0lt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFB7C4CEF1;
	Fri,  9 Jan 2026 12:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960996;
	bh=TWWKPLIDqpGjeajLXEH3s55ZTXFUkxCfjeNQJKONAOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gRSvP0ltQo1g6Mwy6QPdArtcPuziml2gkfa/1dHFfVIN+fxaPRfCrBI5xRfxE2AwB
	 AzopCQu4DWzEY7LZf6iYUbPsoFzZqdb2wGa76goBS4Q1FH/FzV4DFrkiUzoJ/FpcWX
	 +v0zeQwK+PMnTcUdgQlVQ6faJKP1nUwrJYD+bEQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Ma <maqianga@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 597/737] LoongArch: Correct the calculation logic of thread_count
Date: Fri,  9 Jan 2026 12:42:16 +0100
Message-ID: <20260109112156.467059338@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Ma <maqianga@uniontech.com>

commit 1de0ae21f136efa6c5d8a4d3e07b7d1ca39c750f upstream.

For thread_count, the current calculation method has a maximum of 255,
which may not be sufficient in the future. Therefore, we are correcting
it now.

Reference: SMBIOS Specification, 7.5 Processor Information (Type 4)[1]

[1]: https://www.dmtf.org/sites/default/files/standards/documents/DSP0134_3.9.0.pdf

Cc: stable@vger.kernel.org
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/setup.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -56,6 +56,7 @@
 #define SMBIOS_FREQLOW_MASK		0xFF
 #define SMBIOS_CORE_PACKAGE_OFFSET	0x23
 #define SMBIOS_THREAD_PACKAGE_OFFSET	0x25
+#define SMBIOS_THREAD_PACKAGE_2_OFFSET	0x2E
 #define LOONGSON_EFI_ENABLE		(1 << 3)
 
 #ifdef CONFIG_EFI
@@ -130,7 +131,12 @@ static void __init parse_cpu_table(const
 	cpu_clock_freq = freq_temp * 1000000;
 
 	loongson_sysconf.cpuname = (void *)dmi_string_parse(dm, dmi_data[16]);
-	loongson_sysconf.cores_per_package = *(dmi_data + SMBIOS_THREAD_PACKAGE_OFFSET);
+	loongson_sysconf.cores_per_package = *(u8 *)(dmi_data + SMBIOS_THREAD_PACKAGE_OFFSET);
+	if (dm->length >= 0x30 && loongson_sysconf.cores_per_package == 0xff) {
+		/* SMBIOS 3.0+ has ThreadCount2 for more than 255 threads */
+		loongson_sysconf.cores_per_package =
+					  *(u16 *)(dmi_data + SMBIOS_THREAD_PACKAGE_2_OFFSET);
+	}
 
 	pr_info("CpuClock = %llu\n", cpu_clock_freq);
 }


