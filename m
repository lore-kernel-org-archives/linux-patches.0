Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0EC330B03;
	Fri, 17 Oct 2025 15:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715832; cv=none; b=odnvecv/1WutdVwwbj3mLVEczMe64kOYUt31YniRjzZ17BrJwAZaXg5ktcNfXhKjgsZcjkUQh+3BE+P1109EEuWMO8KjBCgZfnIdis72xtRAeUY3SeyHyOkN1DsD/z3mJedTYnnLiQkOktmUd6vxlWn75ExAtQbJU7n5aZV/OME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715832; c=relaxed/simple;
	bh=Xp/yCJnO1q4mvyMEzqfIDrln5bgSpv3TOub/ChXHYOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4jtN+iS6BhgZLtkcsFg/oD8A+7wLvY+Tl7vm3LRjvwCyY95XvygesO9Y5eU/AayHdGXj5z1VsyQt2Ux5c0y64xkAOJ6FaQPRyGyMi7RaBrszBAQTddF6UcAu8vnU/KFJG10AS3TtwfAvEiOCiJud2gfRjN+RBlWHKR0K6d/Qn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y51KM4BM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y51KM4BM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8519AC4CEE7;
	Fri, 17 Oct 2025 15:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715831;
	bh=Xp/yCJnO1q4mvyMEzqfIDrln5bgSpv3TOub/ChXHYOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y51KM4BMdtL8XIkBORxWbPiKdOjIOMehafj0bpRPzZW7llxRE9E5xBKIBrpvSZQFp
	 Zc1Q33tvSu5urKoZ832l2qP+rC512RzXo9InRKiSFfRivYJfcm/nBh0UtJ40TqYaPW
	 fXg1fQ9E1lm+ac+28xSTiz2lapGzI+zijDPFSLqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+031d0cfd7c362817963f@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 353/371] media: mc: Clear minor number before put device
Date: Fri, 17 Oct 2025 16:55:28 +0200
Message-ID: <20251017145214.856658637@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 8cfc8cec1b4da88a47c243a11f384baefd092a50 ]

The device minor should not be cleared after the device is released.

Fixes: 9e14868dc952 ("media: mc: Clear minor number reservation at unregistration time")
Cc: stable@vger.kernel.org
Reported-by: syzbot+031d0cfd7c362817963f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=031d0cfd7c362817963f
Tested-by: syzbot+031d0cfd7c362817963f@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ moved clear_bit from media_devnode_release callback to media_devnode_unregister before put_device ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/mc/mc-devnode.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/media/mc/mc-devnode.c
+++ b/drivers/media/mc/mc-devnode.c
@@ -50,11 +50,6 @@ static void media_devnode_release(struct
 {
 	struct media_devnode *devnode = to_media_devnode(cd);
 
-	mutex_lock(&media_devnode_lock);
-	/* Mark device node number as free */
-	clear_bit(devnode->minor, media_devnode_nums);
-	mutex_unlock(&media_devnode_lock);
-
 	/* Release media_devnode and perform other cleanups as needed. */
 	if (devnode->release)
 		devnode->release(devnode);
@@ -281,6 +276,7 @@ void media_devnode_unregister(struct med
 	/* Delete the cdev on this minor as well */
 	cdev_device_del(&devnode->cdev, &devnode->dev);
 	devnode->media_dev = NULL;
+	clear_bit(devnode->minor, media_devnode_nums);
 	mutex_unlock(&media_devnode_lock);
 
 	put_device(&devnode->dev);


