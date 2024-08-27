Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902551C1723;
	Tue, 27 Aug 2024 15:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772277; cv=none; b=m61JbiVyxpNxS+s9z02fxdi6gLUTWYjVCzAxhK56G0mGVfLHWcgHcrVG32qF3Yqn9mF6+NKZnP9QkoIG9L97E6/RZeDSVcnXeeLO6cpeuKry2xswjRs5ZWx7PwKK0IjkIrdzPhK4dHpkOigX1Ogb8ar0q/5Cxb0YbV+yfpBB6m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772277; c=relaxed/simple;
	bh=hQ4buIu/9a4BOgdYzP6FsteuNM6d//lzVolqRAFVULY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPV2NlCzfMXF5DCteLH560+blrPB9SnHAOoh5SeilhXvx1fIs8SP7OYyXoTKAq7k+VnutZwn/7tYj8PJc/jASvC+9xN9GkvzIzMjdo8Bef5it0f/a3y5KO3fZw5mZTSJr2Ap7B7GcdxvBQY84pHGGYydLpeggq11JJrON36bLgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TSpvb9it; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TSpvb9it"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019EAC61071;
	Tue, 27 Aug 2024 15:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772277;
	bh=hQ4buIu/9a4BOgdYzP6FsteuNM6d//lzVolqRAFVULY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TSpvb9itJkHjabaFLvoVGFwguHjO4NVj/Q4MyWBXcqUl6Wib8+CspD4QVmLZTOhoo
	 3lICYyHtxJQedrE9TX+FM7iDLoMrlsar0H/m6qsiuOjz4H9jHRMUqdTCZ00+BOhzgn
	 0uHvsMTb682M3WW1NofQZF5dr96FpmjK3T5w+TlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Filippov <jcmvbkbc@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 165/321] fs: binfmt_elf_efpic: dont use missing interpreters properties
Date: Tue, 27 Aug 2024 16:37:53 +0200
Message-ID: <20240827143844.512166629@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2aecd4ffb13b3..c71a409273150 100644
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



