Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13D2197A8B;
	Wed,  5 Feb 2025 14:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767133; cv=none; b=qTm5bzlMBgWdcKx7sG4t/BWzxd7v2DfMEUjpIl0rRVbNDJ6DNyorNcFPSNI8mo+5FB706ytUgBXrMUAcLJJSCLHrxWYO1SSm4Ll6/ANyTumjW6S+LytZ9uN98q9jdZf6DLKs02RszjkGejuuEX0nBjaM2EWd2x/uCP2iSk12soM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767133; c=relaxed/simple;
	bh=QhQ+eEXMwR7EV5aF8SxvBHJpoBNKlyISa0Kt2GNhn3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZxsGHCgo1E0jzNboBBkSUp/Hlp7aOjYbGM+sjP9Kh1Ux6xFZlUqpNzJot9dhJ8eaw8kSQXw+2OR7tddMEjA7fNUwZJhzq4c9GXPd9VikxApI8n3w1HOiRw3FhBvL9JBDUhJJyMrSoge5fjjsWgRKKWuMf2XZgzGVlAQGdssw0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPbY9zo7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPbY9zo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34978C4CED1;
	Wed,  5 Feb 2025 14:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767133;
	bh=QhQ+eEXMwR7EV5aF8SxvBHJpoBNKlyISa0Kt2GNhn3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPbY9zo7AHlcH8bLkM0sa47JUkmRFd5RJ3J3rP7jXSBi9JqBV1eg36KU2ksLy/uJ6
	 cSdh2I8HjUpR4jg9TGyTOHlt1oJq9BqLMoyEuVUG8CYzxgHRToCJW2Q2mePoVJCJgZ
	 E8/qSzgAfDmmzZNFQ0o9axhAlKK9Gg+jsUurt/AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 361/623] RDMA/srp: Fix error handling in srp_add_port
Date: Wed,  5 Feb 2025 14:41:43 +0100
Message-ID: <20250205134510.033350581@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



