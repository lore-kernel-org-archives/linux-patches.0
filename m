Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF641CA8F;
	Mon,  1 Apr 2024 16:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987502; cv=none; b=Hiu9a4y/gsajGiCm4Z4D3aB32xNjARTx1PpImej8iicTfzWj1m+wFvB3In/KlM35WX0sbyylD1KXvr5o0ctTN0Kwkqxkrb+j9hQoTlSa98IjCuSdhJhuzZm3AZH67KXbdBTsh16R8/rIL2qm4D4RcB9DlaITaww3zGXMsCBT0kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987502; c=relaxed/simple;
	bh=3HxbZZKIzyYoMB40aEX0KQ1nv/XQ5oM9XkwxGqAKbnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgMfmsz9O48MnH6Tm9CHI8UxpWBOJMvv9GLXqDg89qsSS0CLbjlUEXQJv6zph0NLeLexXnUypwvEwHGQDRqWyhcqLugFnTPH4fjGVIFS+ExoqpPtyWL/sRXMsJLzu2Rj9AIPbp6izmxkD+MxBGKTvxyuOj+WOdk44Luid5Fl/mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejNBpFh7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejNBpFh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB74BC433F1;
	Mon,  1 Apr 2024 16:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987502;
	bh=3HxbZZKIzyYoMB40aEX0KQ1nv/XQ5oM9XkwxGqAKbnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ejNBpFh7fFwLNT+7+AzLsWqq3Kcoe7fMtfwpDLo52oZA7iz4DZorPuwdQ0/8QaANK
	 ywe5Eki2x9wi9xOrPx+lLL0mlB+PXcUHmI6PijkJeBHI8RUpm+QRtX3U3KDho8cBkW
	 IKBfAb3Lsd1z5+NvYbsLNw5QYekMIhMaEH53PtsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Filippov <jcmvbkbc@gmail.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.8 307/399] exec: Fix NOMMU linux_binprm::exec in transfer_args_to_stack()
Date: Mon,  1 Apr 2024 17:44:33 +0200
Message-ID: <20240401152558.353389530@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

commit 2aea94ac14d1e0a8ae9e34febebe208213ba72f7 upstream.

In NOMMU kernel the value of linux_binprm::p is the offset inside the
temporary program arguments array maintained in separate pages in the
linux_binprm::page. linux_binprm::exec being a copy of linux_binprm::p
thus must be adjusted when that array is copied to the user stack.
Without that adjustment the value passed by the NOMMU kernel to the ELF
program in the AT_EXECFN entry of the aux array doesn't make any sense
and it may break programs that try to access memory pointed to by that
entry.

Adjust linux_binprm::exec before the successful return from the
transfer_args_to_stack().

Cc: <stable@vger.kernel.org>
Fixes: b6a2fea39318 ("mm: variable length argument support")
Fixes: 5edc2a5123a7 ("binfmt_elf_fdpic: wire up AT_EXECFD, AT_EXECFN, AT_SECURE")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Link: https://lore.kernel.org/r/20240320182607.1472887-1-jcmvbkbc@gmail.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exec.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -895,6 +895,7 @@ int transfer_args_to_stack(struct linux_
 			goto out;
 	}
 
+	bprm->exec += *sp_location - MAX_ARG_PAGES * PAGE_SIZE;
 	*sp_location = sp;
 
 out:


