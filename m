Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF951DF246;
	Tue,  8 Oct 2024 12:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392242; cv=none; b=rnAahJZgGtbE0FfmsDeTTaNeFuOZq7Krv/+ylp6W1WYA8zKkksr3r8UMIg2e+nOPRCZh+TBUJyXnIDj82FwvLrBhzvAW2N4Wu+Sk/ezY8l1Zk6MVp8//xqa9/zv/P0NZAya4tU0ldHnzfUWSXZxe4mC50aXpAD96RiHGu/2tlKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392242; c=relaxed/simple;
	bh=LYODPKdu9BIcv4HJSj7cYceG/3P+/CkvN8IZ7sFQPJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfO869EHm+0wAfb4S7PXcap8bLpcLoGBddRarFaTiVxjFDj0VmXUiIzCJNdXqCECSkAtvPTLMf3xq4Shwb7kbqIf5fRAflAFFECsjvykf3DQf+/SKamRRp40rgfPN7sLqtIskSyFJgeNCnd5y4rcQhZ5TaBSYmWpamwU4ocVqz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FsXmvp7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FsXmvp7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60197C4CEC7;
	Tue,  8 Oct 2024 12:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392241;
	bh=LYODPKdu9BIcv4HJSj7cYceG/3P+/CkvN8IZ7sFQPJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FsXmvp7+Jl2aEYFEDB2rRVQgtYqoi2epf7nkNS5BqRAkMyaN31O6R8EX68R9DL+J8
	 JA3RGoF0w06Web1aboMj1FdVtrHjLMK3uRHwzeiCMjbhb4VRIq1Gbd0Ado82WEZHgZ
	 OEwfbDU+3jGnok6ofZvDhNllTCJyBT3yOZoSC1mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Baynton <mike@mbaynton.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.11 358/558] ovl: fail if trusted xattrs are needed but caller lacks permission
Date: Tue,  8 Oct 2024 14:06:28 +0200
Message-ID: <20241008115716.387428227@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Baynton <mike@mbaynton.com>

commit 6c4a5f96450415735c31ed70ff354f0ee5cbf67b upstream.

Some overlayfs features require permission to read/write trusted.*
xattrs. These include redirect_dir, verity, metacopy, and data-only
layers. This patch adds additional validations at mount time to stop
overlays from mounting in certain cases where the resulting mount would
not function according to the user's expectations because they lack
permission to access trusted.* xattrs (for example, not global root.)

Similar checks in ovl_make_workdir() that disable features instead of
failing are still relevant and used in cases where the resulting mount
can still work "reasonably well." Generally, if the feature was enabled
through kernel config or module option, any mount that worked before
will still work the same; this applies to redirect_dir and metacopy. The
user must explicitly request these features in order to generate a mount
failure. Verity and data-only layers on the other hand must be explictly
requested and have no "reasonable" disabled or degraded alternative, so
mounts attempting either always fail.

"lower data-only dirs require metacopy support" moved down in case
userxattr is set, which disables metacopy.

Cc: stable@vger.kernel.org # v6.6+
Signed-off-by: Mike Baynton <mike@mbaynton.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/params.c |   38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -755,11 +755,6 @@ int ovl_fs_params_verify(const struct ov
 {
 	struct ovl_opt_set set = ctx->set;
 
-	if (ctx->nr_data > 0 && !config->metacopy) {
-		pr_err("lower data-only dirs require metacopy support.\n");
-		return -EINVAL;
-	}
-
 	/* Workdir/index are useless in non-upper mount */
 	if (!config->upperdir) {
 		if (config->workdir) {
@@ -911,6 +906,39 @@ int ovl_fs_params_verify(const struct ov
 		config->metacopy = false;
 	}
 
+	/*
+	 * Fail if we don't have trusted xattr capability and a feature was
+	 * explicitly requested that requires them.
+	 */
+	if (!config->userxattr && !capable(CAP_SYS_ADMIN)) {
+		if (set.redirect &&
+		    config->redirect_mode != OVL_REDIRECT_NOFOLLOW) {
+			pr_err("redirect_dir requires permission to access trusted xattrs\n");
+			return -EPERM;
+		}
+		if (config->metacopy && set.metacopy) {
+			pr_err("metacopy requires permission to access trusted xattrs\n");
+			return -EPERM;
+		}
+		if (config->verity_mode) {
+			pr_err("verity requires permission to access trusted xattrs\n");
+			return -EPERM;
+		}
+		if (ctx->nr_data > 0) {
+			pr_err("lower data-only dirs require permission to access trusted xattrs\n");
+			return -EPERM;
+		}
+		/*
+		 * Other xattr-dependent features should be disabled without
+		 * great disturbance to the user in ovl_make_workdir().
+		 */
+	}
+
+	if (ctx->nr_data > 0 && !config->metacopy) {
+		pr_err("lower data-only dirs require metacopy support.\n");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 


