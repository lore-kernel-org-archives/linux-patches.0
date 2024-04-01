Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753CD47A62;
	Mon,  1 Apr 2024 16:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988253; cv=none; b=EpBZZCMqbAznTDN6pZAAiKk16w22Z7PTLATeXwc7THpOeO4/tPTc9vwksmIqu5tE+Xfp+HTI0knm9nAxU8FI+NK9tTCsomuTYBJC3WVNXvGyAT55NIWHE7dTk2X4J+7cvHBbVdQuKRbqbjGXT6ckhM8gglW/O9oS+p3+38QXol8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988253; c=relaxed/simple;
	bh=k1I2oGFAjBCVDpxCUmQ3oUNBZqnrOqvaH0u6Qxm1Wao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CA84qG2DtpCQM5c44cX5L6t4HnZ2Mev89WRTL4QQQacMKFb9kiJPfH0hq9fnB31P1djTc3SKwBtdBCl/VYEXgfVJQqXuNPYaEaLfBrOeWG0ABXk5fcQGuwsIEDXRPGqfFyATqs3ETRLMlIL4ZXYaXUYRQ1538P1AWwKU6ZbLXYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yS+xRvuT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yS+xRvuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8DFC433F1;
	Mon,  1 Apr 2024 16:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988253;
	bh=k1I2oGFAjBCVDpxCUmQ3oUNBZqnrOqvaH0u6Qxm1Wao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yS+xRvuTh+Btfmf2P2X04UsvAIkLfMk3f/F7ZI7ivoNummPTI2n1IWvjuZe2ANxzS
	 POb28HZEaPy3shAEDH9WOCnPFqXXp2xpq7Hh8rMNLhqZC5WUcllK+q9Whms1+DcTjU
	 hSXjzW45QNA27jv+9wv6vhtws3+/tdcg+DJlfQYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 129/432] io_uring/net: correctly handle multishot recvmsg retry setup
Date: Mon,  1 Apr 2024 17:41:56 +0200
Message-ID: <20240401152556.979448279@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



