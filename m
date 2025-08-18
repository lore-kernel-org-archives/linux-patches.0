Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED591318126;
	Mon, 18 Aug 2025 13:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522599; cv=none; b=I+EXqtts1I0Ra5Bqwhx8YsMY58zlJZuSuC+Hccm3EK9zug9JrSNvyinUsdgjo1EIbYqgUmdD/1myE90VSMX3G7K4f/WO/20+KJFbvEgrNiQJps4UGFSShQEpFOf6paHZ+7J4eWRCdfVcf32VwRDRumQZKvcspWQDr/+44xcq95s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522599; c=relaxed/simple;
	bh=v7rLKxRfXL446stmEKcyOTrj965HoK+mRhf27+d1eI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzjBNiGMOWAp+bLhiD3yGcvdJyk2y2S/v0i6PXegOg3+Xr0jxgd5W/7IPX0fftFc9pUcOrKr/6QT6/iOjix7/Ihw3Pk+oHduKIdzIn+eyjBJnpZP49HV7Q1l7Nq1Do8eictIdKNVc5q7Um+MmX3Cz7JQazEM5TBPdQFlIrgBrAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ToMpBaB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ToMpBaB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC11C4CEEB;
	Mon, 18 Aug 2025 13:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522598;
	bh=v7rLKxRfXL446stmEKcyOTrj965HoK+mRhf27+d1eI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ToMpBaB2psmIskbH2S4OHVgkHTdtxdjWuOWcohTDqunUCeEjasLn58voWcernjYr/
	 Vcr54LlGp2JIXAEd8XZczcEShmtiiAX1hJd1lrLDuye/FpfSMZglJvqkLSMsX20WvV
	 VUHxholg3X2KuDrw+XpHJD/YKB4fR2FPv7/V+EiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Totev <gabriel.totev@zetier.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 331/444] apparmor: shift ouid when mediating hard links in userns
Date: Mon, 18 Aug 2025 14:45:57 +0200
Message-ID: <20250818124501.348388958@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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
index d52a5b14dad4..62bc46e03758 100644
--- a/security/apparmor/file.c
+++ b/security/apparmor/file.c
@@ -423,9 +423,11 @@ int aa_path_link(const struct cred *subj_cred,
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



