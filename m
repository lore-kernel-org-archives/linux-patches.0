Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4F530F554;
	Mon, 13 Oct 2025 15:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368846; cv=none; b=IaCw+St78QVoKi8y7C8N+Z0UvDhxwcayTNmGm9bzpr91RHatzAvB7t1o82jk+FayZ2jQggGC/WpJDWOSol7JRhmc59Gg2Pl6hYdV48/GWalwQ4HAamb2mG5LbAGRbrxCpfjmgA3jtTiqW41pLIklYAPGiPs23uHqeLhRi9NOW/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368846; c=relaxed/simple;
	bh=yfF4lUL1SD2NaE1r33GQR3rEGbk/jEgmr58HY8dDqbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eabMfLAkkWbpDvPbQ8KK1Ax8D2Ol4m/Hl3xzUVtCpesusDHpjkyViMFDAuO2/dhU/Hc2uCKxSRDw1lganztdqAzv8ckzkHpLlPZjgI+ZSgeobFmQ09RGdmjzN19vCDrbQsvRYbmQ1BmIZ4/79wYch38lbk69zqF/ydW6CiW+ijQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PGv8XRL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PGv8XRL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34233C4CEE7;
	Mon, 13 Oct 2025 15:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368846;
	bh=yfF4lUL1SD2NaE1r33GQR3rEGbk/jEgmr58HY8dDqbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PGv8XRL5nnr/sMLjjBxQT69EYzn3Qsoz7qc5vvLNFxw/sMfKdgy2SlmnYXT3vNxrX
	 UoUxFM4tlsltYp4pxU21J/s/ioxVnilvK1sqGpsGZ2r+pTSrezSX1aKopOnO6HAUK+
	 eN60pUL9njLiwruKw3r6j+aywTPJQPpnmPpAZvg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vacek <neelx@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 039/563] btrfs: return any hit error from extent_writepage_io()
Date: Mon, 13 Oct 2025 16:38:20 +0200
Message-ID: <20251013144412.707084013@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 2d83ed6c6c4607b42ee7927e92a9d2fa31d6f30b ]

Since the support of bs < ps support, extent_writepage_io() will submit
multiple blocks inside the folio.

But if we hit error submitting one sector, but the next sector can still
be submitted successfully, the function extent_writepage_io() will still
return 0.

This will make btrfs to silently ignore the error without setting error
flag for the filemap.

Fix it by recording the first error hit, and always return that value.

Fixes: 8bf334beb349 ("btrfs: fix double accounting race when extent_writepage_io() failed")
Reviewed-by: Daniel Vacek <neelx@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b21cb72835ccf..4eafe3817e11c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1621,7 +1621,7 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	unsigned long range_bitmap = 0;
 	bool submitted_io = false;
-	bool error = false;
+	int found_error = 0;
 	const u64 folio_start = folio_pos(folio);
 	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
 	u64 cur;
@@ -1685,7 +1685,8 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 			 */
 			btrfs_mark_ordered_io_finished(inode, folio, cur,
 						       fs_info->sectorsize, false);
-			error = true;
+			if (!found_error)
+				found_error = ret;
 			continue;
 		}
 		submitted_io = true;
@@ -1702,11 +1703,11 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 	 * If we hit any error, the corresponding sector will have its dirty
 	 * flag cleared and writeback finished, thus no need to handle the error case.
 	 */
-	if (!submitted_io && !error) {
+	if (!submitted_io && !found_error) {
 		btrfs_folio_set_writeback(fs_info, folio, start, len);
 		btrfs_folio_clear_writeback(fs_info, folio, start, len);
 	}
-	return ret;
+	return found_error;
 }
 
 /*
-- 
2.51.0



