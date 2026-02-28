Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A3335AC28
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302768; cv=none; b=cHoS/S3LlBN1HmDgnwhLnZOcCwV/UDd4dcJ9bKdpbJkqJGUhQn+KP8ZY2ZMwmOzNxhlP6bcdBnf4Hxdz/ceXcHuguKtwdTKDI1kc+kMN2FtHDdnjVM4DHhIZJZCSj/+zi4HcrU6M9Uh5E4QNwBBVbO/HvMEpWsOyToHpzXRX+Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302768; c=relaxed/simple;
	bh=0QX6fx5ztsOwbqkdDSx3cDlN5iFEkWOFNLENrERXWbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awRmGbL4VXLmhVx8gnzp6ZLMdcq9quD50SH0IlcdDq8Pi70T7LOJqeQ42TSLuMezmDxXs6O/RgDZl6mMSehLzpzHh/0IR1W+clCSXxx0htunSRisOJVdU76rSzz5jenracJx7zYYPbh+XAY3iG7D1xVwyRbjIr22WUzTMTh6wSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u9UGHZdK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u9UGHZdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE28C2BCB0;
	Sat, 28 Feb 2026 18:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302768;
	bh=0QX6fx5ztsOwbqkdDSx3cDlN5iFEkWOFNLENrERXWbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9UGHZdKZsRK6dHPT4KXRvyYNfe/z6naHdWaJNyd1tt5Vb3L52UOYSDQU/pPQ0f8J
	 THn2haHw7a6kLgYFcn7OC4yYSTAkamhfGOt0MP0BneGdwLSc3gsYLVc9QtpAjd57Wp
	 DSJZ5cfGDxsdCjKO5hLUn8v8nf97Dj6cm15RdhvjP1zZMGnypaugzi2zyPV920WPxz
	 5kG0w96CHg0xrAzbUNpANpASSR7b2otaj6h5kVbQXg3LGHwf2qxGnViBUgi4WMUYzV
	 /CyOuzDQjFQGx74J6n+3ODjO7l/hORp9rpcD6NyT9N1gEFX+qZsn5W9JoXnaGxbfV6
	 ej5y/voMSZG1A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Juergen Gross <jgross@suse.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/147] xen-netback: reject zero-queue configuration from guest
Date: Sat, 28 Feb 2026 13:17:28 -0500
Message-ID: <20260228181736.1605592-140-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit 6d1dc8014334c7fb25719999bca84d811e60a559 ]

A malicious or buggy Xen guest can write "0" to the xenbus key
"multi-queue-num-queues". The connect() function in the backend only
validates the upper bound (requested_num_queues > xenvif_max_queues)
but not zero, allowing requested_num_queues=0 to reach
vzalloc(array_size(0, sizeof(struct xenvif_queue))), which triggers
WARN_ON_ONCE(!size) in __vmalloc_node_range().

On systems with panic_on_warn=1, this allows a guest-to-host denial
of service.

The Xen network interface specification requires
the queue count to be "greater than zero".

Add a zero check to match the validation already present
in xen-blkback, which has included this
guard since its multi-queue support was added.

Fixes: 8d3d53b3e433 ("xen-netback: Add support for multiple queues")
Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://patch.msgid.link/20260212224040.86674-1-n7l8m4@u.northwestern.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/xenbus.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 9ee9ce0493fe6..c47e327039a0a 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -735,10 +735,11 @@ static void connect(struct backend_info *be)
 	 */
 	requested_num_queues = xenbus_read_unsigned(dev->otherend,
 					"multi-queue-num-queues", 1);
-	if (requested_num_queues > xenvif_max_queues) {
+	if (requested_num_queues > xenvif_max_queues ||
+	    requested_num_queues == 0) {
 		/* buggy or malicious guest */
 		xenbus_dev_fatal(dev, -EINVAL,
-				 "guest requested %u queues, exceeding the maximum of %u.",
+				 "guest requested %u queues, but valid range is 1 - %u.",
 				 requested_num_queues, xenvif_max_queues);
 		return;
 	}
-- 
2.51.0

