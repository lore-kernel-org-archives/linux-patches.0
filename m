Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75481E493;
	Tue,  8 Oct 2024 12:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390759; cv=none; b=TN23jxJfm13uvdhqO5DNO5bUDJQyUq061QUPHQ3Dic+ksTB8rvRN0P9jXEnYoFjFCgpnMpCVV6h4ViaqTg42BSpTMuXx9cWVCAgPIv9MRHluLa7RsgoJcgd+IIWF5/fDxBZ5mfDXtwB3DmdxXQTfGWIxcwI2IkfptBXsZqKEdEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390759; c=relaxed/simple;
	bh=DkNC7yNQR7lFOSjvRqXwmMY0cIuav0HGT5gRPrefNSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+2/idgHqDk33/Em60gorr23tanDPcidCCPV4i0a89DRuIsISH2HizkLiLui1PiBFdOOkioDxcl2SVkuHnT84p7Svk3N+BWYsHWvyv7MO1bLUMjiBv4GLP0mGiYJvkK51T2GnKBb4gCXmpRSbgKiBELumvwjsvDuWfauqR8eH/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4eUKE7h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4eUKE7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB48C4CEC7;
	Tue,  8 Oct 2024 12:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390759;
	bh=DkNC7yNQR7lFOSjvRqXwmMY0cIuav0HGT5gRPrefNSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4eUKE7h4oQDf05px55Qs3SjYnllWlKqG+84PDjAxhJEhLUkZTuYq1uT3b1tPeE6m
	 awJA9LlcLGCq9/aV8fRd5663zAgXuGM+9RNRUYVybk4zZHDipTr5nlYUBGeBr4WXla
	 0IHpzurHhuKBtRZ1zmwI85R087reDyc4JfIgO94k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Tomasz Figa <tfiga@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 6.10 384/482] media: videobuf2: Drop minimum allocation requirement of 2 buffers
Date: Tue,  8 Oct 2024 14:07:27 +0200
Message-ID: <20241008115703.527350639@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2603,13 +2603,6 @@ int vb2_core_queue_init(struct vb2_queue
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


