Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3F7253924;
	Mon, 23 Jun 2025 13:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684746; cv=none; b=TEq4DlyPSBMhLZ8OKdweC3CdR8QN1lkQCpXTuD0ks5FrS8Fzss/NPcNUuOr1kyzQqiP20hoGJSSf0YDAOmLmW7hQBnqjjiYDEMu0xO6SrwbWs+c4uzk52PfelSJ1ltDp2VP2MhC5X2qx3pIvx8j9mRrO+/EAIZDlLDIE1xCVQEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684746; c=relaxed/simple;
	bh=1gOSBU2naqGpsx7NnnZZdOzwB3RNu/x8LW0zv6V77w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hl9tqzMkgy9Pd/nFJB5/XwV1tDGkamq0viNvqTl9ONupqbel1R+Z9ycOvZVHw3VyWgbizA+wYNR1ZYy4OmVn/OivLEgZeICKgAZLevEImkHaV2bI+KId1snFEiW9hN114JBkH+zq4nUGXh9qVtbYJ+kkFOkq7z3gCnm7wkoQpFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=08/TnM65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="08/TnM65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82E9C4CEF0;
	Mon, 23 Jun 2025 13:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684746;
	bh=1gOSBU2naqGpsx7NnnZZdOzwB3RNu/x8LW0zv6V77w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=08/TnM659uoyJ8A8xpsaOVdtWrPrIQlJeNSN9fOxvfzeRw9/jUi7OAdIZzz9pWZn3
	 9I6AR//9AGRGd2Uth430bmDipSqqpoBugTZQmEwhUzFmw6iIJsInweglXQVxtGRRjW
	 zCWf8WrmbbGRnXNuOve9MN/ZoZGAuWxuI497uQLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.15 164/592] nvme-tcp: remove tag set when second admin queue config fails
Date: Mon, 23 Jun 2025 15:02:02 +0200
Message-ID: <20250623130704.181302648@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit e7143706702a209c814ed2c3fc6486c2a7decf6c upstream.

Commit 104d0e2f6222 ("nvme-fabrics: reset admin connection for secure
concatenation") modified nvme_tcp_setup_ctrl() to call
nvme_tcp_configure_admin_queue() twice. The first call prepares for
DH-CHAP negotitation, and the second call is required for secure
concatenation. However, this change triggered BUG KASAN slab-use-after-
free in blk_mq_queue_tag_busy_iter(). This BUG can be recreated by
repeating the blktests test case nvme/063 a few times [1].

When the BUG happens, nvme_tcp_create_ctrl() fails in the call chain
below:

nvme_tcp_create_ctrl()
 nvme_tcp_alloc_ctrl() new=true             ... Alloc nvme_tcp_ctrl and admin_tag_set
 nvme_tcp_setup_ctrl() new=true
  nvme_tcp_configure_admin_queue() new=true ... Succeed
   nvme_alloc_admin_tag_set()               ... Alloc the tag set for admin_tag_set
  nvme_stop_keep_alive()
  nvme_tcp_teardown_admin_queue() remove=false
  nvme_tcp_configure_admin_queue() new=false
   nvme_tcp_alloc_admin_queue()             ... Fail, but do not call nvme_remove_admin_tag_set()
 nvme_uninit_ctrl()
 nvme_put_ctrl()                            ... Free up the nvme_tcp_ctrl and admin_tag_set

The first call of nvme_tcp_configure_admin_queue() succeeds with
new=true argument. The second call fails with new=false argument. This
second call does not call nvme_remove_admin_tag_set() on failure, due to
the new=false argument. Then the admin tag set is not removed. However,
nvme_tcp_create_ctrl() assumes that nvme_tcp_setup_ctrl() would call
nvme_remove_admin_tag_set(). Then it frees up struct nvme_tcp_ctrl which
has admin_tag_set field. Later on, the timeout handler accesses the
admin_tag_set field and causes the BUG KASAN slab-use-after-free.

To not leave the admin tag set, call nvme_remove_admin_tag_set() when
the second nvme_tcp_configure_admin_queue() call fails. Do not return
from nvme_tcp_setup_ctrl() on failure. Instead, jump to "destroy_admin"
go-to label to call nvme_tcp_teardown_admin_queue() which calls
nvme_remove_admin_tag_set().

Fixes: 104d0e2f6222 ("nvme-fabrics: reset admin connection for secure concatenation")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-nvme/6mhxskdlbo6fk6hotsffvwriauurqky33dfb3s44mqtr5dsxmf@gywwmnyh3twm/ [1]
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2392,7 +2392,7 @@ static int nvme_tcp_setup_ctrl(struct nv
 		nvme_tcp_teardown_admin_queue(ctrl, false);
 		ret = nvme_tcp_configure_admin_queue(ctrl, false);
 		if (ret)
-			return ret;
+			goto destroy_admin;
 	}
 
 	if (ctrl->icdoff) {


