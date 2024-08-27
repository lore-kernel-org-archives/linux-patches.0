Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C57344C8C;
	Tue, 27 Aug 2024 14:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770218; cv=none; b=CnpEw/SecEF8FY8P/bdjWIUPLHB7w9Z9n8Z6czuKLgcgVrPxOuuYxEDIrBAk1GJy7SS/jziAtpgSAfN9/Gpa9Li6LWyNESOQe5sPsq70pdy4FgjJFrA5C34UOyAHktm6c5piz3qXLjc/kJrVVm6ErskYVAr2693gXFFBIRLmReU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770218; c=relaxed/simple;
	bh=09YV7xuHPPZXF2GUsAYeuKexKRXS6Jsr3sCmCEyt0hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVE4KViVcGQT2OPbqFY/NOkic1i8JY8GyldAqSyzlPhPX/L51eELEJ9N3qxA5nsU3CyvHYXEl68nuP8V6KOkcfMSe8nPouj7nfsgegxayYrmBQtq3yNPV0n/w7uDXtykD+y+4OG6HHpZeDVPQOS21cC08PyHTQfiDSfkObat6TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nukhPI0x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nukhPI0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94416C4DDEF;
	Tue, 27 Aug 2024 14:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770218;
	bh=09YV7xuHPPZXF2GUsAYeuKexKRXS6Jsr3sCmCEyt0hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nukhPI0xRo4f8xv+c/nc0DRIthLhbHux5bU+QlI+ynGp3T4HFIiZQ0ltLgkEFzcVZ
	 8MgwaFUcTQO6zMSTYW8ZDO/nuDoOwPKamtiwuPaDekMVxqmxgX317+r4vG/iJxJFwT
	 HdztUTWotJTlGcK9mkE6/gbGLBQquyNxdSz+llYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Filippov <jcmvbkbc@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 163/341] fs: binfmt_elf_efpic: dont use missing interpreters properties
Date: Tue, 27 Aug 2024 16:36:34 +0200
Message-ID: <20240827143849.615922598@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 206812ce544ae..96a8b13b57d96 100644
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



