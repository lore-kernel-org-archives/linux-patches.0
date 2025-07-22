Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CA52EA485;
	Tue, 22 Jul 2025 14:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193098; cv=none; b=BrM115HLauFTxKFeggB5/d9H+JCNImUz/BeiDUJlAUHCb28IDssazK3UrBycAW1yUJV5Mr5yhY9VFChQoSBdgA2TD0gzd/KQb10iHPnzvYMLvSV6zY/dchiuLfhJkO0nm2S4qEM1Zub2NOFCdLIsgxZS++yhCcdCU/4c8rqwvTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193098; c=relaxed/simple;
	bh=F2ZzHhg+tlRAUclj4LbGWpJQ/QO8OG0JjCSDs0+eyc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQU4laeCB3X8bsVtjPMPDcaGyOopMjFSyUDZYhCOo7Ij93gSS+1N9hLs7gw9uwMihIXErxbAfc/vX0iaRo/MIxW5FF2ALiRp0du3Lq7Q4Rj36nJ/6pdqigN8SMH1NVp3YsDOe2b/dM1hc6dFOP1/pEhAatYi/pbSX59qAo0rKjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p9i0zF6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9i0zF6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE523C4CEEB;
	Tue, 22 Jul 2025 14:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193098;
	bh=F2ZzHhg+tlRAUclj4LbGWpJQ/QO8OG0JjCSDs0+eyc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9i0zF6dad7JIqxNL10NZ0h+ybuiTWzxo/eqgzr0Q9dfkHfVaEfmdUwd7dzs23bXd
	 KPb/VO2uNUP830ObHjor2kTHjHq/WowUzCAUToxjf9m9PC6hKrgMbtJGQlxsXXu/wM
	 vSGVBtCxyKMluMd+zQVD1VYQUuNiqxociQq4leKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <ihor.solodrai@pm.me>,
	Andrii Nakryiko <andrii@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.12 150/158] selftests/bpf: Set test path for token/obj_priv_implicit_token_envvar
Date: Tue, 22 Jul 2025 15:45:34 +0200
Message-ID: <20250722134346.310524606@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

From: Ihor Solodrai <ihor.solodrai@pm.me>

commit f01750aecdfb8bfb02842f60af3d805a3ae7267a upstream.

token/obj_priv_implicit_token_envvar test may fail in an environment
where the process executing tests can not write to the root path.

Example:
https://github.com/libbpf/libbpf/actions/runs/11844507007/job/33007897936

Change default path used by the test to /tmp/bpf-token-fs, and make it
runtime configurable via an environment variable.

Signed-off-by: Ihor Solodrai <ihor.solodrai@pm.me>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241115003853.864397-1-ihor.solodrai@pm.me
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
---
 tools/testing/selftests/bpf/prog_tests/token.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/bpf/prog_tests/token.c
+++ b/tools/testing/selftests/bpf/prog_tests/token.c
@@ -828,8 +828,12 @@ static int userns_obj_priv_btf_success(i
 	return validate_struct_ops_load(mnt_fd, true /* should succeed */);
 }
 
+static const char *token_bpffs_custom_dir()
+{
+	return getenv("BPF_SELFTESTS_BPF_TOKEN_DIR") ?: "/tmp/bpf-token-fs";
+}
+
 #define TOKEN_ENVVAR "LIBBPF_BPF_TOKEN_PATH"
-#define TOKEN_BPFFS_CUSTOM "/bpf-token-fs"
 
 static int userns_obj_priv_implicit_token(int mnt_fd, struct token_lsm *lsm_skel)
 {
@@ -892,6 +896,7 @@ static int userns_obj_priv_implicit_toke
 
 static int userns_obj_priv_implicit_token_envvar(int mnt_fd, struct token_lsm *lsm_skel)
 {
+	const char *custom_dir = token_bpffs_custom_dir();
 	LIBBPF_OPTS(bpf_object_open_opts, opts);
 	struct dummy_st_ops_success *skel;
 	int err;
@@ -909,10 +914,10 @@ static int userns_obj_priv_implicit_toke
 	 * BPF token implicitly, unless pointed to it through
 	 * LIBBPF_BPF_TOKEN_PATH envvar
 	 */
-	rmdir(TOKEN_BPFFS_CUSTOM);
-	if (!ASSERT_OK(mkdir(TOKEN_BPFFS_CUSTOM, 0777), "mkdir_bpffs_custom"))
+	rmdir(custom_dir);
+	if (!ASSERT_OK(mkdir(custom_dir, 0777), "mkdir_bpffs_custom"))
 		goto err_out;
-	err = sys_move_mount(mnt_fd, "", AT_FDCWD, TOKEN_BPFFS_CUSTOM, MOVE_MOUNT_F_EMPTY_PATH);
+	err = sys_move_mount(mnt_fd, "", AT_FDCWD, custom_dir, MOVE_MOUNT_F_EMPTY_PATH);
 	if (!ASSERT_OK(err, "move_mount_bpffs"))
 		goto err_out;
 
@@ -925,7 +930,7 @@ static int userns_obj_priv_implicit_toke
 		goto err_out;
 	}
 
-	err = setenv(TOKEN_ENVVAR, TOKEN_BPFFS_CUSTOM, 1 /*overwrite*/);
+	err = setenv(TOKEN_ENVVAR, custom_dir, 1 /*overwrite*/);
 	if (!ASSERT_OK(err, "setenv_token_path"))
 		goto err_out;
 
@@ -951,11 +956,11 @@ static int userns_obj_priv_implicit_toke
 	if (!ASSERT_ERR(err, "obj_empty_token_path_load"))
 		goto err_out;
 
-	rmdir(TOKEN_BPFFS_CUSTOM);
+	rmdir(custom_dir);
 	unsetenv(TOKEN_ENVVAR);
 	return 0;
 err_out:
-	rmdir(TOKEN_BPFFS_CUSTOM);
+	rmdir(custom_dir);
 	unsetenv(TOKEN_ENVVAR);
 	return -EINVAL;
 }


