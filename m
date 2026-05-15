Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DB33FF1DE;
	Fri, 15 May 2026 15:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860790; cv=none; b=AYw1BCViMV2fCcjr26yHISVbkb0inyc69aHVfaP84CY5YechiaYbfyTrhANHk0U2KvZNnjpCj+4sU3gt3SyCJBYxQ4mRXbrZxUGXGU9yrqi5yr4iSByJKqQCwz6a5yrDrUhZrxEmeTpkd1SaOERlCRzpOLEBhDHPSJP+UHp6rhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860790; c=relaxed/simple;
	bh=9uurY7ktwuGEHKzdkedcrgFg7KqCRAdturCZwZ2lQh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWT7W6L5kA46W5vsYavkQjX7P1kcBxZfWytTuCynIK+JxDo9BF0rcaO1kSld93imns85nZZ6wy6OlI5+bH/ZmIdigLgNKqDvIBIts/UlJplrVhk7o8vP9UnI0+AwjnV2Nio4lKvePCxFOxQUe6HOIG/QCwTfxodQlITeGOoe22o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FwDCAHI5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FwDCAHI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FD8C2BCB0;
	Fri, 15 May 2026 15:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860789;
	bh=9uurY7ktwuGEHKzdkedcrgFg7KqCRAdturCZwZ2lQh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FwDCAHI5VgnJFoHoGaMfCVRr7zUIc24IX07jUipo77vpR07/GLaT+3PSgbvYC+WHJ
	 UYYuyRnG7rdXnQE+9vWY8uJ+Y4G0EvnEIGy+TZScL8FIykxgUXwZrBfOCeC2GQbuOB
	 SdzKrHvrVm76WenDWnI6l0MwWNQkp0jItv5ONsZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 081/474] LoongArch: Show CPU vulnerabilites correctly
Date: Fri, 15 May 2026 17:43:10 +0200
Message-ID: <20260515154716.791044111@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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
@@ -327,3 +328,9 @@ void cpu_probe(void)
 
 	cpu_report();
 }
+
+ssize_t cpu_show_spectre_v1(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "Mitigation: __user pointer sanitization\n");
+}


