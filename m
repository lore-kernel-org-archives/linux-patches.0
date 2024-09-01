Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3679C183CA7;
	Sun,  1 Sep 2024 16:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208280; cv=none; b=ZKXfcfCXLn6Uh9JKag+jr+hLuOLumSfEr58UnFwIbtSoc11Gu0qkg53qKycHYEEUrBaAInHmdw8DnXm4h3AglAvMizGDSc9UBj4NPIFdNQ4kRycQnOcyi8j4k6pJxSvopGcChZBk+YMlrh7gXIFIH1HoaYJ+Jo3Cy7bk9WxL0AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208280; c=relaxed/simple;
	bh=qDgh7yoyaDspYaG2MqVEdpjS6vhw/32Vp8C7LlB8Pow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwAB9GatPkLmLVJct0canM109kbmNYuEv1ijKrfOdR+vpt2kMyHIfwJwN0DtxhooOGtSOIoDyjAQkib18aQ7RSJQjDAl4QMNRz5tQl/NjXG8v1AozPqY/u9mcjyBjecoBIqJ2ATe1UddzfFbTh4qClGR7Kus5AJcNSYOyxyqkmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pc7UQNsq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pc7UQNsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A7BC4CEC3;
	Sun,  1 Sep 2024 16:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208279;
	bh=qDgh7yoyaDspYaG2MqVEdpjS6vhw/32Vp8C7LlB8Pow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pc7UQNsqfW71StoerGqUOSZnvQAax3r4IYckphaJHf7wScyQbS9wCKBKuf1HJELvy
	 Un2E1hns1hdriZ8uBmN2zVJdDoD2sODDFXpovpl1NxlvDBm8AInxYAYamVR8fIWdPb
	 cAVCJNRbum3xHmPBEVGi3SoQmpUv/Be6mr5StXPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Ungerer <gerg@kernel.org>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.10 034/149] binfmt_elf_fdpic: fix AUXV size calculation when ELF_HWCAP2 is defined
Date: Sun,  1 Sep 2024 18:15:45 +0200
Message-ID: <20240901160818.745189201@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

commit c6a09e342f8e6d3cac7f7c5c14085236aca284b9 upstream.

create_elf_fdpic_tables() does not correctly account the space for the
AUX vector when an architecture has ELF_HWCAP2 defined. Prior to the
commit 10e29251be0e ("binfmt_elf_fdpic: fix /proc/<pid>/auxv") it
resulted in the last entry of the AUX vector being set to zero, but with
that change it results in a kernel BUG.

Fix that by adding one to the number of AUXV entries (nitems) when
ELF_HWCAP2 is defined.

Fixes: 10e29251be0e ("binfmt_elf_fdpic: fix /proc/<pid>/auxv")
Cc: stable@vger.kernel.org
Reported-by: Greg Ungerer <gerg@kernel.org>
Closes: https://lore.kernel.org/lkml/5b51975f-6d0b-413c-8b38-39a6a45e8821@westnet.com.au/
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Tested-by: Greg Ungerer <gerg@kernel.org>
Link: https://lore.kernel.org/r/20240826032745.3423812-1-jcmvbkbc@gmail.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_elf_fdpic.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -592,6 +592,9 @@ static int create_elf_fdpic_tables(struc
 
 	if (bprm->have_execfd)
 		nitems++;
+#ifdef ELF_HWCAP2
+	nitems++;
+#endif
 
 	csp = sp;
 	sp -= nitems * 2 * sizeof(unsigned long);


