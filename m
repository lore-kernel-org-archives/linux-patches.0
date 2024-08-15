Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1556D1AC893;
	Thu, 15 Aug 2024 14:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732706; cv=none; b=QEJyCRgyMpx5sMv2H3SnzFTMza2YwqSkhnrX9mi0wRYEtFVE3bmgTUZUAILpsmuFiaTX6wgguZIRx4qDtE1fM9xOGP5ROslxKNWj4CJxTl/20MuBmt5pEaTvj3d1Hz/mhIPxoX79iFzLwW42DLId0uBYC9o1hHd+a7jGWm9tw6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732706; c=relaxed/simple;
	bh=Wk7oNtPC2YkYjaG95NfIl7iUexwF7I0U6yqm/nJl2TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnQjOJTlPD4Ik9YXvhqIOt86+e9uC2lyvAigAi9Mzv8qaAPcpdHFiscuzTBSXxbEE65KYnNTyt3S+/h4nHBlCds0b0Jmh1mWTqFRjdKNf0N1Wqsv15tfKM6L3NGk0DRMkfaglpM6XqNoLx2b0A+Y8XeJahEaG3bKOphzCMvauYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O4pgvFW1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O4pgvFW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A9CC32786;
	Thu, 15 Aug 2024 14:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732706;
	bh=Wk7oNtPC2YkYjaG95NfIl7iUexwF7I0U6yqm/nJl2TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4pgvFW1BUHHUmPG0f7psVavj3C+8ENZ9Z52/6T6tzEMNEAArFj4e7Uo0zKeUTJbD
	 ntSHn1K3x8VCUUx8uWOUFZj8KaGtppsx5LIVj2FzgpE7vNWKil8R1qx6/QfPWgmtgH
	 41kD/4Vn3Li9SS7e3xSc/8W6Zllt7ekfXhA8G6/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 262/352] md: do not delete safemode_timer in mddev_suspend
Date: Thu, 15 Aug 2024 15:25:28 +0200
Message-ID: <20240815131929.569886805@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 67ceab4573be4..f1f029243e0cb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -524,7 +524,6 @@ void mddev_suspend(struct mddev *mddev)
 	clear_bit_unlock(MD_ALLOW_SB_UPDATE, &mddev->flags);
 	wait_event(mddev->sb_wait, !test_bit(MD_UPDATING_SB, &mddev->flags));
 
-	del_timer_sync(&mddev->safemode_timer);
 	/* restrict memory reclaim I/O during raid array is suspend */
 	mddev->noio_flag = memalloc_noio_save();
 }
-- 
2.43.0



