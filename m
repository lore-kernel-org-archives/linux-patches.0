Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39DE51D53E;
	Wed, 30 Sep 2026 17:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790265; cv=none; b=RHonlnBpgFCa5jTXrbpPiiOWkvbTnXLsvYmxU9VmsRCpUepOCZ/mC0eboZ1MtYPDavsLyN9o3bVQeXXkIIwJF1oKGtO/Qy3bN+5GgHuu/zQbWqnGBPUURgYs4X7Lz4A+RxJo6gakEa9+zsFIKI+pD9bPN4bo5cIY/7opnFnou4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790265; c=relaxed/simple;
	bh=hkaqip/1VrRvmhUHbZ97qPRDLaWg6wWS4fog3ceozuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jq4qOCSoz2t50NX00sXMVZKc8KCqP6BYxM2eHNysUJstgyURZVHPWvy9uqtEowswFyOdk0j/2rWgFIDC0tbuJgP8JavHJhIc/6dkEHGOdscwQHkKEUSPK4r6zKhNUWrStu1+jvOsalm6XbWIGbJMdVFX9gjaI3zCMPzgFxwlqDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o6a/c3pN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o6a/c3pN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7B31F000FF;
	Wed, 30 Sep 2026 17:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790264;
	bh=4KZsmXrLUwD0NTRcIrBUKahdiJttPzB72L1bSU2Hwb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o6a/c3pNiuZv1U1Fh7q+sAeAeSwtWPzsPtwHbwQcrax0ZSDbF1LA0R5cDI05MLw7z
	 mkGj4reCO0vuygGA9FVFhd+vo1L7ib+f46RymXjVrQAPoyKx0bwQPejJXYbsMgfIn8
	 H/JYNvcgKjOygzXhL60meVWjiYTfPBBMophyB9vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 767/877] mptcp: pm: reset retrans_time when ADD_ADDR entry is reused
Date: Wed, 30 Sep 2026 17:27:58 +0200
Message-ID: <20260930152431.256866123@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit f968190c0b42ea2004dc1426359a53ec365a7a37 ]

When an ADD_ADDR entry is reused, the timer is re-armed, because the
goal is to re-announce an ADD_ADDR, and eventually retransmit it if
needed.

In this case, the retransmission counter should be reset as well, so the
re-announced address gets its retransmissions back instead of relying on
what was left before, and possibly not being able to retransmit it.

Fixes: 304ab97f4c7c ("mptcp: allow ADD_ADDR reissuance by userspace PMs")
Cc: stable@vger.kernel.org
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260803-net-mptcp-misc-fixes-7-2-rc6-v2-0-b8f496d71664%40kernel.org?part=4
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260908-net-mptcp-misc-fixes-7-3-rc1-v2-9-df1de70348b6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ adapted mptcp_pm_announced_alloc() in pm.c to mptcp_pm_alloc_anno_list() in pm_netlink.c. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -417,10 +417,10 @@ bool mptcp_pm_alloc_anno_list(struct mpt
 
 	add_entry->addr = *addr;
 	add_entry->sock = msk;
-	add_entry->retrans_times = 0;
 
 	timer_setup(&add_entry->add_timer, mptcp_pm_add_timer, 0);
 reset_timer:
+	add_entry->retrans_times = 0;
 	add_entry->timer_done = false;
 	timeout = mptcp_get_add_addr_timeout(net);
 	if (timeout)


