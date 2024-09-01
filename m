Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535221DFD1;
	Sun,  1 Sep 2024 16:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209490; cv=none; b=Zcd3tGvOO9eZjsz7ATEQDNeQx/1noskhNPOs4E5g1Rgv5Q4lr6CHwVUEi/5MrzPxhzVjDIyfJLm0zW6IXdZayDjqEksLLhm5TaLVSWGWgt2HucKO1WJvwVVJkdU9+k+eXSOvjJI6nHyH4nP4jRNSj0U+/D+C2QMESTUmEGc52cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209490; c=relaxed/simple;
	bh=N0HnvANL7Bk465vvV938zRFfcOcWRDnQsTvGcPo/+rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLEqemb35z4jeAL4+auxiLtpuR5NUgG1R5jr5JHaORQpjHycfqr8TPg8BKZ/que8qnUMBBhlnzV7MKxqvrcNeyws9vy09QlxYoL9v17b0VHVPfEiCp2GtGFtilLsaD1gkrw8ycnEHlUgS/085OqPNuPU7npkSdWpvGz63pyaOLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JhNNPVz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JhNNPVz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E25C4CEC3;
	Sun,  1 Sep 2024 16:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209490;
	bh=N0HnvANL7Bk465vvV938zRFfcOcWRDnQsTvGcPo/+rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JhNNPVz5JZL+JVdDOLWdyAfykrtpLJj9MOShwWFFNbhJEa6eg/2s6WTPr9OGYE71N
	 9H7Ab0lR+9T5UJkC1MkLFxkbNnuzzHNo1kgNS8Svb+xQoStVLMHWv7tLq3ox4V680R
	 olhEreqil2nXJBrG3zJPKofJLy6jxmiVUhFstkfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Filippov <jcmvbkbc@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/151] fs: binfmt_elf_efpic: dont use missing interpreters properties
Date: Sun,  1 Sep 2024 18:16:52 +0200
Message-ID: <20240901160816.075312326@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

[ Upstream commit 15fd1dc3dadb4268207fa6797e753541aca09a2a ]

Static FDPIC executable may get an executable stack even when it has
non-executable GNU_STACK segment. This happens when STACK segment has rw
permissions, but does not specify stack size. In that case FDPIC loader
uses permissions of the interpreter's stack, and for static executables
with no interpreter it results in choosing the arch-default permissions
for the stack.

Fix that by using the interpreter's properties only when the interpreter
is actually used.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Link: https://lore.kernel.org/r/20240118150637.660461-1-jcmvbkbc@gmail.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/binfmt_elf_fdpic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 48bb1290ed2fd..88428de9d873e 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -320,7 +320,7 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
 	else
 		executable_stack = EXSTACK_DEFAULT;
 
-	if (stack_size == 0) {
+	if (stack_size == 0 && interp_params.flags & ELF_FDPIC_FLAG_PRESENT) {
 		stack_size = interp_params.stack_size;
 		if (interp_params.flags & ELF_FDPIC_FLAG_EXEC_STACK)
 			executable_stack = EXSTACK_ENABLE_X;
-- 
2.43.0



