Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C2650EC06;
	Wed, 30 Sep 2026 16:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786606; cv=none; b=GE14vkASOTfmgzb43vdOCntkqXrGJUYDKww/eOdupeUaUp0MuvZ3PkQhXpe5tOW9DPS85oSd8sPGMoXKpYGgGxpY5eJEmAsx678zN9FJuFkmC5p8VLkcV+EdLGwjcEOrEY3CMwwDsrnyy2aA4INO2StU63oRMHCaHk1YRcm6Oc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786606; c=relaxed/simple;
	bh=qfJkhDKxk7onUivwfBGIcnTZojnlbP2cU/rKvbeY2WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8itJ9glTCJcF/jdOdmwjhZ6HDVO2/ajlJovSYt+RXUVHBjZt2jo2C6AliEDbBMV3at7Br74X6VkOT5zZz2Q3FF8VGV/lBJUqK3LLdGxR//yU5pYdA4v9tIa3d0tATfketYVJwkuyh91u9ltU65ftorDF/ais6DFg0mHuLJqMk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFN9SwcW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFN9SwcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31291F000FF;
	Wed, 30 Sep 2026 16:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786605;
	bh=2QD7g2EHbvVecS7TnFCafMJ2xWseTcI8BiNnTlovwn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GFN9SwcWrVJeFQONqES082GTmiGqTKeuiVVJsqa+MA1+hff1x7OL0PW6WeDLXCLZw
	 593CipEwoLa/ujY9+RcpJsVgXufOHiwmcUQVNFps8r++KUGCLexZbIQ4j/rn6vIvIQ
	 LHNc2n4O8fiLqseVw5pn6+GjyYX0JUaAVd/gcJL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Amirkan <markdamirkan@gmail.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 919/982] mptcp: return sk_wait_data() errors from recvmsg()
Date: Wed, 30 Sep 2026 17:27:35 +0200
Message-ID: <20260930152436.479829805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Mark Amirkan <markdamirkan@gmail.com>

[ Upstream commit 60404266ef3e0a1cd8f7a164060e0c83efb72f4b ]

Commit 581302298524 ("mptcp: error out earlier on disconnect") made
mptcp_recvmsg() stop when sk_wait_data() returns an error.  The error is
stored in err, but the function then jumps to a path which returns
copied.  When no data was copied, recvmsg() therefore returns zero and
reports a false EOF.

Store the result in copied, which is the value returned by the function.
This also keeps the usual partial-read result when data was copied before
the error.

A recvmsg() blocked in one thread reproduces the issue when another
thread disconnects the same MPTCP socket with connect(AF_UNSPEC).
Before this change recvmsg() returns zero; afterwards it returns -EPIPE.

Fixes: 581302298524 ("mptcp: error out earlier on disconnect")
Cc: stable@vger.kernel.org
Signed-off-by: Mark Amirkan <markdamirkan@gmail.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260913-b4-send-mptcp-recv-error-v1-1-4eaa3684a8b8@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index ca78add7670d9..10be901f8c026 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2320,7 +2320,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		mptcp_cleanup_rbuf(msk, copied);
 		err = sk_wait_data(sk, &timeo, NULL);
 		if (err < 0) {
-			err = copied ? : err;
+			copied = copied ? : err;
 			goto out_err;
 		}
 	}
-- 
2.53.0



