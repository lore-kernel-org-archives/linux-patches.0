Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA6D1BA88C;
	Tue, 27 Aug 2024 14:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770782; cv=none; b=CxsdZMpP95gVGsLFy5xNteWAQYB/49IcbP5V7l+AD5vBsB33bU4kirgJh1xIr87sWxufPEfBqFRCk+830gOBvVvN83ijULTg7WVPL9l7+IdGUeR0B1qZV2qDYeSf2ybWw/MmPFlU9mdeivG3jC8RpLbQxR4FwgPDCMQjVm8YOOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770782; c=relaxed/simple;
	bh=z+6VEaaQBH86POJbyor8o9NmUZWVxpcxbj8tc46pdok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1fhzNlgfTDeVI3M+EdJXZWlVcwqLJ7Kx3GDfyx1o/wqoqpRjiiNLcPDC6YBFIImyfb9DqcWEHnVpB8aCNRoUVNozHb4LcyZ+xtyWFT1CR/qaMbQjAR/DmyCBT3M43e1yj3u7P3owh+yJrR2MoFRieSSupwBe/TP8ov8edbSOIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcEbJbeR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcEbJbeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0BBC4AF1A;
	Tue, 27 Aug 2024 14:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770781;
	bh=z+6VEaaQBH86POJbyor8o9NmUZWVxpcxbj8tc46pdok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vcEbJbeRu1WZBSnnm8gLgUVQRZIes7Buc5WScjLwqFBxS1z9iTzUZg8FBAJ20ciIH
	 frBXHcY7HTiiOoH7sXAXBUltocVi/J841C+n92Mo/QV5GoBAhfwEkHpNG2GdDvjD9W
	 UsGLNzOXrFPd4qZBB2aRCtqk2I/mq+1mnnu6oeGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Daniel Hodges <hodgesd@meta.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.6 333/341] bpf: Fix a kernel verifier crash in stacksafe()
Date: Tue, 27 Aug 2024 16:39:24 +0200
Message-ID: <20240827143856.067340828@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Yonghong Song <yonghong.song@linux.dev>

commit bed2eb964c70b780fb55925892a74f26cb590b25 upstream.

Daniel Hodges reported a kernel verifier crash when playing with sched-ext.
Further investigation shows that the crash is due to invalid memory access
in stacksafe(). More specifically, it is the following code:

    if (exact != NOT_EXACT &&
        old->stack[spi].slot_type[i % BPF_REG_SIZE] !=
        cur->stack[spi].slot_type[i % BPF_REG_SIZE])
            return false;

The 'i' iterates old->allocated_stack.
If cur->allocated_stack < old->allocated_stack the out-of-bound
access will happen.

To fix the issue add 'i >= cur->allocated_stack' check such that if
the condition is true, stacksafe() should fail. Otherwise,
cur->stack[spi].slot_type[i % BPF_REG_SIZE] memory access is legal.

Fixes: 2793a8b015f7 ("bpf: exact states comparison for iterator convergence checks")
Cc: Eduard Zingerman <eddyz87@gmail.com>
Reported-by: Daniel Hodges <hodgesd@meta.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20240812214847.213612-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[ shung-hsi.yu: "exact" variable is bool instead enum because commit
  4f81c16f50ba ("bpf: Recognize that two registers are safe when their
  ranges match") is not present. ]
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -16124,8 +16124,9 @@ static bool stacksafe(struct bpf_verifie
 		spi = i / BPF_REG_SIZE;
 
 		if (exact &&
-		    old->stack[spi].slot_type[i % BPF_REG_SIZE] !=
-		    cur->stack[spi].slot_type[i % BPF_REG_SIZE])
+		    (i >= cur->allocated_stack ||
+		     old->stack[spi].slot_type[i % BPF_REG_SIZE] !=
+		     cur->stack[spi].slot_type[i % BPF_REG_SIZE]))
 			return false;
 
 		if (!(old->stack[spi].spilled_ptr.live & REG_LIVE_READ) && !exact) {


