Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF7224CEEA;
	Sat, 12 Sep 2026 09:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205537; cv=none; b=cVjXo0XF0bpR0zMY1y4QmvWrnRDOrnwnvkqR71n7/70Id2b4aMei+P/J6dkDdkoQpVRgEM9hRrdCJ2dQArfkMPJyijUCK9rQQdZ30aUBqVGcOuEdfzGDfuvIdSSUYYDoy9okI10Xi2VwiBUXKs9O+6IM2Nlae2cwc+l+AGDILMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205537; c=relaxed/simple;
	bh=FCdymn8ygZqIIvyz8NzbfliklY9GVLzX/Oh8v2mJ1jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRw+PqCm12iWy+CfoE4DbCMNGBzwsioP1bTN2X4nMM5zSRGMGDssKloCVc0ymCYrUG8729YAg+utEEPE5Pwglr+LnrQFNhDTcnIWWh3vj7a6vF1juQl8wTG4ahoe5qKQHGVQhzn6RxzmwUUp9kd1DRwL4U9rIbsxA+eWPwZCoJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bPL/Kxj6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bPL/Kxj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AAA21F000FF;
	Sat, 12 Sep 2026 09:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205536;
	bh=Xhhxp4K7TZ10iXdVKtelo4e6UeORfjJdfEfCtkfjj08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bPL/Kxj63tFAC/irPHwFJU9P25ac4g/bek9ZkURIoEj97/wmhLtunlQr0NYX2kW1f
	 buKJSbZtw0Lh6egCw784MKjuoOK08vZOAJ/Hw2szSUAwUgi+M4x1vg0AWEfweABqMh
	 wG4d2UOU6qP2volE5ex4pp/rEHTmge+JCiZx5wA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0022/1518] tracing/probes: ignore id update from btf_type_skip_modifiers
Date: Sat, 12 Sep 2026 08:36:31 +0200
Message-ID: <20260912065623.922294506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit 823b37855829bc328d46102a56e4d0b2f7a3d0d1 ]

We can pass NULL as id pointer to btf_type_skip_modifiers if we do not
need the id of the returned btf_type.

Link: https://lore.kernel.org/all/20260623132937.3494895-1-martin@kaiser.cx/

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Stable-dep-of: 47e93045a2db ("tracing/probes: Fix BTF kflag check for anonymous struct member access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -355,9 +355,8 @@ static bool btf_type_is_char_ptr(struct
 {
 	const struct btf_type *real_type;
 	u32 intdata;
-	s32 tid;
 
-	real_type = btf_type_skip_modifiers(btf, type->type, &tid);
+	real_type = btf_type_skip_modifiers(btf, type->type, NULL);
 	if (!real_type)
 		return false;
 
@@ -374,14 +373,13 @@ static bool btf_type_is_char_array(struc
 	const struct btf_type *real_type;
 	const struct btf_array *array;
 	u32 intdata;
-	s32 tid;
 
 	if (BTF_INFO_KIND(type->info) != BTF_KIND_ARRAY)
 		return false;
 
 	array = (const struct btf_array *)(type + 1);
 
-	real_type = btf_type_skip_modifiers(btf, array->type, &tid);
+	real_type = btf_type_skip_modifiers(btf, array->type, NULL);
 
 	intdata = btf_type_int(real_type);
 	return !(BTF_INT_ENCODING(intdata) & BTF_INT_SIGNED)
@@ -584,7 +582,6 @@ static int parse_btf_field(char *fieldna
 	struct btf *btf = ctx_btf(ctx);
 	char *next;
 	int is_ptr;
-	s32 tid;
 
 	do {
 		if (!is_struct) {
@@ -595,7 +592,7 @@ static int parse_btf_field(char *fieldna
 			}
 
 			/* Convert a struct pointer type to a struct type */
-			type = btf_type_skip_modifiers(btf, type->type, &tid);
+			type = btf_type_skip_modifiers(btf, type->type, NULL);
 			if (!type) {
 				trace_probe_log_err(ctx->offset, BAD_BTF_TID);
 				return -EINVAL;
@@ -635,7 +632,7 @@ static int parse_btf_field(char *fieldna
 				ctx->last_bitsize = 0;
 			}
 
-			type = btf_type_skip_modifiers(btf, field->type, &tid);
+			type = btf_type_skip_modifiers(btf, field->type, NULL);
 			if (!type) {
 				trace_probe_log_err(ctx->offset, BAD_BTF_TID);
 				return -EINVAL;
@@ -754,7 +751,7 @@ static int parse_btf_arg(char *varname,
 	return -ENOENT;
 
 found:
-	type = btf_type_skip_modifiers(ctx->btf, tid, &tid);
+	type = btf_type_skip_modifiers(ctx->btf, tid, NULL);
 found_type:
 	if (!type) {
 		trace_probe_log_err(ctx->offset, BAD_BTF_TID);


