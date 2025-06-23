Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9164409;
	Mon, 23 Jun 2025 22:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716113; cv=none; b=mqYllC56FzNhw0xHqQRCFlpe/DEnzkTU6MfWyqX9HOl9PA7eXN1fC7KHIPdtHQ7w2bW5+tDBf9pa3mvUzZh9VGktNk0tUpttYDwzUc28g7dhpxJxl6nUaEub9APtYXGFlSdbIAGvwayLnXIwR57lSEWWIZN8mpiOy/qmlr5fZtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716113; c=relaxed/simple;
	bh=q4SBgfVd4OkeyEdz/X6ngqGif8jI7iZePECB329eMTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYRcynYgKGqwgEuMKQs9TM3idJwB94TUIzhNou47Hm4RJUxR10Uu5fnxvZaa7UV4yJY/7dQLDD8GLFoeRDEyH2p0k7eBh+arOvt2RTza7zXJDgREVxKVvrFrdgOAjmqGT2ENRyCI4KsGCWhQS+XgciE4FyvX3y/VzSGLLgO2EV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JvbZbJFk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JvbZbJFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870AFC4CEEA;
	Mon, 23 Jun 2025 22:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716112;
	bh=q4SBgfVd4OkeyEdz/X6ngqGif8jI7iZePECB329eMTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JvbZbJFktFC2LGlS1wySqSFF4EV2X13rBMgAs8AwDerGn6C4iOSXG4c3BlmJGk3XP
	 2s0tWGheJI4i1uFmGDbd7g4F5W3IEuWqNz0YkgtVKXDCJfObqow8DCNMRwaORZFORo
	 vIm7HRpARWl4ehXES4kfLQ4aRq0CAkYCTWHwAsck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 228/414] bpf: Pass the same orig_call value to trampoline functions
Date: Mon, 23 Jun 2025 15:06:05 +0200
Message-ID: <20250623130647.735825447@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 94bde253d3ae5d8a01cb958663b12daef1d06574 ]

There is currently some confusion in the s390x JIT regarding whether
orig_call can be NULL and what that means. Originally the NULL value
was used to distinguish the struct_ops case, but this was superseded by
BPF_TRAMP_F_INDIRECT (see commit 0c970ed2f87c ("s390/bpf: Fix indirect
trampoline generation").

The remaining reason to have this check is that NULL can actually be
passed to the arch_bpf_trampoline_size() call - but not to the
respective arch_prepare_bpf_trampoline()! call - by
bpf_struct_ops_prepare_trampoline().

Remove this asymmetry by passing stub_func to both functions, so that
JITs may rely on orig_call never being NULL.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/r/20250512221911.61314-2-iii@linux.ibm.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_struct_ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 477947456371a..2285b27ce68c7 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -577,7 +577,7 @@ int bpf_struct_ops_prepare_trampoline(struct bpf_tramp_links *tlinks,
 	if (model->ret_size > 0)
 		flags |= BPF_TRAMP_F_RET_FENTRY_RET;
 
-	size = arch_bpf_trampoline_size(model, flags, tlinks, NULL);
+	size = arch_bpf_trampoline_size(model, flags, tlinks, stub_func);
 	if (size <= 0)
 		return size ? : -EFAULT;
 
-- 
2.39.5



