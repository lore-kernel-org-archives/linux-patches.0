Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5FB3D7D74;
	Wed, 20 May 2026 16:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294399; cv=none; b=B4TYD0FWnlpWbidZd9AMCOOzP0BeIWRu5WBks0giqmYjL95c2e649lxA5ORO4Az57uDKoLdGwuPZfoD+tcZz9uaPiZz44KMlY1CB1xa17WQ1+wsfWzxWM62lMGD9OrWXKAlc/njyyEnKwabKEPwilwZAaYuhy1LR5HZJnYNuYsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294399; c=relaxed/simple;
	bh=nY18PQg1p99w/BpcQU5MeEHrpmyMa+aqAqyNTzAivdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H9Il3KW5SulaiUOg+2FDYkqZts1WWUhY9Kr5Jqb/xlKd8k5BNOkLUus8Z2F31SJRCI6EYrwqZKW6V1v9tXHSz547FXbDERo5Rp64EG7r8MFzprtUCFHOnV9zqM/UKJkIZFF/q996ZWECB4WCWneQr0UduyoO157KIt55w+iTu00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kyAhvJHd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kyAhvJHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5AC1F00893;
	Wed, 20 May 2026 16:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294397;
	bh=quka+qpBxcYUjoIwnTvQu+xjHZzbwLnB7tvWl6Fgqq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kyAhvJHd6pKJTaOslaCuTtqP5ikGubIYY5vxHvr8gVBZBUfTqhKI4SgJaguJIsIAE
	 3zNT7rJuw6Zh5nXpuukhFFI4GMglsZnALbM7I60se7P0PcN1O5hR6xdwskwIyxk+xe
	 Ii/Pw1gFJOT9/mcl0SlS26eMTSAJIlgV1B3waljA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jaron=20Vi=C3=ABtor?= <jaron@vietors.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0024/1146] btrfs: do not reject a valid running dev-replace
Date: Wed, 20 May 2026 18:04:34 +0200
Message-ID: <20260520162148.932175461@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 3c0c45a4dff73845ba93d41365fc14e45ee32bd7 ]

[BUG]
There is a bug report that a btrfs with running dev-replace got rejected
with the following messages:

  BTRFS error (device sdk1): devid 0 path /dev/sdk1 is registered but not found in chunk tree
  BTRFS error (device sdk1): remove the above devices or use 'btrfs device scan --forget <dev>' to unregister them before mount
  BTRFS error (device sdk1): open_ctree failed: -117

[CAUSE]
The tree and super block dumps show the fs is completely sane, except
one thing, there is no dev item for devid 0 in chunk tree.

However this is not a bug, as we do not insert dev item for devid 0 in
the first place.
Since the devid 0 is only there temporarily we do not really need to
insert a dev item for it and then later remove it again.

It is the commit 34308187395f ("btrfs: add extra device item checks at
mount") adding a overly strict check that triggers a false alert and
rejected the valid filesystem.

[FIX]
Add a special handling for devid 0, and doesn't require devid 0 to
have a device item in chunk tree.

Reported-by: Jaron Viëtor <jaron@vietors.com>
Link: https://lore.kernel.org/linux-btrfs/CAF1bhLVYLZvD=j2XyuxXDKD-NWNJAwDnpVN+UYeQW-HbzNRn1A@mail.gmail.com/
Fixes: 34308187395f ("btrfs: add extra device item checks at mount")
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6b8e810a35ce1..fd400fbc654d9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -8457,7 +8457,12 @@ bool btrfs_verify_dev_items(const struct btrfs_fs_info *fs_info)
 
 	mutex_lock(&uuid_mutex);
 	list_for_each_entry(dev, &fs_info->fs_devices->devices, dev_list) {
-		if (!test_bit(BTRFS_DEV_STATE_ITEM_FOUND, &dev->dev_state)) {
+		/*
+		 * Replace target dev item (devid 0) is not inserted into chunk tree.
+		 * So skip the DEV_STATE_ITEM check.
+		 */
+		if (dev->devid != BTRFS_DEV_REPLACE_DEVID &&
+		    !test_bit(BTRFS_DEV_STATE_ITEM_FOUND, &dev->dev_state)) {
 			btrfs_err(fs_info,
 			"devid %llu path %s is registered but not found in chunk tree",
 				  dev->devid, btrfs_dev_name(dev));
-- 
2.53.0



