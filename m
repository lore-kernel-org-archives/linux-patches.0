Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4B061FFE;
	Tue, 12 Aug 2025 18:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023262; cv=none; b=MGalWVKhm3+MJyoYcDIxbUkpDOX+OHk2MoDe5aQa94OFDdRRXtg707l9nnZgydjIpTzDD9sEc4RJvNl8RYMMnW+GGK43XVYNsJ8F6DmYzWj9N0prJgd650nV6u//ZKGnnYN4C5OGlARRJjVqs+VlgWEsjqJM7Z5fBcNc5naDkWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023262; c=relaxed/simple;
	bh=jz58q21568z2KWQzqil6R8r6SHAbUcrq89uYn+51x9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdVUtpGivadOoVq1Hkr/0ZnogICzZXUe1vPp7M7eEXhP9adehJr6nkjJsczrepJGZToZ9nNpuDg7Gzpr2Big+w/u3v0+l+Yob192jAqp0wtccRupN4BwIOE4WmtmJsVbHrw4WqXN/cFllWFb4sS2DRFg3UH7a0rhPkkeERK7hxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xQE5UJpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xQE5UJpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6E5C4CEF1;
	Tue, 12 Aug 2025 18:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023262;
	bh=jz58q21568z2KWQzqil6R8r6SHAbUcrq89uYn+51x9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQE5UJpD3xNBQpfChkfX0qxU4IhNxvZlhNQD0zqwvPsHci4MGZURRpUo7E5p3dJrM
	 gyhnAw5bMAWbSueLYn4ccFX8nPZzTyxf1bgql0MwghHf0Wf0+gmVAvdf6se1Eu/bLc
	 PaReVrzLh+15YgCV97xYtepcuVXn13CeTW9gCCpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 008/627] ublk: use vmalloc for ublk_devices __queues
Date: Tue, 12 Aug 2025 19:25:03 +0200
Message-ID: <20250812173419.636550663@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit c2f48453b7806d41f5a3270f206a5cd5640ed207 ]

struct ublk_device's __queues points to an allocation with up to
UBLK_MAX_NR_QUEUES (4096) queues, each of which have:
- struct ublk_queue (48 bytes)
- Tail array of up to UBLK_MAX_QUEUE_DEPTH (4096) struct ublk_io's,
  32 bytes each
This means the full allocation can exceed 512 MB, which may well be
impossible to service with contiguous physical pages. Switch to
kvcalloc() and kvfree(), since there is no need for physically
contiguous memory.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250620151008.3976463-2-csander@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 9fd284fa76dc..8ded49f3b68b 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2513,7 +2513,7 @@ static void ublk_deinit_queues(struct ublk_device *ub)
 
 	for (i = 0; i < nr_queues; i++)
 		ublk_deinit_queue(ub, i);
-	kfree(ub->__queues);
+	kvfree(ub->__queues);
 }
 
 static int ublk_init_queues(struct ublk_device *ub)
@@ -2524,7 +2524,7 @@ static int ublk_init_queues(struct ublk_device *ub)
 	int i, ret = -ENOMEM;
 
 	ub->queue_size = ubq_size;
-	ub->__queues = kcalloc(nr_queues, ubq_size, GFP_KERNEL);
+	ub->__queues = kvcalloc(nr_queues, ubq_size, GFP_KERNEL);
 	if (!ub->__queues)
 		return ret;
 
-- 
2.39.5



