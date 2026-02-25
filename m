Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C844A2D73BE;
	Wed, 25 Feb 2026 06:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002767; cv=none; b=QwfLVnSH2CxNRogk1oAT5Q+kvhMRSrc0ExSz2PTR0V1tJ6gsdAG6Z2dOmGUWgK6nFFv/ykY5a2gKt+Q0JfyvNkmBaFhEcfPhl6UtjGFgUKtWkQ0CglAagnXgXtO8a7I4cBtRpMYMKmPBMPeHy/qMirTQj/DtXj3tGH73e2r4n7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002767; c=relaxed/simple;
	bh=zS9HUu7/zYuBJ8mXCTvHr3FvfDIQcx/PBPauXKb/hnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afX+TRCQg5MpNW3e/aJL06eQRYkTdQP+weMG24kUy/ozLNyBhaHW55ghBmThmaKItyTdyAYuxs8v2QL10zOpEx70RgUu41rWe18h319RfEJCPb4dMfMt6rlLg9kBJqgMnqoofO1+DjhgCoF1DPqUqKIcQcT3/2mn77ieG5bycIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7xQt6N+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7xQt6N+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11B4C116D0;
	Wed, 25 Feb 2026 06:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002767;
	bh=zS9HUu7/zYuBJ8mXCTvHr3FvfDIQcx/PBPauXKb/hnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7xQt6N+STBuyxcG3rInHxdL9noiB//pc48+xXDvIz1QwQlvY+N5zGxsUF/a5RMEp
	 J5ie+rSTS8gCLLZlTSsudlvQYga57BrKKOLqyVHbZRST8Rojd/HXr+OEOQBeWmWJdT
	 v+nPKWtJ6b6hzBHrNmjkhn6+MMWESd6CoMQEelPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 571/641] apparmor: move check for aa_null file to cover all cases
Date: Tue, 24 Feb 2026 17:24:57 -0800
Message-ID: <20260225012402.356666330@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 4a134723f9f1ad2f3621566259db673350d19cb1 ]

files with a dentry pointing aa_null.dentry where already rejected as
part of file_inheritance. Unfortunately the check in
common_file_perm() is insufficient to cover all cases causing
unnecessary audit messages without the original files context.

Eg.
[ 442.886474] audit: type=1400 audit(1704822661.616:329): apparmor="DENIED" operation="file_inherit" class="file" namespace="root//lxd-juju-98527a-0_<var-snap-lxd-common-lxd>" profile="snap.lxd.activate" name="/apparmor/.null" pid=9525 comm="snap-exec"

Further examples of this are in the logs of
https://bugs.launchpad.net/ubuntu/+source/apparmor/+bug/2120439
https://bugs.launchpad.net/ubuntu/+source/snapd/+bug/1952084
https://bugs.launchpad.net/snapd/+bug/2049099

These messages have no value and should not be sent to the logs.
AppArmor was already filtering the out in some cases but the original
patch did not catch all cases. Fix this by push the existing check
down into two functions that should cover all cases.

Link: https://bugs.launchpad.net/ubuntu/+source/apparmor/+bug/2122743
Fixes: 192ca6b55a86 ("apparmor: revalidate files during exec")
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/file.c | 12 ++++++++++--
 security/apparmor/lsm.c  |  4 ----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/security/apparmor/file.c b/security/apparmor/file.c
index 919dbbbc87ab6..7de23e85cd5d0 100644
--- a/security/apparmor/file.c
+++ b/security/apparmor/file.c
@@ -154,8 +154,12 @@ static int path_name(const char *op, const struct cred *subj_cred,
 	const char *info = NULL;
 	int error;
 
-	error = aa_path_name(path, flags, buffer, name, &info,
-			     labels_profile(label)->disconnected);
+	/* don't reaudit files closed during inheritance */
+	if (unlikely(path->dentry == aa_null.dentry))
+		error = -EACCES;
+	else
+		error = aa_path_name(path, flags, buffer, name, &info,
+				     labels_profile(label)->disconnected);
 	if (error) {
 		fn_for_each_confined(label, profile,
 			aa_audit_file(subj_cred,
@@ -616,6 +620,10 @@ int aa_file_perm(const char *op, const struct cred *subj_cred,
 	AA_BUG(!label);
 	AA_BUG(!file);
 
+	/* don't reaudit files closed during inheritance */
+	if (unlikely(file->f_path.dentry == aa_null.dentry))
+		return -EACCES;
+
 	fctx = file_ctx(file);
 
 	rcu_read_lock();
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 5fc99fe8d38a4..be3678d08ed23 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -524,10 +524,6 @@ static int common_file_perm(const char *op, struct file *file, u32 mask)
 	struct aa_label *label;
 	int error = 0;
 
-	/* don't reaudit files closed during inheritance */
-	if (unlikely(file->f_path.dentry == aa_null.dentry))
-		return -EACCES;
-
 	label = begin_current_label_crit_section();
 	error = aa_file_perm(op, current_cred(), label, file, mask, false);
 	end_current_label_crit_section(label);
-- 
2.51.0



