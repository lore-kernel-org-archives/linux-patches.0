Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D468242FCC9;
	Tue, 21 Jul 2026 19:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662900; cv=none; b=Qx/dg6OZ4BmNWEAtwMKOVT+C9eVMmk9+7CRNcr/JONCKpKpJcuKBzM3U+T7Pez+F95oNYH1ndc8Ejdf2um888llQ5hMPMJAbdJhRfo50xdeAoyb0sfLdNIwmjZvppRwzIF2B9RO4QQxbmDtLWgRlUG74LsktwEFWCFkt5Ntp9qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662900; c=relaxed/simple;
	bh=xK/fn5rqBenbk9B1vN/swPSEf7iAUxAyF7dJwqoJGbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JaZY959SRESX3Pq6LL6HJuZgySTbPfkHX2RNwqI5gdFxcPzYXF0EsVIpL00bJZhQoizKylcSaZPGxWiuErtDQphW9ZCXclo8zAGM6r1EhfHC2vEvNjI+V7EYcB+SQqinNos58Vsbu2/7vmqNWeVo3DDgcQUsIJAVXb6YETfojgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MEWSv0EL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MEWSv0EL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4548B1F00A3F;
	Tue, 21 Jul 2026 19:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662898;
	bh=5A34HOhnSP6j01hB2EHSj9rA9ULeV8iOJMm8oXYdcUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MEWSv0ELzeFggSwc01dUplBkACMpIaO6XHcOwpSsmHmGAlEWkUz5qgI7al5gBOhlN
	 nQdD/b0qNQd5qBhMOclDPtTh45+e7lx6MImMqLKnfsPN6EcJY5SiUkuaHxTvIqQ51X
	 IkGqSp3Y7hxo20hUYUtThjjr1PEBIeSabiZqVRdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Quentin Monnet <qmo@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0619/1276] bpftool: Fix vmlinux BTF leak in cgroup commands
Date: Tue, 21 Jul 2026 17:17:42 +0200
Message-ID: <20260721152459.961376515@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4189c9d74fb062..f4aa711c7fb1e5 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -74,6 +74,13 @@ static unsigned int query_flags;
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
@@ -384,6 +391,8 @@ static int do_show(int argc, char **argv)
 	if (json_output)
 		jsonw_end_array(json_wtr);
 
+	free_btf_vmlinux();
+
 exit_cgroup:
 	close(cgroup_fd);
 exit:
@@ -433,7 +442,9 @@ static int do_show_tree_fn(const char *fpath, const struct stat *sb,
 		printf("%s\n", fpath);
 	}
 
-	btf_vmlinux = libbpf_find_kernel_btf();
+	if (!btf_vmlinux)
+		btf_vmlinux = libbpf_find_kernel_btf();
+
 	for (i = 0; i < ARRAY_SIZE(cgroup_attach_types); i++)
 		show_bpf_progs(cgroup_fd, cgroup_attach_types[i], ftw->level);
 
@@ -536,6 +547,7 @@ static int do_show_tree(int argc, char **argv)
 	if (json_output)
 		jsonw_end_array(json_wtr);
 
+	free_btf_vmlinux();
 	free(cgroup_alloced);
 
 	return ret;
-- 
2.53.0



