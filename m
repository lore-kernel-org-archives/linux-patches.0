Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6D413D53B;
	Sun,  1 Sep 2024 16:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208084; cv=none; b=Ah4eF5iaqqXApySxa/uOhsmwlwfQUaLLZ4JfRe8TY5Qeg3WfZ53D3rPUTBvS6Vw7XiwQTDw7qvLWmc1ft5fxiDJ462ME0SnfcVExyaJUVRsgApU/kFZcRXG6UOP+UaC4sen0cz6t31lyaGnUzHGiHw4MwaWSv6CEyg/Fcrx9Ud0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208084; c=relaxed/simple;
	bh=JuC0DvE3BWhzBa7y59RI1PP8ZYINpzxeYuQkVwpRjAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxzhZ/4BxwsEVyJEVWFPjjDCxhRA6aep8u1yyKMr+MBB9zOzms1E6BQZZiugEVNhvMAdzFNdgZLTauq/4lEshVcans1DlJXqU+q6XEvWOIn+GQVj28prQ2Huw8avHC8eCNorAZ7sWuBHGv8luSeQkM5RTF518ITVTt/std2w28E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZZKqTdb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZZKqTdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B270C4CEC3;
	Sun,  1 Sep 2024 16:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208084;
	bh=JuC0DvE3BWhzBa7y59RI1PP8ZYINpzxeYuQkVwpRjAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZZKqTdbq4VAaSOXUriEgs/qvMmqpLy0KVvOoc5e6FUH6C/L7yiCIo17lqwlRWrQz
	 xPxzeHQj9P0aaYiOCA7WRvx5EvUljE5IfiaGcDmG8NH523nyL7ydz0dj79Nd/SJopi
	 RfamfUaC9U7FsO4ubtsVi0BDWK7FWB5xU8ayNMD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 37/93] ovl: fix wrong lowerdir number check for parameter Opt_lowerdir
Date: Sun,  1 Sep 2024 18:16:24 +0200
Message-ID: <20240901160808.756407145@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit ca76ac36bb6068866feca185045e7edf2a8f392f ]

The max count of lowerdir is OVL_MAX_STACK[500], which is broken by
commit 37f32f526438("ovl: fix memory leak in ovl_parse_param()") for
parameter Opt_lowerdir. Since commit 819829f0319a("ovl: refactor layer
parsing helpers") and commit 24e16e385f22("ovl: add support for
appending lowerdirs one by one") added check ovl_mount_dir_check() in
function ovl_parse_param_lowerdir(), the 'ctx->nr' should be smaller
than OVL_MAX_STACK, after commit 37f32f526438("ovl: fix memory leak in
ovl_parse_param()") is applied, the 'ctx->nr' is updated before the
check ovl_mount_dir_check(), which leads the max count of lowerdir
to become 499 for parameter Opt_lowerdir.
Fix it by replacing lower layers parsing code with the existing helper
function ovl_parse_layer().

Fixes: 37f32f526438 ("ovl: fix memory leak in ovl_parse_param()")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Link: https://lore.kernel.org/r/20240705011510.794025-3-chengzhihao1@huawei.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/params.c | 40 +++++++---------------------------------
 1 file changed, 7 insertions(+), 33 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 17b9c1838182d..39919a10ce1c9 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -357,6 +357,8 @@ static void ovl_add_layer(struct fs_context *fc, enum ovl_opt layer,
 	case Opt_datadir_add:
 		ctx->nr_data++;
 		fallthrough;
+	case Opt_lowerdir:
+		fallthrough;
 	case Opt_lowerdir_add:
 		WARN_ON(ctx->nr >= ctx->capacity);
 		l = &ctx->lower[ctx->nr++];
@@ -379,7 +381,7 @@ static int ovl_parse_layer(struct fs_context *fc, const char *layer_name, enum o
 	if (!name)
 		return -ENOMEM;
 
-	if (upper)
+	if (upper || layer == Opt_lowerdir)
 		err = ovl_mount_dir(name, &path);
 	else
 		err = ovl_mount_dir_noesc(name, &path);
@@ -435,7 +437,6 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 {
 	int err;
 	struct ovl_fs_context *ctx = fc->fs_private;
-	struct ovl_fs_context_layer *l;
 	char *dup = NULL, *iter;
 	ssize_t nr_lower, nr;
 	bool data_layer = false;
@@ -475,35 +476,11 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 		goto out_err;
 	}
 
-	if (nr_lower > ctx->capacity) {
-		err = -ENOMEM;
-		l = krealloc_array(ctx->lower, nr_lower, sizeof(*ctx->lower),
-				   GFP_KERNEL_ACCOUNT);
-		if (!l)
-			goto out_err;
-
-		ctx->lower = l;
-		ctx->capacity = nr_lower;
-	}
-
 	iter = dup;
-	l = ctx->lower;
-	for (nr = 0; nr < nr_lower; nr++, l++) {
-		ctx->nr++;
-		memset(l, 0, sizeof(*l));
-
-		err = ovl_mount_dir(iter, &l->path);
+	for (nr = 0; nr < nr_lower; nr++) {
+		err = ovl_parse_layer(fc, iter, Opt_lowerdir);
 		if (err)
-			goto out_put;
-
-		err = ovl_mount_dir_check(fc, &l->path, Opt_lowerdir, iter, false);
-		if (err)
-			goto out_put;
-
-		err = -ENOMEM;
-		l->name = kstrdup(iter, GFP_KERNEL_ACCOUNT);
-		if (!l->name)
-			goto out_put;
+			goto out_err;
 
 		if (data_layer)
 			ctx->nr_data++;
@@ -521,7 +498,7 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 			 */
 			if (ctx->nr_data > 0) {
 				pr_err("regular lower layers cannot follow data lower layers");
-				goto out_put;
+				goto out_err;
 			}
 
 			data_layer = false;
@@ -535,9 +512,6 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 	kfree(dup);
 	return 0;
 
-out_put:
-	ovl_reset_lowerdirs(ctx);
-
 out_err:
 	kfree(dup);
 
-- 
2.43.0



