Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A3A26E6FA;
	Wed, 25 Feb 2026 01:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983656; cv=none; b=UBegpfNKgvEh7fbCvRXkeABXHxa5hZtTSIhCXSpiY0KmZgIeCssD5JeWTlCNl4Dh6b7vJVul7tauke9jd3VvVXKJVwCTqPJJ13ePSMytojpgrL+UIup97Z1BiCF3ljqBCa1oLm8IKf433S/IXta7Jz5wbeX6l+2Qy/0/+O4yldQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983656; c=relaxed/simple;
	bh=OM3dI5QGDlCIDg1gIFGpw4pUnxGrncGnhJwd9UlFB2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SnGKv3wOI0MY4DPAhh2R6DN8uuJX4siy/jEDR+W++/fdSzMKnvCnqwqUucy+Lg7CA81hxhKDpOPlqXh/t/2HpyeJFQICCoNwgHnFdKzDzrkQh4BJ1W3B4X1KvP7LAbSxtuYVvKAMCrHESOuuGbeY+bjr9CgpllTNZD5ur0Hiwm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVIQj3rJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVIQj3rJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C580C116D0;
	Wed, 25 Feb 2026 01:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983656;
	bh=OM3dI5QGDlCIDg1gIFGpw4pUnxGrncGnhJwd9UlFB2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVIQj3rJwiUF8HXWiLflq3kcS900iC6ub7v/bcr1Evdl1AOSeqES5/+msbiQ/cQVC
	 1mmsSIx8ggtviNKlFVZj1I7MSpMQexgRJfJ0XFR70E5yP7i/e2WGaFVInouxMs4t/w
	 eoVL2c/q2zS7HA/IejwkbHxKlL3GuqSZAHQWsNoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 699/781] apparmor: move check for aa_null file to cover all cases
Date: Tue, 24 Feb 2026 17:23:28 -0800
Message-ID: <20260225012416.900869347@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index f47d60d8c40a2..8d5d9a966b719 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -525,10 +525,6 @@ static int common_file_perm(const char *op, struct file *file, u32 mask)
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



