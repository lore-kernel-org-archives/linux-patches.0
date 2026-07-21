Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5128F471252;
	Tue, 21 Jul 2026 19:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661008; cv=none; b=nklB3BHyvBC09qWwyfW5MfD+S76pfiJ9qGzoFjpDdsCsRj2QZW7vmRg1l6V8uGYIKcwIyJl6yT/h3C1zEdbm3P3OS1KDHjZJ9Fkb2yjfUkOyuVVDRCrxd2wk+0zklk4r+YTujoI+FUUH7Ra1a5eoRy2kQPo3O30lqKYLwSfFaVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661008; c=relaxed/simple;
	bh=8hFKFiWgSaO56eAOWZQngj013Fv0N5DFy1hoee08RCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFYztFIzzOgIHAvSdxeUkH+RNyuzEtXT+IFW2zyhluTL+W0kbCJm6V7EQFgw/Bxz/meoxT25RWXWgfPo1rbyxHZudpc5cia7lfZbN2oh5jK2LhwK15k8gemCV0V9KZamMjIDtp677ElR8h+T4sknQqfLQeP1W3HLv9LmDYbSS30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPaIzppp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPaIzppp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74A01F000E9;
	Tue, 21 Jul 2026 19:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661005;
	bh=Uqeg9oOAKL4/IN65EjqY57j4jFrsgSlHGMCAzz0ZbUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WPaIzppp3HWfiq2TP32KsNTykBFxwOlSFdBZmbzD5L1r9samiDqdS5taV35zFRB//
	 f8l9ySM7TvkEpytPCMgWKMtVTXVlQqALjadwobE83jNYTgJL+FC9wBR1eTmxEFqO2Z
	 sotaMIZGBinsEyMVO0wicZiv+gy1HPvmhXEoXtPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Quentin Monnet <qmo@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1193/2077] bpftool: Fix vmlinux BTF leak in cgroup commands
Date: Tue, 21 Jul 2026 17:14:26 +0200
Message-ID: <20260721152620.953478351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit bda6a7308ef8e79cfbb7d09e48e1c7ffaa522269 ]

bpftool cgroup show and tree call libbpf_find_kernel_btf() to
resolve attach_btf names, but never release the returned BTF object.

For cgroup tree, do_show_tree_fn() is called once for each cgroup
visited by nftw(). When more than one cgroup has attached programs,
each callback overwrites btf_vmlinux with a new object and loses the
previous allocation.

Load vmlinux BTF only once during a tree walk and release it when
cgroup show or tree completes. Reset btf_vmlinux_id at the same time
so batch mode starts with clean state.

Fixes: 596f5fb2ea2a ("bpftool: implement cgroup tree for BPF_LSM_CGROUP")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Reviewed-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/r/24357C69B4405079+20260617090117.280222-1-chenyichong@uniontech.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/cgroup.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index ec356deb27c9ec..ce69d1e5468e36 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -78,6 +78,13 @@ static unsigned int query_flags;
 static struct btf *btf_vmlinux;
 static __u32 btf_vmlinux_id;
 
+static void free_btf_vmlinux(void)
+{
+	btf__free(btf_vmlinux);
+	btf_vmlinux = NULL;
+	btf_vmlinux_id = 0;
+}
+
 static enum bpf_attach_type parse_attach_type(const char *str)
 {
 	const char *attach_type_str;
@@ -388,6 +395,8 @@ static int do_show(int argc, char **argv)
 	if (json_output)
 		jsonw_end_array(json_wtr);
 
+	free_btf_vmlinux();
+
 exit_cgroup:
 	close(cgroup_fd);
 exit:
@@ -437,7 +446,9 @@ static int do_show_tree_fn(const char *fpath, const struct stat *sb,
 		printf("%s\n", fpath);
 	}
 
-	btf_vmlinux = libbpf_find_kernel_btf();
+	if (!btf_vmlinux)
+		btf_vmlinux = libbpf_find_kernel_btf();
+
 	for (i = 0; i < ARRAY_SIZE(cgroup_attach_types); i++)
 		show_bpf_progs(cgroup_fd, cgroup_attach_types[i], ftw->level);
 
@@ -540,6 +551,7 @@ static int do_show_tree(int argc, char **argv)
 	if (json_output)
 		jsonw_end_array(json_wtr);
 
+	free_btf_vmlinux();
 	free(cgroup_alloced);
 
 	return ret;
-- 
2.53.0



