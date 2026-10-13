Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0274D7D30;
	Tue, 13 Oct 2026 11:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892261; cv=none; b=gHB2aGJq4aOIrq1s/jHUoljaEUmN6U38w1o/P0jpUHHHRdSWnTJa9PW8geXtjwthBWBovhdMtt3aX/QeOp82INFv0FvnFMVOqlhUZvyCaDPr3MbLJ7iRle71NUjODKWwoDdW//bB6xtp8YD34nTd1L3f9eaNGLoaHy19UMnTw8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892261; c=relaxed/simple;
	bh=K5+MiId7cGx+m3d7ASQBb6cuKSfzG+fo6jsJtIWS6QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7wXId18OZS342NiXZ3F7xLK65Wp7N3G0MUHwKmZ2nr/NzIIv3ok9+YnSDHIpsK2X56njK90JhzIU6gxOarWZzl7tKyn1Fzg8V4ELny2zwoPd5rVUwDwXvy0WE+gLi2SPoZcINmG5tcqzmiz0+J1rHI8gpVDcJ7SZrIWuEnvBLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljOwFtVX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljOwFtVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A371F000FF;
	Tue, 13 Oct 2026 11:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892260;
	bh=Midb7FQ8E27OsSlJVIhtU2bHR2mgHqJTQbtM1d5PYFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljOwFtVXXP5ZpHJWXiiF4B6U+X50P8WtQFVRZJpsEBdYIkyKi/MrlvfAv04J9VZo8
	 +zF4K5P2o5TmeQADQRvKhKCT5rOoXwZSSdqgEtGZNMOETY7SMMKR9AhAqMeX4h7Mje
	 +uPfyX0CHWCkbyWm2u8yuvaE/6TvNaowgQXALA7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Pei <cp0613@linux.alibaba.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 7.2 113/281] riscv: ptrace: reject CFI regset access when extensions are absent
Date: Tue, 13 Oct 2026 13:37:09 +0200
Message-ID: <20261013112857.891315749@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Chen Pei <cp0613@linux.alibaba.com>

commit adadf6df0bd55aa40ccbc6519fb443133e103227 upstream.

riscv_cfi_get() and riscv_cfi_set() do not check whether the Zicfilp
or Zicfiss extensions are present. On systems without them,
PTRACE_GETREGSET on REGSET_CFI still succeeds and returns a zeroed
user_cfi_state, misleading debuggers into believing the register set
is available, and PTRACE_SETREGSET silently accepts writes that have
no effect (e.g. clearing SR_ELP).

Reject the access with -EINVAL when neither branch landing pads nor
shadow stack is available to userspace, using the same availability
helpers as the prctl path.

Fixes: 2af7c9cf021c ("riscv/ptrace: expose riscv CFI status and state via ptrace and in core files")
Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
Link: https://patch.msgid.link/20260820063233.2567-1-cp0613@linux.alibaba.com
Cc: stable@vger.kernel.org
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/ptrace.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/riscv/kernel/ptrace.c
+++ b/arch/riscv/kernel/ptrace.c
@@ -299,6 +299,9 @@ static int riscv_cfi_get(struct task_str
 	struct user_cfi_state user_cfi;
 	struct pt_regs *regs;
 
+	if (!is_user_lpad_enabled() && !is_user_shstk_enabled())
+		return -EINVAL;
+
 	memset(&user_cfi, 0, sizeof(user_cfi));
 	regs = task_pt_regs(target);
 
@@ -337,6 +340,9 @@ static int riscv_cfi_set(struct task_str
 	struct user_cfi_state user_cfi;
 	struct pt_regs *regs;
 
+	if (!is_user_lpad_enabled() && !is_user_shstk_enabled())
+		return -EINVAL;
+
 	regs = task_pt_regs(target);
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &user_cfi, 0, -1);


