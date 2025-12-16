Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01DF34EEF1;
	Tue, 16 Dec 2025 12:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886612; cv=none; b=BUNsQoUK6zJhZ5gWNWrKDIM74/k1/YPXLcNwU86/C38/8xyX/LKkqdBdGizMZj61TvPcX5BDPsmBU2Ug/3Lv4a99pnsztr1xa+V0RoEigAvPus0wZE1dyqoX9HyBQ8DXGArZfZMaf7jHulk+w8898N8PJSfiK2dI2rZHYpG9Xdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886612; c=relaxed/simple;
	bh=nEqQSEosbszJnD1hKT/qgBC5HP1sCrT2Uzdur/vrgfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2AlDp3ojZlAqakM5Nx+FdSYhGEShncWQmu+dMF7ULnb/lxfTnKD+w+Jw/WoFjAt9GJgXh1jwGmsRqzmtFXrTEwhsTCxK9MaMVtFSTY1GVdkgyEjBx9pB5jGiJaANwuy0DcFE2pAMW7nCtNKhRTqkISUEtyINlgT7lW8+IlgFso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l2kWJKs1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l2kWJKs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E26EC4CEF1;
	Tue, 16 Dec 2025 12:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886612;
	bh=nEqQSEosbszJnD1hKT/qgBC5HP1sCrT2Uzdur/vrgfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l2kWJKs1TgEoNyuT/YeSlb+4j4WnavvkfYk6v3HQ9RF7BxaCgxipqDDq+k8VGWS1B
	 giStCAZUMBHmX3GaiWkShSNimcGY3DD51jXbv4Sq1oVrQLNdNaR+xtokodEtY6jH0b
	 hNKXI1c9q+deEgsU1UNdhzzaXqGRWMLEqGkfPwXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Simakov <bigalex934@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 487/507] dm-raid: fix possible NULL dereference with undefined raid type
Date: Tue, 16 Dec 2025 12:15:28 +0100
Message-ID: <20251216111403.083550314@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Simakov <bigalex934@gmail.com>

[ Upstream commit 2f6cfd6d7cb165a7af8877b838a9f6aab4159324 ]

rs->raid_type is assigned from get_raid_type_by_ll(), which may return
NULL. This NULL value could be dereferenced later in the condition
'if (!(rs_is_raid10(rs) && rt_is_raid0(rs->raid_type)))'.

Add a fail-fast check to return early with an error if raid_type is NULL,
similar to other uses of this function.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: 33e53f06850f ("dm raid: introduce extended superblock and new raid types to support takeover/reshaping")
Signed-off-by: Alexey Simakov <bigalex934@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-raid.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index f4b904e243285..0d2e1c5eee92a 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2287,6 +2287,8 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 
 			mddev->reshape_position = le64_to_cpu(sb->reshape_position);
 			rs->raid_type = get_raid_type_by_ll(mddev->level, mddev->layout);
+			if (!rs->raid_type)
+				return -EINVAL;
 		}
 
 	} else {
-- 
2.51.0



