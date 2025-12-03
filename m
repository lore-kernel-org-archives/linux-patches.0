Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BABD35C1B6;
	Wed,  3 Dec 2025 16:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780133; cv=none; b=q7owNTN7hWprDZiojER5qmn/gmWgXD7/Tviwec3CJA9jPgBP9DX/YpNRdDqDGZBQarOugfAPgGVG4e/qAGv4JMoJoHiOu4aTKnmWSdBcejnMT1z6slM3uUCpbU1j6oonQqc9R++ZAihqQ7vg7aYSJCbOBYihijMK09uFZUJJCRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780133; c=relaxed/simple;
	bh=Y8sRz4YJ3jtTCcHP6RKhfW0OFIF9ffTazoXsDzljVsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imyeQ1ifadrzljf6EpBmaKGoUIk/zdziC4iTfZ/giqgenYySZfmnDsULXPLWfdHwA6zoIqtypCYN+D9yBlTXyReZoEV2QlL4nBwP0yR0Dov20m7yUmfMpefSwXz1WdPXl3FjsRM1RP+0YSgwGLBgYqn8GNDJKKJ4+NbIxRP0pA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5U5kEn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5U5kEn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DECC4CEF5;
	Wed,  3 Dec 2025 16:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780132;
	bh=Y8sRz4YJ3jtTCcHP6RKhfW0OFIF9ffTazoXsDzljVsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z5U5kEn6SMLHiBxCm/l3Tgum+rl7yJKj7md9QF8XojOy0CCUI1U95W8bGOopZW+/r
	 0AmXGLLSgQevHPBa/+wGP9yJ41tkLFt9BIVLVOos6ODMuQl438xX4ICy3cQQrEj99e
	 zGLxMm0Y50vD3ABEuwL26dLMeGACV3L6cZexyHIU=
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
Subject: [PATCH 6.1 458/568] nvme-multipath: fix lockdep WARN due to partition scan work
Date: Wed,  3 Dec 2025 16:27:40 +0100
Message-ID: <20251203152457.480409935@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 43b89c7d585f0..a3e225bb4b88f 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -577,7 +577,7 @@ static void nvme_mpath_set_live(struct nvme_ns *ns)
 			return;
 		}
 		nvme_add_ns_head_cdev(head);
-		kblockd_schedule_work(&head->partition_scan_work);
+		queue_work(nvme_wq, &head->partition_scan_work);
 	}
 
 	mutex_lock(&head->lock);
-- 
2.51.0



