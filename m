Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAFF330D27;
	Fri,  9 Jan 2026 12:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962889; cv=none; b=htTgKd0xBIu6LBSoaOdAmcQUQOns/kHcvbFGHEsdFZvK+51lK6HkJorFmczaOpL9CNlPyBp7vOALaSuHbi5hi9Y9VHSQErBv5XdJ40M5chXpMSpOH9VdIv/l/oySkTDhSykjnW3d8fTGMh9rd94TgfcNgnV/e8/fgWmMgD4vK1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962889; c=relaxed/simple;
	bh=iW8K6JNv+NHxBxk8la9sRWhjS0zWLnC0QLTPLz89o6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/8Ttgf1q7zmkuAiVnfYdmHFKz7hbDCvuD7L8Ix4ygUbw1s51LNnVWk8JI6QCn1FajqgCFbNl0OzhY+Hv2ktENjVmNQYkeNCZdrbl+oHjXztK48cLNs8T7y+Q/9mjZo1JH7wb9IG9ibpIOO/5OVHuq0Tqi2MEl0x2qXL1SnePNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oDvV+qwN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oDvV+qwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA22AC4CEF1;
	Fri,  9 Jan 2026 12:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962889;
	bh=iW8K6JNv+NHxBxk8la9sRWhjS0zWLnC0QLTPLz89o6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oDvV+qwNRwwcBAypTeFVnykyQfWtDGCTvD/1OuWVJE9VPw471iKo1ZeISPAixfx9D
	 gfSegkxEevXcarmwEfOlrJ5yspkrgtBn5d9sYZRZo+lBZwnFbRCNXJ7oIa3oMlt+jJ
	 7hMXMeMc9Pu/hD9nw9xzLUPTsak6WW2NTYhDEd1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Ma <maqianga@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 491/634] LoongArch: Correct the calculation logic of thread_count
Date: Fri,  9 Jan 2026 12:42:49 +0100
Message-ID: <20260109112136.019930494@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -50,6 +50,7 @@
 #define SMBIOS_FREQLOW_MASK		0xFF
 #define SMBIOS_CORE_PACKAGE_OFFSET	0x23
 #define SMBIOS_THREAD_PACKAGE_OFFSET	0x25
+#define SMBIOS_THREAD_PACKAGE_2_OFFSET	0x2E
 #define LOONGSON_EFI_ENABLE		(1 << 3)
 
 struct screen_info screen_info __section(".data");
@@ -116,7 +117,12 @@ static void __init parse_cpu_table(const
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


