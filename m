Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7084A1B424F;
	Sun,  7 Sep 2025 20:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276044; cv=none; b=prT0KCtGBour0QsBZmdOUBjyjSH/MEcX/ABR4smJIAiqjhkfbNyCAw+HtPKwOir9K/DVwEFJ+GykuMaXmPEnIhli48goQC8jjJTcJ1PG5/1o0/2+vzTrDe6K/rOQHaA++9rH5gWIT0zBMLhldSjEOttXtlrf0myGA/LV5HVEFPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276044; c=relaxed/simple;
	bh=RAg7jlcFzOV3DgV16wE3nLp20HUiUDBGRa+hp+VD+oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s3WawLkz3EaPqeEAkroCsTkfAqg/mX7UMz32q9Wk4A9mEzkn1q49RsblIVcImOiHWiRlBV7WIpWmts+32EB2YCW46KnTRjYwbrNYM0eN380j4dOaUlHAYM6OlvWBPVtgpNyobijvU1KL9mcXvto0gQ9+cr9/hBybSYId2bMUFc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHV3/uFD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHV3/uFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4AEC4CEF0;
	Sun,  7 Sep 2025 20:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276044;
	bh=RAg7jlcFzOV3DgV16wE3nLp20HUiUDBGRa+hp+VD+oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lHV3/uFDjk98If12R6j803xeR8J9iAGQjFRIqUG1CoX67AEwerfAvzrjBhSh9KCy0
	 LH/RUTJ8vPtuKi1XkVSVgkuXeHzGXY7bYmNlJOySZ7mB5v9y63FJnHRJTUsDHjMJa6
	 ifTGbp0sQQCPBl/bu7APLjjOPD2T8TjatLi/8QnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyejeong Choi <hjeong.choi@samsung.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 46/64] dma-buf: insert memory barrier before updating num_fences
Date: Sun,  7 Sep 2025 21:58:28 +0200
Message-ID: <20250907195604.675358375@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyejeong Choi <hjeong.choi@samsung.com>

[ Upstream commit 72c7d62583ebce7baeb61acce6057c361f73be4a ]

smp_store_mb() inserts memory barrier after storing operation.
It is different with what the comment is originally aiming so Null
pointer dereference can be happened if memory update is reordered.

Signed-off-by: Hyejeong Choi <hjeong.choi@samsung.com>
Fixes: a590d0fdbaa5 ("dma-buf: Update reservation shared_count after adding the new fence")
CC: stable@vger.kernel.org
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20250513020638.GA2329653@au1-maretx-p37.eng.sarc.samsung.com
Signed-off-by: Christian König <christian.koenig@amd.com>
[ adjusted `fobj->num_fences` to `fobj->shared_count` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-resv.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/dma-buf/dma-resv.c
+++ b/drivers/dma-buf/dma-resv.c
@@ -267,8 +267,9 @@ void dma_resv_add_shared_fence(struct dm
 
 replace:
 	RCU_INIT_POINTER(fobj->shared[i], fence);
-	/* pointer update must be visible before we extend the shared_count */
-	smp_store_mb(fobj->shared_count, count);
+	/* fence update must be visible before we extend the shared_count */
+	smp_wmb();
+	fobj->shared_count = count;
 
 	write_seqcount_end(&obj->seq);
 	dma_fence_put(old);


