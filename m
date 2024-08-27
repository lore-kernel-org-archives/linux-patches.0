Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3621C3F19;
	Tue, 27 Aug 2024 15:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771082; cv=none; b=aDTJpZNGdwGraVAvidCLbSr9pzXKFraYs6INBgY+tqX6JNsK4h5GDUivffgDWyJWYF70PupN0cryx5XXB8NsbWfkUE43vA0qobqjL4B9gENBPscyyX+eMbSKfvYoA+i07NEmLacUjzum84wm5JUVj5rUZtJGa1941MLjehk7w08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771082; c=relaxed/simple;
	bh=kUg39chzhFNKVYigZ9bwonUaRRBnw2niUCu7yVYE6IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nSjVALdUcLsN+gWU7+lGB8Eey7jynwTuBm/8v2FquAF4465o8Zjcn+mUaeq6P90lqFggi+2Y+2M/y1q20X++CRZPgPJ2w1dubSs2kr2BGvaRWl8i+sYjURVF5eiq+0iRqn60mOWStTwMJkn03qXIWrTA+h9fVXxTPCEB1hlyzzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Itm6sCl9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Itm6sCl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D50C6105B;
	Tue, 27 Aug 2024 15:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771082;
	bh=kUg39chzhFNKVYigZ9bwonUaRRBnw2niUCu7yVYE6IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Itm6sCl9yRn7nmC78700Cru2I86wL5II1Jwg71FNBRbWgLCdEvDr19TJPz8OQaSS1
	 nSZbahvk0CjplQZsJl9jXDUx+DPiONb+uoZg926GD+g6VmnC6zeCpfAnmLF671e1gX
	 87kp2iPMtOYTg1oV4osvW9yxppMHHfpM3+r74cNE=
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
Subject: [PATCH 6.10 081/273] bpf: Fix updating attached freplace prog in prog_array map
Date: Tue, 27 Aug 2024 16:36:45 +0200
Message-ID: <20240827143836.495137247@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index ff2a6cdb1fa3f..5db4a3f354804 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -846,8 +846,8 @@ static inline u32 type_flag(u32 type)
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



