Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2767F1E0DD8;
	Wed, 30 Sep 2026 16:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787458; cv=none; b=kXjNp1g+LRT58loS1fEENabCjaw2gXGM8aZ0iRztA2OHnM7WqrtppEq+WWWCRWezq8Kk3Cr3JvvFd6QmoxjhpEPQUpTopnKjczUBA92mtLre0LMBx0JVh25LmjzbCUK0OMK1xwdo8jKtNelaUFFdhT2XzfMA7mg99szgWYI2b+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787458; c=relaxed/simple;
	bh=E4qjxN1DdoRgtPsX1Zxcgbb7doCSOZpkDLiiwtiQRJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkFdbUL2LP/pZRdSa6AjBY9A2a0hKlOtXxUK0jIGkKwgHPrSPvVcNghWneI3U4H8Pb+dgEtzrQhsK4FAn6uDrPzERTgXJ+uqkWxjubR7aE9edSR9SqFOqQ7KC7hw1Gco7uOJup8dD5L8WByvf17Uda0v2rCPY8HUKnC9WWEr0eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDhUn2gU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDhUn2gU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818031F000FF;
	Wed, 30 Sep 2026 16:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787457;
	bh=ojAXggIf65NFgZaTVylobUB2YoMETvkw0ZaiPP3aaJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TDhUn2gU490BCwFXpcb6G0/xhtr2I4V4nkI21xEB75gVo4JWHwLPQ9Vl5sjwzywkh
	 px4SmlWxTLBE1eb9pYYyqeOyh5gnnUQ8jybAfXPzeW2SIxaI+mGP3DN1iRbohqHmS5
	 +lJhN5jfL7MC3MoHoazUriUzup+22Qp/PhmXSDls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Amirkan <markdamirkan@gmail.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 236/457] mptcp: return sk_wait_data() errors from recvmsg()
Date: Wed, 30 Sep 2026 17:25:41 +0200
Message-ID: <20260930152351.136893660@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 49c46498af960..de6f289a6e14e 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2401,7 +2401,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		mptcp_cleanup_rbuf(msk, copied);
 		err = sk_wait_data(sk, &timeo, last);
 		if (err < 0) {
-			err = copied ? : err;
+			copied = copied ? : err;
 			goto out_err;
 		}
 	}
-- 
2.53.0



