Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DE76A320;
	Tue, 23 Jan 2024 02:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975342; cv=none; b=NLfbwH2/73OgG6i8gvO33dBjypUfM/ryGx8oFA1OxBN/B4/wEQvBe1rZ9xZbNQ6je1XLW+mq48hBWpzY0P2jA29aNuHDEXGnWJHOu/kWYH26Htr5R4pdj1RNvVI/3d8GqZ3aMDzrsh9CiidRrKFsDBsFYsvnArO44PCiaP9Froc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975342; c=relaxed/simple;
	bh=dFBdVqmKpPuq4oc9gESCY9IjU1knw49ILQqyBnyeWQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayCnZnEty4JQiFkoGj2qAWGGbHuMvmHpslhzgxdkyD/pzz7Um536jPZImyXIDOY3isSdo8l6qbfuPuBZoMUNhokZetPsJhxRSxeP3SZ4J4mTAgLOgHWbP2nbgTnF81AND23j7DNrZ6eerWdpYF1+DRHCtd3jaTa8tYcG9FVyjJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQPAj0Xn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQPAj0Xn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B16C43390;
	Tue, 23 Jan 2024 02:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975342;
	bh=dFBdVqmKpPuq4oc9gESCY9IjU1knw49ILQqyBnyeWQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bQPAj0XnZHmGooZwdF1eW7eVKV+ZVlnPwOkeA/ILBinr5V41eKFdybuOspgVpbcM+
	 MmT8oe+pEoYzXTh78Tl0NkTsZMMj8G2jPTkA41H8RLO1cOdhkPyy9ebFk5ZBQAUXrL
	 ErB4gS5NoMjueabTM1QBN6HgY8FZ8Cwp6yLoKRFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 279/583] media: dvbdev: drop refcount on error path in dvb_device_open()
Date: Mon, 22 Jan 2024 15:55:30 -0800
Message-ID: <20240122235820.533972196@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
index 305bb21d843c..49f0eb7d0b9d 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -104,6 +104,8 @@ static int dvb_device_open(struct inode *inode, struct file *file)
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



