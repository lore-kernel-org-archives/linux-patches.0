Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09461CE701;
	Tue, 27 Aug 2024 15:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771851; cv=none; b=I2D+lWCb5cMGY1pVcWlKOD9S2YzSwe8QoGmQc7oQcNmu8K0SZW01UJB5pE0dXwKo2um+aPzPeLZuGkydOhDxjHfCs9A22Wkr3sCpCL6oCE/s/4q/OcbgORV5V533kxvebQ4gr3Xx7HX1ZtMU1z03dqDQCy56FLTPfP5QG/xBC3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771851; c=relaxed/simple;
	bh=jmRx+2VgslOmfNRh5XvIAkvPJY0V3pZQH9U8h4cfPDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jWyPoW6M4l9J/Oh6uPgdmthHSqWF5ci3YmaYv4QmjjUOx7SYwIXs3RXpG1gJCpNqPUQROr5mPA1br3gOvzx0EyGNQAm2cyCcJwW1Hws5W6d/uMeFedzm4/0G/xmZ9GoRhUt7cvYAz06G1/ASi01pO7xITXuUISraVIRE9H+FkIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=locIy7iW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="locIy7iW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4275AC61068;
	Tue, 27 Aug 2024 15:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771850;
	bh=jmRx+2VgslOmfNRh5XvIAkvPJY0V3pZQH9U8h4cfPDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=locIy7iWSq0Fqq0bgznl4foLOfUcfDclX93vVlbB59YI4YAGuBjVSHSfZ812sil9I
	 eFlisxopzIlsPfHn9xK3SSUJWk28kBwv3+nDGtFS97gBIMQEy4tiCtXFZuPYdxIBnA
	 wG5pp6hTgp3GZQxANjalacgubWxDEL/jDFTnV2cI=
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
Subject: [PATCH 6.1 032/321] bpf: Fix updating attached freplace prog in prog_array map
Date: Tue, 27 Aug 2024 16:35:40 +0200
Message-ID: <20240827143839.441232641@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6a524c5462a6f..131adc98080b8 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -645,8 +645,8 @@ static inline u32 type_flag(u32 type)
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



