Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCE0134B1
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0302FC4339E;
	Mon, 12 Jun 2023 10:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566856;
	bh=SQRgxqwdRxPTZ/X4WsCTGtV9w07LTi8dQHkn5VkWKjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mvF2TtTqrWeC0x7M7oZTcjZ72S/j0yQEiwIGgQ2StKLqeK8IhDKkk8M7J5ZCEJpl/
	 6qGw0JKLVsDeqr2atFJa6EQXvwoizORJh8VdDhmkof4GMDtBfrGLENliT1aTaSwnPM
	 cSfC1dfh2TXL7J8UiMCxSYyNZcMj7m+xZQGESM7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasios Papagiannis <tasos.papagiannnis@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Stanislav Fomichev <sdf@google.com>,
	Yonghong Song <yhs@fb.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 058/160] bpf: Add extra path pointer check to d_path helper
Date: Mon, 12 Jun 2023 12:26:30 +0200
Message-ID: <20230612101717.671091981@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit f46fab0e36e611a2389d3843f34658c849b6bd60 ]

Anastasios reported crash on stable 5.15 kernel with following
BPF attached to lsm hook:

  SEC("lsm.s/bprm_creds_for_exec")
  int BPF_PROG(bprm_creds_for_exec, struct linux_binprm *bprm)
  {
          struct path *path = &bprm->executable->f_path;
          char p[128] = { 0 };

          bpf_d_path(path, p, 128);
          return 0;
  }

But bprm->executable can be NULL, so bpf_d_path call will crash:

  BUG: kernel NULL pointer dereference, address: 0000000000000018
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
  ...
  RIP: 0010:d_path+0x22/0x280
  ...
  Call Trace:
   <TASK>
   bpf_d_path+0x21/0x60
   bpf_prog_db9cf176e84498d9_bprm_creds_for_exec+0x94/0x99
   bpf_trampoline_6442506293_0+0x55/0x1000
   bpf_lsm_bprm_creds_for_exec+0x5/0x10
   security_bprm_creds_for_exec+0x29/0x40
   bprm_execve+0x1c1/0x900
   do_execveat_common.isra.0+0x1af/0x260
   __x64_sys_execve+0x32/0x40

It's problem for all stable trees with bpf_d_path helper, which was
added in 5.9.

This issue is fixed in current bpf code, where we identify and mark
trusted pointers, so the above code would fail even to load.

For the sake of the stable trees and to workaround potentially broken
verifier in the future, adding the code that reads the path object from
the passed pointer and verifies it's valid in kernel space.

Fixes: 6e22ab9da793 ("bpf: Add d_path helper")
Reported-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20230606181714.532998-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index e8da032bb6fc8..165441044bc55 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -900,13 +900,23 @@ static const struct bpf_func_proto bpf_send_signal_thread_proto = {
 
 BPF_CALL_3(bpf_d_path, struct path *, path, char *, buf, u32, sz)
 {
+	struct path copy;
 	long len;
 	char *p;
 
 	if (!sz)
 		return 0;
 
-	p = d_path(path, buf, sz);
+	/*
+	 * The path pointer is verified as trusted and safe to use,
+	 * but let's double check it's valid anyway to workaround
+	 * potentially broken verifier.
+	 */
+	len = copy_from_kernel_nofault(&copy, path, sizeof(*path));
+	if (len < 0)
+		return len;
+
+	p = d_path(&copy, buf, sz);
 	if (IS_ERR(p)) {
 		len = PTR_ERR(p);
 	} else {
-- 
2.39.2



