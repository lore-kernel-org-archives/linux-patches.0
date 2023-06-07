Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89BE1D2A5
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28742C4339B;
	Wed,  7 Jun 2023 20:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171031;
	bh=+wMV/2QnJjGPeJV5uuxqr/Hp5qbBlMgraKerOYvZyq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZgQYyAguNY6xkjMqK7w4QhVj02OTlI/ecior2DtUfYe1b31ERcQVK1RyWpfXq8wD
	 11xLFsQGS75f1H6zWZ0VXHRzK56BHQ2+p99RvQBXbNLTyZA18VN47Rjw6O6s6VFmcN
	 7hc9Vi4YjA641tKW9kywYXJlOulnexzGvgzVlaYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Richard Acayan <mailingradian@gmail.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.10 084/120] misc: fastrpc: reject new invocations during device removal
Date: Wed,  7 Jun 2023 22:16:40 +0200
Message-ID: <20230607200903.541118643@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200900.915613242@linuxfoundation.org>
References: <20230607200900.915613242@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Richard Acayan <mailingradian@gmail.com>

commit 46248400d81e2aa0b65cd659d6f40188192a58b6 upstream.

The channel's rpmsg object allows new invocations to be made. After old
invocations are already interrupted, the driver shouldn't try to invoke
anymore. Invalidating the rpmsg at the end of the driver removal
function makes it easy to cause a race condition in userspace. Even
closing a file descriptor before the driver finishes its cleanup can
cause an invocation via fastrpc_release_current_dsp_process() and
subsequent timeout.

Invalidate the channel before the invocations are interrupted to make
sure that no invocations can be created to hang after the device closes.

Fixes: c68cfb718c8f ("misc: fastrpc: Add support for context Invoke method")
Cc: stable <stable@kernel.org>
Signed-off-by: Richard Acayan <mailingradian@gmail.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230523152550.438363-5-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1688,7 +1688,9 @@ static void fastrpc_rpmsg_remove(struct
 	struct fastrpc_user *user;
 	unsigned long flags;
 
+	/* No invocations past this point */
 	spin_lock_irqsave(&cctx->lock, flags);
+	cctx->rpdev = NULL;
 	list_for_each_entry(user, &cctx->users, user)
 		fastrpc_notify_users(user);
 	spin_unlock_irqrestore(&cctx->lock, flags);
@@ -1696,7 +1698,6 @@ static void fastrpc_rpmsg_remove(struct
 	misc_deregister(&cctx->miscdev);
 	of_platform_depopulate(&rpdev->dev);
 
-	cctx->rpdev = NULL;
 	fastrpc_channel_ctx_put(cctx);
 }
 


