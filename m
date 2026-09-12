Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833C33A1690;
	Sat, 12 Sep 2026 08:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202043; cv=none; b=QrR6/Sb4QKFZ+g1WbA8gVMhAg95WDygLiKpsh4tzbr8WPtJNFyFSVzf7VWvopJlzWfdyu+S1Qiw+rDrk0LkkQFcvqsII1+R2aMuUMqRyeb7sqYoN+Uuvc1druQnBk5qbU3FHI4JRjreX9/4yIz+s3lIrQjGMqqp6xkIi02cyXL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202043; c=relaxed/simple;
	bh=TecaWvIVMEjSMPuMHR7iCrISnLvTAuc/iFmn2KyepPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVUVHzGNzIuMGuZz5oSPIZ/5eeIXL6L1bR+ocTY+cJryKtlGOlybJs1kru/tHy78J1z5tg7SCULjmHgR/a0xmt7jqzhlTleBwX4mTd89H4FTqrVbEPU28Bs1UIVWqeHAX5Xz3v5T3wD9QstfXJLEkFkvCHAgZp9tIafZuBvZIgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIfCysmq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wIfCysmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030121F000FF;
	Sat, 12 Sep 2026 08:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202041;
	bh=bFMMym0lORJfn16sXr6bR7xg5EHtUmN76NZUCVLg6YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wIfCysmqYEqIVpQwlCDktyXcYVZYr+uZIXUDPwbPpTtHWRBjDDDywsZ78vCF4foB3
	 cFZZ0FQE3nV4d8YL7ExMElVL5O4Bc7gcN8ntRcaowSboJT8ZhVsA9ZpKWOF8+e0YiX
	 B3svYx2qyFdBzbPt4S0nFLvG0VMZNsmsCsbnHmHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Viktor Malik <vmalik@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1121/1815] bpf: Fix sleepable check for tracing/lsm prog
Date: Sat, 12 Sep 2026 08:47:51 +0200
Message-ID: <20260912065715.336252412@linuxfoundation.org>
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

From: Leon Hwang <leon.hwang@linux.dev>

[ Upstream commit 00244bdaa423d93f4571f3f6854378ce3365e524 ]

When CONFIG_FUNCTION_ERROR_INJECTION is disabled, a sleepable tracing prog
is allowed to attach to '__x64_'-alike prefix symbols.

It is because the verifier does not verify whether the symbol is a kernel
function or a bpf prog. That said, a sleepable tracing prog is allowed to
attach to a bpf prog target whose name has '__x64_'-alike prefix.

For example, a sleepable fentry prog attaches to a '__x64_sys_nop' XDP
prog, and copies buffer from a user pointer with bpf_copy_from_user()
helper. After attaching the XDP prog to lo interface, the kernel BUG
could be triggered by 'ping -c 1 -W 1 127.0.0.1':

[    3.460756] BUG: sleeping function called from invalid context at kernel/bpf/trampoline.c:1324

Fix it by disallowing sleepable prog always when its target
btf is not a kernel's btf.

Fixes: 16d9c5660692 ("bpf: Always allow sleepable programs on syscalls")
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Viktor Malik <vmalik@redhat.com>
Link: https://lore.kernel.org/bpf/20260805150810.34907-2-leon.hwang@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 34cf85d868d82..85cae5684f59b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -18866,6 +18866,9 @@ static int btf_id_allow_sleepable(u32 btf_id, unsigned long addr, const struct b
 	const struct btf_type *t;
 	const char *tname;
 
+	if (!btf_is_kernel(btf))
+		return -EINVAL;
+
 	switch (prog->type) {
 	case BPF_PROG_TYPE_TRACING:
 		t = btf_type_by_id(btf, btf_id);
-- 
2.53.0



