Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA7E414DF6;
	Fri,  4 Sep 2026 05:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500483; cv=none; b=YiVtJdbI/uA82oVuxgRCfeKGEpeTns1IPWXzJFP2S1uwb4R38ZH3Vp8PkxLCNa8qByuboys8V81KhWvy3ggQxzRGfTS5ilK+ImjSQ52dw/QS2T8p+rpcu7zuqKDGLzAKJrGa05JEzN55OOBJPciIH2rrlcs4rTxaB/9+HMHJTus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500483; c=relaxed/simple;
	bh=wEZJQrTwktqzhaiXMTxRzL0Rpw37MSuQ9ljxgh8d1/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3Ct1u+o2Fdsp5dUCeQ28j1+0K2tV3kvGwN7eHTbF+TrnHontTCZBj+4eyRk4OGJm0z/dFJC8bE9n3sRd8oFU6dFwgsuvJyaZe2TjpndPEFWPo02Um+8QL0KqCZJUoHPQcEB2xymd+zjeDaMqb3+7IT/NWvT5AVSiUCTTUCLLm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gEhzsG/N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gEhzsG/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DC11F00A3D;
	Fri,  4 Sep 2026 05:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500481;
	bh=8zNKo8KVbiScNmSd3kBTgN9uTP7ofEBnwLlsbDcmLg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gEhzsG/Nnd9OWEd7YXbEC20OskyfDBWdwJDhSLnoxt/+IKFtvgNn0hQlcr0jwvljc
	 fj6VaWvXO2ErBfkpaHm2S3fM6NOBR264DAyjzHRNg39HTdO7yM1jIwjszs501dceV1
	 0HJmNTV+qEEKJcy1KfsR0zZT2BLMLEEdG381nODk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.18 029/552] apparmor: fix out-of-bounds write when null terminating a label vec
Date: Fri,  4 Sep 2026 06:53:06 +0200
Message-ID: <20260904045748.489518156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
 


