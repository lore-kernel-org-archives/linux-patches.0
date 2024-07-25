Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CC18468;
	Thu, 25 Jul 2024 14:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919106; cv=none; b=LWs3DhdF4YKI7NlDuIGBeNL43tdxDwjmvltjSdyQ0M8SAmEom342zP64R+EB98RgnrwB73u+CGN0SXDOB3FVuRKAKgqwwxMG1GmHdM4d01s4mtd+s3Ac+6WMbgCfBM0Kn33XL7ggv+85/G1TtOLNRqdw+WMwB0XsKqq+ZG6nRKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919106; c=relaxed/simple;
	bh=rD4pWXgfuxLMfT7epwJqOoLrBTokt9YN7D2qG8Yj4Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzXJiDwJofn/zcOgfQ50wktAs4+rmtzTYUTDsxToixHhcMvVbYITI/3by4trdRXzg3O/eAfTJaFniuiV9cskri9vSwdfP7HwEgTESRo7AfPNgS7U7m0WZ7T2ihNKkKJa+HUJ8Ga8gjWP+stRPXco3o1/QoFon0JTSZ9AbEFM1a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uFphKaJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uFphKaJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9ABC4AF0B;
	Thu, 25 Jul 2024 14:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919106;
	bh=rD4pWXgfuxLMfT7epwJqOoLrBTokt9YN7D2qG8Yj4Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uFphKaJUssWITWgllHaW/6pmhgvxGLqj7GF13Wj5YMVtIyQgDWedyuJgIgkSE1LKe
	 XpzhwCVoTrDZdoOi4c6tTeFi/hyCHde0jVowh+HRfJznbxfpnlBTsQRPBp9jjNBV+M
	 S+ZjzVg4UomT75/P1ODEjLa+/Lh5+wrZ0YDvMHEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 25/87] null_blk: fix validation of block size
Date: Thu, 25 Jul 2024 16:36:58 +0200
Message-ID: <20240725142739.384146972@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Hindborg <a.hindborg@samsung.com>

[ Upstream commit c462ecd659b5fce731f1d592285832fd6ad54053 ]

Block size should be between 512 and PAGE_SIZE and be a power of 2. The current
check does not validate this, so update the check.

Without this patch, null_blk would Oops due to a null pointer deref when
loaded with bs=1536 [1].

Link: https://lore.kernel.org/all/87wmn8mocd.fsf@metaspace.dk/

Signed-off-by: Andreas Hindborg <a.hindborg@samsung.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20240603192645.977968-1-nmi@metaspace.dk
[axboe: remove unnecessary braces and != 0 check]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index ec78d9ad3e9bc..23c4a7b3d4e53 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1749,8 +1749,8 @@ static int null_validate_conf(struct nullb_device *dev)
 		return -EINVAL;
 	}
 
-	dev->blocksize = round_down(dev->blocksize, 512);
-	dev->blocksize = clamp_t(unsigned int, dev->blocksize, 512, 4096);
+	if (blk_validate_block_size(dev->blocksize))
+		return -EINVAL;
 
 	if (dev->queue_mode == NULL_Q_MQ && dev->use_per_node_hctx) {
 		if (dev->submit_queues != nr_online_nodes)
-- 
2.43.0



