Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFA61448F2;
	Thu, 13 Jun 2024 12:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280506; cv=none; b=YLd5Hc6OK2zJoCw9szirlhJftE7jPhuaxFCKhp6PZ9hoRPsg2KawIcjLrXif4dWGQVNEnVp4AE0eKuGDC9g8LOcoCP36O1KKnBOm5Z+W9WFKgkMNKncbLEOeg1/s2OfQWk7kh8FQJjfQvdqpG2Uby4mZXX0wtWfodzMkWb9M9YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280506; c=relaxed/simple;
	bh=E7wwgaNYIb4guB3t/y7inB2fkb++YdVIJMF8ksx0mws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVelRuonqiD2NVSsKDAmMhieB1bo7Scqzi3rKSiLtYqUovDHosmDq0uMToWNSxYxC3Vhsi2RlyS1q/G4G2m0kYE4WAr9bf/Iq44WUIxlY6VDvj+qNiGDfZDA61QTqbHC6s1gXzsN0PIjkafbNX136ZkmpFsNB09IH7mFdAJqbHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIOcz/9X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIOcz/9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E7EC2BBFC;
	Thu, 13 Jun 2024 12:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280506;
	bh=E7wwgaNYIb4guB3t/y7inB2fkb++YdVIJMF8ksx0mws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIOcz/9Xk6bK5Au9qt5P2UPUbnPTYBrM2molhVq4ocQ6f4ksvk+OG10d1eyTkSE2B
	 mo5zXGutMlI/Nvd10JeH/RAmQIOSo8Gu27QLZL3bRj/c42e4pRVsRM3kGtH+8a6unP
	 VjAyoT4kpsMqMvfWqEiT7V2YQR+TkAH/vTRZe37Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.6 045/137] media: v4l: async: Dont set notifiers V4L2 device if registering fails
Date: Thu, 13 Jun 2024 13:33:45 +0200
Message-ID: <20240613113225.040956706@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 46bc0234ad38063ce550ecf135c1a52458f0a804 upstream.

The V4L2 device used to be set when the notifier was registered but this
has been moved to the notifier initialisation. Don't touch the V4L2 device
if registration fails.

Fixes: b8ec754ae4c5 ("media: v4l: async: Set v4l2_device and subdev in async notifier init")
Cc: <stable@vger.kernel.org> # for 6.6 and later
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-async.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -618,16 +618,10 @@ err_unlock:
 
 int v4l2_async_nf_register(struct v4l2_async_notifier *notifier)
 {
-	int ret;
-
 	if (WARN_ON(!notifier->v4l2_dev == !notifier->sd))
 		return -EINVAL;
 
-	ret = __v4l2_async_nf_register(notifier);
-	if (ret)
-		notifier->v4l2_dev = NULL;
-
-	return ret;
+	return __v4l2_async_nf_register(notifier);
 }
 EXPORT_SYMBOL(v4l2_async_nf_register);
 


