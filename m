Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020945;
	b=HURB2oduDb4kuRK15ofk2ITGKgnkCnTBcWj2k9Er881UjZicxiHj08SlzkfYwb2+MAU9
	 3apQL0es6g/m/LBDr4CY6iGF7l3Cg5uSz3KaKk1Jx4jNSurzmlGhxEtxbsOHNZTw1KAAb
	 rPiSTkva+sFLiJnPpGW0zuW5FBc4cZeqTqbV6tAI8H5xm3WvSOWQMlGhLwY0YI4fHyrVj
	 68PSdAfIRs9XC8es32fK9ogaqW3uJbBgyM9qEsvLVVVE26qwbZxe9zfCSuFvc58x8Fc7N
	 WgsTRoWRtBvqzvOGVeuRMw3ab5RKEWgdKP1aDlZrXFnxrpHvRY9Ik26e4kLjNu3blJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=knPiYeG6/6+9PsIuFZZBxBl5SsJ3V65+4VeAXRNmSfg=;
	b=oc6k01RK5/YYohB6EB4fHCAYn9dOGnCTx44xzxV0fhrs6j9nY4GVYSdJv1jXAQeQ4pr4
	 Lm0InxCZB3CQgxHRyaoLTKNGQ8ttc6y887oaB4pWK3myUZ3EedGRPnloeahq8koaH+U+q
	 jdTXGndaE/c/vZOfeDQ8pM0YHEXBpZu60DLCkx5xFrodMx9kZytscqlYyTRHb5VfeKd7g
	 pE08N+stRYwuKQ0b2a/8nhzdyPYE8SI+UxIcZQJkbXUm0oSCsZDVu6YCGVnsKxqmBY3hy
	 NXSzdeII/7NY6E4nA0sE42IvRtvM+ZK7w7b9EQnBZG88CIJnIjIyFa1wzvCyQBkdhsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MAbprgrQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0004606A325;
	Wed, 18 Nov 2026 16:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MAbprgrQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DD61F000C4;
	Wed, 18 Nov 2026 16:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020945;
	bh=knPiYeG6/6+9PsIuFZZBxBl5SsJ3V65+4VeAXRNmSfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MAbprgrQZu6QeLJOb29ug5nhPRnP3HYydrXcM+Gk708DQbHrWfScpPwLAXMtZxXIW
	 R6ossQrusM9zU1qwFbCbyLoiw2ga1Oubcpys4D35exejRe4F3BZ0RP3tTIMBGccq+E
	 plOzs7MFDf+Cn/xoEgE3MVr3ywfT4gKPQXP0e+hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2131/2651] bpf: Use memmove() to store bytes in an xdp_buff
Date: Wed, 18 Nov 2026 15:56:11 +0100
Message-ID: <20261118150402.605315584@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 3ffff068b03a7..9e577495eef19 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4337,7 +4337,8 @@ BPF_CALL_4(bpf_xdp_store_bytes, struct xdp_buff *, xdp, u32, offset,
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



