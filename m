Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B1E23C6;
	Tue, 23 Jan 2024 00:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969589; cv=none; b=M5UfdaerYccmnBd7mN4D8KT7uMzFUO8Xi01L4DKj9R1HgK4/Hux0gv+hHAddodrq0lo3F8pwI8q9mdlEP3BC5kbF17iu1qor9R+zDjV/wcRhpby+5/b67tD6SXztVPKDA/BEtnx4SiRzRm2yRJ+NKdf/sOi9+zJ5xRL6hruaSTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969589; c=relaxed/simple;
	bh=46iopOS9QSX7wU+OmJciXctQvU1oR1G8rYt0OhQ/9fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xd2AWIf4OUdgWZGR9PrGAMqlBPHqZ45tuNqF0C3e9w6YgaoUlH7qTWocQapYZH6g14Bi8+3TEnK/F/ikjlgJeNSgGGJVRmQnC5f18dXNRhPrYVhVZQLnFFFLnzvdhQfaL0V5GDuBzfLIutSMxgK5Vq+vjexNv+IceZTVyQ9GjAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rTAF0f/S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rTAF0f/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629D6C43390;
	Tue, 23 Jan 2024 00:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969589;
	bh=46iopOS9QSX7wU+OmJciXctQvU1oR1G8rYt0OhQ/9fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rTAF0f/SHo0GomMa7cRcd1jqHdyaPGLs1MeYglsK39nFU7n8ChaAMNjDmO2xx2J14
	 WMt+kkGD1SCTlgXdy+qwnDcIyuA6h9tv1NjeIo7d4+/nhtFhfr39y2qn5yrijKUwph
	 x+mNNpG/JDRqDTfb4FGmHEAObm9zB/8WrijXqwhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 317/641] media: dvbdev: drop refcount on error path in dvb_device_open()
Date: Mon, 22 Jan 2024 15:53:41 -0800
Message-ID: <20240122235827.804890807@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



