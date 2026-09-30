Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5682C51E459;
	Wed, 30 Sep 2026 17:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789497; cv=none; b=HVL3pQoUcqkVXaY9PYKKhIx0hU/84k8gLZiio0LMXLKFORs/0Kk/LNZhxgEzo5aL4fNhqLBRP/Q94zVgR9z7D8V5cpNIIGKqzFXg3d7B9THRfLg67fXEolX3hbrf1853fBxrZGDpMbZ4NWPoVdUW6xAANtkmUDyGkb6Nh8DbDUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789497; c=relaxed/simple;
	bh=4ydQKmhX34/7mitTwCySsitoii2+nObboauSW+b0Tgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJ3R+b038w9kdjgZHYRYJM3nkZqe2/HTiuqGJQO8SpbmhUwKrZaeMJ6/Iklurz7OakI+fYSN1A6bgOo7/CtQ9gRD9XChsrGUDKY525pKlicPkWcotQ3qAN4HMsd/0HWaKltnvYyCiw9l0ptvCfYhUmqxFWu2f42Pon2QObuXZeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=myHfjZk6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="myHfjZk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B195B1F000FF;
	Wed, 30 Sep 2026 17:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789496;
	bh=3liEoQvPr2zBBC03vLRSxjzaggHN2kka3mDAXyZNED4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=myHfjZk6Zo2sDZEcyf7zbQfOtL1iH9jxpb/86iIpzx0G8sN1iW6Su/gnLN+c1yLji
	 aSfLQGpWUAf/8c/iwrTYYU0JLCFJ0bG24kPixPWmP72+k33ooEKPFgv3OLd62CbGgR
	 DP3Vg51IedqmnwQ/KfcFuJ1r+A8+rdmHfaK6ZLPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Amirkan <markdamirkan@gmail.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 453/877] mptcp: return sk_wait_data() errors from recvmsg()
Date: Wed, 30 Sep 2026 17:22:44 +0200
Message-ID: <20260930152424.455762101@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index ee160c783ff5a..4e467e7d3b362 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2364,7 +2364,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
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



