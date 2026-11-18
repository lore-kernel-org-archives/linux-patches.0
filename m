Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041966;
	b=IndVtyM/3kiPd95jCsYlIQ1VqcCdw+NMrhU/NTBuGkzI95UjI/naMNLKdGeEkan2cwAm
	 Ex40ZMcKvA9nDThT8XaNMfdUZrvWt2JnZtqhTIpUOHxm6hIlNOA475a6JCIaY4SwvwCFL
	 8h7bZNskMdMiDLMwSFh+0EQHl9p92BFTKuU21FdGwx8eOh8kumwkOhJJeSgQr1VRikb25
	 AZRotyfZlfFETWvgs6S3lxQeEaanhjyTLuSzBXLeyUfs2+ItNj1GnN38D9rUBBRAQW4iV
	 0PbV36knt3idf04K71y6X546q+/zSYiaPoKZslb3iLPTVKpkl3OqKbvCp5ZShhEY2rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041966;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8VQ1qEtxLpAD6+oF4I0sgIUylIDbJ6D9MAEE9f5x07s=;
	b=UE0w1AuPLHNEwq48MPOM2WUsPPmCa5cfiZeF05OZFZ8NV6PrXa1rfhnUHA1MAITpWmqK
	 qzTNIISqSdUJ2gm3trDt7HRpJOwVk0/xJGtafXowz4ZbxUIjh2xvccONqaKFcHUN4YSXr
	 hOdftW01fQnD6KAoTVtH33i3Y9UxP6M4q2EFWa2ntSee2obP9tQK6l5kxL0hGUntciN9Y
	 IseIEcEVUtq7SHi7RIU4gxhfhKbjFUIfsviD6+J/qhzg6Z2Wq0EvmKXfMXXco/fgJqLZf
	 Nti95ygS/gOT47fkCGHvfxineoocluacY1JHlFIjP4Ze7IkHdgSkhgnyF6L0PBHgCdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mqx2s8xK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C37F606A320;
	Wed, 18 Nov 2026 22:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mqx2s8xK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEF51F000C6;
	Wed, 18 Nov 2026 22:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041966;
	bh=8VQ1qEtxLpAD6+oF4I0sgIUylIDbJ6D9MAEE9f5x07s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mqx2s8xK0QE1BIitHWxLtg2Q+4/u2zwtxCw5KWBBVDpbB9XfZ157Izw7BBBN6/OMB
	 3x2pxZB+co0Pm6Gs3mu67hYDlt52HHRR1Ov0t0qNAi5MAlO/zyfYN8dURrxSANphef
	 Ao//RXmr8cA/qDdVqbxQLKxLxEsTDRAPWCAqiEFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3002/3318] bpf: Bound the nesting that the BTF show code follows
Date: Wed, 18 Nov 2026 16:00:24 +0100
Message-ID: <20261118150450.319060742@linuxfoundation.org>
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
index 5cef2bb2ddfc1..27d99d40af859 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -913,6 +913,8 @@ static const struct btf_type *btf_type_skip_qualifiers(const struct btf *btf,
 }
 
 #define BTF_SHOW_MAX_ITER	10
+/* nested structs and arrays shown; __btf_show_indent() has as many columns */
+#define BTF_SHOW_MAX_DEPTH	32
 
 #define BTF_KIND_BIT(kind)	(1ULL << kind)
 
@@ -1306,8 +1308,18 @@ static void *btf_show_start_aggr_type(struct btf_show *show,
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



