Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660791272D1;
	Tue, 23 Jan 2024 00:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968681; cv=none; b=VLzJMJ2p5L3K44a9tNbNouEvJsuQg+7ZfHAdIk2bhc4lO0jMa/k8rQmLGvNlEGiU1H59W4YIXW0wUDp56BzdOI46SXpvfyE1lPLCY3ZMWNbMX7BMS0sozPipJBZdFFGZ4bCYfCNdLyDFopB6cAtbtBR5MzDuAGJPeKjeUpCR490=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968681; c=relaxed/simple;
	bh=CGWP3BKy2k/5jqfY4AbxerSRZN0QCC07BGalz/B4fLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U01boavI/5dpe0e2ENcquDUuLDZB0BR4mVCGhYixoVOJ2nGJF+ebbmN6zmoPWtEykI6V7m5PydvWyVB3E0KwYaRsk1oZybw8LihnrbSgDVZtGfEaIAb13si8hUUn+qZfliGWTABsFuBBcuhmeOqipQDt8zwYtMap8uxwKGOxS5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SvNQghIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SvNQghIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF76C433F1;
	Tue, 23 Jan 2024 00:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968680;
	bh=CGWP3BKy2k/5jqfY4AbxerSRZN0QCC07BGalz/B4fLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SvNQghIXpNgU8XYuA122ZF1yliC7TeiajOe+G0K+s/cZXKipa8ETxDvVEFs0HkdkW
	 2FKPSOK5eHpxbLVUbUK9nRVuA3/hWLVlqhXiaAJf0PlyL9d5VM1U0CO23+CNVKks4P
	 vdMP1VrGMO2WOckvQOmWP3qEdtkObjFjkGo8XJeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 101/148] media: dvbdev: drop refcount on error path in dvb_device_open()
Date: Mon, 22 Jan 2024 15:57:37 -0800
Message-ID: <20240122235716.489290429@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index e103999711fc..b8335ede6626 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -113,6 +113,8 @@ static int dvb_device_open(struct inode *inode, struct file *file)
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



