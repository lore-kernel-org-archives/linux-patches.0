Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B8023EA97;
	Mon, 23 Mar 2026 14:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277519; cv=none; b=NAIfuACb7B7zUJKxPYZ5QZaee2lFVXgjVwljHsslJAdjjNSd+lsm5ZXrqUmjZNquNhv0tvDKd/R8tL5akKLAlO6c1HypRYAgDRrb2cgEz8mFR/2itB6RUokDlCXaO/bDQqinXmqiAJwkyX4Q5xOqlrZiBkHcgT8X0z0tuXuDKjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277519; c=relaxed/simple;
	bh=vAiIeFlsG+h+wQVoZEjKGfUteplFlZfrnGURm4lLwVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZREBxpTWhWEbNbpgzhlyxuqIOENRUD8qPGS27k9AX3sKERrPn6Bu/hnZyokL+mEcEP8ub1g5Cty7N2vF+Zxw7le9CuoZBeZp2eagSixEzKVGSdKkWD4/zAZZ1B5bZ0PQiohDP46nS8T6upYtunt2ldC5Qq53tzhSQl9q9bE+V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShD/FBFm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShD/FBFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BF7C4CEF7;
	Mon, 23 Mar 2026 14:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277519;
	bh=vAiIeFlsG+h+wQVoZEjKGfUteplFlZfrnGURm4lLwVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShD/FBFmVGTcMkO9zMSBrX6MLU+okmnTcg81eYVFMxO74IXSZd/TomGb2+NRVbXbQ
	 HoyKJk7higIwXzPJekmUWO0yqNCOJu8B2iuepOcUrCtfm1BO8uqIPam6Oif6cgzbdm
	 KthfWNhb9t3z6x7yONyFZD6HnCmlHdByHZpmKJfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/481] btrfs: fix compat mask in error messages in btrfs_check_features()
Date: Mon, 23 Mar 2026 14:39:57 +0100
Message-ID: <20260323134525.619550599@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit 587bb33b10bda645a1028c1737ad3992b3d7cf61 ]

Commit d7f67ac9a928 ("btrfs: relax block-group-tree feature dependency
checks") introduced a regression when it comes to handling unsupported
incompat or compat_ro flags. Beforehand we only printed the flags that
we didn't recognize, afterwards we printed them all, which is less
useful. Fix the error handling so it behaves like it used to.

Fixes: d7f67ac9a928 ("btrfs: relax block-group-tree feature dependency checks")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 52e083b63070d..0ff373022c11f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3356,7 +3356,7 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
 	if (incompat & ~BTRFS_FEATURE_INCOMPAT_SUPP) {
 		btrfs_err(fs_info,
 		"cannot mount because of unknown incompat features (0x%llx)",
-		    incompat);
+		    incompat & ~BTRFS_FEATURE_INCOMPAT_SUPP);
 		return -EINVAL;
 	}
 
@@ -3388,7 +3388,7 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
 	if (compat_ro_unsupp && is_rw_mount) {
 		btrfs_err(fs_info,
 	"cannot mount read-write because of unknown compat_ro features (0x%llx)",
-		       compat_ro);
+		       compat_ro_unsupp);
 		return -EINVAL;
 	}
 
@@ -3401,7 +3401,7 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
 	    !btrfs_test_opt(fs_info, NOLOGREPLAY)) {
 		btrfs_err(fs_info,
 "cannot replay dirty log with unsupported compat_ro features (0x%llx), try rescue=nologreplay",
-			  compat_ro);
+			  compat_ro_unsupp);
 		return -EINVAL;
 	}
 
-- 
2.51.0



