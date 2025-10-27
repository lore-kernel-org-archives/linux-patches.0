Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0EF2D836A;
	Mon, 27 Oct 2025 19:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592341; cv=none; b=XH5YZF2faCkWxArMa5ww7mUjLWGamgWb0o2vdNwir6qBaJxVT8UjGrJPo1TjAV6JhZ1ZpOf3hmJjNdXqLdO0jZW23Z+lDvHT5A/ZIH1OB+ENAY2mMVQb9U/l43+dITUJZj849x0WV7WR34jGW8pq0eRoLxbrP2Ro4QmbevnCRyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592341; c=relaxed/simple;
	bh=ZvvndlAeWB2L7ZT2ouusqC7muu98c/DbWdg0rnizm7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7Rhq2xvQwLEAzC33qlM8vIlln0Z140C2LUlJSJaK+v+OzwKeiftwEhgqeyDXVzHJoT5Kipx2n+KwXvH21aB0DyLq9+u6m42oR14Cu+ItfYr3o4mFONpBkIma21jIw5Vwhv2zrrm6kzps6lvm4AD57VpY93ROMunt5RVzW8PxJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1kg8WJa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1kg8WJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCCC5C4CEF1;
	Mon, 27 Oct 2025 19:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592341;
	bh=ZvvndlAeWB2L7ZT2ouusqC7muu98c/DbWdg0rnizm7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K1kg8WJag+8rNjwuMdjzWfvjq1ASuYE/7dxiaubZiGIBpNVKgncdyFWIMcym3SL9F
	 qr/zhqrYtFtjh/55t94M0h/N90FdYPz5qgYeXVJ6CWvNFrjEod+HjMxjC9Ii+lrH2W
	 hky9e5viNMj6CZYVtjcry9B/ippfd+WB9Hvdbc0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/157] net: tls: wait for async completion on last message
Date: Mon, 27 Oct 2025 19:35:06 +0100
Message-ID: <20251027183502.505277448@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 54001d0f2fdbc7852136a00f3e6fc395a9547ae5 ]

When asynchronous encryption is used KTLS sends out the final data at
proto->close time. This becomes problematic when the task calling
close() receives a signal. In this case it can happen that
tcp_sendmsg_locked() called at close time returns -ERESTARTSYS and the
final data is not sent.

The described situation happens when KTLS is used in conjunction with
io_uring, as io_uring uses task_work_add() to add work to the current
userspace task. A discussion of the problem along with a reproducer can
be found in [1] and [2]

Fix this by waiting for the asynchronous encryption to be completed on
the final message. With this there is no data left to be sent at close
time.

[1] https://lore.kernel.org/all/20231010141932.GD3114228@pengutronix.de/
[2] https://lore.kernel.org/all/20240315100159.3898944-1-s.hauer@pengutronix.de/

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://patch.msgid.link/20240904-ktls-wait-async-v1-1-a62892833110@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b014a4e066c5 ("tls: wait for async encrypt in case of error during latter iterations of sendmsg")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index fe6514e964ba3..c67cf1a06c0e5 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1184,7 +1184,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 
 	if (!num_async) {
 		goto send_end;
-	} else if (num_zc) {
+	} else if (num_zc || eor) {
 		int err;
 
 		/* Wait for pending encryptions to get completed */
-- 
2.51.0



