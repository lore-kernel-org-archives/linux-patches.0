Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32771DAC9F;
	Tue,  3 Dec 2024 15:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240925; cv=none; b=CwqrBPEfEx1MnY4kM9+RJffq3N2Too90fg66sl5x2AxqgqCUWi47L0QfsleSGcadEZSFhi+uipfJZhzZXr1ZXi7/U8jhJFSyEo1ck4Gpd1KY8/OD8zBr8av2YDmQgIiU10Kbl+zDyQEMYSyICXl0o2hI1EYPfm5d56zf1BXOg4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240925; c=relaxed/simple;
	bh=qYleLKZ1uO9MIAsVC+ulF2/X3L/DronYZMe2Yf0FYro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opp34vKYpi2RJD8Y8Y9y6w6soGEleYDf8OrThyeAEsYVzwqny8hCfMHjpi6MDXRqmFkHXuGkeKz9uPcJHFfziv8LkdQ8m07ZIUgsTXr1OPDZYrmH/70I3/mfLJU8JuHysabmkaRul3nkMFBsVjFmZJJNvxwellG7vRVwyR00X1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxcYPJLS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxcYPJLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD947C4CED6;
	Tue,  3 Dec 2024 15:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240925;
	bh=qYleLKZ1uO9MIAsVC+ulF2/X3L/DronYZMe2Yf0FYro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jxcYPJLSBF61kZgI4uwSpkwuxw7hk8pM8U67ia2N9NCcwbJmvGAzbC2naw/n44sIb
	 chILQnrFXZwWnlhKV00ep7s9PO0e5K8NDT79Xq7Xk8Fu3+wuzq6obj49MihAgtMM5k
	 z521ft/agGuJ4IpKDVQApGcLoXRTlc/G085GC89w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 245/826] libbpf: never interpret subprogs in .text as entry programs
Date: Tue,  3 Dec 2024 15:39:32 +0100
Message-ID: <20241203144753.323238381@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit db089c9158c1d535a36dfc010e5db37fccea2561 ]

Libbpf pre-1.0 had a legacy logic of allowing singular non-annotated
(i.e., not having explicit SEC() annotation) function to be treated as
sole entry BPF program (unless there were other explicit entry
programs).

This behavior was dropped during libbpf 1.0 transition period (unless
LIBBPF_STRICT_SEC_NAME flag was unset in libbpf_mode). When 1.0 was
released and all the legacy behavior was removed, the bug slipped
through leaving this legacy behavior around.

Fix this for good, as it actually causes very confusing behavior if BPF
object file only has subprograms, but no entry programs.

Fixes: bd054102a8c7 ("libbpf: enforce strict libbpf 1.0 behaviors")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20241010211731.4121837-1-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index dde03484cc42c..1a54ea3a9208d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4389,7 +4389,7 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
 
 static bool prog_is_subprog(const struct bpf_object *obj, const struct bpf_program *prog)
 {
-	return prog->sec_idx == obj->efile.text_shndx && obj->nr_programs > 1;
+	return prog->sec_idx == obj->efile.text_shndx;
 }
 
 struct bpf_program *
-- 
2.43.0



