Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC50224B09;
	Tue, 26 Aug 2025 13:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215202; cv=none; b=RXlKC25573nliMsRW6whqnMHd39MAa2Wdx7NBT1/U0QCgiMD9IMEefburrgONwrF+GWpvAOv9nbKvy8d+i38uqnaYJ+7A+rjxvZokMhszXbdK19Dd1WclgH8R4DPz176kmDuj0HodPzJfzs6SDYQ6glf9oHqfZIwfmaGkUzj1JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215202; c=relaxed/simple;
	bh=NwNPQUlewldiqjQXkyOvDQ7VwfXfRiACkNiBRrrgufw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAKyMF1KTw4noMKr2PzNCRzHyQV+XNPNUyQXX0Q/NIr0XJ77I/XOsCISF3jQRbFL9GhcL6zfn9/v8mOsuN63nUIej1gTBqNR9+2DXAKklvyK/B7epOPoNNdmlCcANJEYjDgIdX2G85eE/YfqqCGlnaC8/0M9xkj3jyHdNkg9rtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxR3+Tkf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxR3+Tkf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B13C4CEF1;
	Tue, 26 Aug 2025 13:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215201;
	bh=NwNPQUlewldiqjQXkyOvDQ7VwfXfRiACkNiBRrrgufw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxR3+TkfBFraWGpr2HvdeZeIWcjVmiWwCkC9jBLzVKLVuXRgRpIG8J6wOuFR6e4Ep
	 9XAioazNZ+mpKStWCoKySgqzfx5c7A8GOP7JxhUAYeS3/j7NOCakryw+4nr5N7rcl/
	 Z3/tBYA2FKj+L4SuYPTUwJPUgDUFosJ/bpjh9Dtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 426/482] ext4: preserve SB_I_VERSION on remount
Date: Tue, 26 Aug 2025 13:11:19 +0200
Message-ID: <20250826110941.353282496@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit f2326fd14a224e4cccbab89e14c52279ff79b7ec ]

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
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1937,6 +1937,9 @@ int ext4_init_fs_context(struct fs_conte
 	fc->fs_private = ctx;
 	fc->ops = &ext4_context_ops;
 
+	/* i_version is always enabled now */
+	fc->sb_flags |= SB_I_VERSION;
+
 	return 0;
 }
 
@@ -5113,9 +5116,6 @@ static int __ext4_fill_super(struct fs_c
 	sb->s_flags = (sb->s_flags & ~SB_POSIXACL) |
 		(test_opt(sb, POSIX_ACL) ? SB_POSIXACL : 0);
 
-	/* i_version is always enabled now */
-	sb->s_flags |= SB_I_VERSION;
-
 	if (ext4_check_feature_compatibility(sb, es, silent))
 		goto failed_mount;
 


