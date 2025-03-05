Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740E078F3A;
	Wed,  5 Mar 2025 18:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197656; cv=none; b=JQapUvGvO7zNhRcf7x/RbSypsNiZiHQyl6IOuSV95HGEoxNWOstrcvVksYj+mU9VhaeQ7w99TL8KO1I2tYsCiR7wthtL/PeT1X2tb6+HPOp6h7uAAPwsMAxo6iCirZA9BqO79TuS5ysBpSbHDukzQRg9Mn0ksIFA43rmKUO6Cwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197656; c=relaxed/simple;
	bh=3nRm4HVsBuJP1y5osT4gjW8DXXUvN+O/XJQ120qElrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEvBBy70zJKVVxILC3iO4754lFb7h7kFXggj9i6H6nMS+JkS+Hzw+CX+Cg9ydTue4vWpO2WC1Vl1C5J0VxUNTlp404rTuP6/06DPqh8U5meGPiJCbzHh02z3x3wAv6oh4jfkP+H9zDgEGUbIJLcnNSyfKYC+DN/g52iDvQvzShA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRXjbHl6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRXjbHl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F9AC4CED1;
	Wed,  5 Mar 2025 18:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197656;
	bh=3nRm4HVsBuJP1y5osT4gjW8DXXUvN+O/XJQ120qElrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRXjbHl6lsn4+Ho5Slj4nCnnSNzMRCFYa73dBJOhIQUCQHGvSRQQ6vUpTON8SM/9r
	 w/Ex83RODu2I0fty+mwGZAR+i+9SPorOe0hmw47c6hTlkoqYBIiRwBf944boONC8gG
	 Qa4FE5Yk/eoIiiY9BUJg71e3Y1czwFOmbF8vla44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/142] io_uring/net: save msg_control for compat
Date: Wed,  5 Mar 2025 18:47:53 +0100
Message-ID: <20250305174502.508711324@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 56091292950fd..1a0e98e19dc0e 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -303,7 +303,9 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
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



