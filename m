Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A993D8129;
	Mon,  4 May 2026 14:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904612; cv=none; b=pltxgNQTYREFnJgE8wjqnbNL5bEjkKeSs2TwG8TfuAhcZhInpSWf7POhedmW1jhPkVHyM7MKv7K3P0+xYmCtPgePc1VgJ5wcnM85X4b2DFhk0kM14cHu3gBhRMIa6O1oLewccjM3Sal4Ksxggebj2aKd30dTzT9wESkOIhRlgvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904612; c=relaxed/simple;
	bh=DrRbax55KN5O/5r897wz4KOFXMgeBbCwQ0iYvJn2y2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLrwnV9ohI5eZOlzYs5xKKSAIJuyJQQqgufkGsvf8+dYl8WFJULznVuFmHuujbqakMOeH2qXNDOelX/w/oyR8E2KFWA4OPngNXL01HTpuN8CiOCzIKRhCkZh75ogcro1iKUEZV9lqXp87ekaLIt8/RtBU5F4aZu3StW5Y2lPaXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6KRhreT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6KRhreT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1CAC2BCB8;
	Mon,  4 May 2026 14:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904612;
	bh=DrRbax55KN5O/5r897wz4KOFXMgeBbCwQ0iYvJn2y2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6KRhreTnz5nAzqvi8fRJqcC7BwardcQAw/vHV4RD0DwD8atedFxyFIJxznyGMdV9
	 cgU0JF62irx/sFJh1tmHJ0UYzRCXkslunEp2Mhxw9DMRZgwxfZ85qZf6xzuVPVWbhM
	 ir+B4xv8tafjeDLb1iEiN/iuDYwwXPe9dEjvXTnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 099/215] LoongArch: Show CPU vulnerabilites correctly
Date: Mon,  4 May 2026 15:51:58 +0200
Message-ID: <20260504135133.771410119@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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
@@ -352,3 +353,9 @@ void cpu_probe(void)
 
 	cpu_report();
 }
+
+ssize_t cpu_show_spectre_v1(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "Mitigation: __user pointer sanitization\n");
+}


