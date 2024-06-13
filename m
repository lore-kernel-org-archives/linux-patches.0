Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE9D143861;
	Thu, 13 Jun 2024 11:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279334; cv=none; b=hnRq+HX60s/8eD01RQozp3XtDtZx8lCRJbcTYLM3MQcXrEEBlddZylGmfoLI6l+Qskuc75BzB0wkj+maCSXD96umRZ57H+JIPG78HSvsv0ypnF7HVwYtjHmnMm4FL/8x3mrQ43Yxuy8LFIN/I4+zDB4qRnwrGVNEH6/Om64uA84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279334; c=relaxed/simple;
	bh=Lq6sCIz2tLATC3JBE1MO5RrSiR14I+yGWYc+j0x/OpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbjxG1bxgNDO21bxcw0kfGyIhZ2UI7wJkUNRhH7xZJdBvENJCY3jUTMVO041cQFt694+uocjutqg1GNKUCDYUgDDOcLT/pH4KzljdHpG3Ltiet85hL1htKpAo5YG7cFKR0oCYUJRDcgnC2SbjGqtDNFeUBOBqcxzTJLFDI192YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+L3jGn2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+L3jGn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70BFC2BBFC;
	Thu, 13 Jun 2024 11:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279334;
	bh=Lq6sCIz2tLATC3JBE1MO5RrSiR14I+yGWYc+j0x/OpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+L3jGn2QtE+AUPBtu6bR2SqRpZdGIW9Sk1GZ/K0LTDv+AWuuFf3P0Pe2WZRVD89J
	 XAnRBZTZU6cFs7lGspAUSSuD1GqpAMyfutSRhUsPdWOj96u3Hr2dvA+EJGR9q+1xP1
	 o6ZtyWrgfjqa3myOneWiUkZ0yddKKRwSDN/kMDOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.9 041/157] media: v4l: async: Dont set notifiers V4L2 device if registering fails
Date: Thu, 13 Jun 2024 13:32:46 +0200
Message-ID: <20240613113229.012671656@linuxfoundation.org>
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
 


