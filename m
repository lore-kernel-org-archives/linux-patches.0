Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E121D12BF3D;
	Tue, 23 Jan 2024 00:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968965; cv=none; b=TibKemgvSCpJGTGqY60kA+y2EOyMTR9Ax/b/ZvRADqD3IBvRHfkqaF97sEBrRiiMm4rCiQTnNeOj63SjtcOtuMgG4AQGXQkDP7fFFqRmO4EbVOjdSReJw/RZFPIRm7MG1Mn1HvZfbF4/xjBRn+RsKM1X24T2dkYY+TJOjdVgy/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968965; c=relaxed/simple;
	bh=mFhvM0Q0+AsMLYUZI5uFr5iSgnpzYzARxMJyfgbuzeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEPZK2NQtibwz9VcFqLzVmANvLI37wNqTjHWIy44hfnIjg+SXsLH95tPd/ALT9I1388ct10/nj5vXPD5y6DkpiybXJ6hDHmY1qQjXRsXCK7ezN5bYfZTk1G1ko1/slKtpy2KxY749qGQAR3vAtnvudEnS3CitRe5GXoxXO2iXQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJUbYltm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJUbYltm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93210C433F1;
	Tue, 23 Jan 2024 00:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968964;
	bh=mFhvM0Q0+AsMLYUZI5uFr5iSgnpzYzARxMJyfgbuzeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJUbYltm2/4RQX4t9XSILC1BevrLM2t+gBQcBC54yJDVqy5C7U4YxWs/0Pm3w4JnG
	 zNv7ik82BFvA5uD62DABe6NEs4gFYk74Zg3BWJNCGretfeR/sJB7t6rnBZZvnTalpT
	 KGWpUYbSCtLspEV3imGyIBKJlFwtAjxnekszVURY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 126/194] media: dvbdev: drop refcount on error path in dvb_device_open()
Date: Mon, 22 Jan 2024 15:57:36 -0800
Message-ID: <20240122235724.640921363@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 31b299ced3c1..e7cd7b13fc28 100644
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



