Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54423241C8C;
	Mon, 13 Oct 2025 15:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368047; cv=none; b=J0qSzPNris6WQq8qIHFGPKbk/9Te4dTns+HmKfJSNYy2uVxNopqEkCryWBy1F22p7Vgrg/R51Y+eerdxzoimHJBj/yKqGqr4PMOEe7hPxJJkUh6B01+UrrsZPjXekwnxAJ3a9M70MRmzVubXPHh1VIzuIDxUtu8uovM3a9x9d2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368047; c=relaxed/simple;
	bh=mJ1FoUP+EEvcnOD5af9KBrYLof0R6Zk1/7XG+VsJiA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDEWRovhvjAReNI0+l/gTi7IWjeKoXwRAI0roNWx5CSXxz00ooYJ66LN0VAUJRzXTVfKcpO2/KDCg2sKjcum0Qugg/dMTm+YT8+FpYYv3ml2pu/DNTz5tpu9teNlMGrwQdl7giQdTAovYIUKsE36agXTsHZzQ/rFGbwHaRjs1Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2t5Hd1lz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2t5Hd1lz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22D0C4CEE7;
	Mon, 13 Oct 2025 15:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368047;
	bh=mJ1FoUP+EEvcnOD5af9KBrYLof0R6Zk1/7XG+VsJiA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2t5Hd1lz+ILkiL+unLsQJsxg3cFQYvbqsuIsSeimuxO7kgPMFhiNzA723+MkDpI8Q
	 Z/kVcebknwRpEUKz907v74N4b8vDnBdeo0H6hXUer/HeXSCngts+CDZUWSQkiRr3NQ
	 xb7wksJ5KLATrWshS3ffoTWG9k7tbauQJTg9ff5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/262] s390/bpf: Write back tail call counter for BPF_TRAMP_F_CALL_ORIG
Date: Mon, 13 Oct 2025 16:42:47 +0200
Message-ID: <20251013144327.038795680@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit bc3905a71f02511607d3ccf732360580209cac4c ]

The tailcall_bpf2bpf_hierarchy_fentry test hangs on s390. Its call
graph is as follows:

  entry()
    subprog_tail()
      trampoline()
        fentry()
        the rest of subprog_tail()  # via BPF_TRAMP_F_CALL_ORIG
        return to entry()

The problem is that the rest of subprog_tail() increments the tail call
counter, but the trampoline discards the incremented value. This
results in an astronomically large number of tail calls.

Fix by making the trampoline write the incremented tail call counter
back.

Fixes: 528eb2cb87bc ("s390/bpf: Implement arch_prepare_bpf_trampoline()")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20250813121016.163375-4-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index a88d53fe87743..c15be6955cc7f 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -2808,6 +2808,9 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im,
 		/* stg %r2,retval_off(%r15) */
 		EMIT6_DISP_LH(0xe3000000, 0x0024, REG_2, REG_0, REG_15,
 			      tjit->retval_off);
+		/* mvc tccnt_off(%r15),tail_call_cnt(4,%r15) */
+		_EMIT6(0xd203f000 | tjit->tccnt_off,
+		       0xf000 | offsetof(struct prog_frame, tail_call_cnt));
 
 		im->ip_after_call = jit->prg_buf + jit->prg;
 
-- 
2.51.0



