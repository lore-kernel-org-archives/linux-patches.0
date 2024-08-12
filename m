Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D83187343;
	Mon, 12 Aug 2024 16:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479302; cv=none; b=sN/ElapIsGP32ACtFcu3CCI8cVdqCF9KKealpL48gP2ESPKkQa16k3L9889e7XByxDIEjzjQAs25ut/Zx3tcqAPf939YUIsxANJgcCuVrJv0fJtL2VsdKAwBgOWHqzuoTkciopxOFXHBKWCKCNMp5VG5r+7cfUVA2A3l/a7g2y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479302; c=relaxed/simple;
	bh=uScv1mny68jhCAJlVOOLH3HJOWEJJmBZsDeXzZcyrtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqrFohGuSdyzrD7/lU3pZUEUTjUxkpbgK61aNYlRC8L/LozhPx663YZmt8ayBuB5+9T3HeZ7QrEAOaUP1R+NuyNhForhiw9HDeLyTyPjLWhW1sKg4lzq5cLszSJ3G0Br13pj8q+kkVX5WWJiNRet30lQR90GtjvvMgLyNyL3mac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWFDxoHD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWFDxoHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D943AC32782;
	Mon, 12 Aug 2024 16:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479302;
	bh=uScv1mny68jhCAJlVOOLH3HJOWEJJmBZsDeXzZcyrtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWFDxoHDNsB5h2V86hPmzS3MbeONL7qbduHyiwJbhfe4S09Z1g298TAd+qk2eS2bU
	 jnpgVNxacsKChHMYCuqaq+62z86OlSD/mUG7GoaSwxFZUbRkPgnfCf5f+KadkyiJzT
	 O6hZk0Iz0BEa9U/WoJa/JU2XaUENCym5kRVfFK8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/189] md: do not delete safemode_timer in mddev_suspend
Date: Mon, 12 Aug 2024 18:01:23 +0200
Message-ID: <20240812160133.190533569@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Nan <linan122@huawei.com>

[ Upstream commit a8768a134518e406d41799a3594aeb74e0889cf7 ]

The deletion of safemode_timer in mddev_suspend() is redundant and
potentially harmful now. If timer is about to be woken up but gets
deleted, 'in_sync' will remain 0 until the next write, causing array
to stay in the 'active' state instead of transitioning to 'clean'.

Commit 0d9f4f135eb6 ("MD: Add del_timer_sync to mddev_suspend (fix
nasty panic))" introduced this deletion for dm, because if timer fired
after dm is destroyed, the resource which the timer depends on might
have been freed.

However, commit 0dd84b319352 ("md: call __md_stop_writes in md_stop")
added __md_stop_writes() to md_stop(), which is called before freeing
resource. Timer is deleted in __md_stop_writes(), and the origin issue
is resolved. Therefore, delete safemode_timer can be removed safely now.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240508092053.1447930-1-linan666@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b5dea664f946d..35b003b83ef1b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -456,7 +456,6 @@ void mddev_suspend(struct mddev *mddev)
 	clear_bit_unlock(MD_ALLOW_SB_UPDATE, &mddev->flags);
 	wait_event(mddev->sb_wait, !test_bit(MD_UPDATING_SB, &mddev->flags));
 
-	del_timer_sync(&mddev->safemode_timer);
 	/* restrict memory reclaim I/O during raid array is suspend */
 	mddev->noio_flag = memalloc_noio_save();
 }
-- 
2.43.0



