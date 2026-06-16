Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05991A6803;
	Tue, 16 Jun 2026 17:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630340; cv=none; b=l16vx8L//Zpm+jl8usHjm5+/uCcWfFvKzK/TKNbrk3F+iueqBHIZFeCk8Toz3eKu5h/AXMg4sHnm+nvgNIXSlGp/y+kvgx48sWPI+xjvFZgHnGwHxWL4fp6A6JDdkjIWK9NSBDTmGd39mJVHW0T13iUMpSUKQFdAZDBLHhfIAlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630340; c=relaxed/simple;
	bh=H/vFCcePDB8yosbWgVimqAd+EfSu0EBwprM0Pze0mjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dk4ROtTPzmgE09NDiIfCFsil/PTA9URHYqF+c7U9A6KfGr4U9cMA2TryuhHmALCCIWGS5N93NWk82e5SZP6cvTjobLC/gSDwZudIPSRSYGiiuJ4uhrUN07tsvLQgNiRXS+8HJsxtj36yG1mNn9FbSx+7j7e+fpuvpELi+3rYTvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFk1ic4E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFk1ic4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994081F000E9;
	Tue, 16 Jun 2026 17:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630339;
	bh=7V2soz66x4Y6Iq+UMLVRVeh7vG6affnAjzJSBbiDPvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jFk1ic4EPUAU7rtZl8OGZCcy2aFLF/5L4GmKxdO8Q5HhzaZOxp0EWfEtgTzgttcas
	 Ehxdal/UwVE2hnsSkGRsviV0kIYfXtit8dn0H5oApNeS3gjlFl9jjL0ZCt3yIVZ4g1
	 zVWVcgbiu0LZDA0HlG4f68psWfNwbR+JmPg6mX78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 448/452] mptcp: fix missing wakeups in edge scenarios
Date: Tue, 16 Jun 2026 20:31:15 +0530
Message-ID: <20260616145140.046013792@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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
@@ -2205,7 +2205,11 @@ static bool __mptcp_move_skbs(struct mpt
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


