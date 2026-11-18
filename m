Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027265;
	b=o1XZ1dmhfaUHvecVe2BQRUop5jBd38GVySMhJHyvPsN+VloZqtr9dDJ9H/yz/0Z/jr96
	 Wcp6z4DZBA28UBYPfMxALrP9dnWzZZ/dCZP1yO3gfz8EDvo2idyI47hrl2C0Zs5lPmbTX
	 7wi9eH8eNQ0GHrWLpBKg5Ns2RZ250AjLkMZWopEyYTtlqSAdWBQxwd60nF5UkLntoFFWs
	 Uv58dhmKK/SePndsech/CjwexsLTR47PLxH0rp3W0fCGLZT3i6xFYDN0COgQt6RUTWmPt
	 VmkesLG6elNd5TI3xlVRA2u3uu9ZjFqTJOcqa8yMWgFFdwFVmGP90l8KTKR9Dl0DHEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027265;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3CeCpLo1ln4VTSTaL8R7WN2eldUfLypnpydQ3lU1Sf0=;
	b=FQ2qOGkAWcPKeKJlO65fRRS3mEyukAKSECq1gO93+nLPcFTs1kTRxujYZCmealxuZpoR
	 C6KkWQ8Pb+r7R9yWl9N+BOUjOjOeLmlS3pFC0QXSPMMuf1XwZ182gFaBFAC34ynjzde9j
	 K/WN7WW+o7zW6QS/99iMAjqsyAGRy/vbFrMrp90/u4fUc9rGm0lqYTIHcIEUgipRpauYX
	 6m+hjIO1ZRZkKo4hTsuMcE9BFp3bZcJZwuI1B4Am2ZvNjXCi5LLRJyz9fHX1qTwJDMwpc
	 CgNgEnbFKWQsChaPlrOLXHedBA/5jheZD3HK3AUuLYd+iInNewYse+I975MZnkz6tfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ANiztHit;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4168606A740;
	Wed, 18 Nov 2026 18:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ANiztHit
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0641F000C4;
	Wed, 18 Nov 2026 18:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027265;
	bh=3CeCpLo1ln4VTSTaL8R7WN2eldUfLypnpydQ3lU1Sf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ANiztHitSTPzePmLrA3dAy0/JmV38caenCoodlgmlvFFFTL2hp3Et5OhSMHgBmlAu
	 MxiMeqzbXVgO0VwXA5Wz+nMcRGgU3fUk9bliOQmY1TMezOmRdrLIodlSOYsXMd+aLt
	 QM+5hKERA/0RwAlRksdEY/OdMtTT9/KakfWpI7LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1727/2151] bpf: Bound the nesting that the BTF show code follows
Date: Wed, 18 Nov 2026 15:57:42 +0100
Message-ID: <20261118150224.753574383@linuxfoundation.org>
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
index 706b3eefd9ef5..9b239f639861c 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -953,6 +953,8 @@ static const struct btf_type *btf_type_skip_qualifiers(const struct btf *btf,
 }
 
 #define BTF_SHOW_MAX_ITER	10
+/* nested structs and arrays shown; __btf_show_indent() has as many columns */
+#define BTF_SHOW_MAX_DEPTH	32
 
 #define BTF_KIND_BIT(kind)	(1ULL << kind)
 
@@ -1346,8 +1348,18 @@ static void *btf_show_start_aggr_type(struct btf_show *show,
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



