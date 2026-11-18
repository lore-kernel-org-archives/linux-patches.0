Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020870;
	b=mtUkQdJvxlJXKVbt6ifAInmrD/2MyP0pIpQ6ECvxTihy2c5NMji9Ij28SvDzxTff0mEe
	 3xkNsO1SeaYrMQOdQm4e+ris8lKqvkYU7r+r8fd4cUDF7VOfMQbUdpcAYq12A/PTPVOWP
	 5jBs2c8q6zZM2RbmTbGIegltCJhC4fu86M70z5FUoNdWolSFeVYH9AxoQgsCQX7hTzePC
	 3V82FqlmjOVMcUqMVeV3Nhc4Rk7ew92dvnok7jjRhUORk/Tu1qi3ZD3ocgKtYt4y9+pVX
	 INKJmqkQieVQ98NgU7qlp2HDE6OVRMIJRpu9OJh3HmvqZjn0nJ1P6en7kvk7u5ixXNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R//2/xZZY8hddp3r1UaIitP2uzuivyfZyhYzrfD88fw=;
	b=HxVEMDIq+RPsqCCeFEcWbdaA9TNgNNvHqWGJEDRKWQvedWdhWy8RZ43mikntQimLeD17
	 bEpFt8NetS6f9PZarmq3YvGr3jq276zBZGAqiqQc2QSmULrOsiXi4JQlHIOjYA9fbRSNf
	 MeALdfNaHQg55Ar32BK2jWZxzYzzMuD/pLX6SIo3n6m08AXwYmbahjojWnkofjf8+3+rK
	 WoOY4UCL2FLm5e3GBN6JP+kMLDIGsmVEvqCQaUcoPcdxg7japHS4GGokQMuQrN+CBah8S
	 QyGqY7qc4wDYmf1RGCfIWlFoRolOOS1TS/CoZPCzqVNnpw19OlzM0jy0zdmcuaWX2Uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XZ9Of7+E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5EF606A320;
	Wed, 18 Nov 2026 16:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XZ9Of7+E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876E81F000C4;
	Wed, 18 Nov 2026 16:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020870;
	bh=R//2/xZZY8hddp3r1UaIitP2uzuivyfZyhYzrfD88fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XZ9Of7+EmrRe2Pp+e6taQP6iG/jc94Q4sP1dJipaVuyU3ftPhSDvaXtcQdpTfqZwc
	 4P0WddRe10wJtQDp2kdK9pBOtsQ2H2AXL4e1AGUEAe+FzRwy63lUp8rCBS9U8WCuri
	 ID6J7s1ATvKscvjNG+QJzC0wXG8kmF3OZzAW8l3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2106/2651] bpf: Bound the nesting that the BTF show code follows
Date: Wed, 18 Nov 2026 15:55:46 +0100
Message-ID: <20261118150401.786168426@linuxfoundation.org>
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
index d870bc5e50bc8..b1adb52e2f310 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -1065,6 +1065,8 @@ static const struct btf_type *btf_type_skip_qualifiers(const struct btf *btf,
 }
 
 #define BTF_SHOW_MAX_ITER	10
+/* nested structs and arrays shown; __btf_show_indent() has as many columns */
+#define BTF_SHOW_MAX_DEPTH	32
 
 #define BTF_KIND_BIT(kind)	(1ULL << kind)
 
@@ -1458,8 +1460,18 @@ static void *btf_show_start_aggr_type(struct btf_show *show,
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



