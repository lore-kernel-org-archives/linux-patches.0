Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7F43B19B9;
	Sat, 17 Oct 2026 16:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255975; cv=none; b=bmjhiLn8Lf5LdV4bF2EkZ6HmptGIosq+vqXQYb70X5zNHj6ao3XfrVkdBk7Z3ojX24ZolPM8ogbCRtP9OMo04EAFyJK+NM5ie05IEY6g4SNWIlcGC39mHhV5/DPlFUWWiXJsisMTEGhCbRJ7Ju+9zdneSC004B0tLbWH9fqMDUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255975; c=relaxed/simple;
	bh=mM5/+PtUzR/btiPPnsQ9FW2Ir9Ao2dc4NTu8ixMBfWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LxyXiZDYSX2IyL0iPEqibKJ8gIU3D/9JVpeevqkFnBP+i65gDVN28jVzoOiIpjdp/90TJK53o8JXiAxWGRXRH2tRbM5zxbKJfRVyA8tCuwmiYV991ClPW0HHdnxaBS/jyLdUri615eLkpFjpdgooksWipLjxhJa+ab6z90bG6jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1sQkchw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1sQkchw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C911F000C4;
	Sat, 17 Oct 2026 16:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255974;
	bh=WXFidhm6PVJEY0Bg/gDCb5pwqi8Kkx9kS2DuLPGdDIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E1sQkchwXHpXQX5MsspzgkWp/NGY3mlbi1M3if3h0vW+KxSRa7j+g07dT5bVMjD6C
	 rr8avedOpf7ml5mTAv+bM0zflRuus37Avb45SZN2kx2f7eENgdy02M+JMviIzwl1fh
	 97E/SbSmjPKTIwcwgHRsow27DECjI3xB13NAQ9Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0084/1674] tracing/probes: Fix anon_stack check for unnamed bitfields in btf_find_struct_member
Date: Sat, 17 Oct 2026 17:39:16 +0200
Message-ID: <20261017160433.289506837@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit f36d94a20ca185bcadef3a10b980cd2cfd72d53a ]

btf_find_struct_member() traverses into nested anonymous structures
and unions by pushing members with !member->name_off onto anon_stack.
However, it does not consider the unnamed bitfields (e.g. `int : 5`
or `unsigned int : 0`) which also have member->name_off == 0.

If such an unnamed bitfield is pushed to anon_stack, the
btf_find_struct_member() return an error even if there are other
valid entries in anon_stack.

To fix this, only push unnamed struct/union members to anon_stack.
Also move the btf_type_is_struct() check to the entry of this function
because now it is sure only struct/union are pushed to anon_stack.

Link: https://lore.kernel.org/all/178827249775.123716.7813217688423513612.stgit@devnote2/

Fixes: 302db0f5b3d8 ("tracing/probes: Add a function to search a member of a struct/union")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260830143859.D56991F00A3D@smtp.kernel.org/
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
[ retained the existing kcalloc() allocation instead of upstream’s kzalloc_objs() call. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_btf.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_btf.c b/kernel/trace/trace_btf.c
index 5bbdbcbbde3cd..40e66eb59abbc 100644
--- a/kernel/trace/trace_btf.c
+++ b/kernel/trace/trace_btf.c
@@ -74,24 +74,24 @@ const struct btf_member *btf_find_struct_member(struct btf *btf,
 {
 	struct btf_anon_stack *anon_stack;
 	const struct btf_member *member;
+	const struct btf_type *mtype;
 	u32 tid, cur_offset = 0;
 	const char *name;
 	int i, top = 0;
 
+	if (!btf_type_is_struct(type))
+		return ERR_PTR(-EINVAL);
+
 	anon_stack = kcalloc(BTF_ANON_STACK_MAX, sizeof(*anon_stack), GFP_KERNEL);
 	if (!anon_stack)
 		return ERR_PTR(-ENOMEM);
 
 retry:
-	if (!btf_type_is_struct(type)) {
-		member = ERR_PTR(-EINVAL);
-		goto out;
-	}
-
 	for_each_member(i, type, member) {
 		if (!member->name_off) {
 			/* Anonymous union/struct: push it for later use */
-			if (btf_type_skip_modifiers(btf, member->type, &tid) &&
+			mtype = btf_type_skip_modifiers(btf, member->type, &tid);
+			if (mtype && btf_type_is_struct(mtype) &&
 			    top < BTF_ANON_STACK_MAX) {
 				anon_stack[top].tid = tid;
 				anon_stack[top++].offset =
-- 
2.53.0



