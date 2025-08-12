Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E152C21F7;
	Tue, 12 Aug 2025 19:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026780; cv=none; b=GIrA2gli5FWToboC9xeAKz03xJyz9yOdCF9KFfHnSRRsCBWIjsFQWl2EDTkRiXXXG/8Jh6CKT/9Zrr/Mb1R3PuOlim0t7K1ZPol/FCVJSii76T2A7P5IEVDA3ERuJ9trZCJbmLWuhGh5wObOIfhqfOIxeegXVl+RS7mljBXRPaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026780; c=relaxed/simple;
	bh=lcwuJ5eveNSPAj6ArSVt1f56FeXN2Zbev3AaMUdN98o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqMXZl5NAQUtWkiXVoRBl2Sz9wIz0nfUeNzvDmR3dwbdj/cJNr4hag/Gk1c+3GChFXFALlN5jSxTXR4fxgMhOh1mrNxjdNC2FsPgFhU7Ta9CK7GalZqfqdpQ7El3zwujrvwa9MJDaZc7RGPf1xxy5tUChpZfll9FcoEI1bPMJus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8MmRYJl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8MmRYJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE31C4CEF0;
	Tue, 12 Aug 2025 19:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026780;
	bh=lcwuJ5eveNSPAj6ArSVt1f56FeXN2Zbev3AaMUdN98o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l8MmRYJlvwD/q42y2j8LTZIsmhMdvK+33b2AW7SvhqYFuvXE7+H5FB0eoX69GRb6L
	 a7trSpdIwaOnKhGkJuPJ+GGNtWBK2G7/MI6aIHSu8E7UitfNecJ2VnTvyATs3bHLkO
	 5OHhmPF/bEArh/Kh+apWr+WBM+t0GyqKaEZrCQAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 406/480] eth: fbnic: unlink NAPIs from queues on error to open
Date: Tue, 12 Aug 2025 19:50:14 +0200
Message-ID: <20250812174414.180947787@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 4b31bcb025cb497da2b01f87173108ff32d350d2 ]

CI hit a UaF in fbnic in the AF_XDP portion of the queues.py test.
The UaF is in the __sk_mark_napi_id_once() call in xsk_bind(),
NAPI has been freed. Looks like the device failed to open earlier,
and we lack clearing the NAPI pointer from the queue.

Fixes: 557d02238e05 ("eth: fbnic: centralize the queue count and NAPI<>queue setting")
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250728163129.117360-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_netdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
index 2524d9b88d59..34c00c67006f 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
@@ -33,7 +33,7 @@ int __fbnic_open(struct fbnic_net *fbn)
 		dev_warn(fbd->dev,
 			 "Error %d sending host ownership message to the firmware\n",
 			 err);
-		goto free_resources;
+		goto err_reset_queues;
 	}
 
 	err = fbnic_time_start(fbn);
@@ -57,6 +57,8 @@ int __fbnic_open(struct fbnic_net *fbn)
 	fbnic_time_stop(fbn);
 release_ownership:
 	fbnic_fw_xmit_ownership_msg(fbn->fbd, false);
+err_reset_queues:
+	fbnic_reset_netif_queues(fbn);
 free_resources:
 	fbnic_free_resources(fbn);
 free_napi_vectors:
-- 
2.39.5



