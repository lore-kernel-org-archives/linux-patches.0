Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265EB18A950;
	Tue, 10 Sep 2024 10:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964097; cv=none; b=ZicjrbSH20iJsYc0xxKGRcaIkkDXnSCXC+EnohnJrx+CCzPKsmiznF6pcyAcGtYqzCuY+HeyvQJEKIvd6/qEmB4IIzlboqeFWw9qRpzUvGO6UvHYgUIKW+GaTcSuK9eLydLb4ywqaLRH3ZH63oOgfM8SQLjD9aWHDRDrK8NPp1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964097; c=relaxed/simple;
	bh=DCs2NxwlgTsHqXxYmSyg5uT2Fjso/4A3pIx3v12NhQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6eLJtzI+jaO+8PMVV+MNjq/nNJfyb9EkfD/oLLucD2tkWcsLFaNQxYVTj9iBkPHIcBK5kSr34TZJxXJ4euyKLN3kmvSnlFoQkee8DbXWZOuNJgzpMFNLFlj6cowy33MzcwWPdFiXvl43HkPQBLKQocHKjXdLGJET3PAPBvrtyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7dqIcNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7dqIcNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BF8C4CEC3;
	Tue, 10 Sep 2024 10:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964097;
	bh=DCs2NxwlgTsHqXxYmSyg5uT2Fjso/4A3pIx3v12NhQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7dqIcNWV2q8pNnTk0+MxXzccgSdGcVvBRWtu+VPCb2P9PCaaGKZPOzcqVm2grNDZ
	 f0iAD1l1oiFeytsiUa/h+PsNE3sOqgiHjU/NAccr8TJztciexN5YU/OpFKldObUTrE
	 D4vIaT1cfh29eGTyW8hloxQCuVJHVz/DJg6njzAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/269] ELF: fix kernel.randomize_va_space double read
Date: Tue, 10 Sep 2024 11:30:54 +0200
Message-ID: <20240910092610.583985324@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit 2a97388a807b6ab5538aa8f8537b2463c6988bd2 ]

ELF loader uses "randomize_va_space" twice. It is sysctl and can change
at any moment, so 2 loads could see 2 different values in theory with
unpredictable consequences.

Issue exactly one load for consistent value across one exec.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Link: https://lore.kernel.org/r/3329905c-7eb8-400a-8f0a-d87cff979b5b@p183
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/binfmt_elf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 7b3d2d491407..fb2c8d14327a 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1008,7 +1008,8 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	if (elf_read_implies_exec(*elf_ex, executable_stack))
 		current->personality |= READ_IMPLIES_EXEC;
 
-	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
+	const int snapshot_randomize_va_space = READ_ONCE(randomize_va_space);
+	if (!(current->personality & ADDR_NO_RANDOMIZE) && snapshot_randomize_va_space)
 		current->flags |= PF_RANDOMIZE;
 
 	setup_new_exec(bprm);
@@ -1300,7 +1301,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	mm->end_data = end_data;
 	mm->start_stack = bprm->p;
 
-	if ((current->flags & PF_RANDOMIZE) && (randomize_va_space > 1)) {
+	if ((current->flags & PF_RANDOMIZE) && (snapshot_randomize_va_space > 1)) {
 		/*
 		 * For architectures with ELF randomization, when executing
 		 * a loader directly (i.e. no interpreter listed in ELF
-- 
2.43.0



