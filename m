Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0C73E47B;
	Mon,  1 Apr 2024 16:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988213; cv=none; b=lfPD4WFV6EDRouCmkExZWQqIdQR+h9dqXAl3s2pwWkWTMNeu03gAl0RDYyzfAPpvTU3zVr8fHf5fK3yAWM1FeYHD19aZSNZb6ilcA1MYAy9tFyphSq7P4j1bxyfUheEQ02ca9UPrKGQEsL7uEWVrDp78HdtNyp/rtFBMWFU4tAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988213; c=relaxed/simple;
	bh=H++4EQouU0Q6sMCymrlvYk+vV731X1YdrpbxCOB/qco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QAlYN7Fr+tNi7sZ9HDhEFCl0I+HS6C0bQY+wq4ic5Z3IhoWZisTIh6sdZI7WIrP/RSgh4DE06Y8z+/5YmbXC9G5vUq88KjLOk8DmUAdf1NY7f5BsN1trklpWcW4MUJ54VKB77yykN2dzgm/AyyeRhZ9QI6ECsSzJzsbwmpy5NgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hqdNpz0g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hqdNpz0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9572CC433C7;
	Mon,  1 Apr 2024 16:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988213;
	bh=H++4EQouU0Q6sMCymrlvYk+vV731X1YdrpbxCOB/qco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hqdNpz0gkmZi1x+/EQ3vHa54/g3xG/XQk0HkoeBMNwA4yWaXP4P5+5EevrbOXlKL9
	 M3jNqzbRcYqeq8P77YwU2b261NqI98Sj1hAOsLIxiP8NBQUV6v6d4MfQhQ7CAyjNTt
	 Q1XQjyZwZg6OLcxf9L5Y80h+AGEU9179dXkJGSYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 118/432] io_uring: fix mshot read defer taskrun cqe posting
Date: Mon,  1 Apr 2024 17:41:45 +0200
Message-ID: <20240401152556.644667053@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 70581dcd0601a09f134f23268e3374e15d736824 ]

We can't post CQEs from io-wq with DEFER_TASKRUN set, normal completions
are handled but aux should be explicitly disallowed by opcode handlers.

Cc: stable@vger.kernel.org
Fixes: fc68fcda04910 ("io_uring/rw: add support for IORING_OP_READ_MULTISHOT")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/6fb7cba6f5366da25f4d3eb95273f062309d97fa.1709740837.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 9394bf83e8358..f66ace04403f7 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -926,6 +926,8 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 	 */
 	if (!file_can_poll(req->file))
 		return -EBADFD;
+	if (issue_flags & IO_URING_F_IOWQ)
+		return -EAGAIN;
 
 	ret = __io_read(req, issue_flags);
 
-- 
2.43.0



