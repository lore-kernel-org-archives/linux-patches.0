Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079001519A4;
	Wed,  5 Feb 2025 14:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764973; cv=none; b=bQMc6Inm2kNqOsXN8YMEOqQOTJSeybKDy4bQnvf0mLVUY/0j0/icm0oGd7fNjHlx2h05XvX0r3Md/b/NWz1bn634HBNVuELZ5J8c+F7VR0tm32eSvovgI5sWyBV/cNCpzv/e4YAQXNRH9HE26SwmYVHVfDdoVOU2/lIDHMrq+es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764973; c=relaxed/simple;
	bh=B2P2I5y7uit9LRNy8/alEIH+QiRX9kVVGB9O1ImkuEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIwfHCo7GvWHEV3DYBPCpTnsZ6ctPtkaqcTUMEBFNov/0Z1BDkuGy4pcsRg9GXTDhVujHvCcex/cQgNldQContJdev9ChtOsHKXIw0BV4JWOIRb7sauYOX/adQxjOjcacgkrSRwb3FVnEmQuFJgtbtvT+t61rwKeLZc8tVbvj6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cn/Hpwno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cn/Hpwno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078BFC4CED6;
	Wed,  5 Feb 2025 14:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764972;
	bh=B2P2I5y7uit9LRNy8/alEIH+QiRX9kVVGB9O1ImkuEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cn/HpwnoUh6UuARMtxj//wwFveyBH3HaYycNCQAzXXpPb/+a6tUx/BueGj5hMKhgh
	 cYSF6LhSx6YzQoXOMmZw38moIyoSxa+BZTmQE1xn3+IKHZYQsm86MyENOhHNfC+sQH
	 qwJo5jHLiZMT8StBms8Mdb2mZGH936F46KxFhI6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 220/393] RDMA/srp: Fix error handling in srp_add_port
Date: Wed,  5 Feb 2025 14:42:19 +0100
Message-ID: <20250205134428.721038116@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make_ruc2021@163.com>

[ Upstream commit a3cbf68c69611188cd304229e346bffdabfd4277 ]

As comment of device_add() says, if device_add() succeeds, you should
call device_del() when you want to get rid of it. If device_add() has
not succeeded, use only put_device() to drop the reference count.

Add a put_device() call before returning from the function to decrement
reference count for cleanup.

Found by code review.

Fixes: c8e4c2397655 ("RDMA/srp: Rework the srp_add_port() error path")
Signed-off-by: Ma Ke <make_ruc2021@163.com>
Link: https://patch.msgid.link/20241217075538.2909996-1-make_ruc2021@163.com
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 2916e77f589b8..7289ae0b83ace 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3978,7 +3978,6 @@ static struct srp_host *srp_add_port(struct srp_device *device, u32 port)
 	return host;
 
 put_host:
-	device_del(&host->dev);
 	put_device(&host->dev);
 	return NULL;
 }
-- 
2.39.5



