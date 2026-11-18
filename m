Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050596;
	b=3KRB48YMWHt/u0lCRoR9r3SkhlrkTj7Cx2pTyD9iRL2ZYg0HeKOKKC0eIN2kR1yAq8u8
	 jM/DKHtfQ4e5OQoDaJ7Zx0QlVS4w0rYHRh4O3AEpwdjS8N/3EZi96T9lN8YQRL/IlNt0t
	 EZpS5cvL8NJJ2KKeGVA5lUp5/jBNLafiGFDmJyjwbaN3pz0kdsV4l5gXyY8+nwR+GSBKa
	 8aE9DurqdBQi869CRWKOQ8QZvgQFxRlNedPObETibEWvn8LMLc7dDifoCcUam+JNNGo+W
	 c+Y3fO7TDebX3lBYT6WgzRh6HI5KMeS9lw/26R7BSBWNpy8+V5yUqld/CwFLPQ35rAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gb5EJ3hTkp7gIhoFxqVxr9kBOUZIRrRwni46EgeXAVA=;
	b=tn7r2txX0GOe5x3OFjbR5ocuqYc+fvfNfJICdjtKo75XQRr7okfTst47amamEhLU084f
	 i43JPyn1+jYJSbXZVdJ3usRtwhQYA6Lmu6UK9mNesc0p6zbdVxayJXO7URb4IgFy1TcJp
	 Cb4hpk/aYL7Bk/3lKAczxPYnq89Ml8aaxznukve/jlru5ig3ZevXXWHCs9L5oEIIelnb7
	 47XGXOWf3L8OVwo19zrCCqc3jRR3SVihGY491hknjaY2q1X9e3OT7BOM8jggBCOqxSj0B
	 stqmzz17a9XD4tmeNNI6RuQEFQP47GoFSZGL3vGTBHjNdQfO/qKaAdaiBmcJI5XYiSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ieBavTYx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D227606A31C;
	Thu, 19 Nov 2026 01:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ieBavTYx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5481F000C4;
	Thu, 19 Nov 2026 01:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050596;
	bh=gb5EJ3hTkp7gIhoFxqVxr9kBOUZIRrRwni46EgeXAVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ieBavTYxXF4TIUgQpgedmOeFx/EjDAoS3IRpOCx+GtKiZewr9ExYAeJeKkNAj8SB8
	 7dYVb3eRocngFvSb+V+rL0aAfROS/6Vtz3V9nX1SXqpKg9nrPN3P/6pXZXjf1z9gE/
	 QS65Mvbz7pylQhEf8E9Ly26jW/+Xor5G3Z67qY1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2765/2857] nvmet: prevent double-free after metadata SGL allocation failure
Date: Wed, 18 Nov 2026 16:03:19 +0100
Message-ID: <20261118150341.161857794@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 2f61b9d1d54edf75a352c43eebe3804144b5d44e ]

If metadata SGL allocation fails, nvmet_req_alloc_sgls() frees
req->sg without clearing it. The RDMA error completion path later
frees the same scatterlist again.

Use nvmet_req_free_sgls() instead so that the scatterlist pointers
and counts are cleared before response cleanup.

Fixes: c6e3f13398123 ("nvmet: add metadata support for block devices")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 9035c78fba75c..817127153f73d 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1129,7 +1129,7 @@ int nvmet_req_alloc_sgls(struct nvmet_req *req)
 
 	return 0;
 out_free:
-	sgl_free(req->sg);
+	nvmet_req_free_sgls(req);
 out:
 	return -ENOMEM;
 }
-- 
2.53.0



