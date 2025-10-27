Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B732132F777;
	Mon, 27 Oct 2025 19:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591870; cv=none; b=t1ODuDkyT4XDuFaiM25ek2X8TA8XQgEmUWs2vFKdVeyuSfHHQH12JGCtTO4Q3NI/D96uit/SiaRICUThg27E4dQqC4YnE4Ly43gKtZzZ2kRd40UzJnKGcfq3yqzKRnk0cBipe3C5fPE1jaZsri6YQ+QTmBRr3mPh9QD+j3z3G20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591870; c=relaxed/simple;
	bh=BAAWqqgCrDBK+qQUxYOI8BdzCD7V0rkoHdhSHDd6BxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tdqa2mkRlbCVhvPWEOsm+xumbuZoOiBPxcuTUl2QhsHMhiJkMU/c3zvQpgiXMG8X2lXmRENDvV+FBqnALyhYIzQR7+E5XWop8dZHbLHGkJBBcMiXFoJ6ZIOBFAtqZQzC8fgsAtTq1GGxqehtBwNwqp/q6dez6S+l1/lTSADl3mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJwP3rEG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJwP3rEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CADCC4CEF1;
	Mon, 27 Oct 2025 19:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591870;
	bh=BAAWqqgCrDBK+qQUxYOI8BdzCD7V0rkoHdhSHDd6BxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJwP3rEGvkw0vmN26z5uMijNfKGLyvjr0qOgkXplrSwBU1/MPbGwyUrkzTv6bWUFz
	 qQC03Fu7PoaysjDZ09q9bjvTHPCjbH1YD/fM5hLpW/D1lvIF3oowbiJNterAuEpawH
	 FUjd4lLLakyqpTGXGKvwxzywL/hrwZ2Ml6nYnktU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 007/123] media: lirc: Fix error handling in lirc_register()
Date: Mon, 27 Oct 2025 19:34:47 +0100
Message-ID: <20251027183446.589949358@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit 4f4098c57e139ad972154077fb45c3e3141555dd ]

When cdev_device_add() failed, calling put_device() to explicitly
release dev->lirc_dev. Otherwise, it could cause the fault of the
reference count.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: a6ddd4fecbb0 ("media: lirc: remove last remnants of lirc kapi")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/lirc_dev.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -748,11 +748,11 @@ int lirc_register(struct rc_dev *dev)
 
 	cdev_init(&dev->lirc_cdev, &lirc_fops);
 
+	get_device(&dev->dev);
+
 	err = cdev_device_add(&dev->lirc_cdev, &dev->lirc_dev);
 	if (err)
-		goto out_ida;
-
-	get_device(&dev->dev);
+		goto out_put_device;
 
 	switch (dev->driver_type) {
 	case RC_DRIVER_SCANCODE:
@@ -776,7 +776,8 @@ int lirc_register(struct rc_dev *dev)
 
 	return 0;
 
-out_ida:
+out_put_device:
+	put_device(&dev->lirc_dev);
 	ida_free(&lirc_ida, minor);
 	return err;
 }


