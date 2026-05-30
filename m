Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EC632D42B;
	Sat, 30 May 2026 16:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160028; cv=none; b=Y4eqkmUSUS0bcUXO134r9rZxsztnDkGcri0AftBcjXeaNOLB+qmDD2bSKMhB9SxwpzxPD89vX1NWBKD30xeiIUCP+zmU16P9ma6CX4lst16UkPnYLERJQuYleej7aNd1SdnKe0597KA7Ikyl18wv7RCgLJd2L2JZ2M84GqHa4tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160028; c=relaxed/simple;
	bh=hG24RyJ2/QGAqk8NMBcLQ8EbRCEhH90paTB5OHB1rII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlTq92H+r+aVBh1mnzgHfHTdha7Wu5Q1lKA64/bJP79OLwB+6a13UcBAmY0Fp/CAQ2Dkd149qkHhEZToobO+EJ4G3vaHC4rYrTo1CYvN+wlW7op+tH4nCQwTBK0SQVD8LHl6sAON1RnTGYbu5JC6ZbbG2KkD9uYv5q3Qxht2yLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zicDWMOb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zicDWMOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1191F00893;
	Sat, 30 May 2026 16:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160027;
	bh=vjlk7iO/3QgCq9Fg0u8g+7Y4VBiEW+W22ASX2gx4Hn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zicDWMObybPuXY/T06brTipI/JZ2LaSXeNrVfD38e5+dsxnPRF/LJvGt8VoBJyDWN
	 ie+k0Q6hT26XkdKdr57sJop2U2CzSaLg0LUd5tXwC+TqLpO0uyAfBpS4aU/l5duKmk
	 5Lw392EsjSdKrMWqcoAMzeobw9ecriBOcZcrJzTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 224/969] LoongArch: Show CPU vulnerabilites correctly
Date: Sat, 30 May 2026 17:55:48 +0200
Message-ID: <20260530160306.639389460@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
@@ -297,3 +298,9 @@ void cpu_probe(void)
 
 	cpu_report();
 }
+
+ssize_t cpu_show_spectre_v1(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "Mitigation: __user pointer sanitization\n");
+}


