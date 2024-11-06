Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7111E0B7B;
	Wed,  6 Nov 2024 12:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897364; cv=none; b=MddRJIri8DKMVQs0DG8O5aba/WVucvif2e5K3q9kx7BzyXm/ypCm10BsBl+WyJ8rHMkFv17t1vh+XR58tK9WX3N9LcuKg8hlfwObD9wlQcWHGO479aGtJQdsDoACg9seKM+/I8wfsVmjTu3Gv3VYKXxwtRkBxqjbW1FgYxj9w58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897364; c=relaxed/simple;
	bh=H5h22hvXToWXUMrZ8BvgFM83tCmEKCL7vHLi0lR/2dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofYFxnpfGp7XhuklScQxiDyvoVb1cO47cFaaprun+Ztn7WfdEIRXq55r461XQrHko3Dpky1LnElOFBgBqTU01oqHawc2Q1eudl6qp+6HolUqSROWiAaxB40Lj7u9YeYTTzCzlXZ1rS7YGw7JG18MJ0Im7geDkQY6X/r0i4oTjUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LcDKgqFj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LcDKgqFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C5AC4CECD;
	Wed,  6 Nov 2024 12:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897364;
	bh=H5h22hvXToWXUMrZ8BvgFM83tCmEKCL7vHLi0lR/2dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LcDKgqFjUqPACnd+K5X41gT1FzOaxt/1vsNYtsMM0YtCsmWGX7TcGqEqpaapkn0ao
	 80PFijzOfW942xg34kmc2zv7NsjC1KFVgCFNcz7Tkb71l+oumbat0I3X98KZH2iMyk
	 BufM8jPX8cepBDAU3BNfXJ8Y6Rd5UB5sm2now3PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/151] selftests/bpf: Add bpf_percpu_obj_{new,drop}() macro in bpf_experimental.h
Date: Wed,  6 Nov 2024 13:03:36 +0100
Message-ID: <20241106120309.610940862@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit 968c76cb3dc6cc86e8099ecaa5c30dc0d4738a30 ]

The new macro bpf_percpu_obj_{new/drop}() is very similar to bpf_obj_{new,drop}()
as they both take a type as the argument.

Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20230827152805.1999417-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: aa30eb3260b2 ("bpf: Force checkpoint when jmp history is too long")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/bpf/bpf_experimental.h  | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/bpf/bpf_experimental.h b/tools/testing/selftests/bpf/bpf_experimental.h
index 209811b1993af..4494eaa9937e5 100644
--- a/tools/testing/selftests/bpf/bpf_experimental.h
+++ b/tools/testing/selftests/bpf/bpf_experimental.h
@@ -131,4 +131,35 @@ extern int bpf_rbtree_add_impl(struct bpf_rb_root *root, struct bpf_rb_node *nod
  */
 extern struct bpf_rb_node *bpf_rbtree_first(struct bpf_rb_root *root) __ksym;
 
+/* Description
+ *	Allocates a percpu object of the type represented by 'local_type_id' in
+ *	program BTF. User may use the bpf_core_type_id_local macro to pass the
+ *	type ID of a struct in program BTF.
+ *
+ *	The 'local_type_id' parameter must be a known constant.
+ *	The 'meta' parameter is rewritten by the verifier, no need for BPF
+ *	program to set it.
+ * Returns
+ *	A pointer to a percpu object of the type corresponding to the passed in
+ *	'local_type_id', or NULL on failure.
+ */
+extern void *bpf_percpu_obj_new_impl(__u64 local_type_id, void *meta) __ksym;
+
+/* Convenience macro to wrap over bpf_percpu_obj_new_impl */
+#define bpf_percpu_obj_new(type) ((type __percpu_kptr *)bpf_percpu_obj_new_impl(bpf_core_type_id_local(type), NULL))
+
+/* Description
+ *	Free an allocated percpu object. All fields of the object that require
+ *	destruction will be destructed before the storage is freed.
+ *
+ *	The 'meta' parameter is rewritten by the verifier, no need for BPF
+ *	program to set it.
+ * Returns
+ *	Void.
+ */
+extern void bpf_percpu_obj_drop_impl(void *kptr, void *meta) __ksym;
+
+/* Convenience macro to wrap over bpf_obj_drop_impl */
+#define bpf_percpu_obj_drop(kptr) bpf_percpu_obj_drop_impl(kptr, NULL)
+
 #endif
-- 
2.43.0



