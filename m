Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2331B3727;
	Wed, 20 Nov 2024 12:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107534; cv=none; b=kycYy/7jrT1gMwk+NP8QPsbu4dvAtXHtkdvVlKDx3dnOewtngA4w10S/na0XiCTFIMUfy44K+9J0yAYZ3dZWL/ROpBiAmcv41v8FPd62JEATdpT9x8n34E2Z9RxR5+fj8e/h68DK1gWNAods4sNvUWNC5tcih3FOLyMqkWOfy6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107534; c=relaxed/simple;
	bh=JMYFJoAg3PYo/rfx77r7L61cXa/sEHupTEfSnyOte+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P53DGJd3auio+yTwf7FRDi6GdTx2KETPs/fSZRhflM3PFfbpTuvTFtIgiI90PnvgJlUwRttqPRvXKyKtV2sfjEYTB00QNVilfjLBuuHIsQpQmDJCTqz2uAyjLCnGdi2elLSsJxZcdrMQrtcekmGls/ge3mz9EAIGgkcs0sfmdjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGydPsNL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGydPsNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAA4C4CED6;
	Wed, 20 Nov 2024 12:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107534;
	bh=JMYFJoAg3PYo/rfx77r7L61cXa/sEHupTEfSnyOte+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGydPsNLzFF5ZOtWqwsffjOfSYPYnG7OmwYfQY4xjfo4UgKXeeDFYSndAnBuSFedB
	 Lcz29HKxMR9gApcrAvrP2rsgCr+K3pllSoJjVgovSu+euxRLSz+ZswSZToE8cByBVP
	 tvfFbsjwd22XuUpn6AkaVpCsstzbSnna8P+FUMmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.11 067/107] mptcp: pm: use _rcu variant under rcu_read_lock
Date: Wed, 20 Nov 2024 13:56:42 +0100
Message-ID: <20241120125631.187833147@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit db3eab8110bc0520416101b6a5b52f44a43fb4cf upstream.

In mptcp_pm_create_subflow_or_signal_addr(), rcu_read_(un)lock() are
used as expected to iterate over the list of local addresses, but
list_for_each_entry() was used instead of list_for_each_entry_rcu() in
__lookup_addr(). It is important to use this variant which adds the
required READ_ONCE() (and diagnostic checks if enabled).

Because __lookup_addr() is also used in mptcp_pm_nl_set_flags() where it
is called under the pernet->lock and not rcu_read_lock(), an extra
condition is then passed to help the diagnostic checks making sure
either the associated spin lock or the RCU lock is held.

Fixes: 86e39e04482b ("mptcp: keep track of local endpoint still available for each msk")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20241112-net-mptcp-misc-6-12-pm-v1-3-b835580cefa8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -520,7 +520,8 @@ __lookup_addr(struct pm_nl_pernet *perne
 {
 	struct mptcp_pm_addr_entry *entry;
 
-	list_for_each_entry(entry, &pernet->local_addr_list, list) {
+	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list,
+				lockdep_is_held(&pernet->lock)) {
 		if (mptcp_addresses_equal(&entry->addr, info, entry->addr.port))
 			return entry;
 	}


