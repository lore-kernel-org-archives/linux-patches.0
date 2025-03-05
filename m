Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23571A840E;
	Wed,  5 Mar 2025 18:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198133; cv=none; b=ZoaBUr2NT8WA42mCmwyG5PI6KSdUa6E6aTG0Cr3ow0KoFsCSOSwlmUH7lHcjk9nRiBI6JAcusjcEbZc/DxatNfPslaLP110RVtrmEA4MOHRa/VlqUI3eW4tU9VNlMUYUquhxrOXGety4Y37yF+XDWXq3TjsWkpc5r8+3Y68GSA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198133; c=relaxed/simple;
	bh=Q1C8oeYI1TUcpYy4XZMZXkShcrSJ/U0WcwoHtXx2l2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3wgZtKJMZ8EyJHTNiVDx1aeCgoJAKncsDrMU4USQpQnqcujk1ut6A92ni4/Q3P7Vu6NPiPSYYIUcOp79R7KOGySdjktNNsObs6OWQoXe3fASsGlbT16Clbzvcw28ZKBZmiLZnucfF69PRCspHJV8IgwQ10TlljzIvPDeBrsbfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6RcfTYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6RcfTYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D565C4CED1;
	Wed,  5 Mar 2025 18:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198132;
	bh=Q1C8oeYI1TUcpYy4XZMZXkShcrSJ/U0WcwoHtXx2l2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6RcfTYUfvfJIyicbl1PTHnWWqO9pJd4hT0b2kW4T7BI1AZBqJX7r3s0KrJI9HVUL
	 T2yZC2FInyY/UbpKvy5t9HYU30Su6Qo9L1ZFvF0j+wswufdSpHpVMrrctEXsj4iUS8
	 9eFQxGgxLr3hGIFgYxmllUpWhG+dKf1rKhe+BaZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/150] io_uring/net: save msg_control for compat
Date: Wed,  5 Mar 2025 18:48:23 +0100
Message-ID: <20250305174506.790176874@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 6ebf05189dfc6d0d597c99a6448a4d1064439a18 ]

Match the compat part of io_sendmsg_copy_hdr() with its counterpart and
save msg_control.

Fixes: c55978024d123 ("io_uring/net: move receive multishot out of the generic msghdr path")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/2a8418821fe83d3b64350ad2b3c0303e9b732bbd.1740498502.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/net.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 3974c417fe264..f32311f641133 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -334,7 +334,9 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 		if (unlikely(ret))
 			return ret;
 
-		return __get_compat_msghdr(&iomsg->msg, &cmsg, NULL);
+		ret = __get_compat_msghdr(&iomsg->msg, &cmsg, NULL);
+		sr->msg_control = iomsg->msg.msg_control_user;
+		return ret;
 	}
 #endif
 
-- 
2.39.5



