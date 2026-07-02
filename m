Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC9B318EDC;
	Thu,  2 Jul 2026 16:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010165; cv=none; b=ZKeQAagDaqxDOSgEmpJIXGhQK61DfgQV774Ws/TdIeY8qpKJyJKplFW/zYH23oS58nKEZ2mb4FZEyWWwinsEVoCNfEWMqY1+ZmHNm7MzPToZVODsQSTEcZtCKFK3/bv1SxRt2MTBWdtTanY04/SXT4f2KDQIq+e6iA4ZXwWFQ0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010165; c=relaxed/simple;
	bh=k9qYn0Q5Se1uxOQPdcypimRJtDCSgyaczSIYMzgCYPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ok1vqf6RnjsSM5MNjNjSDFcccuBQaALqX6wsib65EFDkkX3GTzCphTRYNw1QA/BmKK38/HdL2VT+sk/pHp1I7Vcy/RhZxbk9dFYUbziCNY+EpuT+5y1OjEg+iDtXt9fxncCG1uxCHJUGZ6+McoKW4qyoAa2lVbajq/6UkdcR//I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljv+NLzx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljv+NLzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0027C1F000E9;
	Thu,  2 Jul 2026 16:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010164;
	bh=qhBhIUjaiiVvEO2I5vIf1XS7bGtXJdQzP1j7otFGU3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljv+NLzxB5X5TmAXOwWzRT/5GSOq2E5gDxePtkchiDKHmJfWVZlCVsjB2qhoqkDfx
	 49F8HLm4UEOxhzSaBR568b5YgXoYgST4hq64DBTDVIW+AE62aAwVriYJCCLvJkOlhU
	 NSEU73rodxAfkehzuOZFYZj7grhzmR7QyvNsHbQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 113/129] mptcp: fix missing wakeups in edge scenarios
Date: Thu,  2 Jul 2026 18:20:32 +0200
Message-ID: <20260702155114.482609742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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
 net/mptcp/protocol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2197,8 +2197,10 @@ static bool __mptcp_move_skbs(struct mpt
 		__mptcp_splice_receive_queue(sk);
 		mptcp_data_unlock(sk);
 	}
-	if (ret)
+	if (ret) {
 		mptcp_check_data_fin((struct sock *)msk);
+		sk->sk_data_ready(sk);
+	}
 	return !skb_queue_empty(&msk->receive_queue);
 }
 


