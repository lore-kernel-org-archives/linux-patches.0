Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0733E264612;
	Fri, 21 Nov 2025 13:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731290; cv=none; b=MtEeOUlEl0cFbi7jlcgrgeqdZ3NSINUSvaj5oise5PLAsIS1GHkdA2b3J7fnRt/viNviSDY3Q5i7VHxkdzloIGd5vdHuaM2+ajYjGZzy1MVRQI5hk4AAjn3FH2g2EJviePbcZEXa8Esw9y8z2d4UQ1+gpvriCbhCaNTMd5SBSmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731290; c=relaxed/simple;
	bh=HehjfeLo+FrhOyu78Ph2T+AJxqUZ9HT5FCeGCKYUWw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGM1e+t99aByLHUl7yrRSX4mR6bmDZK/SasZ9btsmg5Uw7b7Zk0otjs3ZB7BiClSeMXxRTZP55Gi6L24AY0K4ZJlNajOFYatpErljLy6TdgXa1QiiEKnAsG8O00jvxUAPnXX3a6oZehX1t5wrT29tPumfWN+jm6RV3oJ6vzHOSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2n1t1WIU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2n1t1WIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8540AC4CEF1;
	Fri, 21 Nov 2025 13:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731289;
	bh=HehjfeLo+FrhOyu78Ph2T+AJxqUZ9HT5FCeGCKYUWw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2n1t1WIUoWOW+oUHoO+D4Y+XoI7tt2TO9m8bpEQEcov0y+j9Is+QRm3wipFEAKxGx
	 qRfhwk8JIjycX5wPF7WGhS+Kbp5qzby9Fmq2wNg64X2uDnMvTyiyR8cHfsjH+ly4ik
	 CkTocquwpz9EjBCxOLyLBjdlYds5RYBUrWAz2NPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geoffrey Thorpe <geoff@geoffthorpe.net>,
	Hongbo Li <lihongbo22@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 123/247] hostfs: Fix only passing host root in boot stage with new mount
Date: Fri, 21 Nov 2025 14:11:10 +0100
Message-ID: <20251121130158.998299567@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongbo Li <lihongbo22@huawei.com>

[ Upstream commit 2c2b67af5f5f77fc68261a137ad65dcfb8e52506 ]

In the old mount proceedure, hostfs could only pass root directory during
boot. This is because it constructed the root directory using the @root_ino
event without any mount options. However, when using it with the new mount
API, this step is no longer triggered. As a result, if users mounts without
specifying any mount options, the @host_root_path remains uninitialized. To
prevent this issue, the @host_root_path should be initialized at the time
of allocation.

Reported-by: Geoffrey Thorpe <geoff@geoffthorpe.net>
Closes: https://lore.kernel.org/all/643333a0-f434-42fb-82ac-d25a0b56f3b7@geoffthorpe.net/
Fixes: cd140ce9f611 ("hostfs: convert hostfs to use the new mount API")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Link: https://patch.msgid.link/20251011092235.29880-1-lihongbo22@huawei.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hostfs/hostfs_kern.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 01e516175bcd7..30fcce80a2c35 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -979,7 +979,7 @@ static int hostfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 {
 	struct hostfs_fs_info *fsi = fc->s_fs_info;
 	struct fs_parse_result result;
-	char *host_root;
+	char *host_root, *tmp_root;
 	int opt;
 
 	opt = fs_parse(fc, hostfs_param_specs, param, &result);
@@ -990,11 +990,13 @@ static int hostfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 	case Opt_hostfs:
 		host_root = param->string;
 		if (!*host_root)
-			host_root = "";
-		fsi->host_root_path =
-			kasprintf(GFP_KERNEL, "%s/%s", root_ino, host_root);
-		if (fsi->host_root_path == NULL)
+			break;
+		tmp_root = kasprintf(GFP_KERNEL, "%s%s",
+				     fsi->host_root_path, host_root);
+		if (!tmp_root)
 			return -ENOMEM;
+		kfree(fsi->host_root_path);
+		fsi->host_root_path = tmp_root;
 		break;
 	}
 
@@ -1004,17 +1006,17 @@ static int hostfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 static int hostfs_parse_monolithic(struct fs_context *fc, void *data)
 {
 	struct hostfs_fs_info *fsi = fc->s_fs_info;
-	char *host_root = (char *)data;
+	char *tmp_root, *host_root = (char *)data;
 
 	/* NULL is printed as '(null)' by printf(): avoid that. */
 	if (host_root == NULL)
-		host_root = "";
+		return 0;
 
-	fsi->host_root_path =
-		kasprintf(GFP_KERNEL, "%s/%s", root_ino, host_root);
-	if (fsi->host_root_path == NULL)
+	tmp_root = kasprintf(GFP_KERNEL, "%s%s", fsi->host_root_path, host_root);
+	if (!tmp_root)
 		return -ENOMEM;
-
+	kfree(fsi->host_root_path);
+	fsi->host_root_path = tmp_root;
 	return 0;
 }
 
@@ -1049,6 +1051,11 @@ static int hostfs_init_fs_context(struct fs_context *fc)
 	if (!fsi)
 		return -ENOMEM;
 
+	fsi->host_root_path = kasprintf(GFP_KERNEL, "%s/", root_ino);
+	if (!fsi->host_root_path) {
+		kfree(fsi);
+		return -ENOMEM;
+	}
 	fc->s_fs_info = fsi;
 	fc->ops = &hostfs_context_ops;
 	return 0;
-- 
2.51.0



