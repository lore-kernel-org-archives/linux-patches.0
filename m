Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B53223D298;
	Wed, 23 Apr 2025 15:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421368; cv=none; b=nUlg30HvLeWJMsQXKpBxzDEC3/ks6x7uEn0fNTFWgTP0P2v8zvgyfHStcXuAU9+CCgT5M+pahpoYmI5Q/GMNUiS+GIdXIkmm8umhSLTNRF9yRKN8Li++ivCuPBgP6AFTZz3nUObAO2S1kuZHrm9miWwbZULaj61m//w6SvPsxpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421368; c=relaxed/simple;
	bh=vpVpRoZmfVAx3PP6PAAsQQDnNxgnf5B37J3+Q7emOmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwVI+Wi148vWwaVV+Gok+8+DhqgReuxvscUtkHow8bCodzkxl3/N8mXVxoolmK1uhRMLC0TJH2TsrcJNCu91uNlU11AAjD8yi4jkdJsxq+M9+k3fk9LL/S4zJdnJffg6Lv6GPTt/OwSE/CpfDLDwwtWqgESm0Am/6xEJ6nMDwu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytPv5Ds4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytPv5Ds4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97FBC4CEE2;
	Wed, 23 Apr 2025 15:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421368;
	bh=vpVpRoZmfVAx3PP6PAAsQQDnNxgnf5B37J3+Q7emOmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ytPv5Ds4/thI6/9pMTic6D7FrlXW2akbgsxbZBBagfM4ekVO41RuunozErnCDu3RM
	 yt2XV8ZwRb8qkCEAyS4KRZcUsYmKYzg72PnvbqUDk4aKVNY2tDiqsbyDlloHDLg9bW
	 dKkJkMhVLnTHJCplSiMEIu5Om2OgSezE6DmGHvnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.12 215/223] bpf: add find_containing_subprog() utility function
Date: Wed, 23 Apr 2025 16:44:47 +0200
Message-ID: <20250423142625.925478805@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2528,16 +2528,36 @@ static int cmp_subprogs(const void *a, c
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


