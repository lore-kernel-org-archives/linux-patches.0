Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A814F96D3;
	Thu, 17 Sep 2026 17:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667184; cv=none; b=mhib/4/5A+J5X100/zhfA3l3vBsaEMGe/gDkgPqyjlEvq04ggyfMjg325NfZe6T43mz+fe0IflqYM4kAcUjtqdHX00UUF/MeA5/JDMJ53UM+sEuSVYeTb1w6v3WoU2HtiV2zMC3jaI/gIk8QlXgXwTPU27rFo4K+xGvGPjMgnxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667184; c=relaxed/simple;
	bh=fGJL/h3y/GfgT65OXDsX9ctEDyAPYH4lCFE2GhRpnrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXazOioN+bHC1lvBMgeDuYQpYyo5+wNGZCGoGaItHssAvM8l5aZY6zKcALuCbZUgzVZlsRQXTTFu6/DKbrNddzRMMnvMehhGOla8ZgDNjkEh/d8VYjWbmw78Wig8z2RNu/a68VJTwGdgw41Vfiw2fZY0PYxLk9s7QmNoTI96fJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KGw1CrZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KGw1CrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA581F000FF;
	Thu, 17 Sep 2026 17:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667183;
	bh=xtI6ElhLXLxBH3fS6/4pV5QLwzBtcV+gP6O0/e6G+0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1KGw1CrZJwUN11iqMNODLvcB8NFz/573MjcfVE7pj8hTDMmBkm2UTFVop2K7/t4gD
	 lfXDyh4EVTGKn+NJgx1aE2CE5/E1vFKoG4EUlecP0di+WlGClO3k62a6QW3eQX7YP+
	 iVldclE+ABO8ByBNePWYNXsVHiVScUaCr4tHrlac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1233/1250] mptcp: pm: reset retrans_time when ADD_ADDR entry is reused
Date: Thu, 17 Sep 2026 16:17:08 +0100
Message-ID: <20260917151625.711146782@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -461,10 +461,10 @@ bool mptcp_pm_announced_alloc(struct mpt
 
 	add_entry->addr = *addr;
 	add_entry->sock = msk;
-	add_entry->retrans_times = 0;
 
 	timer_setup(&add_entry->add_timer, mptcp_pm_add_timer, 0);
 reset_timer:
+	add_entry->retrans_times = 0;
 	add_entry->timer_done = false;
 	timeout = mptcp_adjust_add_addr_timeout(msk);
 	if (timeout)


