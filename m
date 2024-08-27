Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401231C68A6;
	Tue, 27 Aug 2024 14:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769973; cv=none; b=rB56xJSokGL7Nop+9l/B/UaZN12BcLE+FrbFIP5Kk8GlXYMMsHAmzcTQ7Z3mQgofG9BaosxbdAFbM1xVYxnOmfAeE9epzFR0YP7zSWBoQnha3fCNp7HINvrSPxcAWBmFT2c811Elb5BeR02GKQuJiP3nzjm/8ReFpIB7E5qyxb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769973; c=relaxed/simple;
	bh=A/fh8h9ETBZp7RMP5YYPXgFFxQwG28yOfab7U2pHRXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kOPzpPeQP3tEdna4araE/zRLQIwu9JEoLTZATLjCladrZrENlvhoNUk8rjKYYhmwEOsWu6pCIOND0agfdIz8Vm192mzN6/cav490hWlFXNPFmIFllSXpo2mVwKHKQWDhEEk3SFlU63XyVwlOFzbeO3ND+x31zG0nQt/a02TK+es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=esKrBdLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="esKrBdLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA77AC61063;
	Tue, 27 Aug 2024 14:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769973;
	bh=A/fh8h9ETBZp7RMP5YYPXgFFxQwG28yOfab7U2pHRXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=esKrBdLzXn5H95LhF8JCwG8nMxTDWVMjor8jEmXs4NYAbV6VOd14uDBczbXDTeaBU
	 Z6C7D8/luEvHpLld0YEbs9N84mog+rBPZ0CDuLb6NLst0J7Sgs+E6ts8gOG8dFiZs9
	 dQZdxnOsRKyDS2uCft+9reM5atuLGdD2f/CPTQf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/341] bpf: Fix updating attached freplace prog in prog_array map
Date: Tue, 27 Aug 2024 16:34:39 +0200
Message-ID: <20240827143845.243027593@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <leon.hwang@linux.dev>

[ Upstream commit fdad456cbcca739bae1849549c7a999857c56f88 ]

The commit f7866c358733 ("bpf: Fix null pointer dereference in resolve_prog_type() for BPF_PROG_TYPE_EXT")
fixed a NULL pointer dereference panic, but didn't fix the issue that
fails to update attached freplace prog to prog_array map.

Since commit 1c123c567fb1 ("bpf: Resolve fext program type when checking map compatibility"),
freplace prog and its target prog are able to tail call each other.

And the commit 3aac1ead5eb6 ("bpf: Move prog->aux->linked_prog and trampoline into bpf_link on attach")
sets prog->aux->dst_prog as NULL after attaching freplace prog to its
target prog.

After loading freplace the prog_array's owner type is BPF_PROG_TYPE_SCHED_CLS.
Then, after attaching freplace its prog->aux->dst_prog is NULL.
Then, while updating freplace in prog_array the bpf_prog_map_compatible()
incorrectly returns false because resolve_prog_type() returns
BPF_PROG_TYPE_EXT instead of BPF_PROG_TYPE_SCHED_CLS.
After this patch the resolve_prog_type() returns BPF_PROG_TYPE_SCHED_CLS
and update to prog_array can succeed.

Fixes: f7866c358733 ("bpf: Fix null pointer dereference in resolve_prog_type() for BPF_PROG_TYPE_EXT")
Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Cc: Martin KaFai Lau <martin.lau@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/r/20240728114612.48486-2-leon.hwang@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index b62535fd8de5f..92919d52f7e1b 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -760,8 +760,8 @@ static inline u32 type_flag(u32 type)
 /* only use after check_attach_btf_id() */
 static inline enum bpf_prog_type resolve_prog_type(const struct bpf_prog *prog)
 {
-	return (prog->type == BPF_PROG_TYPE_EXT && prog->aux->dst_prog) ?
-		prog->aux->dst_prog->type : prog->type;
+	return (prog->type == BPF_PROG_TYPE_EXT && prog->aux->saved_dst_prog_type) ?
+		prog->aux->saved_dst_prog_type : prog->type;
 }
 
 static inline bool bpf_prog_check_recur(const struct bpf_prog *prog)
-- 
2.43.0



