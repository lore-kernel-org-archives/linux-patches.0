Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7D41C9B99;
	Tue,  8 Oct 2024 13:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392660; cv=none; b=fDFsa7zDRZ6G7K/0XmHtQA8iZMvQTeyHA1XhEbFH1AjKCb22xgLXh523f8BKkSSu9bdK68M0rqRosb3fXj1Z9kjSh+GnZCnQBsFEshb2zIoUEGEW9NZObtvDkBNmfSCCADqTKM2SXGwuCIWS9dtOk69G/dQNUSI6tC4dA1eCJL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392660; c=relaxed/simple;
	bh=Lu6lXt7t7/PbH9JJQOTTGQw56c+56Qa/CkfMZxBmlkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aL89cxULx7IBDA2Em0Z1ZFr0JZI1O5msi8R3W/RqufQBppKq/1S1iGPAzkHgh3WSIllxMMv4WfH5nV9zrUzdFGIaGSGHbf0IefsD6/ri7LKG6uJ2AhlJa11WRpdsCvg7nAjkpldUw3YlRew7HRJnj4Ty3ZpsGST0uU+YYj+0KpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1n+kNOcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1n+kNOcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6CCC4CEC7;
	Tue,  8 Oct 2024 13:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392660;
	bh=Lu6lXt7t7/PbH9JJQOTTGQw56c+56Qa/CkfMZxBmlkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1n+kNOcfbificOUS/yZr/6OFEb6dmGaJV5mG+wiDRG0knc6GZOwQcFhMFZr/Vq+eD
	 LvwrwFjb2GV7/+0hjSC6WtkT5oO14Zi2xBdYQscW42YKzWUFLpYq55qP/Au052kxEE
	 tZL6+fQ8mGWmXNd6xJgf+Cfw9OYK6bHJEZFa5H7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Tomasz Figa <tfiga@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 6.11 450/558] media: videobuf2: Drop minimum allocation requirement of 2 buffers
Date: Tue,  8 Oct 2024 14:08:00 +0200
Message-ID: <20241008115719.970420056@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

commit e5700c9037727d5a69a677d6dba25010b485d65b upstream.

When introducing the ability for drivers to indicate the minimum number
of buffers they require an application to allocate, commit 6662edcd32cc
("media: videobuf2: Add min_reqbufs_allocation field to vb2_queue
structure") also introduced a global minimum of 2 buffers. It turns out
this breaks the Renesas R-Car VSP test suite, where a test that
allocates a single buffer fails when two buffers are used.

One may consider debatable whether test suite failures without failures
in production use cases should be considered as a regression, but
operation with a single buffer is a valid use case. While full frame
rate can't be maintained, memory-to-memory devices can still be used
with a decent efficiency, and requiring applications to allocate
multiple buffers for single-shot use cases with capture devices would
just waste memory.

For those reasons, fix the regression by dropping the global minimum of
buffers. Individual drivers can still set their own minimum.

Fixes: 6662edcd32cc ("media: videobuf2: Add min_reqbufs_allocation field to vb2_queue structure")
Cc: stable@vger.kernel.org
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Acked-by: Tomasz Figa <tfiga@chromium.org>
Link: https://lore.kernel.org/r/20240825232449.25905-1-laurent.pinchart+renesas@ideasonboard.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/common/videobuf2/videobuf2-core.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -2602,13 +2602,6 @@ int vb2_core_queue_init(struct vb2_queue
 		return -EINVAL;
 
 	/*
-	 * The minimum requirement is 2: one buffer is used
-	 * by the hardware while the other is being processed by userspace.
-	 */
-	if (q->min_reqbufs_allocation < 2)
-		q->min_reqbufs_allocation = 2;
-
-	/*
 	 * If the driver needs 'min_queued_buffers' in the queue before
 	 * calling start_streaming() then the minimum requirement is
 	 * 'min_queued_buffers + 1' to keep at least one buffer available


