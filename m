Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063741;
	b=VY0mgpoIJgWiEU/SsBwbJGb4Jz77l6arZXV55Ca4rGqt+kvg2IP3ofSzA6xRaG/8QXAx
	 4giBzoW6cQ+yglQgQr+gS8RQB8JjrWdrQDm5Hox7qKbW/jyy78l6MR36sf43IOTIJ3eM8
	 3gfNZeBMrnvrzZ2Jyy2RQ2Uu1vhF1o2nggMzIlbafDzex6cFB7FWrdnVEnu2Gq+AnSYdL
	 7217PHg7JJL5YRLD3wkEYZHQ/+AqqLumv6FC/7psbHBBf0X7FMJtwBvf6OPyiMnOKYozg
	 lsWXFPuJHwTLDC0hmOOd8UbjhQBilrpvBjstU8huIGVe1eP1lp5y2aLcJEHahKnTiJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063741;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ec1CVW08h+kDshcUdUIjf8SZ5Bvm6xiGsP0Y5bU89PE=;
	b=WIE2tQoZNfeMZeVw0v7nP3LRspKApQnizC3Xspdwu1R11mE3P8VyblFLmRLZqlAl3Rww
	 lp+Hzb2BkRa4Te7nY++gVJ8UXKliaSamLrfYQqUrkHnNeLCePzVGnLlLmgfhseLn/CYy3
	 xG0bIxFUAB/qmcwpLJRih5Y1DYDnf4FElzhWlvKdEPid9M7wP6bvB1mZFeWEdwCpOfhbF
	 IHydCM8aQDpbCCk2qLIVUV/sQ0OrP/ToBK0xpSHgE5aIYi/hC45TbmLU9/nCrB0a87Fle
	 uYljFHW8169vpwLavWqhDLja2hlro0q2OpQt0VYqdVRKRaJzJbjYoldhRmaFWNzcQvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fn39URCU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CF6606A32D;
	Sat,  7 Nov 2026 15:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fn39URCU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A411F008A2;
	Sat,  7 Nov 2026 15:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063741;
	bh=ec1CVW08h+kDshcUdUIjf8SZ5Bvm6xiGsP0Y5bU89PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fn39URCUi/TKX2vavXMJw81mZLQbEIGY2i4LV18E2p0IRZy+16s7EYwxuJkym7vC+
	 VRDs1mJ19na6BrkmtMnNWuQ0uEUztPQtoZ0mDIfEufsuEUw7635WHZEdN0VHc/DXFE
	 BmhzBGPX+jisR58uvoeEPGQ6q7GBoqR+IVgB20jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 836/869] nvmet: Finish the blk plug when integrity allocation fails
Date: Sat,  7 Nov 2026 08:58:38 -0500
Message-ID: <20261107134921.236972828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 18fc5f6f1ca945630dae5404265de55d65194e22 ]

nvmet_bdev_execute_rw() starts a plug before building the bios, but
the two error exits taken when nvmet_bdev_alloc_bip() fails return
without calling blk_finish_plug().  current->plug is left pointing
at the stack frame of the returned function, so the next
blk_flush_plug() walks a stale list.

Route both failures through a common exit that finishes the plug.

Fixes: c6e3f13398123 ("nvmet: add metadata support for block devices")
Cc: stable@vger.kernel.org
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/io-cmd-bdev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 0103815542d49..160364cc8c980 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -305,7 +305,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 							  &prot_miter);
 				if (unlikely(rc)) {
 					bio_io_error(bio);
-					return;
+					goto out_plug;
 				}
 			}
 
@@ -325,11 +325,12 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 		rc = nvmet_bdev_alloc_bip(req, bio, &prot_miter);
 		if (unlikely(rc)) {
 			bio_io_error(bio);
-			return;
+			goto out_plug;
 		}
 	}
 
 	submit_bio(bio);
+out_plug:
 	blk_finish_plug(&plug);
 }
 
-- 
2.53.0



