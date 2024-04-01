Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8415B46551;
	Mon,  1 Apr 2024 15:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986993; cv=none; b=YhdvZYbWfvaR14g+/yFKv3ZYH/PC2OnnlpU0VbRcMEm/YpX9gRKMpU8TgnGjHRAGbTby0nPzzo1hoA3SKE0gS953Lk8diOyRiJFAOuSBIbz844fOFffHL8vQl861Yndn5ukYliLUbnTmzdzZzNPomKzWrMhyqKPgHKOUSKUa/34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986993; c=relaxed/simple;
	bh=Z6lbGVK6yNqqnkIuHAm5W1APvIVSEU8ei0VyTUQxuU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJ8SkPCClygJdNlyubjIOgXJiKu/T4YVdLgex002WdAxF7wkBBwAuzkcGF7M4LiMQrZUIaHbcf5aQIbaW6pdE3cLFa2Zf2La2I2V9cohyA9PyWc+h8TLXvRMn2SnFWxZZ4YsE18PPgJgcQifUCXTMPGVl1OrtBELesTPNNfV3Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUKolLvA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUKolLvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00990C433C7;
	Mon,  1 Apr 2024 15:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986993;
	bh=Z6lbGVK6yNqqnkIuHAm5W1APvIVSEU8ei0VyTUQxuU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aUKolLvAT9w1SULR3jrSCzz+gh2QTFEvFDP834Te+zaIOuPARa81bD6aLLBopcsJT
	 BBTLKpx7iGRuDvKFGjD7A0AKBwm0R+EzADRBIsjzucclwwmohETp2oHMhVX0PGR1/i
	 BfWnvBuhq/e2NLxGb2XfE3IFpy+TAFeKsGVsrCMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 133/399] io_uring/net: correctly handle multishot recvmsg retry setup
Date: Mon,  1 Apr 2024 17:41:39 +0200
Message-ID: <20240401152553.161413162@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit deaef31bc1ec7966698a427da8c161930830e1cf ]

If we loop for multishot receive on the initial attempt, and then abort
later on to wait for more, we miss a case where we should be copying the
io_async_msghdr from the stack to stable storage. This leads to the next
retry potentially failing, if the application had the msghdr on the
stack.

Cc: stable@vger.kernel.org
Fixes: 9bb66906f23e ("io_uring: support multishot in recvmsg")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 4aaeada03f1e7..386a6745ae32f 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -915,7 +915,8 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 			kfree(kmsg->free_iov);
 		io_netmsg_recycle(req, issue_flags);
 		req->flags &= ~REQ_F_NEED_CLEANUP;
-	}
+	} else if (ret == -EAGAIN)
+		return io_setup_async_msg(req, kmsg, issue_flags);
 
 	return ret;
 }
-- 
2.43.0



