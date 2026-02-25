Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AD8243376;
	Wed, 25 Feb 2026 01:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983796; cv=none; b=EeVX77EKyNor56ApxXKpKSyCAdgyae0MW632gsOeyW/MVRjGv3v0sDV+HalRWyKEavld81g+IxEv5niVBGckLdJ5cMcQRL/lXB0tErpvWcTeIcFS4nHCmSkh3TrNHT/uV+1saOwYfpdB9SrlGBX7hLTDD06EFda/yi1JuzapA4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983796; c=relaxed/simple;
	bh=lfNPBaGSuvuWKjY+PyHfOfXScMTN2+C1O03p7BqNU7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JffJzNbN95OcTJlTRlHY1XD3bmIXYTLffNpKLbsGjQaFPhc6X4Jo547NqSLgx59GWdVq6bOL5pgOEMEfHx3D44QmUiyYXKl2H5UKr7pqMBKgGJI1n9YNDopJOdtxddaIEyEdImDRbK6jfQFJLtR6LMU2jSHRARkByo/GNgvTOGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bf8zjNUd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bf8zjNUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12662C116D0;
	Wed, 25 Feb 2026 01:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983796;
	bh=lfNPBaGSuvuWKjY+PyHfOfXScMTN2+C1O03p7BqNU7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bf8zjNUd8jYDbzYnYKFsHEpjjR4qKb+tLeDRmv3AZGZDKsLV4kr8i9mgGi23KImFx
	 eQH5lvuZlmeu3YaV/tyj8MFSLbvbrjAyFfXr42ruhMrGWn+F+fn8gTadDXbgipzm2W
	 jqFixWhZi8J1rCc107snFW2sCZGNZKZIkoHaxpE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 045/641] md/raid5: fix IO hang with degraded array with llbitmap
Date: Tue, 24 Feb 2026 17:16:11 -0800
Message-ID: <20260225012350.120166425@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Yu Kuai <yukuai@fnnas.com>

[ Upstream commit cd1635d844d26471c56c0a432abdee12fc9ad735 ]

When llbitmap bit state is still unwritten, any new write should force
rcw, as bitmap_ops->blocks_synced() is checked in handle_stripe_dirtying().
However, later the same check is missing in need_this_block(), causing
stripe to deadloop during handling because handle_stripe() will decide
to go to handle_stripe_fill(), meanwhile need_this_block() always return
0 and nothing is handled.

Link: https://lore.kernel.org/linux-raid/20260123182623.3718551-2-yukuai@fnnas.com
Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Li Nan <linan122@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1041788a54c20..3b711a1198adb 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3751,9 +3751,14 @@ static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
 	struct r5dev *dev = &sh->dev[disk_idx];
 	struct r5dev *fdev[2] = { &sh->dev[s->failed_num[0]],
 				  &sh->dev[s->failed_num[1]] };
+	struct mddev *mddev = sh->raid_conf->mddev;
+	bool force_rcw = false;
 	int i;
-	bool force_rcw = (sh->raid_conf->rmw_level == PARITY_DISABLE_RMW);
 
+	if (sh->raid_conf->rmw_level == PARITY_DISABLE_RMW ||
+	    (mddev->bitmap_ops && mddev->bitmap_ops->blocks_synced &&
+	     !mddev->bitmap_ops->blocks_synced(mddev, sh->sector)))
+		force_rcw = true;
 
 	if (test_bit(R5_LOCKED, &dev->flags) ||
 	    test_bit(R5_UPTODATE, &dev->flags))
-- 
2.51.0



