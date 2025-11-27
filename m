Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CF832AAC4;
	Thu, 27 Nov 2025 15:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255854; cv=none; b=megqB/Cx60JCsVkkir6bD/V08l8poavFBYuexBJwEHKey5F+UhKG5ogoigQII2f2JPLwOip2DLNQ21tpCBhjf7mU4V7p2GfCHLrhPgrdqfOUhav/c1ZZO37li0DhWdYCrA5GFBqueN/+nNS+ijvz3gWhydes+I/4rzPKCPUkABA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255854; c=relaxed/simple;
	bh=ORJAD0e4asMRe8oxtcMO/1vauoA+5tPmU+Les8NXzUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZnnFv8AYYZ2Lt9LZbBjPs2qR9BcwfGFhDnT6LUGHHD9qAtYgmfuI1g/Lgal6Xb0ba5Bt425K74ZXGvvqzfl+HPeL4nYAl8l1CnU2daAZ5H9nfVO8sWtDtd46daYD2gUZ+1qfMYGsnwET4tcTQgL+370HFZj8AP7Ov07EPt7njVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fgpa/Hc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fgpa/Hc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B07C4CEF8;
	Thu, 27 Nov 2025 15:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255854;
	bh=ORJAD0e4asMRe8oxtcMO/1vauoA+5tPmU+Les8NXzUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fgpa/Hc3sYcliHfT61F6IVGSlBIa3KGVkcb4Eb2SxnhjSSKJ88esLAnQnPdEe+CNr
	 2xCsY/887naEURD1GER4TQBA1IziSn7MWPRK7mUTi7USf8fl0ceO9HqPrZrUwaQg0h
	 8/g35iWtkB2XHnMHJff6uY2euE+4S6YsbUYKV3N0=
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
Subject: [PATCH 6.17 104/175] nvme-multipath: fix lockdep WARN due to partition scan work
Date: Thu, 27 Nov 2025 15:45:57 +0100
Message-ID: <20251127144046.757734260@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 543e17aead12b..e35eccacee8c8 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -793,7 +793,7 @@ static void nvme_mpath_set_live(struct nvme_ns *ns)
 			return;
 		}
 		nvme_add_ns_head_cdev(head);
-		kblockd_schedule_work(&head->partition_scan_work);
+		queue_work(nvme_wq, &head->partition_scan_work);
 	}
 
 	nvme_mpath_add_sysfs_link(ns->head);
-- 
2.51.0



