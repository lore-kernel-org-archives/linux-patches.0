Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1AB4F3EC3;
	Thu, 17 Sep 2026 17:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665507; cv=none; b=dSa/J9U/rFG7UBhs27z2xS/h7jVHcy0epsem+MweuBK3PMkvTp2MWLeUwHS3gOQosJ1k9fN6fFS0Kr7F2736ZD1bRJ/QpuXlrwoqndRyKxFOTuzO1Q2XrOWqe3U5PO5KoTPQWlZtvHAMdG6gy6cEe9DB9z+wn+ggAy/Y8xRGDS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665507; c=relaxed/simple;
	bh=438msc05L9f54CYBFdxM0Ypc8ZjNQZCuzR6cZI+ZLoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2050wMqE5rgqrZVrZgEFdVFTWifd40YquzLDbLjpDZxh4uADtfQhVB/o3Hr8fTKPByj2z4k9alXIdxNUt9lCADp9PhD7thHduLLwpVGv5S38sFMJjFBvySiO2grNZHiAbceMXQdPAGAE2jw6apKrEAu89qtDylzW2eCVUcqn84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMBgD4T5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMBgD4T5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD911F000FF;
	Thu, 17 Sep 2026 17:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665506;
	bh=jIYZdhlrG9DIj6CL0PGteqfMEjFNxp7oJmIbZvBFKoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oMBgD4T5f6eesEDRfQDb2yWx/Cw1B+bRgusWiD3pfLCL7VXuKTG7CnSqWFQ4utu3j
	 eo0AwOcP6/dYhR145Mgx8y2NCivth8drv7mHvQSQKoxjXbKGq6sL5uKZOrDSMfmA7I
	 5nQ/kaP18iWJp4+SgqKJx8gx8fSADKzXYHrpyTl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0726/1250] btrfs: return proper negative error code for update_raid_extent_item()
Date: Thu, 17 Sep 2026 16:08:41 +0100
Message-ID: <20260917151611.568003504@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

[ Upstream commit a03fa65184545837d6461413275da71f30527385 ]

The function btrfs_abort_transaction() only accepts negative error code,
and have the macro VERIFY_NEGATIVE_ERROR() to verify that error code.

But inside update_raid_extent_item(), if there is such key found, we
return 1, breaking the negative error code scheme.

Furthermore if we hit some real error during the tree search, e.g. -EIO,
then the error code is always over-written to -EINVAL.

Fix both problems by following other call sites by overwriting @ret to
-ENOENT if the btrfs_search_slot() failed to locate the key.

This is very unlikely to hit, as we only enter update_raid_extent_item()
if there is a conflicting key already in the raid stripe tree.

This was reported by Sashiko when reviewing another patch.

Link: https://sashiko.dev/#/patchset/20260817021512.3010812-1-shuangpeng.kernel%40gmail.com
Fixes: 8c4cba2adbb0 ("btrfs: update stripe extents for existing logical addresses")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/raid-stripe-tree.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index e3aaf8dc32151..d31b292600473 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -279,8 +279,10 @@ static int update_raid_extent_item(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_search_slot(trans, trans->fs_info->stripe_root, key, path,
 				0, 1);
-	if (ret)
-		return (ret == 1 ? ret : -EINVAL);
+	if (ret > 0)
+		ret = -ENOENT;
+	if (ret < 0)
+		return ret;
 
 	leaf = path->nodes[0];
 	slot = path->slots[0];
-- 
2.53.0



