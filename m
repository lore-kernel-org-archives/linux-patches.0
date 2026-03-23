Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102723AC0EB;
	Mon, 23 Mar 2026 14:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277558; cv=none; b=WZ1jAn4Qx7GRzgOP4knOxIM2RL0aaNavWPi2Qxa4aUrY8ugYH5UtuM5GkNDYACG7aiYUMW4mIdpH5rlh7QZJI6oBu+VWNxgdtGZRw/e/DNo9we3W2TUKO4EoxTXVP6wLal1ZB/8jFHeaUdQXT3ClFN1QkDt0C06gZCGQqG5R7w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277558; c=relaxed/simple;
	bh=I/OyTXMNQcSYJmYMPk1Mc1K//0Uymh+o5e9rSUMsyhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ch59l+hD9w5vY9qXOgxUbgUgxCBPtsfC6xaNcHG+lyJN4gJyufLiSXTmOb8KIdaOFNy6QNlp2ZpAE0lbcu8ucgA8Lvmj48S4GGRHT2rnQdWBcFRGHk7P79h3auRYkMuWYWVgMl+ApMJFbowGK1c4xSWXfMMVns4Jc4j/nuELb/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1GYmL8wP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1GYmL8wP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87337C4CEF7;
	Mon, 23 Mar 2026 14:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277557;
	bh=I/OyTXMNQcSYJmYMPk1Mc1K//0Uymh+o5e9rSUMsyhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1GYmL8wP6WsMwVHuRJeOA6WgUfhTUX6MQNEdfE30a2fMaQDClW0W1PI+cXauxBoTP
	 KW9pld3pSx2aZIbivok9jlhmeBsBtoEJb8QR5xyh/CECnPTEOMcdCynBjKn4fLJFl4
	 Rg0U0v7OUO01HG7lzFyDfy/RAFneB3jSQzHQcB7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/567] btrfs: fix warning in scrub_verify_one_metadata()
Date: Mon, 23 Mar 2026 14:39:03 +0100
Message-ID: <20260323134534.341329936@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit 44e2fda66427a0442d8d2c0e6443256fb458ab6b ]

Commit b471965fdb2d ("btrfs: fix replace/scrub failure with
metadata_uuid") fixed the comparison in scrub_verify_one_metadata() to
use metadata_uuid rather than fsid, but left the warning as it was. Fix
it so it matches what we're doing.

Fixes: b471965fdb2d ("btrfs: fix replace/scrub failure with metadata_uuid")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 3338e2e7a9a02..d2d2548eea05a 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -635,7 +635,7 @@ static void scrub_verify_one_metadata(struct scrub_stripe *stripe, int sector_nr
 		btrfs_warn_rl(fs_info,
 		"tree block %llu mirror %u has bad fsid, has %pU want %pU",
 			      logical, stripe->mirror_num,
-			      header->fsid, fs_info->fs_devices->fsid);
+			      header->fsid, fs_info->fs_devices->metadata_uuid);
 		return;
 	}
 	if (memcmp(header->chunk_tree_uuid, fs_info->chunk_tree_uuid,
-- 
2.51.0



