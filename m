Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B244A1F91E3;
	Mon, 13 Oct 2025 15:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370300; cv=none; b=QqjuFBZHk1tjf7+gZsAKI+qYD6EgTZdzj6EEuUOCT4esguQak1M0H7Dwn1B/CQVs5OtPaQWmJi4hHhha5AFsM5BvI+C3Ucp1sE8n/Z8o/cWEjNuRL0GCLND8IorPzZNnlsNVPyoIyg0yvJSpejwUe5lTnd9DtlrWC+KGLLVBxxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370300; c=relaxed/simple;
	bh=gJDDbiZC5scABqr3gZrotMNaHOpmLRLjaV3qoFIykGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVA0h8hf7Tg/zMiM7KzFNTio8eHxhhVnvncNPHXskh8ZP+Bi6CIuUyZOc1LM8NdWwObl5UqP9DrygT6kGTbUvVsP6b9DbnW8Zp3vLVGSLvyGxkQYgaE4zKwrqbandjqHpHWnt5QWiE49eCeD+JWupswHZiao9FoZXuJy4YO/j18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wN3ELFRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wN3ELFRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AEAC4CEE7;
	Mon, 13 Oct 2025 15:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370300;
	bh=gJDDbiZC5scABqr3gZrotMNaHOpmLRLjaV3qoFIykGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wN3ELFRTwC/p1E9AxU5xC7kfeAyeO2QZ0RkP5gYgPnFcXfJyJG5vAj+aJ6F0V17By
	 JanQAdqZmXs9lP+B8BeNvPTp5dwYuP4kwbkalHkuVZS3b5apKtBCA6tp3vs5Eo+DSt
	 kDg7wquE0qI7lONhJ7SU/rIGYfqeu4NkeXFnTcJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youling Tang <tangyouling@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.17 521/563] LoongArch: Automatically disable kaslr if boot from kexec_file
Date: Mon, 13 Oct 2025 16:46:22 +0200
Message-ID: <20251013144430.186696640@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youling Tang <tangyouling@kylinos.cn>

commit c8168b4faf1d62cbb320a3e518ad31cdd567cb05 upstream.

Automatically disable kaslr when the kernel loads from kexec_file.

kexec_file loads the secondary kernel image to a non-linked address,
inherently providing KASLR-like randomization.

However, on LoongArch where System RAM may be non-contiguous, enabling
KASLR for the second kernel may relocate it to an invalid memory region
and cause a boot failure. Thus, we disable KASLR when "kexec_file" is
detected in the command line.

To ensure compatibility with older kernels loaded via kexec_file, this
patch should be backported to stable branches.

Cc: stable@vger.kernel.org
Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/relocate.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/loongarch/kernel/relocate.c
+++ b/arch/loongarch/kernel/relocate.c
@@ -166,6 +166,10 @@ static inline __init bool kaslr_disabled
 		return true;
 #endif
 
+	str = strstr(boot_command_line, "kexec_file");
+	if (str == boot_command_line || (str > boot_command_line && *(str - 1) == ' '))
+		return true;
+
 	return false;
 }
 


