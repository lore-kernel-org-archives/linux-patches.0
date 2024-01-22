Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82982627E3;
	Tue, 23 Jan 2024 00:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971194; cv=none; b=arql+qqHqxLa4kYmSM1ZdEUqraYGNhnc6lN+YzWzsMLNVJfPQZCL7vlfOoULbARd+Q9YO3MfQHfoyrTH8nL0W51DkmHOmsu9gAM5VpkvIWzhiU1IlhNRPBkEuB/4gUicshzgAM1Hg8RX6552ENYgacbPE4eRT+AM2x5g77vLBEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971194; c=relaxed/simple;
	bh=vE9axcSn3gWwW7+xS1kjRMWBd25tFIuGal6mwq6uqfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8Ho5bnCqikniABilABumm/bL3ffw9nrAPr7WnJNVYOxpgTl2nD6lAONi343MyKF6EDbx4/ZFAeFhrq13TiPA7cK3w0g97DAyNoQwrjr0TFc4U1yZg70LWVkx4lRRR9WAWl/xG69Mg/JZibyEVDzhDg9MKl+qA+KJqq1gCFB9Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bVhLH+08; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bVhLH+08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE85C43390;
	Tue, 23 Jan 2024 00:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971194;
	bh=vE9axcSn3gWwW7+xS1kjRMWBd25tFIuGal6mwq6uqfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVhLH+08DXE5/94xFpURhkT8hSyGJHSB5e3kzki2VUp50P5eZzdwBjsy1NUkXqEzS
	 U/OCpoUKdY6xjRcbd+LpWpsXKYa5xbSjTnAKQnjU46Rn4DMxz+rZX5IBQ5nOxfcboE
	 49evgiGWvmmONor39x/Hd9LssdgcPoq+LIO0zc/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 201/417] media: dvbdev: drop refcount on error path in dvb_device_open()
Date: Mon, 22 Jan 2024 15:56:09 -0800
Message-ID: <20240122235758.895494870@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
index 9f9a97652708..d352e028491a 100644
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



