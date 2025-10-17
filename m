Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909432F12D2;
	Fri, 17 Oct 2025 15:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715820; cv=none; b=HmoXItEb4RHRJrAV/1uCey42a6oc6O9P2oJ4iBUJT8oUC2gX2goLUQJfmqYDdfX9T+4173NQx+krxwhCWITRZCbtT9z5gXixyesiieeWBzBoZy+gCHdG8eYAeI3oTbtPqWgAW7yWDyrvO75M6LbaFKcHgH+9SyrIMHb+YH/tz+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715820; c=relaxed/simple;
	bh=WXD8xMZtBMTcYcTj7YdIzzK53GB44W8bUWdOLD4qPwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1iqi/7HiTHLt+jErFK0wrXoMZIBj++fK3QG+bkyIw6Z/FmfNQBLso36kcu5XimA8BjH/3qjMfoe3zmu1a34ERPzPyUyeSasvUYBldbBGzd9esm8/hde3X82DX+uWKf0yZPxuOWC8dcFhyU6OftlE8ap+wzsffDcak9qskG3nBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OhzLm48Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OhzLm48Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9C0C116B1;
	Fri, 17 Oct 2025 15:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715820;
	bh=WXD8xMZtBMTcYcTj7YdIzzK53GB44W8bUWdOLD4qPwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OhzLm48Zf6MAtHzY1P+uZumc+nY5Hty9aq5yCT+InhZIMN60UWqDUOQKXMCDSSYut
	 uirca99rQ55KAwOpQwhZZvRftG3wqFzpiFzIyirFrblAwD7Md6+CXFzfcF6XA3CuGm
	 s6w4u+ksV/i9HlNXtLYgel7auyTzp+wbVMfKEamM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Greg Thelen <gthelen@google.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.17 349/371] ipmi: Fix handling of messages with provided receive message pointer
Date: Fri, 17 Oct 2025 16:55:24 +0200
Message-ID: <20251017145214.706522652@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit e2c69490dda5d4c9f1bfbb2898989c8f3530e354 upstream.

Prior to commit b52da4054ee0 ("ipmi: Rework user message limit handling"),
i_ipmi_request() used to increase the user reference counter if the receive
message is provided by the caller of IPMI API functions. This is no longer
the case. However, ipmi_free_recv_msg() is still called and decreases the
reference counter. This results in the reference counter reaching zero,
the user data pointer is released, and all kinds of interesting crashes are
seen.

Fix the problem by increasing user reference counter if the receive message
has been provided by the caller.

Fixes: b52da4054ee0 ("ipmi: Rework user message limit handling")
Reported-by: Eric Dumazet <edumazet@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Message-ID: <20251006201857.3433837-1-linux@roeck-us.net>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_msghandler.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -2280,8 +2280,11 @@ static int i_ipmi_request(struct ipmi_us
 	if (supplied_recv) {
 		recv_msg = supplied_recv;
 		recv_msg->user = user;
-		if (user)
+		if (user) {
 			atomic_inc(&user->nr_msgs);
+			/* The put happens when the message is freed. */
+			kref_get(&user->refcount);
+		}
 	} else {
 		recv_msg = ipmi_alloc_recv_msg(user);
 		if (IS_ERR(recv_msg))


