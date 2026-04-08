Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9687B3D9043;
	Wed,  8 Apr 2026 18:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674510; cv=none; b=hCvZbfstu0jLqRQTHzxx6HJaeAStKxhnZ6I3ibYW+bhDeMiPrrs0uDCnTcBHJyr/BM88vIQHvcb5mAbn8fP7TX38uIiYfYgv3jB1VLlneGIUuhkIy6UVZXQ8csJb0zIeFFYAEjroq91ywh6j1qNfMLgS76hcoy+ilvxinCGdMDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674510; c=relaxed/simple;
	bh=5wznJaxBRALTTn0+ULWSdJNcsllIhd6oa9Xj4zpCcY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQwq2YQ14gzOyc4h1V6ggm21wLO0pwySMAsDaNPkr8UpawPE6NdODENG0ncNOx3wwcRupcWwKsHlcBAlBWpkXNaI3u1h4cSFVjs0HLKZ0cYQMRtpfFsLFZ6z339//BMF3s08MR+qW3Kfm3hg+hfOoPWXw+/Cqwx+b9U4Ji1j3GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVOZspue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVOZspue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FE2C2BCB2;
	Wed,  8 Apr 2026 18:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674510;
	bh=5wznJaxBRALTTn0+ULWSdJNcsllIhd6oa9Xj4zpCcY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVOZspueGhw+xp9DIIhyqKnkW8htvslQCSBZUrIPoJmi9B/HHpCtuRcLAH1H0eSvH
	 mF8SRnr93Ty25xFdDq0Vr83Zw2cDwItvYqre5P9a6QVzPbdbtxPR6RLlMmEzEjP5H7
	 2NvDKX53A23yLDU2PalwCyj0r4XvGrpHxZMTDi8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Varun R Mallya <varunrmallya@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 125/311] bpf: Reject sleepable kprobe_multi programs at attach time
Date: Wed,  8 Apr 2026 20:02:05 +0200
Message-ID: <20260408175944.083937270@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Varun R Mallya <varunrmallya@gmail.com>

[ Upstream commit eb7024bfcc5f68ed11ed9dd4891a3073c15f04a8 ]

kprobe.multi programs run in atomic/RCU context and cannot sleep.
However, bpf_kprobe_multi_link_attach() did not validate whether the
program being attached had the sleepable flag set, allowing sleepable
helpers such as bpf_copy_from_user() to be invoked from a non-sleepable
context.

This causes a "sleeping function called from invalid context" splat:

  BUG: sleeping function called from invalid context at ./include/linux/uaccess.h:169
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1787, name: sudo
  preempt_count: 1, expected: 0
  RCU nest depth: 2, expected: 0

Fix this by rejecting sleepable programs early in
bpf_kprobe_multi_link_attach(), before any further processing.

Fixes: 0dcac2725406 ("bpf: Add multi kprobe link")
Signed-off-by: Varun R Mallya <varunrmallya@gmail.com>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Acked-by: Leon Hwang <leon.hwang@linux.dev>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20260401191126.440683-1-varunrmallya@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index e448a2553f7ce..42734975a06bc 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2739,6 +2739,10 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	if (!is_kprobe_multi(prog))
 		return -EINVAL;
 
+	/* kprobe_multi is not allowed to be sleepable. */
+	if (prog->sleepable)
+		return -EINVAL;
+
 	/* Writing to context is not allowed for kprobes. */
 	if (prog->aux->kprobe_write_ctx)
 		return -EINVAL;
-- 
2.53.0



