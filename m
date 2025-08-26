Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C80672602;
	Tue, 26 Aug 2025 13:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213217; cv=none; b=DfvZ+LwqLiqVyW1/jcs0GS/UuaKZG43C5XjGKtQ2tqfLJqngjIyxh33WMx/bghiuds5Ny1aW/3iBHxd76gcz236mDW3JFt8LVZP5tHfyTZWO+/ZQ1LtMoBbYTwkRTtO4pAO5q9T4VprcYywEiMJ9V7tN+X6dgtUVognnKleti5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213217; c=relaxed/simple;
	bh=vGWNY5xsIxzQHE3EbLgsuXfMUAEniU5ytXHHyqdxkY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2wA3G+9fzH5FYrupglKcZCmer04qEMJ/M7eWA04+qhy0SxxiQY0k4seVNsCir7uMseVr8M+1qN2PX03O0YzGuEWXbRPlZrNHIMzHyOqk2bSY2nBWpAdQFzB9jyfAI0bJH3RGnJucM+c+ukg7pFEwJyotMaI5lClAbs5yrZp65k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v57ltqhZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v57ltqhZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1AB8C4CEF1;
	Tue, 26 Aug 2025 13:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213217;
	bh=vGWNY5xsIxzQHE3EbLgsuXfMUAEniU5ytXHHyqdxkY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v57ltqhZnyT9bA6yHUAM9lv4ZWoesELZUQKmer+Y/pfFpN0LKyXXR6yHcmeh4ziJX
	 7dK8IKLRw01d+JgUdah5n5aTgtWUsijwpLf9njYyskLv08wsiV3epxIWBOlF02BLjv
	 13QvTLxb4ehMvLPGbNolL4y0tWGsYBfimKOmxPzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Totev <gabriel.totev@zetier.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 265/587] apparmor: shift ouid when mediating hard links in userns
Date: Tue, 26 Aug 2025 13:06:54 +0200
Message-ID: <20250826110959.670380918@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Totev <gabriel.totev@zetier.com>

[ Upstream commit c5bf96d20fd787e4909b755de4705d52f3458836 ]

When using AppArmor profiles inside an unprivileged container,
the link operation observes an unshifted ouid.
(tested with LXD and Incus)

For example, root inside container and uid 1000000 outside, with
`owner /root/link l,` profile entry for ln:

/root$ touch chain && ln chain link
==> dmesg
apparmor="DENIED" operation="link" class="file"
namespace="root//lxd-feet_<var-snap-lxd-common-lxd>" profile="linkit"
name="/root/link" pid=1655 comm="ln" requested_mask="l" denied_mask="l"
fsuid=1000000 ouid=0 [<== should be 1000000] target="/root/chain"

Fix by mapping inode uid of old_dentry in aa_path_link() rather than
using it directly, similarly to how it's mapped in __file_path_perm()
later in the file.

Signed-off-by: Gabriel Totev <gabriel.totev@zetier.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/file.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/file.c b/security/apparmor/file.c
index 6fd21324a097..a51b83cf6968 100644
--- a/security/apparmor/file.c
+++ b/security/apparmor/file.c
@@ -436,9 +436,11 @@ int aa_path_link(const struct cred *subj_cred,
 {
 	struct path link = { .mnt = new_dir->mnt, .dentry = new_dentry };
 	struct path target = { .mnt = new_dir->mnt, .dentry = old_dentry };
+	struct inode *inode = d_backing_inode(old_dentry);
+	vfsuid_t vfsuid = i_uid_into_vfsuid(mnt_idmap(target.mnt), inode);
 	struct path_cond cond = {
-		d_backing_inode(old_dentry)->i_uid,
-		d_backing_inode(old_dentry)->i_mode
+		.uid = vfsuid_into_kuid(vfsuid),
+		.mode = inode->i_mode,
 	};
 	char *buffer = NULL, *buffer2 = NULL;
 	struct aa_profile *profile;
-- 
2.39.5



