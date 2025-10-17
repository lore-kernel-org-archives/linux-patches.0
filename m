Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D354432C929;
	Fri, 17 Oct 2025 15:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714663; cv=none; b=KLmAIJGGJXdIfUSkjw0+cGCsVEQyaMtsHRrFdm5Rzq9ZIb7jdcVr9/Mgl/vjn+WRpParl8Va/Rq/t27+EglHO0ARlmqRESewXpixxc9Zl02CcC8b5imE8zhG7jCRKOqsNBEdyOu3UpKIcMI9Zx/mvHQz0dAmpbWXiiD+8Fno/yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714663; c=relaxed/simple;
	bh=Z9dcxC8+YDYCIF1CQ2FGbQOt+VNTcnbEkZHLL56o3aU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbDdbRqoOrVgNi4RJR2FSh6dYAe/HQWzqfxfbDGaH/Sr8+3/A2b71igrSVjya1WkfDoFbpbzgxeUtFFkPymQbBBrFDbrakTbZXWU1gtPSkNANIbtpAarGNXq82fCAfP7+sbJsot+MgKiV00kH7XitF/KUuCchZ/52rl7TOGnYCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kisic/eB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kisic/eB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573F1C4CEE7;
	Fri, 17 Oct 2025 15:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714663;
	bh=Z9dcxC8+YDYCIF1CQ2FGbQOt+VNTcnbEkZHLL56o3aU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kisic/eBJf6KDA3ZXsgHoPXJzmAx8TciBvBnhT6SHBUAzrZTE0vS6EO2cDtdy8fgc
	 IJomI/m8nN5by5rqioTv+VPbvXWCiGP77UZC6/8kpCj2Fe2sJJDtJntgVeEhiRsdFc
	 ABHsrSRVvKgwHLTptyblZW55duLzY96H6Wz5iNvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+031d0cfd7c362817963f@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 224/277] media: mc: Clear minor number before put device
Date: Fri, 17 Oct 2025 16:53:51 +0200
Message-ID: <20251017145155.305578612@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


