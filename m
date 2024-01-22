Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1AF5D8F9;
	Tue, 23 Jan 2024 01:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974391; cv=none; b=EZpI4QFgv4vOeImWiRs0V5SXBE0obHXIteyeXJJU4uNriV/i+yercrl2AoWuRm80Dx9ljcW1RfC8spGgfLJMupESPPGtNSdltpMpkpk6gDpmIByTUBLVIVjdiriuoV3ulZDuSM0rCbcIMOcTA/mfZGLzC/3jfwjHrUR3zGT/xDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974391; c=relaxed/simple;
	bh=PKBeKeQ6D+tmqJulcy5mxx96ts4qyKRPnWjx/gEUQhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dgav1R88dA45ObhAX6ao1qTjzdTzPTOUcDufBPVnblieLLfQRy2P3U7l7Ew+wD30lhnVO6jiB5N93DJyhAWzdjelUKH9xXjhkYQGgG/J6lIaeMAX2zyjAWAmmmj+xXvqKwGLn6qlZKcm9Of09WqnuEJdf0acPKC7tLAJb1jiw8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xf84YLZ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xf84YLZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7919EC433C7;
	Tue, 23 Jan 2024 01:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974391;
	bh=PKBeKeQ6D+tmqJulcy5mxx96ts4qyKRPnWjx/gEUQhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xf84YLZ72MJ1xdtMPKtpGPt7Cq0/hIfRFwSsQbJkAxo9Zy0G20vHPJ6azXgpSZ9m1
	 HM1rohiibfyGhWVuLc0+t9DLcgK7tRVM9AC88zr/v/TFbUQ6V9367jGypGalhCPk3I
	 dq2T9voUePA/K3x9fOh5eW10QlGg2eRGj07fxRiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 206/374] media: dvbdev: drop refcount on error path in dvb_device_open()
Date: Mon, 22 Jan 2024 15:57:42 -0800
Message-ID: <20240122235751.782706492@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit a2dd235df435a05d389240be748909ada91201d2 ]

If call to file->f_op->open() fails, then call dvb_device_put(dvbdev).

Fixes: 0fc044b2b5e2 ("media: dvbdev: adopts refcnt to avoid UAF")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvbdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 2ff8a1b776fb..3a83e8e09256 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -114,6 +114,8 @@ static int dvb_device_open(struct inode *inode, struct file *file)
 			err = file->f_op->open(inode, file);
 		up_read(&minor_rwsem);
 		mutex_unlock(&dvbdev_mutex);
+		if (err)
+			dvb_device_put(dvbdev);
 		return err;
 	}
 fail:
-- 
2.43.0



