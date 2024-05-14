Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C771CFB2;
	Tue, 14 May 2024 11:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687769; cv=none; b=tsSWvklQH9yxSWnn2M67n2E/s4t/BjfY06JBDVd/rV3sb4BsURp2TeLuWxbknHQnpCgIc1ltaGIL3r6wgWU3f813GRYOLeHG4YPjvHJKqRyZg42mQdZP6LYOSht4LMfJrBXAb3uApWz4uyS7U14CyYTBIXD/BTeeAQy8baEN5Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687769; c=relaxed/simple;
	bh=1WFFKjy03ndX3WWWs5IHsgBIwSSc8BclZeQHcBvTjvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByM+u9i9hvs9199w7bd47AQ0L0/rEJybWJqqG/B0Rsp3Ckdn6ETOY9xX3YBMbnq8OJ2M/RRPxCIubvFMRja1PQoQyB1MzOHLXJ+Wn/SJcPpkqordT4TahrWqD6OFmcHpdXjK6q+ZSULzA/24xtEFkmuuL1ABEDe8RIZjMYMUSyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YvN61e9M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YvN61e9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A86C32781;
	Tue, 14 May 2024 11:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687769;
	bh=1WFFKjy03ndX3WWWs5IHsgBIwSSc8BclZeQHcBvTjvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YvN61e9M91HIav7GX85rYCFMGLOjAVfNeyYi8DIZENOfNSCtfxzDMlyJ/jwo/EI3O
	 izWqoEyOyL0Evsc7kvZ31lILP4WZdYTpjyvT9okfd6qx0DDygZV+MM0M3OBs/G0WQc
	 bRTUB/+PekIJ4I6LyJpFUcQjBFj+abUQ43OcQ1Ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Fastabend <john.fastabend@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/168] bpf, sockmap: Reschedule is now done through backlog
Date: Tue, 14 May 2024 12:19:56 +0200
Message-ID: <20240514101010.389378780@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit bce22552f92ea7c577f49839b8e8f7d29afaf880 ]

Now that the backlog manages the reschedule() logic correctly we can drop
the partial fix to reschedule from recvmsg hook.

Rescheduling on recvmsg hook was added to address a corner case where we
still had data in the backlog state but had nothing to kick it and
reschedule the backlog worker to run and finish copying data out of the
state. This had a couple limitations, first it required user space to
kick it introducing an unnecessary EBUSY and retry. Second it only
handled the ingress case and egress redirects would still be hung.

With the correct fix, pushing the reschedule logic down to where the
enomem error occurs we can drop this fix.

Fixes: bec217197b412 ("skmsg: Schedule psock work if the cached skb exists on the psock")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20230523025618.113937-4-john.fastabend@gmail.com
Stable-dep-of: 405df89dd52c ("bpf, sockmap: Improved check for empty queue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index e9fddceba390e..51ab1e617d922 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -481,8 +481,6 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 		msg_rx = sk_psock_peek_msg(psock);
 	}
 out:
-	if (psock->work_state.skb && copied > 0)
-		schedule_delayed_work(&psock->work, 0);
 	return copied;
 }
 EXPORT_SYMBOL_GPL(sk_msg_recvmsg);
-- 
2.43.0



