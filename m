Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98825266B7
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZ201ui5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC462C433C8;
	Mon, 16 Oct 2023 14:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467735;
	bh=ZHpznt1a/KcI3e3DPqtxInV2iLubDsCnbb75+6wOa5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZ201ui5yi+RPxWKKlmtq5touxp5YZr+BJbePt9ODl2y455Wl+I8H3nbvbhNknxRs
	 ncAFE0WivPYAtxqnrG0rii543vnycOiPXgnV4vxCKodJqk7wzcAJUxII3vWhybqlZ9
	 QkWtuOKhVGqbqY2B4nbYtfD0d//Dr8/fUNwoOxTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 079/191] s390/bpf: Fix clobbering the callers backchain in the trampoline
Date: Mon, 16 Oct 2023 10:41:04 +0200
Message-ID: <20231016084017.247997292@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit ce10fc0604bc6a0d626ed8e5d69088057edc71ab ]

One of the first things that s390x kernel functions do is storing the
the caller's frame address (backchain) on stack. This makes unwinding
possible. The backchain is always stored at frame offset 152, which is
inside the 160-byte stack area, that the functions allocate for their
callees. The callees must preserve the backchain; the remaining 152
bytes they may use as they please.

Currently the trampoline uses all 160 bytes, clobbering the backchain.
This causes kernel panics when using __builtin_return_address() in
functions called by the trampoline.

Fix by reducing the usage of the caller-reserved stack area by 8 bytes
in the trampoline.

Fixes: 528eb2cb87bc ("s390/bpf: Implement arch_prepare_bpf_trampoline()")
Reported-by: Song Liu <song@kernel.org>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20231010203512.385819-2-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 2861e3360affc..9a9733e4bc801 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -2260,8 +2260,12 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im,
 	tjit->run_ctx_off = alloc_stack(tjit,
 					sizeof(struct bpf_tramp_run_ctx));
 	tjit->tccnt_off = alloc_stack(tjit, sizeof(u64));
-	/* The caller has already reserved STACK_FRAME_OVERHEAD bytes. */
-	tjit->stack_size -= STACK_FRAME_OVERHEAD;
+	/*
+	 * In accordance with the s390x ABI, the caller has allocated
+	 * STACK_FRAME_OVERHEAD bytes for us. 8 of them contain the caller's
+	 * backchain, and the rest we can use.
+	 */
+	tjit->stack_size -= STACK_FRAME_OVERHEAD - sizeof(u64);
 	tjit->orig_stack_args_off = tjit->stack_size + STACK_FRAME_OVERHEAD;
 
 	/* aghi %r15,-stack_size */
-- 
2.40.1



