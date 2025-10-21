Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14767350A0D;
	Tue, 21 Oct 2025 20:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077079; cv=none; b=a9nJPIO3H4sJQmvL67JMDv1/44Ika72v9g077/9GyeTMJU4s3q7z8Zvd7HbLj8U0GR5E1V8pMCYqtQCeMXAqEUmals1qapRA1NNvtxGoZOUt/5V/hlGVOBlv4xA47EBBYL62Lsi8G+/95xXQVEOfOCu/aQhMVdqQuAeth9UAkcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077079; c=relaxed/simple;
	bh=/hUFGAC0TVC/geyMV5dQoEvVDt3I9zRlXX5YZiCFtYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXcQNkhg/d2yYQ+YO86lYgNfhB5H78dGZ4J6eI2Rfq8n8diAUIckws7zQAwWTQ1RJW2MAFdBwAdU3akdKWyuTZc+TMuQrjuP4orIgfCjbP7Lyna0auZ2EVE6Mt+KjSm3o78E+0yFRJcpLPZ5ThK4O94Yi94M+dqj6VGAAbWcTSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dvPqTl/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dvPqTl/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933CBC4CEF1;
	Tue, 21 Oct 2025 20:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077079;
	bh=/hUFGAC0TVC/geyMV5dQoEvVDt3I9zRlXX5YZiCFtYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dvPqTl/QILro9agpEN3DOhHgf2c6GySaB3lcIoYnG7NRVgifIeb1WPt91RvOuwB36
	 0AQJzU6Sw9Yl4TnSRXOAQ2lLu70dZC+ggFxWlvhFWwXKiB8EZdc/pryl3ZF1n84JL1
	 VGPE7y9KUGukrpSHzJTOTlGjoxxef2AQHedxkWbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 128/136] mptcp: Call dst_release() in mptcp_active_enable().
Date: Tue, 21 Oct 2025 21:51:56 +0200
Message-ID: <20251021195039.062650307@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 108a86c71c93ff28087994e6107bc99ebe336629 ]

mptcp_active_enable() calls sk_dst_get(), which returns dst with its
refcount bumped, but forgot dst_release().

Let's add missing dst_release().

Cc: stable@vger.kernel.org
Fixes: 27069e7cb3d1 ("mptcp: disable active MPTCP in case of blackhole")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250916214758.650211-7-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 833d4313bc1e ("mptcp: reset blackhole on success with non-loopback ifaces")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/ctrl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mptcp/ctrl.c
+++ b/net/mptcp/ctrl.c
@@ -385,6 +385,8 @@ void mptcp_active_enable(struct sock *sk
 
 		if (dst && dst->dev && (dst->dev->flags & IFF_LOOPBACK))
 			atomic_set(&pernet->active_disable_times, 0);
+
+		dst_release(dst);
 	}
 }
 


