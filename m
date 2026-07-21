Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01963358C6;
	Tue, 21 Jul 2026 18:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657739; cv=none; b=LLlL7UwyHsRNk6wqmJY/I827vDjudEiN95mlnpLojAh88JkgQXlKX5K30Uo/yOS+7OHJK+GHCpjVYg5WjOQR0YoEV9OxzCIG7VcP3pfAEyG53i2EPfxzJcuUD2A5qw5rB9rYaxarI2DKMmlR7Hnotx/yBrzQyTbbQwwGFGyIyFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657739; c=relaxed/simple;
	bh=ljZUfnRBIIT44k99xovqRCXOJdaIobmucBQanZU1u78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igmKMn5ond2kKDYlz0EpAhas1KkGVZciNtHgJlOW2kZ2j6b5cwLHlzLI2RZOKmn6wRrLHoIfMZVh8PUTz+aNFcCtuIeDE2+wHJ6zgEY5yft8we6x40jteD5yOxmIElopR1HorYn36XLBnida+cz+UlfA3g1EBfw4sGvZ+/c7S9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1DdZQKE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1DdZQKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3838E1F000E9;
	Tue, 21 Jul 2026 18:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657738;
	bh=sWUzq4M5zBMRrWEpxfRr+472wT3R3ZHthZC+oEP0wjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T1DdZQKExOs8pQzvF/nEndXdvLMFZNT2fQFfFgbrWseegiUBm0/DCxUAzR3WXQ9gc
	 3t0G7SIy34Z/A1Ga6AQFbYaazJH3dFMpFjiyVNCZs+L2W+egG6c/IFJqLv1SFFMCYr
	 7F76UBZxfgQlzpAaHuU7Nwy3htZjrrHSRZehdAwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Quentin Monnet <qmo@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0877/1611] bpftool: Fix vmlinux BTF leak in cgroup commands
Date: Tue, 21 Jul 2026 17:16:33 +0200
Message-ID: <20260721152535.117030239@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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



