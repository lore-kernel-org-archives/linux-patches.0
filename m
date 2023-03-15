Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF95A4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:38:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B0CC4339B;
	Wed, 15 Mar 2023 12:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883899;
	bh=3x/A+2MGeGdMB43OhLiNVkcShYoaa19ONio/m/N34Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJ+vC92gp3kFg10iUILOXxZGic8rh4izS6gUc7FQLtxX/vJgilBwb9zu9I1y+5Nyn
	 9xUFMljlBgA95PWRneI74+pEzRVA4Erw7k9o5WnUmftARSQ9f106Fs35ykttscGdAX
	 e5/x8KCpfrKPhTigYZ0Cxw2Ct51DVDPWlUpTmprQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Forza <forza@tnonline.net>,
	Anand Jain <anand.jain@oracle.com>,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.2 003/141] btrfs: fix percent calculation for bg reclaim message
Date: Wed, 15 Mar 2023 13:11:46 +0100
Message-Id: <20230315115740.064238519@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 95cd356ca23c3807b5f3503687161e216b1c520d upstream.

We have a report, that the info message for block-group reclaim is
crossing the 100% used mark.

This is happening as we were truncating the divisor for the division
(the block_group->length) to a 32bit value.

Fix this by using div64_u64() to not truncate the divisor.

In the worst case, it can lead to a div by zero error and should be
possible to trigger on 4 disks RAID0, and each device is large enough:

  $ mkfs.btrfs  -f /dev/test/scratch[1234] -m raid1 -d raid0
  btrfs-progs v6.1
  [...]
  Filesystem size:    40.00GiB
  Block group profiles:
    Data:             RAID0             4.00GiB <<<
    Metadata:         RAID1           256.00MiB
    System:           RAID1             8.00MiB

Reported-by: Forza <forza@tnonline.net>
Link: https://lore.kernel.org/linux-btrfs/e99483.c11a58d.1863591ca52@tnonline.net/
Fixes: 5f93e776c673 ("btrfs: zoned: print unusable percentage when reclaiming block groups")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add Qu's note ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1687,7 +1687,8 @@ void btrfs_reclaim_bgs_work(struct work_
 
 		btrfs_info(fs_info,
 			"reclaiming chunk %llu with %llu%% used %llu%% unusable",
-				bg->start, div_u64(bg->used * 100, bg->length),
+				bg->start,
+				div64_u64(bg->used * 100, bg->length),
 				div64_u64(zone_unusable * 100, bg->length));
 		trace_btrfs_reclaim_block_group(bg);
 		ret = btrfs_relocate_chunk(fs_info, bg->start);


