Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623433;
	b=tmd/S5dLBdrSphOhFedOQK22vaVy37zOenO6JOAZMNi+QajmAUlnWo/7xF4QBQpOzWrt
	 ggCpyf5qqW2J99U6pGV6wQ48+PixTKLcr0WdGQ5pjSJAg+AMXJs2iPfLdfAWwMPYuS7DG
	 z/o7edx6MZuUWR59XKrS8QKjzETptcq4O4OZWkbqAJVxzmF+gGEinKQlIIXLk7+Jbyo5P
	 ZiEjkR1RA8YSKzHzxjl8s77r10+5cJXZPPk3t6NJ2I+XNnWgV/a7R9Def/q4S+ng7YDjP
	 Xs5/6IKr102LwZZLIZgy5wkSl+xoWOTM7m6j7I97tpz74jZE6lAoBzdMWu4fmakm7dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623433;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M6u3jid3bzjwyVcBq4ERQysMI4aFjwOpOZdtxWZ5M5M=;
	b=foP1JkPuyseVj07IgLuA6OZmuluhqH/E1vmR/xMw4leYzkz/FROfhr/NgHU6onfd4/z/
	 bTwkK+uNwW40PKbupKJ3E9yT38Mi3NLAH5TeiL3gey02yfM130Y4BHAGbbA0WFdqlaxHu
	 Iw3okHY8Vd9JYSS3jIg2L9uJOVpET8jMRi5BByPJuf/KqV1Nk9ojvz05s0WY5T4+KDFEK
	 UE4COxNOUPtclHxLwmnwRliyFAy0E3xSp7Oat4l6LlZscCQsAC1P3wKAMMlawgNIhCSqD
	 E833M6CVxLtiT6fjG7efkh6r9xwyGRMm8VLMonCHuBy9Cq2qsCwfGJeNDBtp2eMFNig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tNRPnq5u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083FD606A31E;
	Wed, 25 Nov 2026 16:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tNRPnq5u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590861F000CA;
	Wed, 25 Nov 2026 16:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623432;
	bh=M6u3jid3bzjwyVcBq4ERQysMI4aFjwOpOZdtxWZ5M5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tNRPnq5uWVdeJy9txwQSglNgaa05EnsflWdj4bHB4ccrTmSC8NB96We1YkbiIA4fK
	 BCKgCI2d7FkVhzsQPBDBYWE0sRk0Dhcshyx3yo7TxnidZrFd6EiNnbPfGaDGLEzUfl
	 xNnOUKiMP/BYisB3Rl5dQqP4IN8lm6OA0vg/M66w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <1075151112@qq.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 858/990] dm thin: avoid wrapping no_space_timeout
Date: Wed, 25 Nov 2026 15:37:05 +0100
Message-ID: <20261125143842.123867488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Yingjie Wang <1075151112@qq.com>

commit bcb78d49620f666b4a9d62997691e8d031fd4ebc upstream.

set_pool_mode() converts the no_space_timeout module parameter with
READ_ONCE(no_space_timeout_secs) * HZ. The usual arithmetic conversions
evaluate the product as unsigned int, so it can wrap before being stored
in the unsigned long delay. With HZ=1000, 4294968 seconds becomes 704
jiffies: a pool that runs out of data space switches to
error_if_no_space and fails queued writes with -ENOSPC after about 0.7
seconds.

Widen the value before the multiplication and cap it at
MAX_JIFFY_OFFSET / HZ, so large timeouts no longer wrap into short
delays. On 32-bit kernels, values beyond the supported jiffies range
saturate at the largest whole-second delay not exceeding
MAX_JIFFY_OFFSET. The timer wheel's existing handling of very long
delays is unchanged.

Fixes: 80c578930ce7 ("dm thin: add 'no_space_timeout' dm-thin-pool module param")
Cc: stable@vger.kernel.org
Signed-off-by: Yingjie Wang <1075151112@qq.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2544,7 +2544,9 @@ static void set_pool_mode(struct pool *p
 	struct pool_c *pt = pool->ti->private;
 	bool needs_check = dm_pool_metadata_needs_check(pool->pmd);
 	enum pool_mode old_mode = get_pool_mode(pool);
-	unsigned long no_space_timeout = READ_ONCE(no_space_timeout_secs) * HZ;
+	unsigned long no_space_timeout =
+		min_t(unsigned long, READ_ONCE(no_space_timeout_secs),
+		      MAX_JIFFY_OFFSET / HZ) * HZ;
 
 	/*
 	 * Never allow the pool to transition to PM_WRITE mode if user


