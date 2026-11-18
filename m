Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027848;
	b=cE9x65abx2eVvV+qBYbJEDujS4YYnY035zWDm056YhCaLxjLhjoAEcaUty/beDq3CJWr
	 NLB7pZO5kxsc+8TNl+2r26NpCI+p0ZUZwl4nithbUobZKxn9sVwdimeZZ17IexM2jae3Z
	 bzgiymBpRcQNx1H+pvSEBhIh1ou2vI/9mIj6v1j1KQlsVxWrXFU77wplQOGuzNbMZ2uTF
	 Sg6nDG1DagSvppy29chkLVM2SFuBaCdrHpGwc/aHVsvFHzCU2I//cFLAiQ0EFaaqf1hcM
	 eA3cyjY1vhVi6CNVpHS8l+5PMGp+ZscdFJttMt9VLn1OK7CwgOztH3sAlYUyN3ph+DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jLBrOWtdVXuCNEPfcv1mCBlctTzrO1+3E8chW+F6NiM=;
	b=PGfXKYUZ65p5XxfPzdL2nTQpTxh9BTloREQJXE2pk48b/t+UGyGoy2l1XNX45VyxbemH
	 Bfw4KZbeWx+hopvceh4ttX98KqCYOTNm4SO+CUX1kQ0+MvlTJnI90/ocTO7NxC1o4oIZp
	 lnWDAlKYsjncQ4jf3NTCHAx0CQlI/ejvChrhHOwJivr6zNCSls1yejU0kmONaYZHxyOh+
	 +V/cOEq/KAoj5nWza/UeG7SCaePs8cTFYv7wbMHHtFO6uvJFY0+q2PEDpqFg8oG3a8Kb2
	 pKWk1cpDTtmm36wC1RbhSMqrkVQ2hoJIsOO+Tat3HeKSK2CFXCim1BxJLorwJ1VGqSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x5T0PXfA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25F6606A325;
	Wed, 18 Nov 2026 18:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x5T0PXfA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0C11F000C9;
	Wed, 18 Nov 2026 18:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027848;
	bh=jLBrOWtdVXuCNEPfcv1mCBlctTzrO1+3E8chW+F6NiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x5T0PXfAmo/4j8IVAtUnjj5wpSbNG8TZmdbPVK0XfeKxouAt8Prcm7Bm9Gz3WC0IZ
	 Ul4MkHnKFDE+rLlLfyx5qqUfqGlEhAHadxACRmfhsI52JYtO1lo84fA3dHJBnKnnz7
	 ZGc78/tPv4/DuujzXzIZd5/ifs0odPlMMCMOJckk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ayushman Rout <ayushmanrout27@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1935/2151] bpf: Use memmove() to load bytes from an skb and an xdp_buff
Date: Wed, 18 Nov 2026 16:01:10 +0100
Message-ID: <20261118150232.260908704@linuxfoundation.org>
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

From: Ayushman Rout <ayushmanrout27@gmail.com>

[ Upstream commit b93cf2c8a0552b544e90e25802e4bf989987d29d ]

bpf_dynptr_read() on an skb or xdp dynptr ends in bpf_skb_load_bytes()
or bpf_xdp_load_bytes(). The destination can be a slice of the same
packet, so it can overlap the source, which memcpy() does not allow.
On x86 with FSRM memcpy() copies forward, so a destination above the
source gets the first bytes repeated:

  p = bpf_dynptr_slice_rdwr(&ptr, 8, NULL, 64);
  bpf_dynptr_read(p, 64, &ptr, 0, 0);

leaves bytes 8-71 of the packet as bytes 0-7 repeated, not bytes 0-63.
Reproduced with BPF_PROG_TEST_RUN on both an xdp and a tc program.

Use memmove(), as the store side does since commit 1db084f42884
("bpf: Use memmove() to store bytes in an skb") and commit ab08863c58b1
("bpf: Use memmove() to store bytes in an xdp_buff"). A read that spans
xdp frags still goes through bpf_xdp_copy_buf() and is not changed
here.

bpf_skb_load_bytes_relative() has the same pattern and is reachable
from tc and sk_filter programs, so use memmove() there as well.
Reproduced with BPF_PROG_TEST_RUN on a tc program: loading into a
slice at offset 8 gave wrong bytes before the change and correct
bytes after.

Fixes: 2012c867c800 ("bpf: verifier: Accept dynptr mem as mem in helpers")
Signed-off-by: Ayushman Rout <ayushmanrout27@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261022112312.31563-1-ayushmanrout27@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 17e5f9a23b8e9..8f92e2bf85517 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1791,7 +1791,7 @@ BPF_CALL_4(bpf_skb_load_bytes, const struct sk_buff *, skb, u32, offset,
 	if (unlikely(!ptr))
 		goto err_clear;
 	if (ptr != to)
-		memcpy(to, ptr, len);
+		memmove(to, ptr, len);
 
 	return 0;
 err_clear:
@@ -1873,7 +1873,7 @@ BPF_CALL_5(bpf_skb_load_bytes_relative, const struct sk_buff *, skb,
 	ptr = start + offset;
 
 	if (likely(ptr + len <= end)) {
-		memcpy(to, ptr, len);
+		memmove(to, ptr, len);
 		return 0;
 	}
 
@@ -4168,7 +4168,7 @@ BPF_CALL_4(bpf_xdp_load_bytes, struct xdp_buff *, xdp, u32, offset,
 	if (!ptr)
 		bpf_xdp_copy_buf(xdp, offset, buf, len, false);
 	else
-		memcpy(buf, ptr, len);
+		memmove(buf, ptr, len);
 
 	return 0;
 }
-- 
2.53.0



