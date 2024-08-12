Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7E61EA8D;
	Mon, 12 Aug 2024 16:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478719; cv=none; b=Pxcf31U5ma0+Sh6TfCg/lQlGKMmOH1taTu7SBfiWmdixk/Eyk2OY/nFGhukyuwZniQBXUiaJkCSUzNYF5djvuY5tQNuxik8I9UWsJ9HloVCdJnRD6+V/nZfGHuO+Ir3XUD4VhqmGUI2gESph8yeG6Jg8t7jGbAvEUPP6szJ09PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478719; c=relaxed/simple;
	bh=YX6Gc2qc3I9MbBF7sWOQ+xzcyuFgWO8X26Mf6edCc5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rz7DzMWGI2q+iNRzVh/PPBBUhO7GQwQpy2CJnnJtnBNxyNp9vaqVvKLuGqITGkqFcvR5GryvLo/Mf6zLylnPNWeGKLOCebfDui5L77SvSfptc2Nyjcdvq9xzI+4940qFqujlemEdq7XXyUHIR3VN+lHM7A3rOaIXDXmTkyjqpTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yeSHYBQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yeSHYBQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D381CC32782;
	Mon, 12 Aug 2024 16:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478719;
	bh=YX6Gc2qc3I9MbBF7sWOQ+xzcyuFgWO8X26Mf6edCc5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yeSHYBQJms5IyymCCxnXm9Yq4pkJsFhrfVbgkf5quCLQkXrH12dPWuo9L/OktvM6N
	 BBWZwYzqB47+Ky/WtPxsH89kv4k83mbrTtjpThbTjXxo5FuC8k8vmzS1WS3hk/pTzj
	 xENpDy0MGQqc4sEt7mObEZTBT8+zaJRdUagC3rnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/150] md: do not delete safemode_timer in mddev_suspend
Date: Mon, 12 Aug 2024 18:01:38 +0200
Message-ID: <20240812160125.826098376@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7dc1c42accccd..b87c6ef0da8ab 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -489,7 +489,6 @@ void mddev_suspend(struct mddev *mddev)
 	clear_bit_unlock(MD_ALLOW_SB_UPDATE, &mddev->flags);
 	wait_event(mddev->sb_wait, !test_bit(MD_UPDATING_SB, &mddev->flags));
 
-	del_timer_sync(&mddev->safemode_timer);
 	/* restrict memory reclaim I/O during raid array is suspend */
 	mddev->noio_flag = memalloc_noio_save();
 }
-- 
2.43.0



