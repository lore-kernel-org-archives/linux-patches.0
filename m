Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F23376;
	Wed,  5 Feb 2025 14:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766334; cv=none; b=iBU2Se7lYFX5QFSrEQznO3uu7bvyaq0QCplcZ2cVSoxqboEiOxqkgMIcJyrb97fLO2s5hJWa6uT5p9uGij/W6asSRTcZ+a+XuVeSLIFPXtaFRwoM8sePvIBLSnYu3KbnPlVyAxq7yf+XPsZKaF835YHEDqKoHhW6soXT9mmaZN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766334; c=relaxed/simple;
	bh=ov2+vcihaMA6GnNuOY4XYiqxWNyz3ZYZJdVwUZ8sK28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rlNudXA2/uFtQ7VosDJHlDZ9YzFXbuZuDkx4uoXUdCck2xEd2Kt9Dhk5N6V0YDqQS8BW9i71FW9AhtSs49/SLT9RszLRCDhZ4AKfLZJHhIsmOCCA6mZwEEw9hyzTnbJQFz5ImpW0tJSE4EoaJv9feFl5Vyp7bBR+4kp/sHCnVBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yvcEQsWv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvcEQsWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231D4C4CED1;
	Wed,  5 Feb 2025 14:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766333;
	bh=ov2+vcihaMA6GnNuOY4XYiqxWNyz3ZYZJdVwUZ8sK28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yvcEQsWvSpvQ4nzlBDMMHsug1d0JYCA8kck91HwkVFdtS0YKPTIoyug3AOLNHFHZV
	 owd8cFxWWDrvBA4b/+TkZbiBT4N7rM+CO03pH/VHg8WLBdN9m+tWJToyVG7pRI7P3V
	 4OL8OvW+Mvjdw/OaZf+Ij9gusBWGhSeanjoZJHHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Hongbo Li <lihongbo22@huawei.com>,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Subject: [PATCH 6.6 353/393] hostfs: fix the host directory parse when mounting.
Date: Wed,  5 Feb 2025 14:44:32 +0100
Message-ID: <20250205134433.810470614@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongbo Li <lihongbo22@huawei.com>

commit ef9ca17ca458ac7253ae71b552e601e49311fc48 upstream.

hostfs not keep the host directory when mounting. When the host
directory is none (default), fc->source is used as the host root
directory, and this is wrong. Here we use `parse_monolithic` to
handle the old mount path for parsing the root directory. For new
mount path, The `parse_param` is used for the host directory parse.

Reported-and-tested-by: Maciej Żenczykowski <maze@google.com>
Fixes: cd140ce9f611 ("hostfs: convert hostfs to use the new mount API")
Link: https://lore.kernel.org/all/CANP3RGceNzwdb7w=vPf5=7BCid5HVQDmz1K5kC9JG42+HVAh_g@mail.gmail.com/
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Link: https://lore.kernel.org/r/20240725065130.1821964-1-lihongbo22@huawei.com
[brauner: minor fixes]
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hostfs/hostfs_kern.c |   65 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 55 insertions(+), 10 deletions(-)

--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -17,6 +17,7 @@
 #include <linux/writeback.h>
 #include <linux/mount.h>
 #include <linux/fs_context.h>
+#include <linux/fs_parser.h>
 #include <linux/namei.h>
 #include "hostfs.h"
 #include <init.h>
@@ -925,7 +926,6 @@ static const struct inode_operations hos
 static int hostfs_fill_super(struct super_block *sb, struct fs_context *fc)
 {
 	struct hostfs_fs_info *fsi = sb->s_fs_info;
-	const char *host_root = fc->source;
 	struct inode *root_inode;
 	int err;
 
@@ -939,15 +939,6 @@ static int hostfs_fill_super(struct supe
 	if (err)
 		return err;
 
-	/* NULL is printed as '(null)' by printf(): avoid that. */
-	if (fc->source == NULL)
-		host_root = "";
-
-	fsi->host_root_path =
-		kasprintf(GFP_KERNEL, "%s/%s", root_ino, host_root);
-	if (fsi->host_root_path == NULL)
-		return -ENOMEM;
-
 	root_inode = hostfs_iget(sb, fsi->host_root_path);
 	if (IS_ERR(root_inode))
 		return PTR_ERR(root_inode);
@@ -973,6 +964,58 @@ static int hostfs_fill_super(struct supe
 	return 0;
 }
 
+enum hostfs_parma {
+	Opt_hostfs,
+};
+
+static const struct fs_parameter_spec hostfs_param_specs[] = {
+	fsparam_string_empty("hostfs",		Opt_hostfs),
+	{}
+};
+
+static int hostfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
+{
+	struct hostfs_fs_info *fsi = fc->s_fs_info;
+	struct fs_parse_result result;
+	char *host_root;
+	int opt;
+
+	opt = fs_parse(fc, hostfs_param_specs, param, &result);
+	if (opt < 0)
+		return opt;
+
+	switch (opt) {
+	case Opt_hostfs:
+		host_root = param->string;
+		if (!*host_root)
+			host_root = "";
+		fsi->host_root_path =
+			kasprintf(GFP_KERNEL, "%s/%s", root_ino, host_root);
+		if (fsi->host_root_path == NULL)
+			return -ENOMEM;
+		break;
+	}
+
+	return 0;
+}
+
+static int hostfs_parse_monolithic(struct fs_context *fc, void *data)
+{
+	struct hostfs_fs_info *fsi = fc->s_fs_info;
+	char *host_root = (char *)data;
+
+	/* NULL is printed as '(null)' by printf(): avoid that. */
+	if (host_root == NULL)
+		host_root = "";
+
+	fsi->host_root_path =
+		kasprintf(GFP_KERNEL, "%s/%s", root_ino, host_root);
+	if (fsi->host_root_path == NULL)
+		return -ENOMEM;
+
+	return 0;
+}
+
 static int hostfs_fc_get_tree(struct fs_context *fc)
 {
 	return get_tree_nodev(fc, hostfs_fill_super);
@@ -990,6 +1033,8 @@ static void hostfs_fc_free(struct fs_con
 }
 
 static const struct fs_context_operations hostfs_context_ops = {
+	.parse_monolithic = hostfs_parse_monolithic,
+	.parse_param	= hostfs_parse_param,
 	.get_tree	= hostfs_fc_get_tree,
 	.free		= hostfs_fc_free,
 };


