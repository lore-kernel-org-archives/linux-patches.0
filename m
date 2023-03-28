Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502408BEB
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A09C433EF;
	Tue, 28 Mar 2023 14:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015135;
	bh=Fpa56mnzfJqgvEVswSPhjBrdvPFyba8PS5K5knS9AJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T36Vqp/tOTd6TWsstvBMX85T6bYzYQM/RcHfwVXhF+oOKG+Rpay7L0BtXwK4ATkJV
	 /hMoUWd30vyFVrRuaqfDsKLF8ehFfjpRWi7qRPh/FAkyplZyVyrR8cpxlslqwFSR6F
	 CDP/Ho4FtqxgUX485kkNm1MaOxyzj1TaTwHLoAIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.2 179/240] btrfs: zoned: fix btrfs_can_activate_zone() to support DUP profile
Date: Tue, 28 Mar 2023 16:42:22 +0200
Message-Id: <20230328142627.085432229@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 9e1cdf0c354e46e428c0e0cab008abbe81b6013d upstream.

btrfs_can_activate_zone() returns true if at least one device has one zone
available for activation. This is OK for the single profile, but not OK for
DUP profile. We need two zones to create a DUP block group. Fix it by
properly handling the case with the profile flags.

Fixes: 265f7237dd25 ("btrfs: zoned: allow DUP on meta-data block groups")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2100,11 +2100,21 @@ bool btrfs_can_activate_zone(struct btrf
 		if (!device->bdev)
 			continue;
 
-		if (!zinfo->max_active_zones ||
-		    atomic_read(&zinfo->active_zones_left)) {
+		if (!zinfo->max_active_zones) {
 			ret = true;
 			break;
 		}
+
+		switch (flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
+		case 0: /* single */
+			ret = (atomic_read(&zinfo->active_zones_left) >= 1);
+			break;
+		case BTRFS_BLOCK_GROUP_DUP:
+			ret = (atomic_read(&zinfo->active_zones_left) >= 2);
+			break;
+		}
+		if (ret)
+			break;
 	}
 	mutex_unlock(&fs_info->chunk_mutex);
 


