Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7B87BAF5;
	Mon,  8 Apr 2024 14:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584827; cv=none; b=mKegvtMJzP7jahA4MYGIx5371u7LCfP2PGMFLdqnhico9ktfFKnBG6WajwmRlsoVDUXIcjbMWgsyT8aie4BY0faKcS+mwhacbNZVoSv4OVBef35yDVIl696ED8JvgdiQV15r8v+6x84YtClhplBn6HHABP388YAyedV0XoRa9aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584827; c=relaxed/simple;
	bh=73YBIqid9OpY9EU+N7UqEw0ahz3ThpgazvKs8wlqrFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ph7SOZPV/Lf8Lq80givy6f5lgurrx/lcZQsPynuU3fpNs0SkvwPxdQOxyCnWqcv8LZLBlmxZAxHFFmE+gTRhWmnxsZ9cvejMkHGDy527U0jEGyGJzFJoum7A9nspKpT4GYEFUUPsZxsrLBu+Tau6rN5CkIULQRH2mZeqM4qXj7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F353ZsBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F353ZsBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55BFC433C7;
	Mon,  8 Apr 2024 14:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584827;
	bh=73YBIqid9OpY9EU+N7UqEw0ahz3ThpgazvKs8wlqrFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F353ZsBBOrRp1mbISzIxiT2zzd69JsRtQznTEbBUpQQciOC1RY59SxiVh7taPR6M+
	 lKKBZlEnQnM5MM2YW0HW+Unv/Bc5pHVbmfThuJnhyAcacjq2p9wxkPwqzoxICMg7rq
	 fD+at4tRpqQDBF0g6jq+qBobvQ8RBDWUIdP/0abQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WA AM <waautomata@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 570/690] btrfs: zoned: use zone aware sb location for scrub
Date: Mon,  8 Apr 2024 14:57:16 +0200
Message-ID: <20240408125420.272809878@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 74098a989b9c3370f768140b7783a7aaec2759b3 upstream.

At the moment scrub_supers() doesn't grab the super block's location via
the zoned device aware btrfs_sb_log_location() but via btrfs_sb_offset().

This leads to checksum errors on 'scrub' as we're not accessing the
correct location of the super block.

So use btrfs_sb_log_location() for getting the super blocks location on
scrub.

Reported-by: WA AM <waautomata@gmail.com>
Link: http://lore.kernel.org/linux-btrfs/CANU2Z0EvUzfYxczLgGUiREoMndE9WdQnbaawV5Fv5gNXptPUKw@mail.gmail.com
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/scrub.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3972,7 +3972,17 @@ static noinline_for_stack int scrub_supe
 		gen = fs_info->last_trans_committed;
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
-		bytenr = btrfs_sb_offset(i);
+		ret = btrfs_sb_log_location(scrub_dev, i, 0, &bytenr);
+		if (ret == -ENOENT)
+			break;
+
+		if (ret) {
+			spin_lock(&sctx->stat_lock);
+			sctx->stat.super_errors++;
+			spin_unlock(&sctx->stat_lock);
+			continue;
+		}
+
 		if (bytenr + BTRFS_SUPER_INFO_SIZE >
 		    scrub_dev->commit_total_bytes)
 			break;


