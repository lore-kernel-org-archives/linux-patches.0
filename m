Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5DF3375DC;
	Tue, 26 Aug 2025 11:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207065; cv=none; b=Xc810kNXX+757S1WtHd63lOh3cNGhClSwk2x+XUcx4jOVq8oeFkpnA5rqmJ9vxuw9XY/WVWs0BbzQtUiAgqBHtMoYhdlGxf/8HniTM1atdL4DaoraKC0u6PCAfnlaWo0ephVzu21teu+wkoI0DyxRI6kyM0TQbk+c1HnDr4Kqe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207065; c=relaxed/simple;
	bh=ULJH31bzaTJaExtg7+vRNM+gkj/LJ9duOzOc+MiwPgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAVcO5MYgnScCQ7Pxn/5jPpnN+KNfzd1BN3eccMTlo1Cpob9KtTBjCX7UmCZO2QXp330XZMay85/pyrRuypohyH/A0ZF4k8JRBLjPuR1MJ0vFe/KfudlnGwiTzFbA000qEmRO4wXWaF7bCY/l3kKlD1bAVJyUZf03iXNIwReIeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZTF+J4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZTF+J4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A53C4CEF1;
	Tue, 26 Aug 2025 11:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207065;
	bh=ULJH31bzaTJaExtg7+vRNM+gkj/LJ9duOzOc+MiwPgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZTF+J4IIRQgtGN2YUHObEYpMbdwsA18Yr8S5n1GX6mH6RGpKmFimAiirqDQTfOQl
	 w9aTR+7vf5Er5e1c0iXBzfFZlNOwolcKqndJDjY+oxBKm5d0lwFgPEpExi8H6kYQr3
	 ZqiDXSP1Wk5TIufIyMdJ6DUHH8MBQYar/9t38BY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.16 037/457] ext4: preserve SB_I_VERSION on remount
Date: Tue, 26 Aug 2025 13:05:21 +0200
Message-ID: <20250826110938.261885427@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

commit f2326fd14a224e4cccbab89e14c52279ff79b7ec upstream.

IMA testing revealed that after an ext4 remount, file accesses triggered
full measurements even without modifications, instead of skipping as
expected when i_version is unchanged.

Debugging showed `SB_I_VERSION` was cleared in reconfigure_super() during
remount due to commit 1ff20307393e ("ext4: unconditionally enable the
i_version counter") removing the fix from commit 960e0ab63b2e ("ext4: fix
i_version handling on remount").

To rectify this, `SB_I_VERSION` is always set for `fc->sb_flags` in
ext4_init_fs_context(), instead of `sb->s_flags` in __ext4_fill_super(),
ensuring it persists across all mounts.

Cc: stable@kernel.org
Fixes: 1ff20307393e ("ext4: unconditionally enable the i_version counter")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250703073903.6952-2-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1998,6 +1998,9 @@ int ext4_init_fs_context(struct fs_conte
 	fc->fs_private = ctx;
 	fc->ops = &ext4_context_ops;
 
+	/* i_version is always enabled now */
+	fc->sb_flags |= SB_I_VERSION;
+
 	return 0;
 }
 
@@ -5314,9 +5317,6 @@ static int __ext4_fill_super(struct fs_c
 	sb->s_flags = (sb->s_flags & ~SB_POSIXACL) |
 		(test_opt(sb, POSIX_ACL) ? SB_POSIXACL : 0);
 
-	/* i_version is always enabled now */
-	sb->s_flags |= SB_I_VERSION;
-
 	/* HSM events are allowed by default. */
 	sb->s_iflags |= SB_I_ALLOW_HSM;
 


