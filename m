Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061844;
	b=bNwugQXBLn6/LBVBT5kMjaQCjSxI97nClaGJwF+sqBynKTUKvxXyPChz6EJX2nH25mXU
	 LJx8pPAWx11uWj6N65ETV+kjTaYWnAykZMWGDJ6wFGRqUgLsLnXaPvV12PYMlxebtrm32
	 mU371omvaFP83yUHO7mObPFmgd2yCTBaPesBw1QFH347MO6PNW/iGZKWrTcRB/J2Aa39a
	 Iiyp3I4ayLMA6j7ZUt4/IJUcc8d9O+Jc/iKi230pvBPB/XDqLEW8aAFutCkDancX97Xz8
	 pZ2BkXk+B7NCVmCAbg90QafRdmRtzh6ryQzRBB46B4OStYS0I8vHRoVxhkSQzvWwY5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nsWKA6U5drfaHBx/4HA62ptYnN+G28LQd7xijckVYOo=;
	b=RONHuGdzRmD7dPTCoc1BnDPDpF4bBbVL3p2Yw0bA9uTz0wV2c8A0IdGs91HM3L+lL/Xz
	 3UgwMrAskbrFV9QqGqNWZxDcIzC5pZQVEoFOnp+HMxbvMuB8s7K+LuA7g+RZlKeP8TtUb
	 veHpIEc8iSYna+NtvGbYXfJaY8Y+efM5jw0A3ncXQAj7vcbLxh+Pk9G04HV3DXNbZs0P+
	 pjgC3CIhoTj+t34lCPzpUaj8RMq6mX/Br6UQRp2SOi7PwFJp42kZu64KdXcTQFd0SAkPR
	 er03Az6uVcbwhbtbWXyzPt9aaDcwRb9h3KGGSZvulvX0csDIfJOccp9ETF4HEOIQ9hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gv4GwDyq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2455F606A337;
	Thu, 19 Nov 2026 04:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gv4GwDyq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788231F000C6;
	Thu, 19 Nov 2026 04:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061844;
	bh=nsWKA6U5drfaHBx/4HA62ptYnN+G28LQd7xijckVYOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gv4GwDyqFNhfNh7OztJZ3oYK/0Fwn4QC9Gq95K0chGyodNUNrJda8deqE29/UtwXc
	 4H7an+VWTy9UIFAWCCcZyT2inOC4s+90TEPc+BwHrMlcx7yU2hFuzC4tcDdaVJj8ca
	 Jindfn6VP+kVngbSJUmRBhjMPZ/AsUZHohTROlN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1699/1848] bpf: Bound the nesting that the BTF show code follows
Date: Wed, 18 Nov 2026 16:02:17 +0100
Message-ID: <20261118150030.878376316@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bcdd5a64c43b2..5d9d6678d1a0d 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -751,6 +751,8 @@ static const struct btf_type *btf_type_skip_qualifiers(const struct btf *btf,
 }
 
 #define BTF_SHOW_MAX_ITER	10
+/* nested structs and arrays shown; __btf_show_indent() has as many columns */
+#define BTF_SHOW_MAX_DEPTH	32
 
 #define BTF_KIND_BIT(kind)	(1ULL << kind)
 
@@ -1142,8 +1144,18 @@ static void *btf_show_start_aggr_type(struct btf_show *show,
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



