Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A7F4502F;
	Tue, 16 Jun 2026 16:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627882; cv=none; b=AC15rKAna252QB7VtysXuZ6j1/gMAMLfw7HdbUhpSJ4lOSFLXHns3zha4L5kY496EBDVdQ47df8dpcFk7eNKlLsvwV5NbXlrt2nZC9geRYK77Ux+QmgAY0t4f6KaZILentNOzmKI5JzsYDSrI8sw8mIUTBjDGZy0+N90KF2T3tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627882; c=relaxed/simple;
	bh=TEfTabHO0YqctB4fMKoptJioa2E/XzTOVrRtQbUQmtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jc4KYR/FjNo5NUFQXOj6lIgGjGAoW7H3YLiEMoYs5dzgsPJ1bQ1Q92lApfQmFx2YM1YyQhEWUirXWxzvdPC6lT1F5XeLv4JMOgnath6XgFwfxdLdLFv1eWGX6RT+/U4JtSDuPFTCFziSEsdLB/Mq1MIg8k6yJDq3flpPiBOy3w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sG7DjyL1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sG7DjyL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029351F00A3A;
	Tue, 16 Jun 2026 16:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627881;
	bh=Xm0/984iSx0C2B9yxc2LRtjdwuy+U8vFsuqKSJkYZY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sG7DjyL1fmqKBy750MWi83XOcngzVGX69BRi6c3lhO9zYG+HdaBckdkpEBKYukdnD
	 H9gt2gaUSpudM9UaUzqqYLwC79FMB3bBbldxqgMj9q6cYKW83skrD7w6ZrGzm5J2Ki
	 jC54FBjc8QFBwt+qaKMfzC28mzro0Ttb0cqqH2hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 244/261] mptcp: fix missing wakeups in edge scenarios
Date: Tue, 16 Jun 2026 20:31:22 +0530
Message-ID: <20260616145056.390271726@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 9d8d28738f24b75616d6ca7a27cb4aed88520343 ]

The mptcp_recvmsg() can fill MPTCP socket receive queue via
mptcp_move_skbs(), but currently does not try to wakeup any listener,
because the same process is going to check the receive queue soon.

When multiple threads are reading from the same fd, the above can
cause stall. Add the missing wakeup.

Fixes: 6771bfd9ee24 ("mptcp: update mptcp ack sequence from work queue")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260602-net-mptcp-misc-fixes-7-1-rc7-v2-1-856831229976@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2242,7 +2242,11 @@ static bool __mptcp_move_skbs(struct mpt
 	}
 	if (ret)
 		mptcp_check_data_fin((struct sock *)msk);
-	return !skb_queue_empty(&msk->receive_queue);
+
+	ret = !skb_queue_empty(&msk->receive_queue);
+	if (ret && mptcp_epollin_ready(sk))
+		sk->sk_data_ready(sk);
+	return ret;
 }
 
 static unsigned int mptcp_inq_hint(const struct sock *sk)


