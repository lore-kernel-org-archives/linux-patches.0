Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFECD3B443F;
	Wed, 30 Sep 2026 19:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796936; cv=none; b=UN6vM47bfFtWKfQngI+uf+aR7ZpIB0lnSLXmJH9fnqbYxYqacv+1EU29FKeRcVWADwztPWOEiVnfWfVHaNnw/2KFDPHvRNuDNV0AttBCHRx29lYAp8fTKiIp08l0koU2hdCRSZsPhKRKREszvi4b0HzZsANeLJE03zfup2h3Dh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796936; c=relaxed/simple;
	bh=mE1IxBFka41NUuSk974nWmNqcA1UwCEwqo9OEIHDzV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXs2vRwBIV5wfvUuPt6mpiQg4AR9vqyPrUP0qz68rcX8ZcSXybTaRM6kJF1O75eWs2yg6oAIb3QbyHLe+t+P/0OfQm2HFjXt9XjlAVvhYIDUUvjFdqmEv6VFDesdVoN0aJhPmfGO0gryUBxjonANwpQ0mROl5eYhDkPbX51BUpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7DWsdfm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7DWsdfm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0434E1F00898;
	Wed, 30 Sep 2026 19:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796935;
	bh=gQOkUEDt6bkdOAmS86zYkolCUYiW6O8j6wh4Xh6qpfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C7DWsdfmi8rIopnnRy+d9Tqza0VLRGRaDIDdhQgX83AnaITwWia16RAOv7qZmfqV6
	 4vJPW7sLjguEM0lHwwMVZz7k7aNOwkAU6I4ZyuF0MZ8TcfYeQcRduEUH6WH4vQrWbk
	 xZeNCpc9ivx3O5rWAcmAf20zyFJQku7OC22TM28A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Amirkan <markdamirkan@gmail.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1087/1193] mptcp: return sk_wait_data() errors from recvmsg()
Date: Wed, 30 Sep 2026 17:29:31 +0200
Message-ID: <20260930152458.384255881@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cd76b2d742d3e..48b6e9ed04ee9 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2327,7 +2327,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
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



