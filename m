Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050111;
	b=q8gRQ+VZJlPmrpBYHYaj+ILY29ARtMPmIpDdCLmPDUs12lknmzJUM2j0ApiJtPTmg5U8
	 5l5usAh79Ptx2CUgVpIK4DNNqPVuJmKDqdCl6Td7U9GVTS3ta/bCM8gUFUZimNGfxU5/f
	 w3R+oP9+6oPhYSsCBT792Y8FbkkfqYwt5j+9+EBh8SSdSLbiUpcOZ/l7YRTxvbsqfOixl
	 D/n4gkfy3dpseoMjIrvCoXczqF7YVa0sTcz3qkqRH5OjqLNVDQP1TIO9chRqlepU19EMP
	 oROEONyyBs4MiHTWfupK6LsDIKYL3uH800+zw8mAmXzyIL3CoABRTxIJiLBc45GML1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gAsuyH0Rzbe6h0j2vT2u7T1MHTiA8eSc7Hbf35nzhX8=;
	b=zfIA++EcLY68T+eDNcLPD/Mu2+tG8prcEMPDrt8fsoKvfgxYtNxW8rYbKm1HhPtCN9Ba
	 fA3lDs4/HR9mcApa7QAtNxdl2yCjyJm4sGSdv+IwYETmJefc2HOhZY0PrSsesGZaNjXpc
	 IxrfWUxR7KAIKz/Yn+s0Mwsbb27fnyn5lJwc50PxITk5LekFKp+259D9Vn+TNfgyLTA9H
	 5xzMFXxMYNlFjG2Wi4G+Tja4nNyyh5zCTciz4QT+J1HNuysP65XciJenN4+WtyuHLqAMe
	 5BrkJlz+2wqfyNyXi0TMqGxvF7/0X2O1iHEBbP3idQiF8BMXxkQZm9DXrdnb+Vc6wwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ijhNFFMF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFD5606A33E;
	Thu, 19 Nov 2026 01:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ijhNFFMF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98ECC1F000C4;
	Thu, 19 Nov 2026 01:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050111;
	bh=gAsuyH0Rzbe6h0j2vT2u7T1MHTiA8eSc7Hbf35nzhX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ijhNFFMFKZj2zTl3PIOJCRsgdjmKP9cR2vVoXTEVMpEIrQmmoSZd+Q+YpltbAGLCd
	 0pNZe190sYig4MphJ4yEOP7VQdtq6+ouxdFj1w7H/KhrT1o7Zjm7aEsbQimChj6wT+
	 gBGkXq3cS03AhvufvMaTHtNzi/EOGPHOlt1ec13M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2592/2857] bpf: Bound the nesting that the BTF show code follows
Date: Wed, 18 Nov 2026 16:00:26 +0100
Message-ID: <20261118150334.861441408@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 13ac7c05bc45d3445b580da186548dd3487fae4e ]

btf_struct_show() and btf_array_show() recurse for every nested struct
and array.  MAX_RESOLVE_DEPTH bounds one resolve walk when BTF is loaded,
not the nesting: a member whose type is resolved already is not walked
again, so BTF that defines its types from the inside out can nest them as
deep as it has types.

Whoever may load BTF, with CAP_BPF or a BPF token, can give such a type
to the value of a map.  Reading the file of that map in bpffs then
overruns the kernel stack: with a few hundred levels the stack guard page
is hit and the kernel panics.

Stop at 32 levels.  That is MAX_RESOLVE_DEPTH, and __btf_show_indent()
has as many columns.  Nothing is shown for a member that lies deeper, and
the status becomes -E2BIG, which bpf_snprintf_btf() and
bpf_seq_printf_btf() return.  The types of an x86_64 defconfig kernel nest
14 deep.

Fixes: b00b8daec828 ("bpf: btf: Add pretty print capability for data with BTF type info")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-19-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 850ea69e05fd5..7695a851372a0 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -896,6 +896,8 @@ static const struct btf_type *btf_type_skip_qualifiers(const struct btf *btf,
 }
 
 #define BTF_SHOW_MAX_ITER	10
+/* nested structs and arrays shown; __btf_show_indent() has as many columns */
+#define BTF_SHOW_MAX_DEPTH	32
 
 #define BTF_KIND_BIT(kind)	(1ULL << kind)
 
@@ -1289,8 +1291,18 @@ static void *btf_show_start_aggr_type(struct btf_show *show,
 				      const struct btf_type *t,
 				      u32 type_id, void *data)
 {
-	void *safe_data = btf_show_start_type(show, t, type_id, data);
+	void *safe_data;
 
+	/*
+	 * Structs and arrays are shown by recursion.  BTF loading bounds the
+	 * depth of one resolve walk, not how deep resolved types may nest.
+	 */
+	if (show->state.depth >= BTF_SHOW_MAX_DEPTH) {
+		show->state.status = -E2BIG;
+		return NULL;
+	}
+
+	safe_data = btf_show_start_type(show, t, type_id, data);
 	if (!safe_data)
 		return safe_data;
 
-- 
2.53.0



