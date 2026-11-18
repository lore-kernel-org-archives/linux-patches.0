Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056529;
	b=xp0flkdsNL15EM7dN1aMTKeHJvU5xkVsjqknBct23i67QGBmGVFWThIHsF5XIsR5dgCY
	 QP+/EfTSBf6mVuhqtUo/NRbl/mgLnEJz0PxbMfvou+wDvdrpEHPC9Se73pOR/m5+ZK7aS
	 85KKUb47tXik1nQRVd0WaWwrdM/ZjsJ3T7TiXsdP+z2upZHonjKCzlhVabxUyHdHbPbDm
	 +1hlti+exzgB0VIwuX8er4JwNlycW+ip/krE2VzRQSrBx5CE9s2rj9r+5F53NnxMpNFXX
	 JacmqREwEgnfeRKGpYqCX8IrNL2tw7xH5LGAEs1c91j0bzjsk9JCViTuyKUzz0MERSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056529;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6vxK0VYotLSd3lA8+hXg9I16/oD8QYPe/pxCKVqV+V8=;
	b=5kRNgs/znMfV91LWn0SGg0AJ+ccDlRPtOH4UFcqCYfNNu96ik2M8soavtKb+OKoZp0q+
	 UGU4jd0cOkhX2konXGbNXZfd5sX8GNcX6WJ6mAE+0CKv+ohhuHDCcINuFLsfkgmnR/eqm
	 fakTA/Rl/MNU2+/45R7iPlWfANqMS4v2d1xNylgj7lSwMkKYVaSMztyO6U620A7r9dfOu
	 G7kcsHNt7x+ZzLQhjnohV1qrN26ZocNhrFC6OLHr+5bENglBHWPMwSJVR4iikxfpIfMp1
	 LZCuSNaJ6HGOPair1Ij+oV17MyVmGkPg0/JUL12g4O2QDs4O0uNECio6tLNFk1u3D4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rFGBMUga;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE85E60A2601;
	Thu, 19 Nov 2026 02:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rFGBMUga
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10DDA1F000C4;
	Thu, 19 Nov 2026 02:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056528;
	bh=6vxK0VYotLSd3lA8+hXg9I16/oD8QYPe/pxCKVqV+V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rFGBMUgaBh4uvpuaaGNfQ9dXWee0IxtLNNj6XT0va0Zgu+crJtGrqGqpcmqMpwXUu
	 JaruLRxGzr9JsGu2QHHV7Nm1E5pIDFMSWkbHLk+K89BJLRVq7nHxM3/WpfJ6rYBF5l
	 IyBTIWVWk2P0lTvhJr5CQzAS+Q0r4WfjKLuOKrxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaiyan Mei <M202472210@hust.edu.cn>,
	Yinhao Hu <dddddd@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2019/2214] bpf: Fix verifier WARN on narrow read of bpf_tcp_sock u64 fields
Date: Wed, 18 Nov 2026 16:01:35 +0100
Message-ID: <20261118150131.509123102@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit af873495cbcb066ab029f7f63b94410d4db47628 ]

A BPF program can read the middle of a u64 field in struct bpf_tcp_sock:

	tp = bpf_tcp_sock(listener);
	/* +0x54 is in the middle of the u64 bytes_received */
	unsigned hi = *(unsigned *)((char *)tp + 0x54);

bpf_tcp_sock_is_valid_access() allows this 4-byte read (the default case
only checks size == 4), but bpf_tcp_sock_convert_ctx_access() only knows
the field starts and has no idea how to handle such an offset. It emits
no instruction, cnt stays 0 and the fixup pass trips verifier_bug():

	verifier bug: error during ctx access conversion (0)

Just disallow the narrower access by matching the whole u64 range of the
two fields, so it is turned down at check time:

	invalid tcp_sock access off=84 size=4

Fixes: 655a51e536c0 ("bpf: Add struct bpf_tcp_sock and BPF_FUNC_tcp_sock")
Reported-by: Kaiyan Mei <M202472210@hust.edu.cn>
Reported-by: Yinhao Hu <dddddd@hust.edu.cn>
Reported-by: Dongliang Mu <dzm91@hust.edu.cn>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017143819.209510-1-jiayuan.chen@linux.dev
Closes: https://lore.kernel.org/bpf/7a8ff335.1024c.1a14395f3e5.Coremail.kaiyanm@hust.edu.cn/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index bd23a1ab7a2be..af963bbb5885d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6811,8 +6811,8 @@ bool bpf_tcp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 		return false;
 
 	switch (off) {
-	case offsetof(struct bpf_tcp_sock, bytes_received):
-	case offsetof(struct bpf_tcp_sock, bytes_acked):
+	case bpf_ctx_range(struct bpf_tcp_sock, bytes_received):
+	case bpf_ctx_range(struct bpf_tcp_sock, bytes_acked):
 		return size == sizeof(__u64);
 	default:
 		return size == sizeof(__u32);
-- 
2.53.0



