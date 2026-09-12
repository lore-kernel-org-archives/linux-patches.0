Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DC82737FC;
	Sat, 12 Sep 2026 07:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198924; cv=none; b=JHc5eGYN7reztZsbzBQifQVm/uVT2nZ4fsfaZ6cLocCG3kAYE5wKg3Kz9vzsInj30gRo5icByQd+figI70EYkP3q98rsFOhPygUI9/uI4fqHBawKz+8+hORYwRMCRO77zfWuQHEI4By0QDlqsC6POLhxF+W0qQ4LJHeSfzH0E+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198924; c=relaxed/simple;
	bh=gpVowBlscZ9938HSnbqmwjI3o+KuBfjDhjqFbwBSzXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdEqOe/dVjy+giS5VvtiknPqaEuaTXwkn+3+1iOXFLQshybtxq6laXr9DFWJpw/1waXIyF4wKTyxEEGaVz1Z3rU91M/gf86Otq0HiNLyAvq8keZS91c5pclywPyXY+GVIP/YpUI4cIElscuATQ2fsxzmWZ7i/FgQ+5pYGs0gdmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nes8pcjE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nes8pcjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8491F000FF;
	Sat, 12 Sep 2026 07:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198923;
	bh=x4tjQRg/KithZ42oF9VpN7yW54J+Y0lU662lBvCF/Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nes8pcjEOSruMXJ4iq8SeSxA5GC+P/TqArl5CXJRGgIKrWqycnoJcC0DDj0Vl6qDn
	 /Ytpem3CbhVkioNqN6BCBIYcUSv9nsWRqYJ6kbCVQgNWyGZ5lx0qYlMwGoS2a0wXya
	 /ykPTHeMe3TIlgntgBxA9oBWm6rRjahQyS/sKcWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0480/1815] bpf: Sync tail_call_reachable with callee state on entry
Date: Sat, 12 Sep 2026 08:37:10 +0200
Message-ID: <20260912065700.157950187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 3513ea9dab6c1a3d2dc8e6160c41f690206948b6 ]

Currently in check_max_stack_depth_subprog, when the verifier enters a
new callee branch, the local tail_call_reachable is not properly
synchronized with the callee's state.

Consider a main prog branching into multiple subprogs:

       subprog0 -> tailcall
main <
       subprog1 -> subprog2

When the verifier finishes checking subprog0 and backtracks to main
prog, the local tail_call_reachable state is left as true. As it
proceeds to subprog1, this uncleared state leaks into the new branch,
falsely marking subprog1 and subprog2 as tailcall reachable.

Fix this by explicitly syncing tail_call_reachable with the callee's
has_tail_call state on entry. The caller's state is safely preserved and
restored via the existing backtracking logic.

Fixes: ebf7d1f508a7 ("bpf, x64: rework pro/epilogue and tailcall handling in JIT")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Link: https://patch.msgid.link/20260716120157.835937-2-pulehui@huaweicloud.com
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2cfe54d848b6a..b8b45044ab65a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5211,8 +5211,8 @@ static int check_max_stack_depth_subprog(struct bpf_verifier_env *env, int idx,
 		if (!priv_stack_supported)
 			subprog[idx].priv_stack_mode = NO_PRIV_STACK;
 
-		if (subprog[idx].has_tail_call)
-			tail_call_reachable = true;
+		/* sync tail_call_reachable with callee state on entry */
+		tail_call_reachable = subprog[idx].has_tail_call;
 
 		frame = bpf_subprog_is_global(env, idx) ? 0 : frame + 1;
 		if (frame >= MAX_CALL_FRAMES) {
-- 
2.53.0



