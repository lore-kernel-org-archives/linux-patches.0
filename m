Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA4B289811;
	Thu, 27 Nov 2025 14:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255421; cv=none; b=uEn3Q1e7DtHspxMpkwdCpk7pSwmf+U05Af4IsGQPqQajtqRKyRZTLUhFv1iFBO0LShK7PX8LH4vX1t0uf/pHsBH4967UNehtS1gSjjx7vMdx1hDshAauqj7nGbLn5WSecc/FNUH63IyN9tjuS/Akka0d1mlThc8cEp3dOnh2wpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255421; c=relaxed/simple;
	bh=8kNgnz/lYUeR2hhDdSG7RacQ1ML7s8EM2kiPkDF4l94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnatqnhSbN+kumA44dgRlqYMSYlxjuQL9PjQd/ScHt6/bu0t4Z4xxPnFBe7oC5Z51BRVPpbotryRuN4leAwmkLXSlW0X8Af9Cahq/0rAmo8zm09uwSfBCdN/pfb7/YPh5Qc1skT6FU/rX+0Exb5Pitt9Hbd633L/FJ1BsszVQwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLytJXRs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLytJXRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099D7C4CEF8;
	Thu, 27 Nov 2025 14:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255421;
	bh=8kNgnz/lYUeR2hhDdSG7RacQ1ML7s8EM2kiPkDF4l94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLytJXRsx0t9ll3sOmMKrG/+EmJqoFUd+3wzmQ0RNHeZU0mD9JugSddg1ST0Lww5r
	 tq4KgzJ9Qcs5KfaBTmi9EfME+4GKHs8WvjSVe3yyE+Eduw8wWpMJIqUq0sm9wgfGpr
	 LOyhEI7N9I0Lfl05M0+sUuokhuWY9152nGLl0VcU=
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
Subject: [PATCH 6.12 067/112] nvme-multipath: fix lockdep WARN due to partition scan work
Date: Thu, 27 Nov 2025 15:46:09 +0100
Message-ID: <20251127144035.294735156@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 24cff8b044923..4ec4a1b11bb2e 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -687,7 +687,7 @@ static void nvme_mpath_set_live(struct nvme_ns *ns)
 			return;
 		}
 		nvme_add_ns_head_cdev(head);
-		kblockd_schedule_work(&head->partition_scan_work);
+		queue_work(nvme_wq, &head->partition_scan_work);
 	}
 
 	mutex_lock(&head->lock);
-- 
2.51.0



