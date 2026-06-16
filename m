Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DEF43E4A1;
	Tue, 16 Jun 2026 15:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624052; cv=none; b=VJ7exsf2U1gXvD8wvkGwCuucv+VvFuupeHt908bFUdZiLoUVHe1MmaEAfCN1rBPfKTQR41ZIzdo/O8NXMeQmHbgUXVGjxiJ7vBwqqMSjJjkANDGr6HhF92uR4uHDmT8l0cMO+iydlhMLXySRD09QIlYzQXSkA7Rr3WhfXqVnedA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624052; c=relaxed/simple;
	bh=5PYkhAdpBr1DdfVvsfCB3CUcVR+kQMTNforUfPyey6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cq7Q0tNOJEKEKURJNkZZ5cSM/wjCsAOboQQZBYsbwLpmiE1skKEhEB0yVeOrAW5rUtYytZ3CRY4UnDBwPO2E9zWtyStk4BVzs7w33bBI1R1tNpELi3IfVADtZLAs2jRhR/NTLCl1KLILu6B/5xTLvbCAWr4rNaYjI8Sme+MLAkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+WgbXKi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+WgbXKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112011F00A3A;
	Tue, 16 Jun 2026 15:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624051;
	bh=CwmdDriVwNhOX98OBKsE7dak5OO3giV50RYvf+q8XJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P+WgbXKixhyDue0zdmr7rZGjVk/Se6+1mFKAC0gNo6l7U87C/clLVKVT6+uxs/zAm
	 uIvBGhtJ2L2N7jLCzzrVnpx5gVQ6EuB6plJL/4k9xulxiCPd0OrHRrLIwc/NWxeoIb
	 9cJAUrLWnFOXUMRj/JcvHTUaFkXW7FLLQRjUd2ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 230/378] mptcp: fix missing wakeups in edge scenarios
Date: Tue, 16 Jun 2026 20:27:41 +0530
Message-ID: <20260616145122.372455143@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 9d8d28738f24b75616d6ca7a27cb4aed88520343 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2256,6 +2256,10 @@ static bool mptcp_move_skbs(struct sock
 		mptcp_backlog_spooled(sk, moved, &skbs);
 	}
 	mptcp_data_unlock(sk);
+
+	if (enqueued && mptcp_epollin_ready(sk))
+		sk->sk_data_ready(sk);
+
 	return enqueued;
 }
 


