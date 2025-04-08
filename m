Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0AF2135CD;
	Tue,  8 Apr 2025 11:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110261; cv=none; b=mrV7cetohohYIoJxjX9556F8Ik1CrOVC0+UA2mpchvOTkQEfUoOK4e1NYyyZGIXzFhILyTbQFyIxoXP3oPUoB5N2KxrxCu5Kj8oxVyHXIYYAZzHuUgZBL7htahwNgUyz70ZnZgTx7F8XhH4E9kdwKoLOXYGoWQsJ3wVLDyN0kJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110261; c=relaxed/simple;
	bh=mCCqlhv0Yv/fua2W1DhTUxAILhWNeedyYA9rUx9bpU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q92ZsjL/pgj1UwR+JMYKY/n1jEwQYMjHFlj0CxjWKTYDWmkZJctPtnIEA/PPeR/o4m2N7tORYlWYOdRfte5Uq/UbPtWG65xnXoBvRav6i79Gm8UNJgUzySXC7er9UkRo6SLIgfMMtJIw5d9T6Kxiq2p/yiovcVyYjnbBZbseLKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2IhZCG3S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2IhZCG3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F9FC4CEE5;
	Tue,  8 Apr 2025 11:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110259;
	bh=mCCqlhv0Yv/fua2W1DhTUxAILhWNeedyYA9rUx9bpU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2IhZCG3Sj2Skrm7cRC5ieL6q0/sK3mxf087QikCR+lojw5HSAK4bLwO2eEJnx4Fbx
	 bSOJLRbDjISChriUq29EqDGN6YjZw03MWh8cp5LXqoU8vCkQh15wPpGNso3YJbLeuy
	 tAqXSXbys05Oj0q4abQd8bkQKkT5bde7FGaHKnO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Baoquan He <bhe@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	stable@kernel.org
Subject: [PATCH 5.10 227/227] x86/kexec: Fix double-free of elf header buffer
Date: Tue,  8 Apr 2025 12:50:05 +0200
Message-ID: <20250408104827.083970034@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit d00dd2f2645dca04cf399d8fc692f3f69b6dd996 upstream.

After

  b3e34a47f989 ("x86/kexec: fix memory leak of elf header buffer"),

freeing image->elf_headers in the error path of crash_load_segments()
is not needed because kimage_file_post_load_cleanup() will take
care of that later. And not clearing it could result in a double-free.

Drop the superfluous vfree() call at the error path of
crash_load_segments().

Fixes: b3e34a47f989 ("x86/kexec: fix memory leak of elf header buffer")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Baoquan He <bhe@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20221122115122.13937-1-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/crash.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -399,10 +399,8 @@ int crash_load_segments(struct kimage *i
 	kbuf.buf_align = ELF_CORE_HEADER_ALIGN;
 	kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
 	ret = kexec_add_buffer(&kbuf);
-	if (ret) {
-		vfree((void *)image->arch.elf_headers);
+	if (ret)
 		return ret;
-	}
 	image->arch.elf_load_addr = kbuf.mem;
 	pr_debug("Loaded ELF headers at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
 		 image->arch.elf_load_addr, kbuf.bufsz, kbuf.bufsz);


