Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2E4183CD4;
	Mon, 12 Aug 2024 16:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479940; cv=none; b=Qtzt6NJZSMa4m4cTNkjBa3gXdtY+W6STKK4J8ux63wSsJVS0zsvMwCAN3vWOVmuXFpmYF2Ef8QKLk/EEwwSZyoH6n6RKAv7vacAixeXFthvxB50LXC6C5YaA3MDUUDLjcag/8TfTA8J6JinOWfWO4W50oVsO0TiByUr8BZ3KNYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479940; c=relaxed/simple;
	bh=8VJDOUMY5SuhauSFE9e6AfZ4XUDrFYEEXDOBFm2Ab2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KS39J5kCvdjWwSb/D0zm1XwVkZLIN9Cr4I7EV91WHZM36lxpUuosLEnbNIEl05Tw1uYduetyNBIelPpKSWkmFm0MRFZJdlPVV+AtGtY+AVwpa+Jxr8Ixw8yz3Ey9HjnZexkxxQMJV0WDr2Efk4sohIyDNIoFzvzbY/tX7U8pOoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H3E22jkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H3E22jkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E694AC32782;
	Mon, 12 Aug 2024 16:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479940;
	bh=8VJDOUMY5SuhauSFE9e6AfZ4XUDrFYEEXDOBFm2Ab2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3E22jkQiH1M6P0jERV3IeQgO+vNCrKqQvpHcYB79IV5ekYNpEYumd9s0OTPxnFSz
	 OnhUn8PYd9GCAei1liDLHv/4QLvx40RL9TkQGyplDv9Cfzs+dBExiaFjuj+aUktALE
	 AjTZx9f+WUB828YqznOXk27Y/ls38nQevO6u5hhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 046/263] md: do not delete safemode_timer in mddev_suspend
Date: Mon, 12 Aug 2024 18:00:47 +0200
Message-ID: <20240812160148.307832579@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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
index 9c5be016e5073..60a5fda7c8aea 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -479,7 +479,6 @@ int mddev_suspend(struct mddev *mddev, bool interruptible)
 	 */
 	WRITE_ONCE(mddev->suspended, mddev->suspended + 1);
 
-	del_timer_sync(&mddev->safemode_timer);
 	/* restrict memory reclaim I/O during raid array is suspend */
 	mddev->noio_flag = memalloc_noio_save();
 
-- 
2.43.0



