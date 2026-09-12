Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A696E392836;
	Sat, 12 Sep 2026 07:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196681; cv=none; b=NoO3LMGnDEgO8DuWm0l8lPjnHdBwhYmch4ioGb8QKt1itJmq8hgc1Eq3kzezO1eNjB+QEeUrxCJw97NfRZWvn+kWxajzjaVdCQKRP+aaOKIAPnXWfq829gs0A96EIkVl54f2wuXfmkNqKKzV/kzX3lii3nyzSsU0LJrWnk7aFtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196681; c=relaxed/simple;
	bh=L1Xr1fGfo81pGFef+LK6Qj0P91z8nY+xAUAt+gbtgkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dixx6vWfhUzaNnkqqRG8fYKyIe8/FgO6PFakFP7pn3O1bgt8NP7zFX0e8JsshQPIGuUmsC2yBF5nYJe967aG78t4wYtPPe1UeVYQep2wY3Hqg7gaJ6bnbCE9sWARpPEKXVD5Q5fhCrikWKkT41Lv8aWhKd12qCTQeevoDUcg58Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pRP10bXc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pRP10bXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF831F00893;
	Sat, 12 Sep 2026 07:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196674;
	bh=pwkeXxBFHxWgNj/m3dhoYLtpQN6vJf8j7MbaWzS51IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pRP10bXcR3A/07HA9wdHB3OKsSe3nkuguluTGZAmFR/4ffJ9b3YNwxReYMH/ODXcm
	 M1S1+fq0J59O4UlsD0XzueZNZdixIfWF+rt8s+HMtBof4cv1F40Z7BMuHD951zMGSf
	 uyZ/j7dvJ5b3hY8mDTj7XXz27VFlIB8+It8vFBSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0015/1815] tracing/probes: Fix BTF kflag check for anonymous struct member access
Date: Sat, 12 Sep 2026 08:29:25 +0200
Message-ID: <20260912065649.366787953@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>

[ Upstream commit 47e93045a2db80d24f5fef65adecc6b2b32efa23 ]

btf_find_struct_member() traverses into nested anonymous structures and
unions to find a struct member. However, get_bitoffset_of_field() in
trace_probe.c checked btf_type_kflag(type) using the outer parent type
instead of the actual anonymous structure/union that directly contains
the found member.

If the parent structure and anonymous structure have mismatched kflags
(e.g., the parent has kflag=0 while the anonymous structure has kflag=1
because it contains bitfields), the bitfield size encoded in the upper
8 bits of member->offset is erroneously treated as part of the byte/bit
offset, corrupting the resolved offset and failing to set last_bitsize.
Similarly, btf_find_struct_member() pushed anonymous member offsets
onto anon_stack without masking BTF_MEMBER_BIT_OFFSET() when kflag is set.

To fix this problem, update btf_find_struct_member() to return actual
containing structure/union type via member_type, use appropriate
__btf_member_bit_offset() to get bit offset, and use member_type for
btf_type_kflag() in get_bitoffset_of_field().

Link: https://lore.kernel.org/all/178827250904.123716.17452648791331881284.stgit@devnote2/

Fixes: c440adfbe302 ("tracing/probes: Support BTF based data structure field access")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260822095110.0772E1F000E9@smtp.kernel.org/
Assisted-by: Antigravity:gemini-3.7-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
[ applied changes to parse_btf_field() because get_bitoffset_of_field() is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_btf.c   |   19 +++++++++++--------
 kernel/trace/trace_btf.h   |    3 ++-
 kernel/trace/trace_probe.c |    5 +++--
 3 files changed, 16 insertions(+), 11 deletions(-)

--- a/kernel/trace/trace_btf.c
+++ b/kernel/trace/trace_btf.c
@@ -61,16 +61,17 @@ struct btf_anon_stack {
 
 /*
  * Find a member of data structure/union by name and return it.
- * Return NULL if not found, or -EINVAL if parameter is invalid.
- * If the member is an member of anonymous union/structure, the offset
- * of that anonymous union/structure is stored into @anon_offset. Caller
- * can calculate the correct offset from the root data structure by
- * adding anon_offset to the member's offset.
+ * Return NULL if not found, or ERR_PTR(-EINVAL) if parameter is invalid.
+ * If the member is a member of an anonymous union/structure, the bit offset
+ * of that anonymous union/structure is stored into @anon_offset.
+ * If @member_type is non-NULL, the actual containing structure/union type
+ * of the found member is stored into @member_type.
  */
 const struct btf_member *btf_find_struct_member(struct btf *btf,
 						const struct btf_type *type,
 						const char *member_name,
-						u32 *anon_offset)
+						u32 *anon_offset,
+						const struct btf_type **member_type)
 {
 	struct btf_anon_stack *anon_stack;
 	const struct btf_member *member;
@@ -94,14 +95,16 @@ retry:
 			if (mtype && btf_type_is_struct(mtype) &&
 			    top < BTF_ANON_STACK_MAX) {
 				anon_stack[top].tid = tid;
-				anon_stack[top++].offset =
-					cur_offset + member->offset;
+				anon_stack[top++].offset = cur_offset +
+					__btf_member_bit_offset(type, member);
 			}
 		} else {
 			name = btf_name_by_offset(btf, member->name_off);
 			if (name && !strcmp(member_name, name)) {
 				if (anon_offset)
 					*anon_offset = cur_offset;
+				if (member_type)
+					*member_type = type;
 				goto out;
 			}
 		}
--- a/kernel/trace/trace_btf.h
+++ b/kernel/trace/trace_btf.h
@@ -8,4 +8,5 @@ const struct btf_param *btf_get_func_par
 const struct btf_member *btf_find_struct_member(struct btf *btf,
 						const struct btf_type *type,
 						const char *member_name,
-						u32 *anon_offset);
+						u32 *anon_offset,
+						const struct btf_type **member_type);
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -578,6 +578,7 @@ static int parse_btf_field(char *fieldna
 {
 	struct fetch_insn *code = *pcode;
 	const struct btf_member *field;
+	const struct btf_type *mtype;
 	u32 bitoffs, anon_offs;
 	bool is_struct = ctx->struct_btf != NULL;
 	struct btf *btf = ctx_btf(ctx);
@@ -612,7 +613,7 @@ static int parse_btf_field(char *fieldna
 
 			anon_offs = 0;
 			field = btf_find_struct_member(btf, type, fieldname,
-						       &anon_offs);
+						       &anon_offs, &mtype);
 			if (IS_ERR(field)) {
 				trace_probe_log_err(ctx->offset, BAD_BTF_TID);
 				return PTR_ERR(field);
@@ -625,7 +626,7 @@ static int parse_btf_field(char *fieldna
 			bitoffs += anon_offs;
 
 			/* Accumulate the bit-offsets of the dot-connected fields */
-			if (btf_type_kflag(type)) {
+			if (btf_type_kflag(mtype)) {
 				bitoffs += BTF_MEMBER_BIT_OFFSET(field->offset);
 				ctx->last_bitsize = BTF_MEMBER_BITFIELD_SIZE(field->offset);
 			} else {


