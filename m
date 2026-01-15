Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD2C3BC4D8;
	Thu, 15 Jan 2026 17:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499195; cv=none; b=pMpVNweWy8Y5cZNpQ7cObN/GEq4uf8QsrNwiHMqh8ole7KQlsQTu6r9E+KsRZOMvYDInRq1xfoQHlyzvpXz3/Y9FYgV5oHKsecVUqEudoMSTsxC1mtrTLR1J1VDzBRmxUaj73ekul8zZtY+M+pbMLMS2R4tCbg+o39yAbhfwHhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499195; c=relaxed/simple;
	bh=UX8p4c5NphjChGY7/fyfq0MW04BWwliZx6pFSiO0t4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZBdJplyVrbtVcLibZqTH0ecWCSF/teahstU3G3R2cVUU3YyuvCs5h3NokJ/Qk6X4v5SX21N+a2ztpR8CGp71UgLy/QrkmDjo4rOas3APi204Fqlmuuwi5D3rYElzKZ5gPQXmPCuHESxG49Xnq+M6imfD0Cz1nYH7Y8IjZ4EnVLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aehx4yZd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aehx4yZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA19C116D0;
	Thu, 15 Jan 2026 17:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499195;
	bh=UX8p4c5NphjChGY7/fyfq0MW04BWwliZx6pFSiO0t4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aehx4yZdjjt/lz6biizh9v8SvLSi1a1mNJWr8jdSa9YEaFYYeAlElhytrFaVjVZ6U
	 Q9ypLOsKBuzuz7N/WNYoIBLkvtSSq0Qco9ThCPo82IxTLxse4fiPh+hJ/TpvgeecYA
	 xz8fLpDVnAwPGuVefiY74kX/KgAyhBvyK1t3IeG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Simakov <bigalex934@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 142/451] dm-raid: fix possible NULL dereference with undefined raid type
Date: Thu, 15 Jan 2026 17:45:43 +0100
Message-ID: <20260115164236.054230262@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3c0960f294fb5..aa70f668b5cca 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2259,6 +2259,8 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 
 			mddev->reshape_position = le64_to_cpu(sb->reshape_position);
 			rs->raid_type = get_raid_type_by_ll(mddev->level, mddev->layout);
+			if (!rs->raid_type)
+				return -EINVAL;
 		}
 
 	} else {
-- 
2.51.0



