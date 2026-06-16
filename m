Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1812169AD2;
	Tue, 16 Jun 2026 18:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634962; cv=none; b=nzzDKSLd+UaqTLlfZGaJtgNViAz0aPbT3bQfOnwfUjC6MXnniDtIQWbJnz8SmXw0z7SExaxC9rZiOlz+4HxnaKUfJlJQJ29n3O5Tl+7S/StCPL1yIgWcwK1Ziz7DBoQdoPOpiBgLdgLXL72cc30+vi2Uia+UaaEXBTFUp8LgFes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634962; c=relaxed/simple;
	bh=RyItyWwTmn0yC824k2Tn4xdxFtptuuw780PJdLdalwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwOCHfrsJUAXy/ur/gdVRfeh7wNwm+z/J/WrtS18F93Hq+PoGCpcVir8XraA8fQWs/8uzUlZeRRHUc2BT/BQhH2h/J9OPnqrF+iafJ8QtFmfXmoTH2MTq0t7PWH2t3DRUQtGhxH4Wu8SUKjOJ190WuVAA0rSPk8N7neExwecnSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TlGe88YS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TlGe88YS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2CB1F000E9;
	Tue, 16 Jun 2026 18:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634961;
	bh=MeHV7pkSQt35C22kt7/mpQpQAFGOm4ft5Klm1a/2OWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TlGe88YSUtqB6eHYuovoU89OatbCXXSHolZwzcTQFHrfjVbnyl0RJ6p4A20Upjg9u
	 LWa1ANJ5kNX+3DnNr5SI+yF3Hn9QI8aP5X3rTbRSIyOFkTtCYg+Fp626mCn6fujuKE
	 XOgYoAjCVtBeysvBKMSNsLlT8WUgYuY0DBpgVie8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 331/411] mptcp: pm: ADD_ADDR rtx: fix potential data-race
Date: Tue, 16 Jun 2026 20:29:29 +0530
Message-ID: <20260616145118.740448073@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit 5cd6e0ad79d2615264f63929f8b457ad97ae550d ]

This mptcp_pm_add_timer() helper is executed as a timer callback in
softirq context. To avoid any data races, the socket lock needs to be
held with bh_lock_sock().

If the socket is in use, retry again soon after, similar to what is done
with the keepalive timer.

Fixes: 00cfd77b9063 ("mptcp: retransmit ADD_ADDR when timeout")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260505-net-mptcp-pm-fixes-7-1-rc3-v1-3-fca8091060a4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ applied hunk to `net/mptcp/pm_netlink.c` instead of `net/mptcp/pm.c` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -330,6 +330,13 @@ static void mptcp_pm_add_timer(struct ti
 	if (!entry->addr.id)
 		return;
 
+	bh_lock_sock(sk);
+	if (sock_owned_by_user(sk)) {
+		/* Try again later. */
+		sk_reset_timer(sk, timer, jiffies + HZ / 20);
+		goto out;
+	}
+
 	if (mptcp_pm_should_add_signal_addr(msk)) {
 		sk_reset_timer(sk, timer, jiffies + TCP_RTO_MAX / 8);
 		goto out;
@@ -358,6 +365,7 @@ static void mptcp_pm_add_timer(struct ti
 		mptcp_pm_subflow_established(msk);
 
 out:
+	bh_unlock_sock(sk);
 	__sock_put(sk);
 }
 


