Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A9F1D07BC;
	Wed,  2 Oct 2024 14:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878932; cv=none; b=mwA1YiO1L/zbatOMDseRNevVCNobFvrsEQAbvBE0xbxSXZv9w+reZc6dtTSFVTliA04G0egU3UFQD6IZBa/HxYFdzx6EfMRlZd9Kz2eN9O/oXxXoR33YweSIC998/VP1IO/Yr4Qtlhsts2njqjBqH94BNCQUCa/Ih7UFXvL+INE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878932; c=relaxed/simple;
	bh=MEDSQ86bp9MAW7CT+UXtLYPKFLcsu57+ADct6DWvx4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCCVI/E2BLwiNx/9hNBPTjlGv6ylOF8Kzcic8VaIkI2UtbLy/a5/JkFFqSOmy4uLyZzrA30EgKD2Nm/2vxTCNuvGYJDD7SoEYpxjasGf9LtrUoYOc7Ff6D07eIcAcP5v3526t+GL61cOwt6OXo6PO8orN3h+MHflKhRrMRoA670=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfHAwihn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfHAwihn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6103C4CEC2;
	Wed,  2 Oct 2024 14:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878932;
	bh=MEDSQ86bp9MAW7CT+UXtLYPKFLcsu57+ADct6DWvx4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfHAwihnMH3mRlhb/C+eSf1/eCHWuD3mT91erGaCK44/oOkKfq/g6Mgp2yeL2OPeY
	 hBVvJ2ku0ijGI8JRsKfi3geSdDzWZNgAq+iLYm5EhUn0AGcdWuOnu1sFPVuB1xm3D/
	 yAIi6emxDagYsPxec+tSYqHNX5SgTkNv6nDsQkGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.10 582/634] md: Dont flush sync_work in md_write_start()
Date: Wed,  2 Oct 2024 15:01:22 +0200
Message-ID: <20241002125834.089572956@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit 86ad4cda79e0dade87d4bb0d32e1fe541d4a63e8 upstream.

Because flush sync_work may trigger mddev_suspend() if there are spares,
and this should never be done in IO path because mddev_suspend() is used
to wait for IO.

This problem is found by code review.

Fixes: bc08041b32ab ("md: suspend array in md_start_sync() if array need reconfiguration")
Cc: stable@vger.kernel.org
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20240801124746.242558-1-yukuai1@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8648,7 +8648,6 @@ void md_write_start(struct mddev *mddev,
 	BUG_ON(mddev->ro == MD_RDONLY);
 	if (mddev->ro == MD_AUTO_READ) {
 		/* need to switch to read/write */
-		flush_work(&mddev->sync_work);
 		mddev->ro = MD_RDWR;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		md_wakeup_thread(mddev->thread);


