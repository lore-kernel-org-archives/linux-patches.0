Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B7A3CEB89;
	Mon,  4 May 2026 14:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903250; cv=none; b=OR0dVaEbbQhXH4K0w40+FsQFN/YCsF9ZZ5YYpzlXHTfR6oAoXZZwx1S+TAfUhxjzp/mLXg3E+wm64Yrxh8r7OV1vVXqv8HlRGR7Ynx9o0GEaiNIkbMr4Go36KEazgtFch/xyxriMN12eftkbFw3JIMthATCGO/dx8MhYnWB0+xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903250; c=relaxed/simple;
	bh=qcJ6U8P00/ZUzCqQd1+nMzGPCAdxX7LLKMJLf23yuGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HojQmzqJljD2Lub25LlKPPE4rrPgEaFc7v2M7w6E5ghbHmI15nmjenSQrLf0I84PseZUcU1CjOL6jUoqGfvNnDa8UfABXB9toIkPsgmeWjGnmY0hkMvxw7cYb0N6gX3DwgpuMphuctoCMaeENmdPjydnN6b4tk0XdVvy/vsiojE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vD7u7Mk3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vD7u7Mk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B8EC2BCB8;
	Mon,  4 May 2026 14:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903250;
	bh=qcJ6U8P00/ZUzCqQd1+nMzGPCAdxX7LLKMJLf23yuGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vD7u7Mk3GL6M7TRt9G7E5t0AoGmZWNTa0Z7Mq1eXIEZ+OvCocfys5Txlt3R4Pp74Z
	 5BqvAbLL9egUgaZ1NzP7ujhf9qjE5h91XAHLknsVFMXaQGwJSyivd0fm/k+72N02YU
	 qKuuJZzzDnOqjGp8rPuFgGyM+aYYCOlsM5dQx4DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.0 161/307] LoongArch: Show CPU vulnerabilites correctly
Date: Mon,  4 May 2026 15:50:46 +0200
Message-ID: <20260504135148.908799115@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 37e57e8ad96cdec4a57b55fd10bef50f7370a954 upstream.

Most LoongArch processors are vulnerable to Spectre-V1 Proof-of-Concept
(PoC). And the generic mechanism, __user pointer sanitization, can be
used as a mitigation. This means to use array_index_nospec() to prevent
out of boundry access in syscall and other critical paths.

Implement the arch-specific cpu_show_spectre_v1() to show CPU Spectre-V1
vulnerabilites correctly.

Cc: stable@vger.kernel.org
Link: https://cc-sw.com/chinese-loongarch-architecture-evaluation-part-3-of-3/
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/cpu-probe.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/loongarch/kernel/cpu-probe.c
+++ b/arch/loongarch/kernel/cpu-probe.c
@@ -7,6 +7,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/ptrace.h>
+#include <linux/cpu.h>
 #include <linux/smp.h>
 #include <linux/stddef.h>
 #include <linux/export.h>
@@ -402,3 +403,9 @@ void cpu_probe(void)
 
 	cpu_report();
 }
+
+ssize_t cpu_show_spectre_v1(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "Mitigation: __user pointer sanitization\n");
+}


