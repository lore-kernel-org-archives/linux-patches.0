Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F1B6FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A025C433F0;
	Tue, 10 Jan 2023 18:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374766;
	bh=eOl1NMaMazQGbtIBH02ohkfluw1QFycUlov2MiDILG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mteXaNQ2qiykeOqyIpc1b/d3bdWJ/RJ3G9RubRYlOFc1CKgwNuEqbeGdM3xpewUQ6
	 KG3QSo3vSoeNXI/RfKCjFBApL2Om8Dcd8SAI3bkELbzO9M/d4/GWm3ALOo+geHy8st
	 EOPRdAMgrz0HvzvG09V4b0crnyLT1LkVgy1kXttg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Baoquan He <bhe@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	stable@kernel.org
Subject: [PATCH 6.1 126/159] x86/kexec: Fix double-free of elf header buffer
Date: Tue, 10 Jan 2023 19:04:34 +0100
Message-Id: <20230110180022.359094859@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
@@ -401,10 +401,8 @@ int crash_load_segments(struct kimage *i
 	kbuf.buf_align = ELF_CORE_HEADER_ALIGN;
 	kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
 	ret = kexec_add_buffer(&kbuf);
-	if (ret) {
-		vfree((void *)image->elf_headers);
+	if (ret)
 		return ret;
-	}
 	image->elf_load_addr = kbuf.mem;
 	pr_debug("Loaded ELF headers at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
 		 image->elf_load_addr, kbuf.bufsz, kbuf.memsz);


