Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEE3194A45;
	Tue, 27 May 2025 16:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364683; cv=none; b=mvYbcbraOMJvCDdLo02h7TttenB6J97/g4Ej7OOCYt0lAK2Tw9OaTIX+Uemil8z8bILyO2HQavvv8OEnQBue4VcDbeMdQ/D7qIOQT7mYKv0qEcpf7UVnxBtwpECRE2KsL2u3dv/KVv5ATwF/yLnGSSpke2ssGK/v/UeCU+Gx9lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364683; c=relaxed/simple;
	bh=fuG7qML061f7L8Ak418zwUUiizXbPliBXxLUTicbvko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k0snJDja7zp+Vr1f+wJYxj9zqi5mAJJJlriEi9kdMLmONzSL4tkZSkHXz7rpGrdDSmea3y6gADRkiptc/WoqHV+DKxUazuFtRpNm0Nb9xCOi3GOkUQZ5GM2b5VrPbOe90aOxBsLFE5H0Txxhqbof4r1+MDkpyPSGZJ2nq4Vs99k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CfOXUr9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CfOXUr9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48208C4CEE9;
	Tue, 27 May 2025 16:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364682;
	bh=fuG7qML061f7L8Ak418zwUUiizXbPliBXxLUTicbvko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CfOXUr9LY9FqkY90Hk29NxHyhIjV7olGyQc/FioFITKo26qzqqnr4LUUH8eW6D7po
	 /IaTlMR/TsaOmwZ/q4+N1g0ggVTULDidfWVcNWkObWhZ/Z2uaUP1QKwgM5pOC80f2H
	 A1Oovho8Q8aM4T5UP4vDC1bAfo7rWvN4I8/rB7jA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Serge Hallyn <serge@hallyn.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 133/626] ext4: reorder capability check last
Date: Tue, 27 May 2025 18:20:26 +0200
Message-ID: <20250527162450.434433375@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8042ad8738089..c48fd36b2d74c 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -649,8 +649,8 @@ static int ext4_has_free_clusters(struct ext4_sb_info *sbi,
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



