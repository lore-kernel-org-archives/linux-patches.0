Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026919;
	b=Ok1igdNRo25U79K3u86AXgqZQiW75TUv+5PwbwDkPyI4eHnhMTnaO5YcBRJE+hiVS7c6
	 q1Em9lr1U2ukujsNRz1n+WZY04SPIJku7od51YIlhSsMktmFMj4mbBQCHdW6BdQvEGasz
	 yUJuF65HRK/GNu3+L5zDVSDfvJbCxQK88ahGvqjCf1ojPe5VfDILDxSeCeepU1DxE/zkZ
	 U/QbcE2w4vqNB3OC17vYnEXXAEl2FQk9Uw3d2KseSUcX8HLomGgSjrboAT+6a3z+iJAgj
	 vn+KpdBw9HAC/Uq7faE+1lRx6OYqLKslaaF1jwetjwhekSnmkk9sfYJOChUlzl/gdlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HGxtszp4hLSynjz8UtGuhNL7Zol4oS5na16RTC4Alkc=;
	b=Yw9D3t/ktKTerhCIEx28uIzOSWwoDQwBaUXb6meIFf9jB2+CBVJFEuSXWgbtvPugSmOu
	 Ywcx3Uhf/ZfDLMxQ0tVu4vimdaJMqvRkRHZqN3hwJZ/75OGs7dRv0HZF0IHenvUgiTKb3
	 GtArtrrZAcjtNHh4ldaaXO8ae67NOJpPSL5re9fJOgcyt1/wraCo/Uq0yQzsXxIPFQ3xx
	 7UP8pHA4DeFPUsewQhuWO3KG8ECNRBzMaPkh9wwsGjY9DgV2aYQihw6sWvXvek8Fu/YWP
	 CaycJziH6G+JGueCCR362jhUlM1Kwy5BKOJdMbMRYh2lvqlvTswq1AMj3UKcdqtdQyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uuaf6C7j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2A6606A32A;
	Wed, 18 Nov 2026 18:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uuaf6C7j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB211F000C4;
	Wed, 18 Nov 2026 18:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026919;
	bh=HGxtszp4hLSynjz8UtGuhNL7Zol4oS5na16RTC4Alkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uuaf6C7jIFbnYS7owZTlMBQ1+oE5z4qQXvngUP3EZ/6cig8l+ReOqpyhau8lPwJJ2
	 yK4ZB70OcGFU+whnQYAJjT5dTDGEBfKTwM3mwIO4XMIosc3RpGDvqwm6TPkfFEYgF1
	 XZqax0NzJIBdPVhS9sGfc13wHAMfeGNlacTUVMtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngsung Ahn <ays511.kr@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1599/2151] RDMA/rxe: reject IB_WR_REG_MR from user QPs in rxe_reg_fast_mr()
Date: Wed, 18 Nov 2026 15:55:34 +0100
Message-ID: <20261118150220.129132973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youngsung Ahn <ays511.kr@gmail.com>

[ Upstream commit 33afe9909f213d8bb8e80f0b93382dde0f56e2c7 ]

IB_WR_REG_MR is documented as kernel-only ("can not be issued by
userspace"), but nothing enforces it.
rxe_wr_opcode_info[IB_WR_REG_MR] sets WR_LOCAL_OP_MASK for IB_QPT_RC,
a QP type userspace can create, so a user QP that writes
opcode = IB_WR_REG_MR into its mmap'd SQ ring reaches
rxe_do_local_ops() -> rxe_reg_fast_mr(). That function then trusts
the ring-supplied fields:

	struct rxe_mr *mr = to_rmr(wqe->wr.wr.reg.mr);
	...
	if (unlikely(mr->state != RXE_MR_STATE_FREE))    /* deref */
	...
	mr->access = access;                             /* write */

For a user QP wqe->wr.wr.reg.mr is a fully attacker-chosen pointer,
so this is an arbitrary-kernel-address dereference (arbitrary read
confirmed, oops). No existing check distinguishes a user QP on this
path.

Reject IB_WR_REG_MR for user QPs before dereferencing the supplied
pointer.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
Link: https://patch.msgid.link/20261001152426.3259522-1-ays511.kr@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_mr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index cd787e24c9ac6..39166bb9dbf42 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -780,6 +780,10 @@ int rxe_reg_fast_mr(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	u32 key = wqe->wr.wr.reg.key;
 	u32 access = wqe->wr.wr.reg.access;
 
+	/* IB_WR_REG_MR is a kernel-only op; a user QP must not reach here. */
+	if (qp->is_user)
+		return -EOPNOTSUPP;
+
 	/* user can only register MR in free state */
 	if (unlikely(mr->state != RXE_MR_STATE_FREE)) {
 		rxe_dbg_mr(mr, "mr->lkey = 0x%x not free\n", mr->lkey);
-- 
2.53.0



