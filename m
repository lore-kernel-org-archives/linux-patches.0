Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E1F347C3;
	Tue, 26 Aug 2025 13:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213646; cv=none; b=dAqHNpYkXw2WQfsT2nCDbuUKz4tPH+3LhBCjgjXeV12nNsh3M0wpVO5gSV40v6F0IlzxjY3mvZT9emPucd+OJPfOMDFTn2uMMuVnNmuBX59aH8T4IuYsFoG9UhN+W6t+r8cDEpzIPZJ/S3jDn0/mS0h+nvOt4aS4rcFPgbHbGGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213646; c=relaxed/simple;
	bh=zw0wJvMdiQCG9Rq4/ZzsabCydIOxY0BLLhGDrl5xa7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OvyvydXhyzbUX7TYeQ3PeOn0EaU5EwYw+u3vI3lkgm+1M9rVIraPNNXOuuFuaU0m9ZpF51IUrOiQVtNWyDFhU+mgt11WvvK0VB8lKqKGUQNPolkZ6ke1ERxmKy69Y8LnrSWy577bkA2ojB00oYSJv9a9+pe+6vEy/nuAnDJmny4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u214P/1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u214P/1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A14C4CEF1;
	Tue, 26 Aug 2025 13:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213646;
	bh=zw0wJvMdiQCG9Rq4/ZzsabCydIOxY0BLLhGDrl5xa7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u214P/1KOzyiINNVSR0J74q/fcJlpDqRN9iSvWEbbQHwGeAAn07yQGCccWMbnSebB
	 lItNQnOLx9SDkMMP6tGcBdMuaOEd/kwsmFd5Fy42uR6qsdwO4Wqn71TElqE2HbXd28
	 sDR0hfBHs8q4FBPTsc5rDQPAiO9Vo0UOXbAeIkdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Dreibholz <dreibh@simula.no>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 427/587] mptcp: pm: kernel: flush: do not reset ADD_ADDR limit
Date: Tue, 26 Aug 2025 13:09:36 +0200
Message-ID: <20250826111003.803583636@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 68fc0f4b0d25692940cdc85c68e366cae63e1757 upstream.

A flush of the MPTCP endpoints should not affect the MPTCP limits. In
other words, 'ip mptcp endpoint flush' should not change 'ip mptcp
limits'.

But it was the case: the MPTCP_PM_ATTR_RCV_ADD_ADDRS (add_addr_accepted)
limit was reset by accident. Removing the reset of this counter during a
flush fixes this issue.

Fixes: 01cacb00b35c ("mptcp: add netlink-based PM")
Cc: stable@vger.kernel.org
Reported-by: Thomas Dreibholz <dreibh@simula.no>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/579
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250815-net-mptcp-misc-fixes-6-17-rc2-v1-2-521fe9957892@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1783,7 +1783,6 @@ static void __flush_addrs(struct list_he
 static void __reset_counters(struct pm_nl_pernet *pernet)
 {
 	WRITE_ONCE(pernet->add_addr_signal_max, 0);
-	WRITE_ONCE(pernet->add_addr_accept_max, 0);
 	WRITE_ONCE(pernet->local_addr_max, 0);
 	pernet->addrs = 0;
 }


