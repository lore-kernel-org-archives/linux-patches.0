Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB288509F0B;
	Wed, 30 Sep 2026 18:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793295; cv=none; b=GdVFceyKgsgGuWXetV2uu4pk8q5vy8T8J/4Nb5OVB9FihPXPiYdz9t7U5pAJRh/08EeHCxuK6dtfYwxdj3KxZ4ToRuwNyREGzSi6EttGc+5bdBvrjMA9xnxhMX3SGNvOvX0xsNNukgkZz18kLzFvzXI118A+sGf4CBnxFnyY/3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793295; c=relaxed/simple;
	bh=q76hDzdgm0CLNesrG4Gopy1maVWCiVTTHSyVBK8TrWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjKrm14HHTjBgW0PLQuNdQ0VVqEUomGW1A+PnyfU7V1WR9DxkENfvPmD79e7dxgn+hkufL5wJp2oRXkaG5c6O1wz3pzP2YXHyfIMzM7S39qd6B6YA61eSCwtfe3o8M4wmdrN+8a8d3c8eLwb5ks+2OUC1tpZk3yFrV4HiyHaAgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZuvvoe4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZuvvoe4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558C21F000FF;
	Wed, 30 Sep 2026 18:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793293;
	bh=yzwUV+vQ4g4rhY5+qC2ytae00WnTHU60FU7g6Gg19Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iZuvvoe4wtpcJ/rJMNMpIyNLhqZsv7lngL77rhqo467UFXgfH+F/iIUQsJkAjiCVQ
	 M6pxbRPvKjn5C2/Q9DhEIc6cDpo8ONl6I2LSSsz/K9shRkvP659GT+nQISi+IcdRhL
	 xAyeqYLWEND/a/e025QNMU6y/pf+ArK9dNU38Usw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Amirkan <markdamirkan@gmail.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 203/395] mptcp: return sk_wait_data() errors from recvmsg()
Date: Wed, 30 Sep 2026 17:27:45 +0200
Message-ID: <20260930152345.050973363@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e9967d55b8ace..7a1696ac92dc8 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2302,7 +2302,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
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



