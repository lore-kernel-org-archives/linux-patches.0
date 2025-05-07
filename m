Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C00E1EB5DD;
	Wed,  7 May 2025 19:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644911; cv=none; b=omP1QJ4ahKtZJDkHduHDKyhgs48y3wojLx3GdY0rwa/mjIKp9luCvwTRpBlI4UwWRAVUP3bkViAz9jSBVtraIafGgDC0SBO/z39cUjL1RHTINGYU89KASviuwPNZmjx3GJ1zmQqlu+XpLIIKJg5Qo6sI/oAqtblkZU98be5q8vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644911; c=relaxed/simple;
	bh=Y4cOgea+4IYOx9nWsujrTkNopxO9onSTTHs1/okRwoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWBAHEJybtqDeSdke7oNJq9ccDkIJdQtbGqIPNI8IbOF1oC5xclzANcVa+FmKNnyCKVxz0Y3S66PSI3UAEObpfR6QpMd6WLJwrzfjRuKxAq3NahOeFhCkILIpl57Pua92owli7bscJWNl8t0A7m1IxK2IitsqCoO76kycY/XvX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lkA+r4Id; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lkA+r4Id"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF53DC4CEE2;
	Wed,  7 May 2025 19:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644911;
	bh=Y4cOgea+4IYOx9nWsujrTkNopxO9onSTTHs1/okRwoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkA+r4IdZv+SLOi7DKtXdlqV9E2GKdaNj8eZKnqEMu6vT+UAfK2HskkU0r46EmWDG
	 O2Lkm9YxBKC+n7QKJVuBAK3KyCYt3uxFQq9IBby40vsBzRj5ddhRJJu0tyujYhbxkf
	 /tGUHXprvVoNTLgeMx/0AI8ee6WaDsPLMTgCThMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.6 033/129] bpf: add find_containing_subprog() utility function
Date: Wed,  7 May 2025 20:39:29 +0200
Message-ID: <20250507183814.867444795@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eduard Zingerman <eddyz87@gmail.com>

commit 27e88bc4df1d80888fe1aaca786a7cc6e69587e2 upstream.

Add a utility function, looking for a subprogram containing a given
instruction index, rewrite find_subprog() to use this function.

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20241210041100.1898468-2-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2636,16 +2636,36 @@ static int cmp_subprogs(const void *a, c
 	       ((struct bpf_subprog_info *)b)->start;
 }
 
+/* Find subprogram that contains instruction at 'off' */
+static struct bpf_subprog_info *find_containing_subprog(struct bpf_verifier_env *env, int off)
+{
+	struct bpf_subprog_info *vals = env->subprog_info;
+	int l, r, m;
+
+	if (off >= env->prog->len || off < 0 || env->subprog_cnt == 0)
+		return NULL;
+
+	l = 0;
+	r = env->subprog_cnt - 1;
+	while (l < r) {
+		m = l + (r - l + 1) / 2;
+		if (vals[m].start <= off)
+			l = m;
+		else
+			r = m - 1;
+	}
+	return &vals[l];
+}
+
+/* Find subprogram that starts exactly at 'off' */
 static int find_subprog(struct bpf_verifier_env *env, int off)
 {
 	struct bpf_subprog_info *p;
 
-	p = bsearch(&off, env->subprog_info, env->subprog_cnt,
-		    sizeof(env->subprog_info[0]), cmp_subprogs);
-	if (!p)
+	p = find_containing_subprog(env, off);
+	if (!p || p->start != off)
 		return -ENOENT;
 	return p - env->subprog_info;
-
 }
 
 static int add_subprog(struct bpf_verifier_env *env, int off)


