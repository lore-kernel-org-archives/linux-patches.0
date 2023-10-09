Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CF21A5A4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZ+G66qC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F912C433C8;
	Mon,  9 Oct 2023 13:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857770;
	bh=9ZQk/sBkDTrWNeyGxWH+opUnLYmDzApcD7J6/QiZfYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZ+G66qCDyXLR++xA+8UerZhRYMQNXru3gLwoNelSPWRhreuHrdGec6hfkosbPqaz
	 P2NIdxsKUaVvD2RDZOmYi9oEk1tTN9veVorL6KrI+AEVak/L/XEGaul90N9QyRwula
	 Lq5JHZt9Rr6DkGXUN9u5i5xw5UXFyVhpS3GUelBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Hamdan Igbaria <hamdani@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.1 150/162] RDMA/mlx5: Fix mutex unlocking on error flow for steering anchor creation
Date: Mon,  9 Oct 2023 15:02:11 +0200
Message-ID: <20231009130127.054409474@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hamdan Igbaria <hamdani@nvidia.com>

commit 2fad8f06a582cd431d398a0b3f9be21d069603ab upstream.

The mutex was not unlocked on some of the error flows.
Moved the unlock location to include all the error flow scenarios.

Fixes: e1f4a52ac171 ("RDMA/mlx5: Create an indirect flow table for steering anchor")
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Hamdan Igbaria <hamdani@nvidia.com>
Link: https://lore.kernel.org/r/1244a69d783da997c0af0b827c622eb00495492e.1695203958.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -2471,8 +2471,8 @@ destroy_res:
 	mlx5_steering_anchor_destroy_res(ft_prio);
 put_flow_table:
 	put_flow_table(dev, ft_prio, true);
-	mutex_unlock(&dev->flow_db->lock);
 free_obj:
+	mutex_unlock(&dev->flow_db->lock);
 	kfree(obj);
 
 	return err;


