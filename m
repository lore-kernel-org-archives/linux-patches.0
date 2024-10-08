Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BC31DEFE5;
	Tue,  8 Oct 2024 12:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390476; cv=none; b=RjnIVnqOQjxAQyyLOuDKPwzGUpor/GekqZJQT8Mw432p1YoJbhJor0MywLsns0JTbWFvnMJcLGr811SuD8vNpukyYF8ghyU67HDkroYqioiB8n6NGgeneH44PIxQqTl1eAfTT8Fb/8IPmDJYRn/+AKDSD5P7mxiagOTzBr/MpPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390476; c=relaxed/simple;
	bh=usEL5loZhOCBYYwQNN5U257hdcN0pM180lSBOLidyCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBKcaQkPmr2Tavb5p4a/iEhuXpq+mxsETuudU1nQLv605vxDiBc4zR1jDVw1ZSuaBIMuoTSwvL4agxvK4f5aNw2Vt65rle7+CeYJp+iWotdnKze2nZKpOmiWvVvPzRPTINi4JjFEhjSlf0QHf4gXPCqDvUe+GO0t7K4Wnc+cAm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQHC/ulp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQHC/ulp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB610C4CEC7;
	Tue,  8 Oct 2024 12:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390476;
	bh=usEL5loZhOCBYYwQNN5U257hdcN0pM180lSBOLidyCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JQHC/ulpXNWcQ486Lp6q5ctdRJaSMBtzZ9cbckNpmM5tQxMaF2ugwRgawOKY0jUXU
	 XQlWAZLgqsnIscDj+wbUE17Z/yc+hWZKaBofAY2Tp77fEzFn2fWqGjb5fbHJYQEPmg
	 DR2FA+bkRakOUQ1/+tG8H+Wk2RynHzLxHj19eQeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Baynton <mike@mbaynton.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.10 301/482] ovl: fail if trusted xattrs are needed but caller lacks permission
Date: Tue,  8 Oct 2024 14:06:04 +0200
Message-ID: <20241008115700.130106809@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -782,11 +782,6 @@ int ovl_fs_params_verify(const struct ov
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
@@ -938,6 +933,39 @@ int ovl_fs_params_verify(const struct ov
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
 


