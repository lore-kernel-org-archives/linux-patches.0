Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235EA1E5724;
	Wed,  8 Apr 2026 18:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672026; cv=none; b=CmE3/KQEbOC4BMeG0bDqYZwzzfvjvRAGj64v+b6ZKuCEnxi6p2q9swd1cjJ7gjMaE6xKVmZaqNeeXdpfdqpC5nIQkTqL+rPMWB0GgcJ6t+bP2zIP/3p9YYumh463QgYl7FdCAQyirZyDKcfxlgpPcQk5K58i+e4gciyEvohouIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672026; c=relaxed/simple;
	bh=GHccGmZOwDib1/wAUDnYj8Pu5cQDXB+83+GaXtkNnJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOyIEd+WYlEpJFoCuu/lt42h1Zv7w5Q7ZrRLMT6BJEAGp+QVECjg9vSb8uIzdE2Mw097K7o6YPJSbZAvDPgIu38yV+gqIA0mW0EMzbpFTLfZrZy4ddEZs6akqSzmGpC3bQ8jwEzJTELcq5YY3BoTJq8siwJPzF5UkhK0QGWGaVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yodcgCJo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yodcgCJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5D3C19421;
	Wed,  8 Apr 2026 18:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672026;
	bh=GHccGmZOwDib1/wAUDnYj8Pu5cQDXB+83+GaXtkNnJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yodcgCJoaSMkPjf0Hb/wEPsyGrudrYiqRDHYNL1NImvt/flF2QenBaZ1Hx8mjOuW4
	 CRBGFOcpxkaS3L+750G4sJduDF6PJag8h0G49nLb0OhpSb5jKVxYT+NPdd70y/E+8Y
	 pty7DnZrST7ugG0IHoMZJbkwZiKGEBnAIz4mpYhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/312] btrfs: fix super block offset in error message in btrfs_validate_super()
Date: Wed,  8 Apr 2026 20:00:45 +0200
Message-ID: <20260408175938.552926938@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

[ Upstream commit b52fe51f724385b3ed81e37e510a4a33107e8161 ]

Fix the superblock offset mismatch error message in
btrfs_validate_super(): we changed it so that it considers all the
superblocks, but the message still assumes we're only looking at the
first one.

The change from %u to %llu is because we're changing from a constant to
a u64.

Fixes: 069ec957c35e ("btrfs: Refactor btrfs_check_super_valid")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index cf124944302f1..203ff9bbad431 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2759,8 +2759,8 @@ int btrfs_validate_super(struct btrfs_fs_info *fs_info,
 
 	if (mirror_num >= 0 &&
 	    btrfs_super_bytenr(sb) != btrfs_sb_offset(mirror_num)) {
-		btrfs_err(fs_info, "super offset mismatch %llu != %u",
-			  btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
+		btrfs_err(fs_info, "super offset mismatch %llu != %llu",
+			  btrfs_super_bytenr(sb), btrfs_sb_offset(mirror_num));
 		ret = -EINVAL;
 	}
 
-- 
2.53.0



