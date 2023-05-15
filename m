Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FED0FBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77820C433EF;
	Mon, 15 May 2023 16:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169689;
	bh=0iaogp2O6ps7ry+Uw6606MgwHXbKeUewVTbumINAuZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xIYkNZPRTfcXsL96RKqAjM5GaMkf5DFOEqSPFjqBY3iPReoJpupXpAOcQ5WyyZzaV
	 rz6rtMCk6Xs9hzc6cttG4tSQiAEFUhqKTpDXZKuJACo5ASemcxMOq3yBH7mfyeOIev
	 UDFHVQ9xlYbDpH/bPd7oOipypWCIcatsMLmQ2zaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.3 138/246] btrfs: zoned: fix full zone super block reading on ZNS
Date: Mon, 15 May 2023 18:25:50 +0200
Message-Id: <20230515161726.706014719@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Naohiro Aota <Naohiro.Aota@wdc.com>

commit 02ca9e6fb5f66a031df4fac508b8e477ca69e918 upstream.

When both of the superblock zones are full, we need to check which
superblock is newer. The calculation of last superblock position is wrong
as it does not consider zone_capacity and uses the length.

Fixes: 9658b72ef300 ("btrfs: zoned: locate superblock position using zone capacity")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -122,10 +122,9 @@ static int sb_write_pointer(struct block
 		int i;
 
 		for (i = 0; i < BTRFS_NR_SB_LOG_ZONES; i++) {
-			u64 bytenr;
-
-			bytenr = ((zones[i].start + zones[i].len)
-				   << SECTOR_SHIFT) - BTRFS_SUPER_INFO_SIZE;
+			u64 zone_end = (zones[i].start + zones[i].capacity) << SECTOR_SHIFT;
+			u64 bytenr = ALIGN_DOWN(zone_end, BTRFS_SUPER_INFO_SIZE) -
+						BTRFS_SUPER_INFO_SIZE;
 
 			page[i] = read_cache_page_gfp(mapping,
 					bytenr >> PAGE_SHIFT, GFP_NOFS);


