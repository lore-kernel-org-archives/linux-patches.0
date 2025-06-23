Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC302222581;
	Mon, 23 Jun 2025 21:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713969; cv=none; b=Dyk8VcJhIJoF9Ya3lcNFYUUWRp3jlqpA/PIuLMV5K95cQkax5aLhOkTOUfwB1N+i5+eYan79Lm5qBiHLoEHlqQtSxEufypr5/u06csbrUJjI+iq3KvJA8EGh+Y4u9CNkPZozXtCXNPtM76QZH87+CFA3bR120RwjKQq3KTXXTn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713969; c=relaxed/simple;
	bh=/feKkd7WSEO5RMo2HxXnIYCN1lBNuSaIvVI3UHKC058=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTXQWkGGidsd8BK1Oe5kpZ22jrAp9XbLCfQyRgq1S3I19NwhAHMZGWUHbNkXH7UAwfJfyfesKmF6/gOU6Dgsm4AFDbCFgWWbwv+/tkL+56i4USZZ0uRDubezJzKJh0PE3HUn5o08h3Fz3q3NIx/JHYBPqEAv38ImSp7ezogOJwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bHkiJsSF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHkiJsSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A97C4CEEA;
	Mon, 23 Jun 2025 21:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713969;
	bh=/feKkd7WSEO5RMo2HxXnIYCN1lBNuSaIvVI3UHKC058=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHkiJsSFzZVqBt2Mgc+7YBIyY1cSelTG4lHYMAU6dmarnp0h4AFeB7wmTdEOeZ+jN
	 5eVRTXey9o0wnGJAa0vybQy/SFqpSamCNlbr01OMemycfqKdvpEKR3PsGBhvDVD/bM
	 Mc7h/4lqir0HyesEzubd0m/gc564LQXJ3GWVuskU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 356/592] bpf: Pass the same orig_call value to trampoline functions
Date: Mon, 23 Jun 2025 15:05:14 +0200
Message-ID: <20250623130708.910794493@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index db13ee70d94d5..96113633e391a 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -601,7 +601,7 @@ int bpf_struct_ops_prepare_trampoline(struct bpf_tramp_links *tlinks,
 	if (model->ret_size > 0)
 		flags |= BPF_TRAMP_F_RET_FENTRY_RET;
 
-	size = arch_bpf_trampoline_size(model, flags, tlinks, NULL);
+	size = arch_bpf_trampoline_size(model, flags, tlinks, stub_func);
 	if (size <= 0)
 		return size ? : -EFAULT;
 
-- 
2.39.5



