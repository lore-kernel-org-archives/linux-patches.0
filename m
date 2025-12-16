Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F79736D513;
	Tue, 16 Dec 2025 12:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888029; cv=none; b=Uxms13Zlj7Huhkv9ToAMfsDmlvfeHfjdgLcrWqEnPbUb7vKqHw0AcLCTIbBdJ0kMLVE2qzrlbMDqhRnsNWUqnyzY/Pj7/8sGjFwPdW3FDN87QdUfStvIh9F0e5BZ2F+JYQX8+CeAeI+dfnI8wY4Mdhf1/9bLXahUrEK1vkL3Z+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888029; c=relaxed/simple;
	bh=gXWkgOR01DTUO4DOpbwOtjbbmRKcDoR2VhMBgAGacJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXHs7B41P5+cSn+ABKNkf689PsOjT4qxJ1KnguSJ+urPGsb8II8L3X/ouDJckA37TF6ggSkBrg8Cw//8lsbPP6ZYot4ZWQYIdpE5Upnhwz2pFwCI1UFztLXAj1mQQ5j9EKhNWTOEx0GwenLWUlj6YB6X/3cKmTTu1Q0Bdn7nskY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iUpaP2yB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iUpaP2yB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1415EC4CEF1;
	Tue, 16 Dec 2025 12:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888029;
	bh=gXWkgOR01DTUO4DOpbwOtjbbmRKcDoR2VhMBgAGacJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUpaP2yByONwb/FPjQHp2lCZZLeHMZUNtEG9ha73eJBPbHm8+C7p6UMcOr4mQhWE8
	 ArGvk/o/YgL8FDNQgf6IwRMjwU4WSumelYa2uQJkRkI69NY1FcF2Ro2rT7FOJBpUX0
	 BDq/XXNBVTJzBYNOxb7t1G/HRs9yZ76LWO1r25RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 410/614] btrfs: make sure extent and csum paths are always released in scrub_raid56_parity_stripe()
Date: Tue, 16 Dec 2025 12:12:57 +0100
Message-ID: <20251216111416.227546868@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit d435c513652e6a90a13c881986a2cc6420c99cab ]

Unlike queue_scrub_stripe() which uses the global sctx->extent_path and
sctx->csum_path which are always released at the end of scrub_stripe(),
scrub_raid56_parity_stripe() uses local extent_path and csum_path, as
that function is going to handle the full stripe, whose bytenr may be
smaller than the bytenr in the global sctx paths.

However the cleanup of local extent/csum paths is only happening after
we have successfully submitted an rbio.

There are several error routes that we didn't release those two paths:

- scrub_find_fill_first_stripe() errored out at csum tree search
  In that case extent_path is still valid, and that function itself will
  not release the extent_path passed in.
  And the function returns directly without releasing both paths.

- The full stripe is empty
- Some blocks failed to be recovered
- btrfs_map_block() failed
- raid56_parity_alloc_scrub_rbio() failed
  The function returns directly without releasing both paths.

Fix it by covering btrfs_release_path() calls inside the out: tag.

This is just a hot fix, in the long run we will go scoped based auto
freeing for both local paths.

Fixes: 1dc4888e725d ("btrfs: scrub: avoid unnecessary extent tree search preparing stripes")
Fixes: 3c771c194402 ("btrfs: scrub: avoid unnecessary csum tree search preparing stripes")
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ba20d9286a340..65361af302343 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2230,9 +2230,9 @@ static int scrub_raid56_parity_stripe(struct scrub_ctx *sctx,
 	bio_put(bio);
 	btrfs_bio_counter_dec(fs_info);
 
+out:
 	btrfs_release_path(&extent_path);
 	btrfs_release_path(&csum_path);
-out:
 	return ret;
 }
 
-- 
2.51.0



