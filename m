Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2283090C1;
	Sat, 14 Feb 2026 21:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104440; cv=none; b=XoIQs1GM9UbZRnBOpJRk9AZI+nKxIO4Kx0wQWPXAP+upiuaqNsNwTcbla2zjxrQNheRgSmNcpcdcAcxdxjuGJnMlbgLMZYcMimk4wk4ixee18g55VLsFU6NuHvV0sPiDLhIvQiH7/BvD0zarPlxRAGEWNuwTNOI/ZoFt9eEsU78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104440; c=relaxed/simple;
	bh=/m8zK3PiW8NNzPqGAahIzF4NobcHVhxidLRTgi9eIxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FukOh3Cd2hdtS7cQ2gxRawbo9+dGokoe5HX7Gy2Krv9mdVdGxzficBVxnaXUTTo2m6bQWgpAEwc9XhmSDvYGYzg3cpnYiU2AHXNl3OqjC73AcumYwR1RMuxD+QkCNQMgVRoCPniAEVxaLXVRiRqlEld7PCJok35ssMOwo7DQaGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YlsVYqow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YlsVYqow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83146C2BC86;
	Sat, 14 Feb 2026 21:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104440;
	bh=/m8zK3PiW8NNzPqGAahIzF4NobcHVhxidLRTgi9eIxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YlsVYqow2D/KhO85CeQNLc4oRwVmG/WMgbYR33d9Gjjc4ZbVlVHhXILVwta3pfYBx
	 tUzK3US3AUIDiGN2F67ioQKJLLgcA/P4mG8h8BvrIuikb7iTauUCzKuCq4pkp/7c/h
	 JbIfuAdJzT2IcJoFZAt9QlDresqcl1T85Oaoe31NuTpmY0ZcxzfpmlvpBKF6V4VYO0
	 QBjvRjmzYy/LtsGDttZLEtlWnPQH8/tpRmIESSJ617KAmNVUiEECUdtq7/B9X+/bbx
	 VHOpNWqiTMBh842JhT6RCbThJYyyx5ZSdkogZeqwiyLrccfXEIhSLeWEaDP1lSz180
	 B6WGxwYW2pV6Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>,
	Jakub Acs <acsjakub@amazon.de>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	viro@zeniv.linux.org.uk,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] fsnotify: Shutdown fsnotify before destroying sb's dcache
Date: Sat, 14 Feb 2026 16:23:50 -0500
Message-ID: <20260214212452.782265-85-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

[ Upstream commit 74bd284537b3447c651588101c32a203e4fe1a32 ]

Currently fsnotify_sb_delete() was called after we have evicted
superblock's dcache and inode cache. This was done mainly so that we
iterate as few inodes as possible when removing inode marks. However, as
Jakub reported, this is problematic because for some filesystems
encoding of file handles uses sb->s_root which gets cleared as part of
dcache eviction. And either delayed fsnotify events or reading fdinfo
for fsnotify group with marks on fs being unmounted may trigger encoding
of file handles during unmount. So move shutdown of fsnotify subsystem
before shrinking of dcache.

Link: https://lore.kernel.org/linux-fsdevel/CAOQ4uxgXvwumYvJm3cLDFfx-TsU3g5-yVsTiG=6i8KS48dn0mQ@mail.gmail.com/
Reported-by: Jakub Acs <acsjakub@amazon.de>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The function is present and the code structure in the current tree
matches what we see in the diff. This function has been in
`generic_shutdown_super()` for a long time and would exist in all active
stable trees.

### 8. SUMMARY

| Criteria | Assessment |
|----------|-----------|
| Fixes real bug | YES — NULL deref / crash during unmount |
| Obviously correct | YES — simple reorder, reviewed by 2 top
maintainers |
| Small and contained | YES — 1 file, ~6 lines, moving 1 function call |
| No new features | Correct — pure bug fix |
| Risk of regression | Very low — only slight performance impact |
| User impact | HIGH — affects any system with fsnotify watches during
unmount |
| Reported by real user | YES (Jakub Acs) |

This is an excellent stable candidate: a small, well-reviewed fix for a
real crash that affects common operations (filesystem unmount with
inotify/fanotify watches). The fix is trivial to understand (reorder one
function call), reviewed by the subsystem and VFS maintainers, and
carries essentially no risk of regression.

**YES**

 fs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 3d85265d14001..9c13e68277dd6 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -618,6 +618,7 @@ void generic_shutdown_super(struct super_block *sb)
 	const struct super_operations *sop = sb->s_op;
 
 	if (sb->s_root) {
+		fsnotify_sb_delete(sb);
 		shrink_dcache_for_umount(sb);
 		sync_filesystem(sb);
 		sb->s_flags &= ~SB_ACTIVE;
@@ -629,9 +630,8 @@ void generic_shutdown_super(struct super_block *sb)
 
 		/*
 		 * Clean up and evict any inodes that still have references due
-		 * to fsnotify or the security policy.
+		 * to the security policy.
 		 */
-		fsnotify_sb_delete(sb);
 		security_sb_delete(sb);
 
 		if (sb->s_dio_done_wq) {
-- 
2.51.0

