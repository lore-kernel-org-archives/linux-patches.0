Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326CA2253FE;
	Mon, 10 Mar 2025 17:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628335; cv=none; b=qD5zp954IZ4PMB4CJuzSWh3+ggWi7oMkz909siGtY3ewfd3O73P/wq8Z3kKYpuOODk4g3Y5iawQA6/kVftj1EW9uGVB0y4DZjNiyyti28U50d00WPT0a/Tm8qOBkYG7XftUMWOoYnSZZTQMaf2sFaVvA4h1+ENnEKMqdqfXdJW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628335; c=relaxed/simple;
	bh=F1ytBQ8Uq2ScJF+3uhNyM33YO/rcLKR1FvD8kQYsyYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEX9oWt/osq5h0X7Oi3NrJ/L0cviAMVOYg+Eu83i0QML0hrMdMCUQAJIXFbSCQLycoThJZ0VBQitZ5ctWNqCPJVWn9OTGbGdqGb11u9BZmmIJ+o09615KL80JJAT0ERDcLMJKRhBB1nWbola/0GNgP3uT98v5bIlKIoBENq9rA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IyA1bedg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyA1bedg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871DDC4CEE5;
	Mon, 10 Mar 2025 17:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628334;
	bh=F1ytBQ8Uq2ScJF+3uhNyM33YO/rcLKR1FvD8kQYsyYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IyA1bedg4/XHpYx1Q+Vw0JBRRjPnm1qGnOe7Incm/8ogWkelkmUy1OuW8ZmZrR9ia
	 1oA0eShcgYJiaQDHC/nPHfsckC6f2Z4uAPwWoXadS3R1ofz64mMYszehhre23v2FOY
	 M3RtaMtFkiJbCWw/kiJUKJYlNhzRro0wLEYSvjGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 009/109] LoongArch: Convert unreachable() to BUG()
Date: Mon, 10 Mar 2025 18:05:53 +0100
Message-ID: <20250310170427.920763068@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit da64a2359092ceec4f9dea5b329d0aef20104217 upstream.

When compiling on LoongArch, there exists the following objtool warning
in arch/loongarch/kernel/machine_kexec.o:

  kexec_reboot() falls through to next function crash_shutdown_secondary()

Avoid using unreachable() as it can (and will in the absence of UBSAN)
generate fall-through code. Use BUG() so we get a "break BRK_BUG" trap
(with unreachable annotation).

Cc: stable@vger.kernel.org  # 6.12+
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/machine_kexec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/loongarch/kernel/machine_kexec.c
+++ b/arch/loongarch/kernel/machine_kexec.c
@@ -126,14 +126,14 @@ void kexec_reboot(void)
 	/* All secondary cpus go to kexec_smp_wait */
 	if (smp_processor_id() > 0) {
 		relocated_kexec_smp_wait(NULL);
-		unreachable();
+		BUG();
 	}
 #endif
 
 	do_kexec = (void *)reboot_code_buffer;
 	do_kexec(efi_boot, cmdline_ptr, systable_ptr, start_addr, first_ind_entry);
 
-	unreachable();
+	BUG();
 }
 
 


