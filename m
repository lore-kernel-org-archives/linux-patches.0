Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E9223A994;
	Mon, 27 Oct 2025 18:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590763; cv=none; b=ZbfZ5/yWG2v90As6cv5+MIcfTh9rXR6Qb8QqkqpaU1MKJCLfjjBv6XBSza3RmY/ZUPvtisPXSbdnHfWu6BwVEJQ1AmaOXOv7kKYn4HB7MQRN62enzpDajrJHWksK/j+r9Gfi+dCFhtT7IK/L6Jc+w+RgwxBDme6ELMEi2jPnA+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590763; c=relaxed/simple;
	bh=1Fm2jQM3LiZ84+0p0NVUAdSdaW+GVvzr7jj5VaGdvEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmVu7L7hmB91FmQ2WMIhFWc3YewenC4Jlxc0tZpWQj9eeMOuQJOwL0fGr6R470CNKvCribf/GPfjFRJQHb7pyMmAth/4dqTl02x6Xhce6ahxCavTJlQylM/XFOG2vUrPlpCTaSzE03kvwIyfShAHpkVUK+FmsyURaJd7r3AOSTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDEuNM2o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDEuNM2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA11C4CEF1;
	Mon, 27 Oct 2025 18:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590763;
	bh=1Fm2jQM3LiZ84+0p0NVUAdSdaW+GVvzr7jj5VaGdvEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDEuNM2ocO0PLnDJgq45swGAl1D8/U0BvDy+S3xYOzVmgzMm//X8FOKoNRQC4YRPi
	 RoPg2lhP5beLAjPZmeoYotmRQa7OB8ZI1JSpRfl67jXW6dg3CR7sKbGDv8yc81Gmnq
	 AK0BxwWk8vsog9PWyZ99ZshGEpfqHYT3y490SHsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+031d0cfd7c362817963f@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 136/224] media: mc: Clear minor number before put device
Date: Mon, 27 Oct 2025 19:34:42 +0100
Message-ID: <20251027183512.615570737@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -283,6 +278,7 @@ void media_devnode_unregister(struct med
 	/* Delete the cdev on this minor as well */
 	cdev_device_del(&devnode->cdev, &devnode->dev);
 	devnode->media_dev = NULL;
+	clear_bit(devnode->minor, media_devnode_nums);
 	mutex_unlock(&media_devnode_lock);
 
 	put_device(&devnode->dev);


