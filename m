Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82FB365A19;
	Tue, 12 May 2026 18:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609607; cv=none; b=o2ZZNTN3X5jI+8HRFxbmR17FtufbrYCR9CxuEQfP/UFQyolt0dV51sQYnDZC7ozJ3bFvo2SEjuwUaWJsReuyXVuuWnR6Nafs5i4ugxCu0BwWL9LlszqUOWVD5D19Lc3V5+NfFU0kKsoaO/opzEGk84WmOjZDAObTdJ4fkW6hu7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609607; c=relaxed/simple;
	bh=xDEUCaggSTTlpkLlc9fWSxt/w8JexSirfZm8XXjVAR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpXIJkABv0uWIAZprvEMqBxSMuRhztv6KNfZeJ0b19wFkEWSX07BM7IhjKIJ72AzTwsmLkqq/BwfhMA6x4R4trrws6DulqmIQ3Dd/sK9jfC4QB7IzRf/dHltI+kWWatZpNQ5MoVKAvvMbY0AqkxnDYFY5wYG1ZOFGuIlXJkgPGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TdaHrykQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TdaHrykQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7A9C2BCB0;
	Tue, 12 May 2026 18:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609607;
	bh=xDEUCaggSTTlpkLlc9fWSxt/w8JexSirfZm8XXjVAR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TdaHrykQzvwrxP0v7sJ3u5Fvln3LUCuzal+4xBP/1nl/q66Oa6OPzm9Zo1freU2+N
	 hDcpqBwPAxcWdbcHamUeEd9rRMCLQKGIcVKSqAK6rksZEshMi4Ji1bxGV+ZNYi2ZxQ
	 IiW4QLRB1tptrHH4xrVqXCFTweALuyTGk8AKoFnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 262/307] mptcp: pm: ADD_ADDR rtx: fix potential data-race
Date: Tue, 12 May 2026 19:40:57 +0200
Message-ID: <20260512173945.657035187@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 5cd6e0ad79d2615264f63929f8b457ad97ae550d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -350,6 +350,13 @@ static void mptcp_pm_add_timer(struct ti
 	if (inet_sk_state_load(sk) == TCP_CLOSE)
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
@@ -378,6 +385,7 @@ static void mptcp_pm_add_timer(struct ti
 		mptcp_pm_subflow_established(msk);
 
 out:
+	bh_unlock_sock(sk);
 	__sock_put(sk);
 }
 


