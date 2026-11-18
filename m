Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027316;
	b=CppwvakWj3bymuMFyRAP7v0dioa4IWeu9TGaS08M7mw2+ziQSeSvux/nQbrBNpwKe5P9
	 i4x8Iw7n/kuzxoHiCWK6JHmbOmhtFGlCU0SDo13lKQb4HJPqcCuAeiziwuVN1NYOWbgsV
	 MocJ5sCW68Vf49/GGB0jfdWk9nwYw3zftUyK/SzSMiEGS2ol6jBJ1Ov5teagUo/2hQOav
	 +Bq72r6PEcAIrxpb8ElFOanZDzAis2F8nFyz6MMNa4sWq6D0Ctpk3RGb6jPej/vmSRNei
	 HeNcbjrDWJyQEW8cy8byw9QNzBhY1SEbCTwKbNK69zSgcdb6KmRIWTCSPf+DK0SeNLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027316;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JdQCcYoAzWZkwI8lNMwbZ2OCRIuzmKXEBQzmJpVbOnM=;
	b=Exo/8TNoNSTXNZVrTu7XmXHMX5qmZn5WPXbZtbOzLwOcJukkHZhkQWw7YviqWlWPViOq
	 aivLPwcU8j381qpNo/aYwfopeOoTXcAUr/FZQDeHGbOgfxXJQBKIpCUnVIRQFup/IqbXF
	 JDOy1uMSX2UHr38GBScSGLIHx6qHwOZq5SbEVcWi9rD6g78n27yq7FHY9qwDf8w5kYWTc
	 vQH2VhzqnM+rJXpI8gDJ2Joj9CosPd9FiKHuyFH9rFP+1lwYnKx+0i0Jc6nPHtvMSu4qe
	 ELqkTE2K5EFi0fOL9jbOjA1etOeG0/TLjAANFEtFToWrtW7Z1wTmbn2oQ/EMsJIW2VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=URe39xSg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B759606A333;
	Wed, 18 Nov 2026 18:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=URe39xSg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50021F000C4;
	Wed, 18 Nov 2026 18:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027316;
	bh=JdQCcYoAzWZkwI8lNMwbZ2OCRIuzmKXEBQzmJpVbOnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=URe39xSgSK99stoioQT+R9BthfhgVbZrDtutz9SbDiL9OtTflHDvzE60bcOrhWM18
	 zcK1IM+ofN6HG1cjkDFhBzgGbDZ07HmGHA18EnEjWA6yX2erVLb0nn3SioKPbu2KJA
	 PPjJMK0GfT1VzcLlCZIN1YSI/baFykjwPD0tWs4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1747/2151] bpf: Use memmove() to store bytes in an xdp_buff
Date: Wed, 18 Nov 2026 15:58:02 +0100
Message-ID: <20261118150225.493786695@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit ab08863c58b1a96ff8378e373cb3d277cbe65b68 ]

bpf_dynptr_write() to the dynptr of an xdp_buff ends in
bpf_xdp_store_bytes(). The source can be a slice of the same xdp_buff which
overlaps the destination, and the helper itself takes such a slice as well.
memcpy() then reads bytes which it has overwritten already. On x86 with
FSRM

  p = bpf_dynptr_slice_rdwr(&ptr, 0, NULL, 64);
  bpf_dynptr_write(&ptr, 8, p, 64, 0);

repeats the first 8 bytes of the packet instead of moving 64.

A write that crosses from the linear part into a fragment is copied piece
by piece, where the first piece can overwrite what the second one has yet
to read. That is not dealt with here.

Fixes: 2012c867c800 ("bpf: verifier: Accept dynptr mem as mem in helpers")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017230950.802052-16-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index d79a51ba69824..17e5f9a23b8e9 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4200,7 +4200,8 @@ BPF_CALL_4(bpf_xdp_store_bytes, struct xdp_buff *, xdp, u32, offset,
 	if (!ptr)
 		bpf_xdp_copy_buf(xdp, offset, buf, len, true);
 	else
-		memcpy(ptr, buf, len);
+		/* through a dynptr the source may be an overlapping slice */
+		memmove(ptr, buf, len);
 
 	return 0;
 }
-- 
2.53.0



