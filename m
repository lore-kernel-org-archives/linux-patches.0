Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9941F55E4;
	Tue, 21 Jan 2025 18:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483066; cv=none; b=QSotqXd+XXh8fSqxp/XBlmOxcwMkh0AInDyNZoNwZCn0JhNOUN7q0iDHKj/wnA71FIre4D+MX9iYaamenCkkKRsNLEz/x9TbJgyfbro7L1/OKrA2eYQgYXPckSl9wS6t/LjLJwMGbO37EOkSzTkNfCQcPIasFHgqH1mQoDS5iv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483066; c=relaxed/simple;
	bh=s+DCodL/M1YGpLXWQNtcMKQ61/RHZ9GgkowSvOsw01E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVQGE6Fa2j8sbZKPVrP6+N5zj+4JnPaHjrvmS2EOJSq9oVyWMBVBfYvX8Dz96Pog6FxMM32czvZ3eA+3iVbjW23JZ4EzXonuImIjYFN/b76swtrTImBhKPhg3tdem/1RPlLuj8HgoJ/awozdastJxPkwd/4bGHwcG95RRtZ/wuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mKwOZQvx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mKwOZQvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B89CC4CEDF;
	Tue, 21 Jan 2025 18:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483066;
	bh=s+DCodL/M1YGpLXWQNtcMKQ61/RHZ9GgkowSvOsw01E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKwOZQvxGEOIjF5Qx+K72o8ED+QXMM09iXJg7N3w2M1hlnbsuo+i41fWJH1OB1jXf
	 Pr4pH4dgnajxUNic7MmuWIcaSZhhvdtDoIBVEkze4BxmxwyQRBg4mQa4b7OBZ9jtvY
	 CzauVoJIYcYmVJDJa64f/T+gg6x8NjADM5VsE4KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang.tang@suse.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/127] mptcp: drop port parameter of mptcp_pm_add_addr_signal
Date: Tue, 21 Jan 2025 18:52:27 +0100
Message-ID: <20250121174532.553967515@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <geliang.tang@suse.com>

[ Upstream commit af7939f390de17bde4a10a3bf0e337627fb42591 ]

Drop the port parameter of mptcp_pm_add_addr_signal() and reflect it to
avoid passing too many parameters.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: cbb26f7d8451 ("mptcp: fix TCP options overflow.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c  | 5 ++---
 net/mptcp/pm.c       | 7 ++++---
 net/mptcp/protocol.h | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index e654701685a8..31bec175886c 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -651,7 +651,6 @@ static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *
 	bool drop_other_suboptions = false;
 	unsigned int opt_size = *size;
 	bool echo;
-	bool port;
 	int len;
 
 	/* add addr will strip the existing options, be sure to avoid breaking
@@ -660,12 +659,12 @@ static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *
 	if (!mptcp_pm_should_add_signal(msk) ||
 	    (opts->suboptions & (OPTION_MPTCP_MPJ_ACK | OPTION_MPTCP_MPC_ACK)) ||
 	    !mptcp_pm_add_addr_signal(msk, skb, opt_size, remaining, &opts->addr,
-		    &echo, &port, &drop_other_suboptions))
+		    &echo, &drop_other_suboptions))
 		return false;
 
 	if (drop_other_suboptions)
 		remaining += opt_size;
-	len = mptcp_add_addr_len(opts->addr.family, echo, port);
+	len = mptcp_add_addr_len(opts->addr.family, echo, !!opts->addr.port);
 	if (remaining < len)
 		return false;
 
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index b14eb6bccd36..4fa31301fe84 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -265,11 +265,12 @@ void mptcp_pm_mp_fail_received(struct sock *sk, u64 fail_seq)
 bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, const struct sk_buff *skb,
 			      unsigned int opt_size, unsigned int remaining,
 			      struct mptcp_addr_info *addr, bool *echo,
-			      bool *port, bool *drop_other_suboptions)
+			      bool *drop_other_suboptions)
 {
 	int ret = false;
 	u8 add_addr;
 	u8 family;
+	bool port;
 
 	spin_lock_bh(&msk->pm.lock);
 
@@ -287,10 +288,10 @@ bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, const struct sk_buff *skb,
 	}
 
 	*echo = mptcp_pm_should_add_signal_echo(msk);
-	*port = !!(*echo ? msk->pm.remote.port : msk->pm.local.port);
+	port = !!(*echo ? msk->pm.remote.port : msk->pm.local.port);
 
 	family = *echo ? msk->pm.remote.family : msk->pm.local.family;
-	if (remaining < mptcp_add_addr_len(family, *echo, *port))
+	if (remaining < mptcp_add_addr_len(family, *echo, port))
 		goto out_unlock;
 
 	if (*echo) {
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 8f5e5a66babf..6026f0bcdea6 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -823,7 +823,7 @@ static inline int mptcp_rm_addr_len(const struct mptcp_rm_list *rm_list)
 bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, const struct sk_buff *skb,
 			      unsigned int opt_size, unsigned int remaining,
 			      struct mptcp_addr_info *addr, bool *echo,
-			      bool *port, bool *drop_other_suboptions);
+			      bool *drop_other_suboptions);
 bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 			     struct mptcp_rm_list *rm_list);
 int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
-- 
2.39.5



