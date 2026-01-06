Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E19233DED6;
	Tue,  6 Jan 2026 17:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721043; cv=none; b=a1DjTSq9N1RRowNRLB7cHBYsgycCEVm74sM0HToprCIRFLkj91bfPitwWQVJm6eeAT4U7AoXJqrN5aQRReuTjNdqpU4i9e/mGxTweVaW+UmC1gr10K54J/NORYGqCcnePvYdiQIof+utAb4lBDJ0RK82OsILDDgrOrbqqGwqj70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721043; c=relaxed/simple;
	bh=V2tf0K74RvQNwMtH9zM0Uj4noMNv+jCVUYRiNVeI2WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzYbQWMC9rLAResAF/Sw+5qEyM++y43ycL0xG3B+m7ZLSmnJbo1UkmpubjyJRANVBSdto6/yxBJuS0bbIcMNeG/GVoCXpmoVhmgHFh/KBaeQ3eg3hszlD5hdHTqKJnXMeRjj53XvmGj3E9Nug8rwpcGcUc1SkBUyGpIsxkmSpWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQlO9ZO4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQlO9ZO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96913C16AAE;
	Tue,  6 Jan 2026 17:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721043;
	bh=V2tf0K74RvQNwMtH9zM0Uj4noMNv+jCVUYRiNVeI2WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQlO9ZO4EjZv0WI2DHd51okhyoz1oDkhvs8hT/Vw9yFDS1+cyf8rN1IXLQkWlY5bF
	 m+KBng6NgHCsS0g/yM0z0StGXxJH5zvd4UzrGoGokfu7DwdNrLk8hV9i2NbGQwEWKU
	 Hkn1M87UDA9gAH1pmYCiRyHy15xGQvfQUjXM69a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Ma <maqianga@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 417/567] LoongArch: Correct the calculation logic of thread_count
Date: Tue,  6 Jan 2026 18:03:19 +0100
Message-ID: <20260106170506.769016438@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
 
 unsigned long fw_arg0, fw_arg1, fw_arg2;
@@ -126,7 +127,12 @@ static void __init parse_cpu_table(const
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


