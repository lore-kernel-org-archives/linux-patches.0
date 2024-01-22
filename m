Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19E73A1B4;
	Tue, 23 Jan 2024 00:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969828; cv=none; b=WPmnAMWjILUukwr17g0gwGVOPF+fjSIgtQp6Rm2K/SAeUOulGMD/Wo4QhjY1r1XoKL9EC0ZG7MZIq7WFqTaXLqBMbbh0nW2ifAAhsRG6zYmg8aR13NqSGZlIXjq822CsDMi367hKe8YaekQtnPIQ6drF6k+uFszfXhbsO1PBCX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969828; c=relaxed/simple;
	bh=n4+TfmOQ1uTQX3DM0WiBO5/J+H0t0VqCjpOPYMQREFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCk64Y2ecuEjkxtblpLXac1XFsEoTKjDp44v5ezFRmBsVpmKf4IpTTVYHqgga1EgYiQ8nu2ep1R83iDKbi4zHP/XlNR6f0ysmMwq01/AjQ8D4HKkGIr5IipJ7vn9Lz+geeU7kQhPO6l+3o1Lm3yznLYLv+s+1kezv/S2Hvyit7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6tP4eLA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6tP4eLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85862C43390;
	Tue, 23 Jan 2024 00:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969828;
	bh=n4+TfmOQ1uTQX3DM0WiBO5/J+H0t0VqCjpOPYMQREFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I6tP4eLAiOixAvDUvmpr7qEU7ZtiTMGH9zDjqn/uGN3pB9qNPHepsBc+qHecuGhkQ
	 VJ3AfoOEIfHd5Nv1aqXm+eJ3u8RzkNX5mSxSwvewhxEiIdpmVHS9xS99EvtG+4/A4M
	 9PdRgrmXQQEy9O9qunzjceBbnx/3L10/KFurkafQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <olsajiri@gmail.com>,
	Song Liu <song@kernel.org>,
	Dmitrii Dolgov <9erthalion6@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.7 450/641] bpf: Fix re-attachment branch in bpf_tracing_prog_attach
Date: Mon, 22 Jan 2024 15:55:54 -0800
Message-ID: <20240122235832.104274852@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <olsajiri@gmail.com>

commit 715d82ba636cb3629a6e18a33bb9dbe53f9936ee upstream.

The following case can cause a crash due to missing attach_btf:

1) load rawtp program
2) load fentry program with rawtp as target_fd
3) create tracing link for fentry program with target_fd = 0
4) repeat 3

In the end we have:

- prog->aux->dst_trampoline == NULL
- tgt_prog == NULL (because we did not provide target_fd to link_create)
- prog->aux->attach_btf == NULL (the program was loaded with attach_prog_fd=X)
- the program was loaded for tgt_prog but we have no way to find out which one

    BUG: kernel NULL pointer dereference, address: 0000000000000058
    Call Trace:
     <TASK>
     ? __die+0x20/0x70
     ? page_fault_oops+0x15b/0x430
     ? fixup_exception+0x22/0x330
     ? exc_page_fault+0x6f/0x170
     ? asm_exc_page_fault+0x22/0x30
     ? bpf_tracing_prog_attach+0x279/0x560
     ? btf_obj_id+0x5/0x10
     bpf_tracing_prog_attach+0x439/0x560
     __sys_bpf+0x1cf4/0x2de0
     __x64_sys_bpf+0x1c/0x30
     do_syscall_64+0x41/0xf0
     entry_SYSCALL_64_after_hwframe+0x6e/0x76

Return -EINVAL in this situation.

Fixes: f3a95075549e0 ("bpf: Allow trampoline re-attach for tracing and lsm programs")
Cc: stable@vger.kernel.org
Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Acked-by: Jiri Olsa <olsajiri@gmail.com>
Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Dmitrii Dolgov <9erthalion6@gmail.com>
Link: https://lore.kernel.org/r/20240103190559.14750-4-9erthalion6@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/syscall.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3205,6 +3205,10 @@ static int bpf_tracing_prog_attach(struc
 	 *
 	 * - if prog->aux->dst_trampoline and tgt_prog is NULL, the program
 	 *   was detached and is going for re-attachment.
+	 *
+	 * - if prog->aux->dst_trampoline is NULL and tgt_prog and prog->aux->attach_btf
+	 *   are NULL, then program was already attached and user did not provide
+	 *   tgt_prog_fd so we have no way to find out or create trampoline
 	 */
 	if (!prog->aux->dst_trampoline && !tgt_prog) {
 		/*
@@ -3218,6 +3222,11 @@ static int bpf_tracing_prog_attach(struc
 			err = -EINVAL;
 			goto out_unlock;
 		}
+		/* We can allow re-attach only if we have valid attach_btf. */
+		if (!prog->aux->attach_btf) {
+			err = -EINVAL;
+			goto out_unlock;
+		}
 		btf_id = prog->aux->attach_btf_id;
 		key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf, btf_id);
 	}


