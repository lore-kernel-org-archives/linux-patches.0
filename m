Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32825289E17;
	Thu, 27 Nov 2025 14:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254963; cv=none; b=HXWUjm+KUtwbMSUtI7yY/n3RQ9paPUwaz8xJA6hIYJ3JvgoTFiLH/69gikJm68v7Mrbhx6WFBV/NK2qKKw/0WZ66uqtNHYyhcjP2MnOhH3b/ekR+JHdNFCt0GrqG8QZJ5X8kRoVzv9eU0IYzwJXalTi7D1FASF6Ti4XoXjI2JKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254963; c=relaxed/simple;
	bh=dZo7htpguKCidEM6eKKKXidjVUwURrMQsmueHOaQ2TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oU4EdqkevRENHRtNF7R+xUSEcFKJpmRsroHbFCHunpjeBL1kF0zTXUkh9V2Oq8DKA3ftvxv1Z8EcUN7uH1UPxjv216TIyQN3yq6JFQaxOaF9e8NIqV8dgFtssIpcAifzwqcov9Rs/Ec14ve+LxsDCr4lqGJK7H/8Qem03uB2Aa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFEdTn1T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFEdTn1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2045C113D0;
	Thu, 27 Nov 2025 14:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254963;
	bh=dZo7htpguKCidEM6eKKKXidjVUwURrMQsmueHOaQ2TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFEdTn1Td6kumRUkOkBe5ZJzP/kS9a9DxLLn5DTBcktnOxxDdhLzNC+ITuqbHuGuM
	 cqQ73Bus7IrRsRBBd8cCTvYozfBZfA17+IAwu0Iy4PO9h6RoAdC6cniUnSfauxtS7B
	 81rkSbH5aPsFVyd1AwFWN0yKgGWRzFE3WIVg9/e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 46/86] nvme-multipath: fix lockdep WARN due to partition scan work
Date: Thu, 27 Nov 2025 15:46:02 +0100
Message-ID: <20251127144029.513345949@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit 6d87cd5335784351280f82c47cc8a657271929c3 ]

Blktests test cases nvme/014, 057 and 058 fail occasionally due to a
lockdep WARN. As reported in the Closes tag URL, the WARN indicates that
a deadlock can happen due to the dependency among disk->open_mutex,
kblockd workqueue completion and partition_scan_work completion.

To avoid the lockdep WARN and the potential deadlock, cut the dependency
by running the partition_scan_work not by kblockd workqueue but by
nvme_wq.

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/linux-block/CAHj4cs8mJ+R_GmQm9R8ebResKAWUE8kF5+_WVg0v8zndmqd6BQ@mail.gmail.com/
Link: https://lore.kernel.org/linux-block/oeyzci6ffshpukpfqgztsdeke5ost5hzsuz4rrsjfmvpqcevax@5nhnwbkzbrpa/
Fixes: 1f021341eef4 ("nvme-multipath: defer partition scanning")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 57416bbf9344f..578f4f29eacfe 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -686,7 +686,7 @@ static void nvme_mpath_set_live(struct nvme_ns *ns)
 			return;
 		}
 		nvme_add_ns_head_cdev(head);
-		kblockd_schedule_work(&head->partition_scan_work);
+		queue_work(nvme_wq, &head->partition_scan_work);
 	}
 
 	mutex_lock(&head->lock);
-- 
2.51.0



