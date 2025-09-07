Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEE114D29B;
	Sun,  7 Sep 2025 20:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757278002; cv=none; b=OwRFto4btfeR3CN5SN7/BHLGBsN4W7V8FVcUPspgvPEQBkqKZ56NB/VL6uOoNC/68cvg5bpdUqcvOOGhjJ20YXCTDj0A4mkWhCOVhbd0MV1J/73UeECkp6BEauSvCDOzC0nRovZxSAN3tF5m1mA5dPGEYd3w9Kk90M5mfAthRjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757278002; c=relaxed/simple;
	bh=JnBfwiiOioXGNb0X/3G9vKJKzFB4unPAeH2tTugRCE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhnnTOFCPlbSQ9xYaziVFQrNx/MFfsOui8AS6acARk9PvOKfc3VA6o6xgP4R4pwVXCoQL+9Boz89oJO1kaZ5uua3cb2oQLdvBcxSEncVDmp+P2UhFwyqIjuArK5p9Eh4N06eUZQh8jD2Ko+kEZk8bPPIKwVobDFYmoWFPe+w+fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JO3z95md; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JO3z95md"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FC4C4CEF0;
	Sun,  7 Sep 2025 20:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757278002;
	bh=JnBfwiiOioXGNb0X/3G9vKJKzFB4unPAeH2tTugRCE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JO3z95mdmtz3vS9DIX2TwSaoODMLMm12vaXQI5J0BqtQ3geIz9K8nbz3lVzmyZEid
	 mmFHR+qKfyZoNBHejGzUd3d+ffZHh9duJL0jusUKYS+oT2c4MZsk4qZdxkP4OyQYRt
	 YI8MVFzsde3vuszXBryHwyYrum7Wt+/e9qFMupfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Li Nan <linan122@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	Ian Dall <ian@beware.dropbear.id.au>
Subject: [PATCH 6.16 170/183] md/raid1: fix data lost for writemostly rdev
Date: Sun,  7 Sep 2025 21:59:57 +0200
Message-ID: <20250907195619.855124756@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 93dec51e716db88f32d770dc9ab268964fff320b ]

If writemostly is enabled, alloc_behind_master_bio() will allocate a new
bio for rdev, with bi_opf set to 0. Later, raid1_write_request() will
clone from this bio, hence bi_opf is still 0 for the cloned bio. Submit
this cloned bio will end up to be read, causing write data lost.

Fix this problem by inheriting bi_opf from original bio for
behind_mast_bio.

Fixes: e879a0d9cb08 ("md/raid1,raid10: don't ignore IO flags")
Reported-and-tested-by: Ian Dall <ian@beware.dropbear.id.au>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220507
Link: https://lore.kernel.org/linux-raid/20250903014140.3690499-1-yukuai1@huaweicloud.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Li Nan <linan122@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6cee738a645ff..6d52336057946 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1226,7 +1226,7 @@ static void alloc_behind_master_bio(struct r1bio *r1_bio,
 	int i = 0;
 	struct bio *behind_bio = NULL;
 
-	behind_bio = bio_alloc_bioset(NULL, vcnt, 0, GFP_NOIO,
+	behind_bio = bio_alloc_bioset(NULL, vcnt, bio->bi_opf, GFP_NOIO,
 				      &r1_bio->mddev->bio_set);
 
 	/* discard op, we don't support writezero/writesame yet */
-- 
2.51.0



