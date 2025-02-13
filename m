Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFA926B0B1;
	Thu, 13 Feb 2025 15:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459061; cv=none; b=A8sxNM1MUUWGCMjDJzeSm2sFpj5cdRGu4rHb/oUxO08rRlph/8FnoQBLRpbKE0hbcjcOLPfsxpE/KUJnWPaQ43pviyF4WRCM7EAnLLOGEsk/CoXi3+pcNg6gz5P7CtstmIFLHH5GPXljccCunJrteYGa2rCm1reNbrkwsdVRNIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459061; c=relaxed/simple;
	bh=G0yUaObmzvVE0kRzVVPvP9Ktxg4G+exdCT4T+0DaTnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LzrH45DabY7jINjzd2RS9choXwf2dQ008B8HMxbHtHPDuLNA57awJQl/8JHdRRg2+88A3Mr3AmgT27noKuHwu+M1qTupRWFgGEH/FxvJK8MmdGjhSshSQ3vUTNrkE8Oc5TE2uE7nT5PG63GvwGGMF5GDZBtj02WpgqXaFxAcGps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Poe1Ci8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Poe1Ci8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7EFC4CED1;
	Thu, 13 Feb 2025 15:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459060;
	bh=G0yUaObmzvVE0kRzVVPvP9Ktxg4G+exdCT4T+0DaTnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Poe1Ci8jOpLYG6uH0yu7n60CcwAPfXakpQUYuEsRv804Dz/R4K/zOzhXmyNv7csKB
	 DGSy+V7heOryK2jAoe8DnMU2oYEC+Pwc3kSs4XHtaIg1hTbs9pVLsYA1duW7Ld6C4e
	 swk8GdyUmyYMnjkZI4Oe9DNtPOIMGZlvx5K6NSco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.13 156/443] block: mark GFP_NOIO around sysfs ->store()
Date: Thu, 13 Feb 2025 15:25:21 +0100
Message-ID: <20250213142446.616474691@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <tom.leiming@gmail.com>

commit 7c0be4ead1f8f5f8be0803f347de0de81e3b8e1c upstream.

sysfs ->store is called with queue freezed, meantime we have several
->store() callbacks(update_nr_requests, wbt, scheduler) to allocate
memory with GFP_KERNEL which may run into direct reclaim code path,
then potential deadlock can be caused.

Fix the issue by marking NOIO around sysfs ->store()

Reported-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20250113015833.698458-1-ming.lei@redhat.com
Link: https://lore.kernel.org/linux-block/Z4RkemI9f6N5zoEF@fedora/T/#mc774c65eeca5c024d29695f9ac6152b87763f305
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-sysfs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -681,6 +681,7 @@ queue_attr_store(struct kobject *kobj, s
 	struct queue_sysfs_entry *entry = to_queue(attr);
 	struct gendisk *disk = container_of(kobj, struct gendisk, queue_kobj);
 	struct request_queue *q = disk->queue;
+	unsigned int noio_flag;
 	ssize_t res;
 
 	if (!entry->store_limit && !entry->store)
@@ -711,7 +712,9 @@ queue_attr_store(struct kobject *kobj, s
 
 	mutex_lock(&q->sysfs_lock);
 	blk_mq_freeze_queue(q);
+	noio_flag = memalloc_noio_save();
 	res = entry->store(disk, page, length);
+	memalloc_noio_restore(noio_flag);
 	blk_mq_unfreeze_queue(q);
 	mutex_unlock(&q->sysfs_lock);
 	return res;


