Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC32264CF2;
	Tue, 23 Jan 2024 00:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971540; cv=none; b=ZbfkPNlS0Ymhc7JDp5faWXfdvl1QcOAaRclqrDBiaKGJyYPsq7VBRTk+KGyZVig2vJE0PSuoe9IdAdsQpFE4D8VxmPealqYvN+cELsn+XLYBhVY+8fiJn6AmSA9Ze8k2R3clpI5vFPEEozIUhzNxgcvkW2nlOarILrZL5Js6QD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971540; c=relaxed/simple;
	bh=+7VUuJj5flWFXQAXMk6MXBfnDvIvDOrPyWXS4lLeZAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fis5/BM+KctzieF+usAp5ue1/kZpX7vZvLzFooKKO65Vglwq8Bz4L7VgVx+k0Insfg3DYNhnYXkQmTAZ1hP+IwNLhl3bVRjP720OLOt6i5P4HpFCtaVd2PxOyUZA34wBVNF5dCz5csMcjcMbl11Rl1j6YkgEEmt8df6KQqomZFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZKVOanh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZKVOanh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E92C433C7;
	Tue, 23 Jan 2024 00:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971540;
	bh=+7VUuJj5flWFXQAXMk6MXBfnDvIvDOrPyWXS4lLeZAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZKVOanhKoOjur1XMTRUUfMWbIe9xvxn1Mn6rOS3Faq7Y4MYXunRuRZTbJirNg4bx
	 EHVGFQdiL0YjL1RMglAsMcD/uZqULAIvd4UxTARq6ry+G5lygRPtR58UkWrAFQPCer
	 GW6ipTotWB1m3KRmJYZ2NFuhdLknh6TVUoNXuDqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 169/286] media: dvbdev: drop refcount on error path in dvb_device_open()
Date: Mon, 22 Jan 2024 15:57:55 -0800
Message-ID: <20240122235738.684283273@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



