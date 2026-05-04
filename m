Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B675935A3AD;
	Mon,  4 May 2026 14:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903979; cv=none; b=FlafwiiitmJ0Hedo9WVgBj3Cc50B32C4c3bgK7xOjkaDrNw0pawleoOybZXvH5SnqEYnyf4kB5zcJ1oSsFjov/ZncP+7tpr7f2ZTxIfnwiYTkgl+pQxv1xxpuSI3H0ul6NlVx7reklP8CdPEXM3mZ79IJgEg9Ree9lrPLi+ba4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903979; c=relaxed/simple;
	bh=potPiOhod3xmaupgm+U4Ma9mU9PaXxDQwDqn6PKuCrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mn/MWeIOgGl0RAHi7WqZDgvNfqN20+W9AGRshfjJsdLZ34LOlSXSp/fsidmyriKpACFHZp+56WGJCR0K/rdeaK8/wlkOEbZR57hkPc0itW7YWlm7awxA4rz5mW3YYf7/nhRRwmDPkSsBx4yRPMJwiFWTvlkxceSWD2FKbxJE/a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awUoEUkP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awUoEUkP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF79C2BCF4;
	Mon,  4 May 2026 14:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903979;
	bh=potPiOhod3xmaupgm+U4Ma9mU9PaXxDQwDqn6PKuCrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awUoEUkPiJ59rIJU24p52vMqQNJv+s3afOV9yknLE/lxu3dVQOlOafjkQyjN3ZqJ3
	 P2vI10nNe2T0/V6rv33NxMEah54b0Omguonv2nCCK+Vmb0AgZ7vClvaukIPrHBf1fh
	 a2EUlmU1T1wVTcw4QATmLlgQBJ2xJu3cuyXZv4gU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 137/275] LoongArch: Show CPU vulnerabilites correctly
Date: Mon,  4 May 2026 15:51:17 +0200
Message-ID: <20260504135147.994597105@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -387,3 +388,9 @@ void cpu_probe(void)
 
 	cpu_report();
 }
+
+ssize_t cpu_show_spectre_v1(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "Mitigation: __user pointer sanitization\n");
+}


