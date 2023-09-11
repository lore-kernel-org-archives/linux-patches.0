Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1E01170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961C6C433C9;
	Mon, 11 Sep 2023 13:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440467;
	bh=BntotUDoifBhuEbT54WunbQg3BeGxnyJxlFHSar6Tpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hmuAwpJkjhv6Cksb4rQz35Lm/5f2f3gwNCIERhwq99SaGxLr3Qz+SRodFcpy9e1RJ
	 0zDPgm8yYH1Faam3ymzf57lLP9tOVIWEe768A8XBUUYaL4wkYyI08WPEWEVWQMnomO
	 y6k36p7wKDk8kBBDIaVBdDSxNcmVohPIkFUdr0Ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 071/739] bpf: Fix an error around PTR_UNTRUSTED
Date: Mon, 11 Sep 2023 15:37:50 +0200
Message-ID: <20230911134653.103689336@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yafang Shao <laoar.shao@gmail.com>

[ Upstream commit 7ce4dc3e4a9d954c8a1fb483c7a527e9b060b860 ]

Per discussion with Alexei, the PTR_UNTRUSTED flag should not been
cleared when we start to walk a new struct, because the struct in
question may be a struct nested in a union. We should also check and set
this flag before we walk its each member, in case itself is a union.
We will clear this flag if the field is BTF_TYPE_SAFE_RCU_OR_NULL.

Fixes: 6fcd486b3a0a ("bpf: Refactor RCU enforcement in the verifier.")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Link: https://lore.kernel.org/r/20230713025642.27477-2-laoar.shao@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c      | 20 +++++++++-----------
 kernel/bpf/verifier.c |  5 +++++
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 817204d533723..7ed82a8d117b7 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6133,7 +6133,6 @@ static int btf_struct_walk(struct bpf_verifier_log *log, const struct btf *btf,
 	const char *tname, *mname, *tag_value;
 	u32 vlen, elem_id, mid;
 
-	*flag = 0;
 again:
 	tname = __btf_name_by_offset(btf, t->name_off);
 	if (!btf_type_is_struct(t)) {
@@ -6142,6 +6141,14 @@ static int btf_struct_walk(struct bpf_verifier_log *log, const struct btf *btf,
 	}
 
 	vlen = btf_type_vlen(t);
+	if (BTF_INFO_KIND(t->info) == BTF_KIND_UNION && vlen != 1 && !(*flag & PTR_UNTRUSTED))
+		/*
+		 * walking unions yields untrusted pointers
+		 * with exception of __bpf_md_ptr and other
+		 * unions with a single member
+		 */
+		*flag |= PTR_UNTRUSTED;
+
 	if (off + size > t->size) {
 		/* If the last element is a variable size array, we may
 		 * need to relax the rule.
@@ -6302,15 +6309,6 @@ static int btf_struct_walk(struct bpf_verifier_log *log, const struct btf *btf,
 		 * of this field or inside of this struct
 		 */
 		if (btf_type_is_struct(mtype)) {
-			if (BTF_INFO_KIND(mtype->info) == BTF_KIND_UNION &&
-			    btf_type_vlen(mtype) != 1)
-				/*
-				 * walking unions yields untrusted pointers
-				 * with exception of __bpf_md_ptr and other
-				 * unions with a single member
-				 */
-				*flag |= PTR_UNTRUSTED;
-
 			/* our field must be inside that union or struct */
 			t = mtype;
 
@@ -6476,7 +6474,7 @@ bool btf_struct_ids_match(struct bpf_verifier_log *log,
 			  bool strict)
 {
 	const struct btf_type *type;
-	enum bpf_type_flag flag;
+	enum bpf_type_flag flag = 0;
 	int err;
 
 	/* Are we already done? */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 02a021c524ab8..600f57ad0ab58 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6085,6 +6085,11 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 				   type_is_rcu_or_null(env, reg, field_name, btf_id)) {
 				/* __rcu tagged pointers can be NULL */
 				flag |= MEM_RCU | PTR_MAYBE_NULL;
+
+				/* We always trust them */
+				if (type_is_rcu_or_null(env, reg, field_name, btf_id) &&
+				    flag & PTR_UNTRUSTED)
+					flag &= ~PTR_UNTRUSTED;
 			} else if (flag & (MEM_PERCPU | MEM_USER)) {
 				/* keep as-is */
 			} else {
-- 
2.40.1



