Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050B02F5E;
	Tue, 12 Aug 2025 18:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021951; cv=none; b=cvvSAwyCZe7jMO8pJf6T2GXrYkZqkOwn49bY7I4BRh/VedvhWtvvziWfzUM+pcyYqIDrDadZlrXboetcOSfWrYLDYhUCW8SnIioOOvRgEfJrSs7oWS+St7xxEY4zKftthIjnRf8b/5iWsSaVP7D6YVpYrhURLQbnDSZqS/zoo4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021951; c=relaxed/simple;
	bh=+VVns0rzqzifyBh15vZEsiycIdhApH3BcgcvsM1Mo58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHfhR2IlUHduFtS3Mbe8RfoyWOiHCeleeNWl4DmQHos2p+xhJR26He3H/vQCc6NzCn8wrAJ7ycypFg0pJTWduSugDtxkQnt7x1229YD/0snOAKaSCB1LIUNOvLdfGtR0OMfHszwppAl12WNGV6C+SDUhg4HsmPzc++ERjMnJuxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5OZJuct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5OZJuct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8A5C4CEF0;
	Tue, 12 Aug 2025 18:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021950;
	bh=+VVns0rzqzifyBh15vZEsiycIdhApH3BcgcvsM1Mo58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5OZJucte+mWF9t6DHJa29lBeR54KKKLL3wTFIvLlDN2+Ss6Xf+5MLGdvaghVYt07
	 VzPg6mCybBbCjrPHnRzbH3trrQ6MdLzoAm8W5q1tnaAv5238DLe3OZHEnfrkG8yHYS
	 iW0V6zkrY/FbPl8KaHvvbWPCIcW6SC65cZVUkrKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/369] ublk: use vmalloc for ublk_devices __queues
Date: Tue, 12 Aug 2025 19:25:08 +0200
Message-ID: <20250812173015.166921094@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3b1a5cdd6311..defcc964ecab 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2116,7 +2116,7 @@ static void ublk_deinit_queues(struct ublk_device *ub)
 
 	for (i = 0; i < nr_queues; i++)
 		ublk_deinit_queue(ub, i);
-	kfree(ub->__queues);
+	kvfree(ub->__queues);
 }
 
 static int ublk_init_queues(struct ublk_device *ub)
@@ -2127,7 +2127,7 @@ static int ublk_init_queues(struct ublk_device *ub)
 	int i, ret = -ENOMEM;
 
 	ub->queue_size = ubq_size;
-	ub->__queues = kcalloc(nr_queues, ubq_size, GFP_KERNEL);
+	ub->__queues = kvcalloc(nr_queues, ubq_size, GFP_KERNEL);
 	if (!ub->__queues)
 		return ret;
 
-- 
2.39.5



