Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEA923D7FA;
	Tue, 26 Aug 2025 11:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208535; cv=none; b=q6GNZvsooyVqwDbBXhRCZFtVfStOOOZkQDWp2xGvO2jtB7Rpw9PJda7L55ZESTpAto3Tk4Fd7+PgV+c06cOEoYc32NKrFi0gIcyZLQElFhJMw0zIkkahSCrzaxo2l21yClFGPqb7vULDc5dPKtR7kOY7k+w4GMoJZBycTCAXNbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208535; c=relaxed/simple;
	bh=jSqW7/60qVkNya74Us+95Y/AdgHp5UdtWi1pYAzl20c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ju6owWS4fjamlQcWzdXn/lWg3Bye7GiSBnTSGXSiTICx8NQ0tTkllPUnCLzsvYPhoFo5cT/ZXFSH6Z9nBFDddrFDmewQDdKJOhPHB1m6Wrm0nVzz+RyRtQTq13gEmEoXQXPSKD+5xmquyKGxHB10duQ0BNT8vKCZTnldtg7rqP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEIn62l3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEIn62l3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71960C4CEF1;
	Tue, 26 Aug 2025 11:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208534;
	bh=jSqW7/60qVkNya74Us+95Y/AdgHp5UdtWi1pYAzl20c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEIn62l3Z3dPX1CYix/mO+JkjnWUTRYFAKCP3lOF1jJplLB1E+klYga0s6+7IsBN/
	 qPCTCZkR6HNHiolwDn8OFwVgVn6CRLNyIypaqcCI7PZvZ+xaWTuDNqdyhs5cioa5DY
	 uqLMl1sGwdQCb/WxiJYW5frKe3DMgG4fyjh/oX88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 149/322] btrfs: zoned: requeue to unused block group list if zone finish failed
Date: Tue, 26 Aug 2025 13:09:24 +0200
Message-ID: <20250826110919.488107052@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit 62be7afcc13b2727bdc6a4c91aefed6b452e6ecc ]

btrfs_zone_finish() can fail for several reason. If it is -EAGAIN, we need
to try it again later. So, put the block group to the retry list properly.

Failing to do so will keep the removable block group intact until remount
and can causes unnecessary ENOSPC.

Fixes: 74e91b12b115 ("btrfs: zoned: zone finish unused block group")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1646,8 +1646,10 @@ void btrfs_delete_unused_bgs(struct btrf
 		ret = btrfs_zone_finish(block_group);
 		if (ret < 0) {
 			btrfs_dec_block_group_ro(block_group);
-			if (ret == -EAGAIN)
+			if (ret == -EAGAIN) {
+				btrfs_link_bg_list(block_group, &retry_list);
 				ret = 0;
+			}
 			goto next;
 		}
 


