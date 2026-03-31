Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F98128507E;
	Tue, 31 Mar 2026 11:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774956646; cv=none; b=rWJCa3GgC/kuHjFxRVckOz5n9U6N5vtf+Psw9jiPS1Fn/yp/avcXP23B0O3+NmnVxN5iTpNTNltDBwoGPjD/VKmNyTrvaMXplffVlUlBMO6LiJEooA53x55AISrEI0C9TnA8mHc4+Lj610RIqAicUB7Bn/Gs7xiF8/87ZlTE4SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774956646; c=relaxed/simple;
	bh=CCUP4sHYCQ9axw7943rER5xM/KZ1AUs+kGKRSkEffmc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=JPt7Zb7F2MNwVG0JleoRcDnebIz1+duDABVqch6TNl1I7QRUt+b2e9SxT/+8+or5rwcg1/l0dYsZpy+W8LOQg9hzTPHh0uL5GbcHyI5/3btDVoJnOZGsnYmiUWQ89hzQc0Z+AB2pMb9ejxNWJWd7lfJVUF8ZDqu9fPBmNeTkmtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BjzGfbrc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BjzGfbrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C424FC19423;
	Tue, 31 Mar 2026 11:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774956646;
	bh=CCUP4sHYCQ9axw7943rER5xM/KZ1AUs+kGKRSkEffmc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=BjzGfbrcnXGWiW9k25HwLiyEozu/Ckerj8dWUv/smgHmYJZ5FVv5V4TxnXGwmtCbY
	 zy5B2TZ1zgsJcceDcZf6uuFXAn+qNUJN2OWLqBtC4DlyvvrmDgG80WECActMxf6ocn
	 s2+w7/6M2DOHFFyEf8ZCbZgmdRTnZTQXNpwrUfMM=
Subject: Patch "nvme: fix admin queue leak on controller reset" has been added to the 6.6-stable tree
To: 1468888505@139.com,axboe@fb.com,gregkh@linuxfoundation.org,hare@suse.de,hch@lst.de,kbusch@kernel.org,kch@nvidia.com,linux-nvme@lists.infradead.org,ming.lei@redhat.com,patches@lists.linux.dev,sagi@grimberg.me,yi.zhang@redhat.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 31 Mar 2026 13:30:22 +0200
In-Reply-To: <20260331073659.3136206-1-1468888505@139.com>
Message-ID: <2026033122-stood-unaligned-08af@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    nvme: fix admin queue leak on controller reset

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     nvme-fix-admin-queue-leak-on-controller-reset.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-231348-greg=kroah.com@vger.kernel.org Tue Mar 31 09:44:05 2026
From: Li hongliang <1468888505@139.com>
Date: Tue, 31 Mar 2026 15:36:59 +0800
Subject: nvme: fix admin queue leak on controller reset
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, ming.lei@redhat.com
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, yi.zhang@redhat.com, kbusch@kernel.org, axboe@fb.com, hch@lst.de, sagi@grimberg.me, hare@suse.de, kch@nvidia.com, linux-nvme@lists.infradead.org
Message-ID: <20260331073659.3136206-1-1468888505@139.com>

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit b84bb7bd913d8ca2f976ee6faf4a174f91c02b8d ]

When nvme_alloc_admin_tag_set() is called during a controller reset,
a previous admin queue may still exist. Release it properly before
allocating a new one to avoid orphaning the old queue.

This fixes a regression introduced by commit 03b3bcd319b3 ("nvme: fix
admin request_queue lifetime").

Cc: Keith Busch <kbusch@kernel.org>
Fixes: 03b3bcd319b3 ("nvme: fix admin request_queue lifetime").
Reported-and-tested-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/linux-block/CAHj4cs9wv3SdPo+N01Fw2SHBYDs9tj2M_e1-GdQOkRy=DsBB1w@mail.gmail.com/
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4287,6 +4287,13 @@ int nvme_alloc_admin_tag_set(struct nvme
 	if (ret)
 		return ret;
 
+	/*
+	 * If a previous admin queue exists (e.g., from before a reset),
+	 * put it now before allocating a new one to avoid orphaning it.
+	 */
+	if (ctrl->admin_q)
+		blk_put_queue(ctrl->admin_q);
+
 	ctrl->admin_q = blk_mq_init_queue(set);
 	if (IS_ERR(ctrl->admin_q)) {
 		ret = PTR_ERR(ctrl->admin_q);


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.6/nvme-fix-admin-queue-leak-on-controller-reset.patch
