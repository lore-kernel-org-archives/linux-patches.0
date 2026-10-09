Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2E14E8DEF;
	Fri,  9 Oct 2026 14:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557056; cv=none; b=cUt5sSkSl0tmNiTrEfilZbicU4C0RyqP5uovmTfFHbV3k48XPaOzIO49lsixBrg9WL6kcYsQmSNtjTi3QYxGiO2xVlJVJB+E552RkjSvH2i4nG37730NeWUIdoUVoz4B8/Eb2x1LKhpzjs5wg1Hd85jAHFAe3+1FKCkpzJYLwZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557056; c=relaxed/simple;
	bh=4vfiFxGx6QfzndwYBR67JO3PgNqtutgAwq07XtQbhGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sE+PAWjK1J2JYFX9ohs+k5kc3lq7hjcpZgj3Cejue2KuzUMLGT1NfmfFTZZsIa/G481e3BaYl9bxK4Ba4lWxlF0rDDOu2L5W2XUHOKeD89KLbOoor/V7Ha97qjZE3TsJ3BjGZ/xxlc0pqscyd+BiAzrOyyeZ+aJ018+SWbnvLYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQqKzPjC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQqKzPjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4813C1F000FF;
	Fri,  9 Oct 2026 14:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557055;
	bh=L+vMtQ97lXzyDEq+MLuRzbJk3Xq8MxIfxMYzKcUZfN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQqKzPjCxqoxglrOCO5DPUd+atMT7HX1EPsaSVa14BktaQNI6OKtUmq7Sm7XBKy6f
	 eWyliTCQmL4PFtPik6ENXMc/0/4hPzOPIdPetEzN4FXYfhExqlsPYmNl9J9I1F8v5c
	 xUROynWqXH1QFX8L5h6wG2wXmkGWU5ycMa3lSp6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 339/403] mptcp: fix msk->timer_ival reset
Date: Fri,  9 Oct 2026 16:11:40 +0200
Message-ID: <20261009141000.184486469@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

In this kernel version, icsk->icsk_rto_min is not initialised, because
this version doesn't contain commit ea4eb2adb0d3 ("mptcp: honour
configured min/max RTO in retransmit paths").

Reset it to TCP_RTO_MIN, which is how msk->timer_ival is also reset in
__mptcp_init_sock() in this version.

Fixes: 374da2b9be12 ("mptcp: prevent race between disconnect() and rtx")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 7a1696ac92dc8..e14a49180eefe 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3312,7 +3312,7 @@ static int mptcp_disconnect(struct sock *sk, int flags)
 	/* The later subflow close can not kick again the tout timer,
 	 * as the msk is already in closed status.
 	 */
-	msk->timer_ival = icsk->icsk_rto_min;
+	msk->timer_ival = TCP_RTO_MIN;
 	sk_stop_timer_sync(sk, &sk->mptcp_retransmit_timer);
 	icsk->icsk_mtup.probe_timestamp = 0;
 	sk_stop_timer_sync(sk, &icsk->mptcp_tout_timer);
-- 
2.53.0



