Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B1F1C68C;
	Sun,  1 Sep 2024 16:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208811; cv=none; b=DJv2QDVHAf/V7Wyf1r9GlYYzg2jgghey+DdxQdhJk6gpU4CkArpHq3jPHBNA+gOKmcuMyAU5r3DOJ1oTZ4vPcnzuUdNyEObCgFkIvrrFi1ljXsnXHUrbRmcLs42bl6AoZcNU8BFQUzhUEBnNzodfG1NTNJy31Vl756pxbutxeIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208811; c=relaxed/simple;
	bh=RZ0WaFEufdslru1dju8yvL8sqmUWDyLSRvTmn/975kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJoVn1gQXwCTCwNdhZgoCEFcnNlcfaZr98NcuNI6blgk5Ju8lQ/97hncmwR0ZBU8WzSWIkQpJpCsLHtnjYmWX+eWB+XlWLBCnnQ+tovggwFuUNNR8dk41Tnb2RvWQADbC4ZTc5kw5S1Mhq/MDWOMFA9qkZi9DYJXONBUQPv+uck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnBiRe3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnBiRe3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D528FC4CEC3;
	Sun,  1 Sep 2024 16:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208811;
	bh=RZ0WaFEufdslru1dju8yvL8sqmUWDyLSRvTmn/975kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OnBiRe3vsamCVb4J5t+w7FSIOtXqHdppWBdK/pbtrUgiWymYd5nG4NGEwmw0fZlj4
	 7tNtxvGIjpQQPAkNNUnzOOSnpSTkUA3BdE83oJmflCpzaWmL5pa17LsdG6PdGA43Hb
	 892YnWzRJLtvHHYOBrDoTxWkU3sitXVcv6u/BWf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Filippov <jcmvbkbc@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 046/134] fs: binfmt_elf_efpic: dont use missing interpreters properties
Date: Sun,  1 Sep 2024 18:16:32 +0200
Message-ID: <20240901160811.841254531@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 28aef31a6e6f2..aeeba59fa7342 100644
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



