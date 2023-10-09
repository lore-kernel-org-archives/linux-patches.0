Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5438118B11
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THxACQKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C358FC433C7;
	Mon,  9 Oct 2023 13:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857031;
	bh=VFGEDoyKozhMBftvcqHkiEnkSKyVWutpJza7nH/fsQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THxACQKfgfqjR0W2NqebhsDx8Nr9txxeT6lh1ELW+bcMmbQVNx9cN1tk2DT8dpQ43
	 qOeeGXr2OkJYu1sfgfz2KGAWxVla2Z5yR5ARZLUanfCQJZLuaOXKidCWDEiU91PdLt
	 wPY7KtFd8ObSgQEcAAEYFsBooSNaYZBOsWiQYQvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 073/163] s390/bpf: Let arch_prepare_bpf_trampoline return program size
Date: Mon,  9 Oct 2023 15:00:37 +0200
Message-ID: <20231009130126.068022883@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Song Liu <song@kernel.org>

[ Upstream commit cf094baa3e0f19f1f80ceaf205c80402b024386c ]

arch_prepare_bpf_trampoline() for s390 currently returns 0 on success. This
is not a problem for regular trampoline. However, struct_ops relies on the
return value to advance "image" pointer:

bpf_struct_ops_map_update_elem() {
    ...
    for_each_member(i, t, member) {
        ...
        err = bpf_struct_ops_prepare_trampoline();
        ...
        image += err;
    }
}

When arch_prepare_bpf_trampoline returns 0 on success, all members of the
struct_ops will point to the same trampoline (the last one).

Fix this by returning the program size in arch_prepare_bpf_trampoline (on
success). This is the same behavior as other architectures.

Signed-off-by: Song Liu <song@kernel.org>
Fixes: 528eb2cb87bc ("s390/bpf: Implement arch_prepare_bpf_trampoline()")
Reviewed-by: Ilya Leoshkevich <iii@linux.ibm.com>
Link: https://lore.kernel.org/r/20230919060258.3237176-2-song@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index de2fb12120d2e..2861e3360affc 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -2513,7 +2513,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image,
 			return -E2BIG;
 	}
 
-	return ret;
+	return tjit.common.prg;
 }
 
 bool bpf_jit_supports_subprog_tailcalls(void)
-- 
2.40.1



