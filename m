Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339D21D04B4;
	Wed,  2 Oct 2024 14:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878426; cv=none; b=FLn1UDCSnG1NR1yy2pGEv3VLjumfTup1dD7jL3uqTt7qpDrSTuKuNm9nRqBwjEk1r7jBF400bsrgJaf/aWaG6CleqioytVm6dwGkQnFxlwXMMlJdhO5WhDITzMpjKdIS/UQvRpi39dTm4a8RG/v4pZzo3/koaf459G4Fja6/WxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878426; c=relaxed/simple;
	bh=b7OfM2A2nME7ke3pfTH8aLsnv2uhXjiCkuczSx62fB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZ4B0Y4Dx4wqITVgJ3ZQfIYJf4hYSrqQGdfPIcT9crZxhW5F/14PASkXIgWOQO+KYGONAHf2ZbHBrSNI/LyPERQP2ZCB/GkGErdfTsvYUQGHZ5+VG2T0BBcjCNBSq/VsTDhgSUq9MJyBLoxRk2vZ9MmIIEeIE3f/6TCZFe3hMb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkYTc/YC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkYTc/YC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE330C4CEC2;
	Wed,  2 Oct 2024 14:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878426;
	bh=b7OfM2A2nME7ke3pfTH8aLsnv2uhXjiCkuczSx62fB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wkYTc/YCBgezU9+D4BGIEGI07diQ7HJE/peUz2jkzbEG0yK3dszZul6/bQNU8MhZW
	 dRWlHnReDanYCRDO+Ko8ysltEZoPTguj19Exesh8PDgGywYCZek5cdwymADyhCybcR
	 Mm5me+oa4LM7nY8X7bqGl4L/a54ooDInVs+cj/PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 368/634] RDMA/mlx5: Fix counter update on MR cache mkey creation
Date: Wed,  2 Oct 2024 14:57:48 +0200
Message-ID: <20241002125825.621849333@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit 6f5cd6ac9a4201e4ba6f10b76a9da8044d6e38b0 ]

After an mkey is created, update the counter for pending mkeys before
reshceduling the work that is filling the cache.

Rescheduling the work with a full MR cache entry and a wrong 'pending'
counter will cause us to miss disabling the fill_to_high_water flag.
Thus leaving the cache full but with an indication that it's still
needs to be filled up to it's full size (2 * limit).
Next time an mkey will be taken from the cache, we'll unnecessarily
continue the process of filling the cache to it's full size.

Fixes: 57e7071683ef ("RDMA/mlx5: Implement mkeys management via LIFO queue")
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://patch.msgid.link/0f44f462ba22e45f72cb3d0ec6a748634086b8d0.1725362530.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index d3c1f63791a2b..a03557c8416e8 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -211,9 +211,9 @@ static void create_mkey_callback(int status, struct mlx5_async_work *context)
 
 	spin_lock_irqsave(&ent->mkeys_queue.lock, flags);
 	push_mkey_locked(ent, mkey_out->mkey);
+	ent->pending--;
 	/* If we are doing fill_to_high_water then keep going. */
 	queue_adjust_cache_locked(ent);
-	ent->pending--;
 	spin_unlock_irqrestore(&ent->mkeys_queue.lock, flags);
 	kfree(mkey_out);
 }
-- 
2.43.0



