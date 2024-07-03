Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E1917D349;
	Wed,  3 Jul 2024 10:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003376; cv=none; b=foYItuoVywZ4ltyW1Frkx9NwQ0Mp8uxgWQ78Kq805TqLHfMUSglvvD9DupQS26PQkuBAc3fwBBSC4tcQ1+lmMfogb3Wq+6vNNudGmIex6eT3nFnInWYB4MHbASjvXa6YO45a/HsMpz2OHs6UZBTDawyGK2z/23bO3my6bMm2C9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003376; c=relaxed/simple;
	bh=p+lDYXD7orzJ43kvQTPhaZWFk+rZ8gZl5grA89Ri5WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s808gkOVbImYEwjZss0MsrXqq6+jnHN0C8Oc39M8kOYNjigu6YzwO//k+pQr31OtRaBNeIZt91YO345bOWx0TL7hNEeXrMOjNYc3ryeVj3BoKRBVnLipfBCK8L5jcrEW8O9x+UpwJhk1TD8GLn8/m9gfemXjNAX1nfBhkB9zvV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOfpUh1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOfpUh1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F29C2BD10;
	Wed,  3 Jul 2024 10:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003376;
	bh=p+lDYXD7orzJ43kvQTPhaZWFk+rZ8gZl5grA89Ri5WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOfpUh1oe0BFQTHMT+hdh+jaKILVcg0yKZzbJakynTaEEexHZR/9qlo2O/zgZDhpn
	 5JyggVSG4ohMGzGROszufLvaBkR5PAifcciYgnx55HLPjT1jOIkjSCszqnYw0K5Wa8
	 cBuR2aNerhYwk36kHVyMqFOPEkfJOURaD+YYt7Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 021/139] media: mc: mark the media devnode as registered from the, start
Date: Wed,  3 Jul 2024 12:38:38 +0200
Message-ID: <20240703102831.241055820@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 4bc60736154bc9e0e39d3b88918f5d3762ebe5e0 ]

First the media device node was created, and if successful it was
marked as 'registered'. This leaves a small race condition where
an application can open the device node and get an error back
because the 'registered' flag was not yet set.

Change the order: first set the 'registered' flag, then actually
register the media device node. If that fails, then clear the flag.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Fixes: cf4b9211b568 ("[media] media: Media device node support")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/media-devnode.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 6b87a721dc499..b4a62b3172e3d 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -253,15 +253,14 @@ int __must_check media_devnode_register(struct media_device *mdev,
 	devnode->cdev.owner = owner;
 
 	/* Part 3: Add the media and char device */
+	set_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
 	ret = cdev_device_add(&devnode->cdev, &devnode->dev);
 	if (ret < 0) {
+		clear_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
 		pr_err("%s: cdev_device_add failed\n", __func__);
 		goto cdev_add_error;
 	}
 
-	/* Part 4: Activate this minor. The char device can now be used. */
-	set_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
-
 	return 0;
 
 cdev_add_error:
-- 
2.43.0



