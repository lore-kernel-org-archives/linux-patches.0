Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310D7196C8D;
	Thu,  6 Jun 2024 14:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682949; cv=none; b=q/xXvAKLH8Ouv5nLSGA56Td2M2odN2vsAvFFq+9cmcrLqyQgKs2IbZrmeRF2S4lzIEnrJoV2DMAlz52ufvLLFdnc0hIgoeKWyi1t+fOwSdg9hGpRE7j8/6DvZcb0QemmCM3DBSwac1JFQlCe/hF8iUbevjB46k7okDPBvIrrefQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682949; c=relaxed/simple;
	bh=o5wY0glUR+JcnhR1vgw5c9pPHJ/yuwAUmu+BRnZQ0C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+azjePqY0OyMhz7LlxrgoXQUh0sb+RPlUIPPNMFVXftkgu+C/w1o5mVKWxGZ6eZqEvqIi0blJJeNbEtTVqdVjSXz/YGIcIa9zAYJovmjhDAGj+OjLzfj8HWgXk7pMEiXekswzGGScK7cC4dUajle1KeaQjw0a8c7TtY5Z6dFfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AiZmll+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AiZmll+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E02CC32781;
	Thu,  6 Jun 2024 14:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682949;
	bh=o5wY0glUR+JcnhR1vgw5c9pPHJ/yuwAUmu+BRnZQ0C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AiZmll+tW1xZ0dJWjBjqsEM4YpQ4jJrN8l6BfjOxQJjkS6bC6BkuhZT+/7NJqCGg/
	 MUJ3p8XZzoqsSUZwT2lAAjupwqku/kHa6hER9BQdM1fD5/OHj18As2ufYI5hhzmQfk
	 BvireUWBNKxOIAWqQngI3ZsuiO2u1fkNlSozhcSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 112/374] fuse: set FR_PENDING atomically in fuse_resend()
Date: Thu,  6 Jun 2024 16:01:31 +0200
Message-ID: <20240606131655.682560180@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 42815f8ac54c5113bf450ec4b7ccc5b62af0f6a7 ]

When fuse_resend() moves the requests from processing lists to pending
list, it uses __set_bit() to set FR_PENDING bit in req->flags.

Using __set_bit() is not safe, because other functions may update
req->flags concurrently (e.g., request_wait_answer() may call
set_bit(FR_INTERRUPTED, &flags)).

Fix it by using set_bit() instead.

Fixes: 760eac73f9f6 ("fuse: Introduce a new notification type for resend pending requests")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 3ec8bb5e68ff5..8eb2ce7c0b012 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1813,7 +1813,7 @@ static void fuse_resend(struct fuse_conn *fc)
 	spin_unlock(&fc->lock);
 
 	list_for_each_entry_safe(req, next, &to_queue, list) {
-		__set_bit(FR_PENDING, &req->flags);
+		set_bit(FR_PENDING, &req->flags);
 		/* mark the request as resend request */
 		req->in.h.unique |= FUSE_UNIQUE_RESEND;
 	}
-- 
2.43.0



