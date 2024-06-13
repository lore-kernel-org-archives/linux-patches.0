Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9AA146597;
	Thu, 13 Jun 2024 12:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280219; cv=none; b=Ts8xV8qnJaWA+fiJ7+NGB36QdpYOpnm+rXEQBQz+o0es/asS0ddoeQqmMZ+nkKBDjBxUmF79988LBnx/TKgpJFr2LNIi7o6lUoE7YqnH4mcDyQIZhDpvcox/pcdx4Wtw53OvFxxMbQ6LB5NNWyLOA+VfuwoLMyK6gUSFLyOGOQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280219; c=relaxed/simple;
	bh=1et/ap9D/hi+BUrPsQW4xCT9XIQqJCEZ8NU0xdmO6WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNF4qVipGw7mx/JAop/sAIp9ntjR/nzebrPRiQulf8ECkVJfV4E/jt58KNVW00tEO2AACgjW15363mXHL5mpaIHt0vsom8jbY8Dl+gDTGLJD7nA3+TYMACph0XpUlc6s2U+C1mM+O4NkpTsYHl0CyxAV8PUmokdqa6BcL4umQ3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8kgNIxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8kgNIxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86726C2BBFC;
	Thu, 13 Jun 2024 12:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280218;
	bh=1et/ap9D/hi+BUrPsQW4xCT9XIQqJCEZ8NU0xdmO6WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8kgNIxMdm4G2YK7/PGxiFp2HtfCW4QkogCCvovPLPJqnl9eobre4fiUe+mqycCL8
	 BmTOWgiL6tz1h20+11e8ovhlugR7Ma4JCU+24XeV4Xa+cL+bFuvdI1v5acMhPgzkMZ
	 43lVSJX0LWGbhITWuHgf6qBdSiYHT/+UQqkF/fTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 5.4 181/202] media: mc: mark the media devnode as registered from the, start
Date: Thu, 13 Jun 2024 13:34:39 +0200
Message-ID: <20240613113234.723967678@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit 4bc60736154bc9e0e39d3b88918f5d3762ebe5e0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/mc/mc-devnode.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/media/mc/mc-devnode.c
+++ b/drivers/media/mc/mc-devnode.c
@@ -246,15 +246,14 @@ int __must_check media_devnode_register(
 	kobject_set_name(&devnode->cdev.kobj, "media%d", devnode->minor);
 
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


