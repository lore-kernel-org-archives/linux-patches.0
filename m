Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136CD248879;
	Tue, 20 May 2025 14:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750630; cv=none; b=sUBtsg1ea8orcKPAtFDFNRtkgQGaE7FAVvotiLDrgwOriF0qQwIA2muC5y4NoYXVJVRzG09N9HKbdKqv1qZAIEe9ZzlW3jL3h9/Tdvz2UToLjeGFot6cCBFx3MmmJr7s7wdIGXuA2VUiYHot3wQxzfT9roiLGG51VUXZ9ccBQrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750630; c=relaxed/simple;
	bh=s+Oa4bBeYkNkKNlM6hMK8OZj+DNirhc2QGgLJxhMHTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEucpLUV4xIieQxRIlmiRSTndXMcGx51Vf4Got61rpfaDpjbIa6wuxWPAghcoGshwPCxXrEqeV+/2fEEIDaJr/U1CFyciB9WZ5uWIr0z4ATf+BZXwhNqiQ3ergf+V3042X9d/BW4nl4Mh6G8jAn+zzCJvVHlagmlracAGORtZug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/DTLrqY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/DTLrqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9D6C4CEE9;
	Tue, 20 May 2025 14:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750629;
	bh=s+Oa4bBeYkNkKNlM6hMK8OZj+DNirhc2QGgLJxhMHTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/DTLrqYRoUIgjU8Ka6xGZ8UFyBjRH0rBN+uowUF1nvme2dJbonPUYbvfbdsi8GAf
	 itDJTS+8jBg7bqLOGMghuy/zGG42Ass+WssuweJDco2zu7acdr10xcP9JVmDCVtDc9
	 vXtTTjaUzGvxU5tdJz/C3k7y0gu3yNaXuw+jK9zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.14 070/145] LoongArch: Move __arch_cpu_idle() to .cpuidle.text section
Date: Tue, 20 May 2025 15:50:40 +0200
Message-ID: <20250520125813.322959736@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 3e245b7b74c3a2ead5fa4bad27cc275284c75189 upstream.

Now arch_cpu_idle() is annotated with __cpuidle which means it is in
the .cpuidle.text section, but __arch_cpu_idle() isn't. Thus, fix the
missing .cpuidle.text section assignment for __arch_cpu_idle() in order
to correct backtracing with nmi_backtrace().

The principle is similar to the commit 97c8580e85cf81c ("MIPS: Annotate
cpu_wait implementations with __cpuidle")

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/genex.S |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/loongarch/kernel/genex.S
+++ b/arch/loongarch/kernel/genex.S
@@ -16,6 +16,7 @@
 #include <asm/stackframe.h>
 #include <asm/thread_info.h>
 
+	.section .cpuidle.text, "ax"
 	.align	5
 SYM_FUNC_START(__arch_cpu_idle)
 	/* start of idle interrupt region */
@@ -31,14 +32,16 @@ SYM_FUNC_START(__arch_cpu_idle)
 	 */
 	idle	0
 	/* end of idle interrupt region */
-1:	jr	ra
+idle_exit:
+	jr	ra
 SYM_FUNC_END(__arch_cpu_idle)
+	.previous
 
 SYM_CODE_START(handle_vint)
 	UNWIND_HINT_UNDEFINED
 	BACKUP_T0T1
 	SAVE_ALL
-	la_abs	t1, 1b
+	la_abs	t1, idle_exit
 	LONG_L	t0, sp, PT_ERA
 	/* 3 instructions idle interrupt region */
 	ori	t0, t0, 0b1100


