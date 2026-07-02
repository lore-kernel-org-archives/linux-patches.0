Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C9E30C158;
	Thu,  2 Jul 2026 16:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010231; cv=none; b=uq2vpeZoh9lwtbxuCzZsK/jEzl1p/wzjaxOJuGKAlFvWS5Zvz49x+edos0vptkY2CjmSQQjEW6twobVe56BZRGEfJ6jofUU7cfl2Q9PoU1Z3G9SJV3oIJ/kaggIdc7A/7wiXv5WJ8SN2aEb+pJsNQTFJ3W8gs6lQwF/7to0ovro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010231; c=relaxed/simple;
	bh=ZdCg3Ho44hgTk/xwL+x8XTIPCCqBRtCBR1bMvrgh1/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAF/KjQkvSgIg2bwKHY7yX+E7rIUAOP1qAfxhihiqbOp6qA4MEzhkrtvLqiOBQsdj+YEwZ3a7VFCrzJ2F0D8D0WtZ3PbryDtR0s+fZr3YARJzfTSJp3+oz5jOu7MHh4vYrARekCsFFvEq3zy0hpGKj+qt5hqVBAxSbxEuJhnjnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+cKN/qu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+cKN/qu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AF51F000E9;
	Thu,  2 Jul 2026 16:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010230;
	bh=bR2UldUF8wQ8hE7d/0dpnWae+VRT+lpUyWARHhZJYfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y+cKN/qukSlhT9HqK9/HmcVLxFJ3ZargBwHoc7fJ2Sd38andWPtZcMYQajvnctMV+
	 BtyVGL2zyPr7BDp0aQodVC/9d+2EYLHawLkN0BcXu65SIYk+7Zb5hytL0JNJE92FHH
	 S12ccphHjFUE1di02ZN4xIqSUsQH9roxJs0uC8IU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Varun R Mallya <varunrmallya@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/204] bpf: Reject sleepable kprobe_multi programs at attach time
Date: Thu,  2 Jul 2026 18:18:08 +0200
Message-ID: <20260702155119.312709464@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Varun R Mallya <varunrmallya@gmail.com>

commit eb7024bfcc5f68ed11ed9dd4891a3073c15f04a8 upstream.

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
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 4a44451efbcc67..41c874fbd6fa79 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2943,6 +2943,10 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	if (!is_kprobe_multi(prog))
 		return -EINVAL;
 
+	/* kprobe_multi is not allowed to be sleepable. */
+	if (prog->sleepable)
+		return -EINVAL;
+
 	flags = attr->link_create.kprobe_multi.flags;
 	if (flags & ~BPF_F_KPROBE_MULTI_RETURN)
 		return -EINVAL;
-- 
2.53.0



