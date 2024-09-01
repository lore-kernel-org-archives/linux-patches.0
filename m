Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4822C1B4;
	Sun,  1 Sep 2024 16:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207731; cv=none; b=H/5fq7AWX63rRUndnhSxpP9S7hcQTYkrBvWQRSlQXAI+qa5IxzQ+xySjRDXKh+1uU/TdYalpcVUQG78AnmklNwrc+JSR2D+8nzhfeRfKWdMb2bP9ggOpysYbLJ56z0SpbWq9pXRbXINYaQNUwRgSUDbSDpqjFkcMZ2mll5jJk1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207731; c=relaxed/simple;
	bh=FFl+xjbFFJS61oQVrKZ9M3aVXzp28T5CP4ORQIicUSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M16xw8nP7cSS46ossNAg71fL5yfF/E6QekZRZQnuEkHCTyTzAtjVZBjAtoWHoZNGZv121Mo2dyh4WJOp3xEWHfe4CYs1hRRIuJqNWQScPEL68+p4qeYMIghphxLsYMm58wcHPcdYLPVIHpMXU/q8+5h+ow9M3qD9f4VbAo3hHso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/HnXbvA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/HnXbvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E288C4CEC3;
	Sun,  1 Sep 2024 16:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207730;
	bh=FFl+xjbFFJS61oQVrKZ9M3aVXzp28T5CP4ORQIicUSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/HnXbvAZU9GLzIF8UDhL840w1EtSmPefmRMVmTvoDC1AKrSpMuoOLY4PFP8ejdRC
	 npZS//LOD93eapJbtr5zWRYRBE6NHlIXy3T850R4+83E3OU09BA4QDghnRCa/fDUCu
	 78INB+A9D6fEMudemFctuhBFALCVOQ5PE78mIqGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Filippov <jcmvbkbc@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 29/98] fs: binfmt_elf_efpic: dont use missing interpreters properties
Date: Sun,  1 Sep 2024 18:15:59 +0200
Message-ID: <20240901160804.792855435@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index a7c2efcd0a4a3..0dbbb3a21e6c3 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -324,7 +324,7 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
 	else
 		executable_stack = EXSTACK_DEFAULT;
 
-	if (stack_size == 0) {
+	if (stack_size == 0 && interp_params.flags & ELF_FDPIC_FLAG_PRESENT) {
 		stack_size = interp_params.stack_size;
 		if (interp_params.flags & ELF_FDPIC_FLAG_EXEC_STACK)
 			executable_stack = EXSTACK_ENABLE_X;
-- 
2.43.0



