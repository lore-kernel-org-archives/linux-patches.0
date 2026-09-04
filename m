Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9D13876CC;
	Fri,  4 Sep 2026 05:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498382; cv=none; b=M+2hC/unT+ivE/O2f15ZaFnPQmAxvbcx0vsU2718pU4r1zDANEJugyb7MaPb2XT4ZpH0TK3gpd0YxR9oQl5fS+QQNO4FVz26M+tN+nU8StdgNZ4AmX0d+2sHahCLjUYDp/BsoaUeQKAtzRh5lANBti2JKcpssaw87Bv9KzTmrAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498382; c=relaxed/simple;
	bh=QlYzXG+2mUrRWRai6OxzWBhShY97U69LlQQmTg3OTSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6G1nasddtaZOyGzUlNA6Vbrs2f0PRehq6/wPI8zaZYmfWRn5rMmduUS5qVyOSALLLJ97+M0y4JXR+gcDtmAvT3npEcQpAo28567nr8VUvS3/+oQWbrGxc6ACgE/3Hgq4fIC40RUb7/ztabQWiMhzUVtU6vAJfVMCXMSj+mqRdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZvZ7U23; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZvZ7U23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905A01F00A3D;
	Fri,  4 Sep 2026 05:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498381;
	bh=YP8HYQTyM/EE/m/HYP/d6isb3+tr5edc8oCIKyz8mKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ZvZ7U23FPRg//G8TNojFPC9A5njlSfBnS2FXBP4hDRR5VgHH9cNjg42CJKEacenF
	 Rv+W+K7Gwk+WX12B0vmQnkLif3ngxFOUsBuaOU/QWH2VqN9QImxO888ByWgVa5YXS1
	 eU733fni5275jZhYYLTSruCWxri6fqZn8R0EIkTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 7.2 043/713] apparmor: fix out-of-bounds write when null terminating a label vec
Date: Fri,  4 Sep 2026 06:50:11 +0200
Message-ID: <20260904045804.794934336@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

commit 9f1e40193eef7f047e6b77cfb4b4cafdecd7a123 upstream.

aa_vec_unique() null terminates at vec[n - dups] when VEC_FLAG_TERMINATE
is passed. If the components are all distinct no duplicates are dropped,
dups is 0 and the terminator goes to vec[n], so the caller has to provide
room for n + 1 entries.

aa_label_strn_parse() sets up its vector with vec_setup(profile, vec, len,
gfp) and then calls aa_vec_unique(vec, len, VEC_FLAG_TERMINATE), but
vec_setup() does not reserve the terminator entry. Up to LOCAL_VEC_ENTRIES
it uses the local array of LOCAL_VEC_ENTRIES pointers, above that it
allocates exactly len pointers. The terminator therefore lands one entry
past the end of the local array when len is LOCAL_VEC_ENTRIES, and one
entry past the end of the allocation when len is larger.

len comes from the number of "//&" separated components in the label name
and label_count_strn_entries() does not bound it. An unprivileged task
reaches the parse by writing to /proc/self/attr/apparmor/current or through
lsm_set_self_attr(2), both of which go through do_setattr(), and the name
is parsed before the change_profile permission is checked.
The query_label() path behind the securityfs .access file, which is
mode 0666, performs no permission check at all. Every component has to
resolve to a loaded profile, so a system with policy loaded is required.

The other two VEC_FLAG_TERMINATE users work on a label vec that
aa_label_alloc() has already sized with "+ 1 for null terminator entry on
vec". Reserve the same entry in vec_setup() and DEFINE_VEC(). Passing
len + 1 from the caller instead would move len == LOCAL_VEC_ENTRIES out of
the local array and into kzalloc().

Fixes: f1bd904175e8 ("apparmor: add the base fns() for domain labels")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/include/label.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/security/apparmor/include/label.h
+++ b/security/apparmor/include/label.h
@@ -23,7 +23,7 @@ struct aa_ruleset;
 
 #define LOCAL_VEC_ENTRIES 8
 #define DEFINE_VEC(T, V)						\
-	struct aa_ ## T *(_ ## V ## _localtmp)[LOCAL_VEC_ENTRIES];	\
+	struct aa_ ## T *(_ ## V ## _localtmp)[LOCAL_VEC_ENTRIES + 1];	\
 	struct aa_ ## T **(V)
 
 #define vec_setup(T, V, N, GFP)						\
@@ -31,10 +31,10 @@ struct aa_ruleset;
 	if ((N) <= LOCAL_VEC_ENTRIES) {					\
 		typeof(N) i;						\
 		(V) = (_ ## V ## _localtmp);				\
-		for (i = 0; i < (N); i++)				\
+		for (i = 0; i <= (N); i++)				\
 			(V)[i] = NULL;					\
 	} else								\
-		(V) = kzalloc(sizeof(struct aa_ ## T *) * (N), (GFP));	\
+		(V) = kzalloc_objs(struct aa_ ## T *, (N) + 1, (GFP));	\
 	(V) ? 0 : -ENOMEM;						\
 })
 


