Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94244144D10;
	Thu, 13 Jun 2024 11:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279331; cv=none; b=nVOLiFaH5wCd7Ybv4N88houUF0GG9ulz2Vlri/+5d7/wkAGghM3ep8B55xAc9ilYRx9M75rLiFMj+9fA/vk5qspwbF/Kw84cbHHGclRr0ffwtZ23k11nJn5fftl9w+d4tkQ3VEP0JiUgf45VUqMQRwCJ2j2uAcatVd4MZi2GC+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279331; c=relaxed/simple;
	bh=ebARyGffjBB/xbBj66ltijwX1FXWJybz/CIuhqgJaRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0zBWt7ClT1dvHMS+pRuPdF6ZJml0opF147twj0s9RuuskEbneT/F1WbG2YEXWEV6oB0JPw0WeKSTn0q/2O75nhp+IEgWpNBbNvsCMq4phVETC0R9XXkQutyhl6jL3pZcGMFgHydT+3d6NYIPZNHQHEsJ+qY0hLN6mye2J50zlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2ut4i3n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2ut4i3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACDBC2BBFC;
	Thu, 13 Jun 2024 11:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279331;
	bh=ebARyGffjBB/xbBj66ltijwX1FXWJybz/CIuhqgJaRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2ut4i3nq5+BGtVXX9nL7bGqGI3pQdIxgnWhrKCnL/jGeRzMrrtJgoOgT0DB0HPAB
	 VADGm/RvsrhGhF1lHb4i8pkKD80W6s3SxyFWzcRpgD7HBtr4Px5BBy0EHAz3s2f6lw
	 +fNB9+/WztvuQdX9RVbPr9HhJ2g526YEgIskx6DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.9 040/157] media: v4l: async: Properly re-initialise notifier entry in unregister
Date: Thu, 13 Jun 2024 13:32:45 +0200
Message-ID: <20240613113228.972687307@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 9537a8425a7a0222999d5839a0b394b1e8834b4a upstream.

The notifier_entry of a notifier is not re-initialised after unregistering
the notifier. This leads to dangling pointers being left there so use
list_del_init() to return the notifier_entry an empty list.

Fixes: b8ec754ae4c5 ("media: v4l: async: Set v4l2_device and subdev in async notifier init")
Cc: <stable@vger.kernel.org> # for 6.6 and later
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-async.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -639,7 +639,7 @@ __v4l2_async_nf_unregister(struct v4l2_a
 
 	v4l2_async_nf_unbind_all_subdevs(notifier);
 
-	list_del(&notifier->notifier_entry);
+	list_del_init(&notifier->notifier_entry);
 }
 
 void v4l2_async_nf_unregister(struct v4l2_async_notifier *notifier)


