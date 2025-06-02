Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBC422C32D;
	Mon,  2 Jun 2025 14:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873259; cv=none; b=ESFRdtt0X0rLhBqXyp8n7mhCSS22UYVO1gPl5xepfcYpDDOtMElvhj7Q78XDIl654h/DsTeDFrqOWNPDX7fzViM2fKFl2DMTIwACXVr+Oe/NiPPOzCT4wHpv0Ei+eSkaElvZWYNVrRudR2RJL6TKxSBVf48INLspxKCEWUNSiyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873259; c=relaxed/simple;
	bh=l3n3qbyvR4FSZT1aEyVrJx8o3uezckgwqKspCy+Y+aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IgB193XzznmP6U2ojYxpZ33pUAKhA6LnIQzskCfnWhNVoV+orMTMy2dJ18Zv6i/flsrI3o1JjXISn4fI4raL0gfh0/KWiuAz4Q+FcoVROLR/QDEifJZasr+HfyblV4/Yt1NPe5EvckFUDOBqlas5t6DqTVNKWLkCETBxHB/Z568=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gt3/S+8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gt3/S+8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C65C4CEEB;
	Mon,  2 Jun 2025 14:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873258;
	bh=l3n3qbyvR4FSZT1aEyVrJx8o3uezckgwqKspCy+Y+aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gt3/S+8hDNxZUEUS4+uvVvHgk9+ZBxQsyXBxk653lhOp5elUhEE8ULh7f/r4A9lKf
	 y7EJ/YJhDoOE0GoroTgaLVBphWbSy2U6ZV2B5Ic0d0Z9gWow5TE2bKzdSG8Tp/JcbV
	 PbcmXti4p8AwatFt4Z1GsSrvY8Bvo081cMG5uht4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Serge Hallyn <serge@hallyn.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/444] ext4: reorder capability check last
Date: Mon,  2 Jun 2025 15:42:30 +0200
Message-ID: <20250602134344.387416541@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

From: Christian Göttsche <cgzones@googlemail.com>

[ Upstream commit 1b419c889c0767a5b66d0a6c566cae491f1cb0f7 ]

capable() calls refer to enabled LSMs whether to permit or deny the
request.  This is relevant in connection with SELinux, where a
capability check results in a policy decision and by default a denial
message on insufficient permission is issued.
It can lead to three undesired cases:
  1. A denial message is generated, even in case the operation was an
     unprivileged one and thus the syscall succeeded, creating noise.
  2. To avoid the noise from 1. the policy writer adds a rule to ignore
     those denial messages, hiding future syscalls, where the task
     performs an actual privileged operation, leading to hidden limited
     functionality of that task.
  3. To avoid the noise from 1. the policy writer adds a rule to permit
     the task the requested capability, while it does not need it,
     violating the principle of least privilege.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Reviewed-by: Serge Hallyn <serge@hallyn.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250302160657.127253-2-cgoettsche@seltendoof.de
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/balloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 396474e9e2bff..3a2dfc59fb40f 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -641,8 +641,8 @@ static int ext4_has_free_clusters(struct ext4_sb_info *sbi,
 	/* Hm, nope.  Are (enough) root reserved clusters available? */
 	if (uid_eq(sbi->s_resuid, current_fsuid()) ||
 	    (!gid_eq(sbi->s_resgid, GLOBAL_ROOT_GID) && in_group_p(sbi->s_resgid)) ||
-	    capable(CAP_SYS_RESOURCE) ||
-	    (flags & EXT4_MB_USE_ROOT_BLOCKS)) {
+	    (flags & EXT4_MB_USE_ROOT_BLOCKS) ||
+	    capable(CAP_SYS_RESOURCE)) {
 
 		if (free_clusters >= (nclusters + dirty_clusters +
 				      resv_clusters))
-- 
2.39.5



