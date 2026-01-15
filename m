Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926C842049;
	Thu, 15 Jan 2026 16:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496006; cv=none; b=G8jYbRbvoWAlwYoUWUc3ruZpJLWiN5wy1qmxmak0mo0QXlJe79EWiFqxkeFNUBzbQS/YXSUI/ayEnUbCxuETxiEFBpHXnYo/yqOJ+709Njei85Ns9OuRnfHbS2UxRbD+WNVw30vOih1JI7G3Gvd4qk/Nk6j/HHYN6hEgTiykbtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496006; c=relaxed/simple;
	bh=8joNl3LGViLPAMG0sPi05lUxlSeGC2GOnXZwb6Byv+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itI0CeW1ylTfkH4VqCdJVAPRRwI4eimBoB1UgReX6lh9/T7FpY7GIXag/cHutKvmCBNZCA2uRl7Qpz3Wwkbc9mb8DvmQo3xz7fGON9tVXffNmWTVW567G8T6zGmrw0xsIAZ1GcHVyIcv1IccZmVVgQ+AEra+3g/H1VZMiBzX3sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJOfiVWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJOfiVWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFEDC19421;
	Thu, 15 Jan 2026 16:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496006;
	bh=8joNl3LGViLPAMG0sPi05lUxlSeGC2GOnXZwb6Byv+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJOfiVWxvYhpl+K+Yq2Bb0NQ7/buR30L+1SQ0jBYPxixJ3vqezjteq5rGjqsCb7BB
	 WH7ONbh/VRDEfxbAjxjdfKH1PLQjXcVTuJXg9lMpwtq2pidqeUUK7GTcnJxO0HnEmg
	 ihOzvTOkfarXmSvN3jpBp2nFdKBd8/Ebd8JufSKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 045/181] ublk: reorder tag_set initialization before queue allocation
Date: Thu, 15 Jan 2026 17:46:22 +0100
Message-ID: <20260115164203.956190061@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

commit 011af85ccd871526df36988c7ff20ca375fb804d upstream.

Move ublk_add_tag_set() before ublk_init_queues() in the device
initialization path. This allows us to use the blk-mq CPU-to-queue
mapping established by the tag_set to determine the appropriate
NUMA node for each queue allocation.

The error handling paths are also reordered accordingly.

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ Upstream commit 529d4d632788 ("ublk: implement NUMA-aware memory allocation")
  is ported to linux-6.18.y, but it depends on commit 011af85ccd87 ("ublk:
  reorder tag_set initialization before queue allocation"). kernel panic is
  reported on 6.18.y: https://github.com/ublk-org/ublksrv/issues/174 ]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/ublk_drv.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -3280,17 +3280,17 @@ static int ublk_ctrl_add_dev(const struc
 			ub->dev_info.nr_hw_queues, nr_cpu_ids);
 	ublk_align_max_io_size(ub);
 
-	ret = ublk_init_queues(ub);
+	ret = ublk_add_tag_set(ub);
 	if (ret)
 		goto out_free_dev_number;
 
-	ret = ublk_add_tag_set(ub);
+	ret = ublk_init_queues(ub);
 	if (ret)
-		goto out_deinit_queues;
+		goto out_free_tag_set;
 
 	ret = -EFAULT;
 	if (copy_to_user(argp, &ub->dev_info, sizeof(info)))
-		goto out_free_tag_set;
+		goto out_deinit_queues;
 
 	/*
 	 * Add the char dev so that ublksrv daemon can be setup.
@@ -3299,10 +3299,10 @@ static int ublk_ctrl_add_dev(const struc
 	ret = ublk_add_chdev(ub);
 	goto out_unlock;
 
-out_free_tag_set:
-	blk_mq_free_tag_set(&ub->tag_set);
 out_deinit_queues:
 	ublk_deinit_queues(ub);
+out_free_tag_set:
+	blk_mq_free_tag_set(&ub->tag_set);
 out_free_dev_number:
 	ublk_free_dev_number(ub);
 out_free_ub:


