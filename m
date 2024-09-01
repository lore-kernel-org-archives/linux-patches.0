Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D823398B;
	Sun,  1 Sep 2024 17:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210153; cv=none; b=DieGW6UmOcDMLafLDnDZ5voTNawKw278njZ1+Rmejt0qTxz0YXFVKT7y2KF8I0QPkPmCdYxQFteZerdSmUxG9embpahPifsYCEufIyhZ7YPBf4xOy6fznsQpMaPCTT1wKmh1aAhacSAFje+dGP4/4OiwvxSkH0zSl3k3S1rz3nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210153; c=relaxed/simple;
	bh=vjDZUh4roFgAhAbT6CmkglmkLclui5edZtHBAwW5xao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOpn0DaEDGoD+fJPIWIH5vdgc9aOfcWzaYpWT6h/WANU9+craIMHcAOjl/1dIXWtjZTuK7KzChjCMkQLquCLo2PayNCXObE0ZF+C6vK36wiWG/5jXMoDvyCJohNoLKMd4I3oLL6GdK0AsOK4hmO+xD5I3u9EAzp+wz0r+b3pjdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ow1tLMTM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ow1tLMTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A28C4CEC3;
	Sun,  1 Sep 2024 17:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210152;
	bh=vjDZUh4roFgAhAbT6CmkglmkLclui5edZtHBAwW5xao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ow1tLMTM9sro/Akgx2UwFjyTFfs2ey8tj8mw/yN7c7JFwdzYI/2lSrDcM8dcRO/UG
	 pMHgXG7bSAuImYBqqVRPG1TOGnuVXvTBo37waBnKd0LHYaBWbShYxN/rAisa4P1pVx
	 4JW20b5myuKI830Kt064SGCpKzkhH1A48A8nNjYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Filippov <jcmvbkbc@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/215] fs: binfmt_elf_efpic: dont use missing interpreters properties
Date: Sun,  1 Sep 2024 18:16:25 +0200
Message-ID: <20240901160826.111154858@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f51f6e4d1a322..a7084a720b28c 100644
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



