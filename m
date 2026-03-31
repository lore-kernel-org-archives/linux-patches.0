Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7B2421A1D;
	Tue, 31 Mar 2026 16:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974618; cv=none; b=GUr56ylPv9fWEmAmlm+sDy+bSQCFAfSTS+tkDmFASuNM3G+lCEToFHoOFfbpVrYfIEoisMB0S9lAOhksxPCpecVMLpzc4N9EbaHZLwEyNN827XjARgHy9BNrV2lJ/6N5pPiXo91xyt30Syady0uwp+eMRkj/lqZBomstBx4RaGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974618; c=relaxed/simple;
	bh=e1MzedQeY1+CbM27PKkog8Obc7WLoEjABasvzOSXlZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViZmjKXeUAMA591nGP0JvZtLxGtTfnQeVwtTgS/B8Vo6Racl/N9UwuPjqKJShdnDZKTIx3sKp9itWRz8yj3MikgWt5sOGmnzL2MhVmBGjU9F4AKfAqW9wqkbv9RfHA58HTsVHjVaGL6/VbzOlPertV6FcyU3pO1/v94YW6dxzKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QIlVMXjz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QIlVMXjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9687CC19423;
	Tue, 31 Mar 2026 16:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974617;
	bh=e1MzedQeY1+CbM27PKkog8Obc7WLoEjABasvzOSXlZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QIlVMXjzg8bGMhtFuT3i+VWNHUNafytwT8oD9XVh7j8uLyHt4WOYpwOF/X1lB+u/d
	 BVSWFqvQ0s01djnngVNsZ8RdctygfI4FEW3b1qWfg165qzt6xf4eZfQ/2nb4kmyO/N
	 KG//jInIhQFmL1U2/ecku0tFEJmO09Q9dIcVFgpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	Li hongliang <1468888505@139.com>,
	Yi Zhang <yi.zhang@redhat.com>
Subject: [PATCH 6.6 155/175] nvme: fix admin queue leak on controller reset
Date: Tue, 31 Mar 2026 18:22:19 +0200
Message-ID: <20260331161735.489034603@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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


