Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFE2401A06;
	Thu, 12 Mar 2026 20:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346416; cv=none; b=ZrLMNZgxugULwaLWgNGEem+F0yWsAUzEaCctk8QwVZjJPw41mnrEkpq7iTlWcozUCBaf9A/4Fl7KWsn9kQD79JaTXHGqb3ZPekoY1Jlxeqw1r0x3Ob/tSPBZIMJ/Tmf18PEDzWJStbNaCrsopXEhLbfjYANwLlTksmGkigzYMTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346416; c=relaxed/simple;
	bh=FW1FfyjN0FiVx2jqt4SaopeLo2ais/d06ij3o6NL8UI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFsEznC/TKCMuMF/hYejy6/HpmR7gcARFGiLjpHmJYD6JTIsc8Li4lFWm8+VWhbFmXKDETzD+Wpb44yIYvgBZrp2k9VMrZzHyoCJSDGL41PxnejCKf59hHtMRLVKvEX0EKobhwh0F+hvqFhPNrgcZeP8h/Jrs4ZAvG0nsZaIX3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGB3ewlT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGB3ewlT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E246C2BC86;
	Thu, 12 Mar 2026 20:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346416;
	bh=FW1FfyjN0FiVx2jqt4SaopeLo2ais/d06ij3o6NL8UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGB3ewlTGv0gzeBxdFSYIrXJaDTxEahvssbsPa8Sei4XJF28uX2jl68a8BY7soUBW
	 qhFiHRGIHyNfSj0/0WLcQ0cYVulPb9KhaFrc5Apcdw1XIbWwTllvEw2H9KmWLvKuTL
	 GkhsqMUZMtihHMev0RCnplOoo8Jg9tP6zpxFI/ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/265] btrfs: fix compat mask in error messages in btrfs_check_features()
Date: Thu, 12 Mar 2026 21:07:04 +0100
Message-ID: <20260312201019.533630615@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 034cd7b1d0f5f..fa4d22f6f29d7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3119,7 +3119,7 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
 	if (incompat & ~BTRFS_FEATURE_INCOMPAT_SUPP) {
 		btrfs_err(fs_info,
 		"cannot mount because of unknown incompat features (0x%llx)",
-		    incompat);
+		    incompat & ~BTRFS_FEATURE_INCOMPAT_SUPP);
 		return -EINVAL;
 	}
 
@@ -3151,7 +3151,7 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
 	if (compat_ro_unsupp && is_rw_mount) {
 		btrfs_err(fs_info,
 	"cannot mount read-write because of unknown compat_ro features (0x%llx)",
-		       compat_ro);
+		       compat_ro_unsupp);
 		return -EINVAL;
 	}
 
@@ -3164,7 +3164,7 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
 	    !btrfs_test_opt(fs_info, NOLOGREPLAY)) {
 		btrfs_err(fs_info,
 "cannot replay dirty log with unsupported compat_ro features (0x%llx), try rescue=nologreplay",
-			  compat_ro);
+			  compat_ro_unsupp);
 		return -EINVAL;
 	}
 
-- 
2.51.0



