Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042022;
	b=QaYi4BpGiEab5cwCmxp4+sK6oLn7Tsth5Kd3N+LwbfzYwF0Yn1YUOubk1QvNnxf0Qb5o
	 49UqqGBQcRT1M4FarHlStWYuDlWbh/oX9z50aBlxO+ESP5Dt26ZjpaFESyOTFLg692QOe
	 Q4MwgeDEc59txYzbHCUazfdtfE5u3IGK0OgOkkBS6ZH5D3M++UGJOpRtC+VKueFIED333
	 Y/KQ3vtXhgsYxqxsuH8LBhIDARkWuTN8GkuxUL8s7eQfDHVUIHMDIPOv8lZ9hr1tcDoRM
	 YE6A/C2fwjUJ/Z6ivJjSSUWuuwprgu2UmStqTYfE0ppQ8cBOR7hHcYh2mM0ydBlS9fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zy2TSPsVcuCANcrn4G+vFbFY1kymz8y2lhzrYVAzNmE=;
	b=UPoIb7/plMNSKa/OkqfjpsGm5sC/2vfU0NCiQ1T6PRTSwn2VnhEgED5dq9USs7258b55
	 hyir3RxuWm7YYH3pllqPJU76SnfGB8qRpPlUtICOMql1bCLmDd6XW826qoFAessHXisLz
	 5lGLZw4iQH5phYNqfmn35LUH+09yNvhtUyOpJ7a8hEa3Uq1XB/j0Ba9EnJXO7CR4LtzXG
	 PjN8565Ad21OX6JB9CtF3wfq5NBjYgdypU1/MZOl9k3YVJWW+6EjnC6xnnO/UYZ2WJ43r
	 cArfdIssrzaOnXB7MttbtUq2FprbRW+FkrvzARjJCvlm+TyJYOANteDnFhUJ0Ch7J2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aQl0JNIB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DF3606A31C;
	Wed, 18 Nov 2026 22:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aQl0JNIB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883C81F000C4;
	Wed, 18 Nov 2026 22:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042022;
	bh=Zy2TSPsVcuCANcrn4G+vFbFY1kymz8y2lhzrYVAzNmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aQl0JNIBmk+NhUcjBg9bZ6iWsaftHF6WeFcePDIoKPpXGTa0gFP2soOedsjXpZnet
	 kyZOFD64a+vvm6wtJF0tlwAeWHTu6upN4RknpHm/Pl93oaPUl8wyQTFOxrZwlegqZM
	 FhegdB5lrYsjGkBvWvLcdTLMp5Hi+FBsHodZI4+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3020/3318] bpf: Use memmove() to store bytes in an xdp_buff
Date: Wed, 18 Nov 2026 16:00:42 +0100
Message-ID: <20261118150450.808838525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c86e31c46582b..ce6014191ed05 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4164,7 +4164,8 @@ BPF_CALL_4(bpf_xdp_store_bytes, struct xdp_buff *, xdp, u32, offset,
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



