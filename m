Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132D147F4A;
	Fri,  8 Aug 2025 15:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754667058; cv=none; b=j/+R8/rGcD6m1hROoHn4XXEeJQTr4LwAWG01GFtZl0dAg8I9XuFQxLBaLS1eePR/dzJWBQUg/HYYvw/C6iTBDbuAFyPM4+8YLuTYV4RVUkzAEU090MhYOJiq80FB7AJAYExZIAJ0nzXr5bDPek8tAMVtQjiVXK88uGK+2ttqzOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754667058; c=relaxed/simple;
	bh=YtrGzm5yiceF78BTCwavoTgYZNPgRSH63nxxWFgy67s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aSCVBJxJ0j7sIpjXw0KTExI7E3NicYiIPdBXA6c41eJO2d7dbSd5Cw1t72PW6qRPGLIwa34lemU54LLrEtQVvaX2Px/9GlYsAOrScZhKifuggH2nz1/OL/adW5/BGTUn+poYvjavOUDvr8LOe7Ps2JULwB2c3DfSirrspQBU+iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GD+k+lpe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GD+k+lpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB241C4CEED;
	Fri,  8 Aug 2025 15:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754667057;
	bh=YtrGzm5yiceF78BTCwavoTgYZNPgRSH63nxxWFgy67s=;
	h=From:To:Cc:Subject:Date:From;
	b=GD+k+lpe/uN94Oc7rfAx/IPPnJ/nNb9GqgrVEZvMS2ZSB5yv1uBmiuuS9niSEcHAg
	 jLLBojhoslEBULhfggvyEKEGN2eiJrVEGeMvjsLwXYaA//MTnfbq1i4TvMN/YTx3qK
	 TXaO/W4yS5DAErSM84IqfETxc3ERarc74bTX4vv5SqE2E4iBoLcfRyk6T/L+Dm0QKo
	 /5mPuBRK1v9xpzrHWSsjVT5tZlMGAlN+hKSPdjpiCu6CZCqLhbkS1DB2Yvr+vIYJB7
	 yl6c9yypaKOjQ/25we8xATgzLQpkaQ9ltCrA1Yx7bu7fpbd1lUELCTIBqnQ7oi7Nmn
	 QMGQLvvOApKpA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gabriel Totev <gabriel.totev@zetier.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>,
	apparmor@lists.ubuntu.com
Subject: [PATCH AUTOSEL 6.16-6.6] apparmor: shift ouid when mediating hard links in userns
Date: Fri,  8 Aug 2025 11:30:41 -0400
Message-Id: <20250808153054.1250675-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Clear Bug Fix**: This fixes a real bug where AppArmor incorrectly
   reports the unshifted uid when mediating hard link operations inside
   user namespaces/containers. The commit message provides a concrete
   example showing ouid=0 instead of the expected ouid=1000000 in
   container logs.

2. **Security Impact**: This is a security-relevant bug that causes
   AppArmor policy enforcement to behave incorrectly in containerized
   environments. The owner-based AppArmor rules (like `owner /root/link
   l,`) won't work correctly because the uid comparison is done with the
   wrong (unshifted) value.

3. **Minimal and Contained Fix**: The change is small and surgical - it
   only modifies the aa_path_link() function to properly map the inode
   uid through the mount's idmapping, following the exact same pattern
   already used in __file_path_perm():
   - Uses `i_uid_into_vfsuid(mnt_idmap(target.mnt), inode)` to get the
     vfsuid
   - Converts it back with `vfsuid_into_kuid(vfsuid)` for the path_cond
     structure

4. **No New Features or Architecture Changes**: This is purely a bug fix
   that makes aa_path_link() consistent with how __file_path_perm()
   already handles uid mapping. No new functionality is added.

5. **Container/User Namespace Compatibility**: With the widespread use
   of containers (LXD, Incus, Docker with userns), this bug affects many
   production systems. The fix ensures AppArmor policies work correctly
   in these environments.

6. **Low Risk**: The change follows an established pattern in the
   codebase (from __file_path_perm) and only affects the specific case
   of hard link permission checks in user namespaces. The risk of
   regression is minimal.

7. **Clear Testing**: The commit message indicates this was tested with
   LXD and Incus containers, showing the issue is reproducible and the
   fix validated.

The code change is straightforward - replacing direct access to
`d_backing_inode(old_dentry)->i_uid` with proper idmapping-aware
conversion that respects user namespace uid shifts. This makes
aa_path_link() consistent with other AppArmor file operations that
already handle idmapped mounts correctly.

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

