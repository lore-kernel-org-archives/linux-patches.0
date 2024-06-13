Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4F61448F2;
	Thu, 13 Jun 2024 12:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280509; cv=none; b=bsCrGgcYg8ntrKzMUhB0KZFrHd8MdUwkOwUG/k8lY5lffta2ADvbmtKs0MSWj3MagJpjnEbhXDsOmWi1GXaiLitLxLJYlmBAU37916zgeiuohgLCuBR45gkBgZUGlaB7Ng+a4H1v3UKKOptrRf8nwWIFrYICihgbG0oJ9fivMpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280509; c=relaxed/simple;
	bh=gksvNOL2diwEGmiluUnj63efImVXv2OhUaZooHr90DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTRgCY+YKCqcOnT5ZKEn7Kc3uoKTOev5ABlMBv/aQWeYVwycy96rGMedCixxciqmw9gBGGX+DB2O9lLoSii/8tKqbGynbAlf1XFSbeN2TZwoZBYvPtRc3B9eUxXlciTWE5O3clPKpV1zxPjLxiI6AkYSmumA4oYDddsvWNiSYQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLfz496U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLfz496U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F37C2BBFC;
	Thu, 13 Jun 2024 12:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280509;
	bh=gksvNOL2diwEGmiluUnj63efImVXv2OhUaZooHr90DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sLfz496UP8d+WkrbNuzgSl67v6C4kusQLptYUdlw6yhCnjnfL4r/BCKrcCcviaiqh
	 3cXTQamDrA4PObcTkvING2wkI0UWntL0HeJfZs55LLLzt+whjDmgaPz5NQMi+eLTao
	 0L2N2eR9PCXIZdNMZcHLjsQxV/0G/pya/e7LzSAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.6 046/137] media: v4l: async: Fix notifier list entry init
Date: Thu, 13 Jun 2024 13:33:46 +0200
Message-ID: <20240613113225.080666176@linuxfoundation.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

commit 6d8acd02c4c6a8f917eefac1de2e035521ca119d upstream.

struct v4l2_async_notifier has several list_head members, but only
waiting_list and done_list are initialized. notifier_entry was kept
'zeroed' leading to an uninitialized list_head.
This results in a NULL-pointer dereference if csi2_async_register() fails,
e.g. node for remote endpoint is disabled, and returns -ENOTCONN.
The following calls to v4l2_async_nf_unregister() results in a NULL
pointer dereference.
Add the missing list head initializer.

Fixes: b8ec754ae4c5 ("media: v4l: async: Set v4l2_device and subdev in async notifier init")
Cc: <stable@vger.kernel.org> # for 6.6 and later
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-async.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -563,6 +563,7 @@ void v4l2_async_nf_init(struct v4l2_asyn
 {
 	INIT_LIST_HEAD(&notifier->waiting_list);
 	INIT_LIST_HEAD(&notifier->done_list);
+	INIT_LIST_HEAD(&notifier->notifier_entry);
 	notifier->v4l2_dev = v4l2_dev;
 }
 EXPORT_SYMBOL(v4l2_async_nf_init);
@@ -572,6 +573,7 @@ void v4l2_async_subdev_nf_init(struct v4
 {
 	INIT_LIST_HEAD(&notifier->waiting_list);
 	INIT_LIST_HEAD(&notifier->done_list);
+	INIT_LIST_HEAD(&notifier->notifier_entry);
 	notifier->sd = sd;
 }
 EXPORT_SYMBOL_GPL(v4l2_async_subdev_nf_init);


