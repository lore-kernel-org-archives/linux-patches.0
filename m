Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FF83EDE59;
	Tue, 12 May 2026 18:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608902; cv=none; b=JU6hiWGtlcNGrYhA2N2U4mScx5f5jOJxG6fC0SDXWDLXREowPl8k08uXGQT/TRHwvF112VsPHrETuFHI2Uxs1l6oWymh9V22FvGdtqqYaxlXgDs9gT26muSf8QMLFKMatc9hVUrg79F+9j3P/7IXYHhgc5r+srBJF5bErEy9zi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608902; c=relaxed/simple;
	bh=Qsb9QsHapcmVTHEh+NweUdLgcEaMNGop8vC0YV9LdSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u28IRbXJ8ts9POt4n3XrwdIa+DPONuUYoTvcDhEFrwz6QyVGbrLC14eHWmgSzQr5Ul1QzkQZRM5geZEgp6kQfB9HgXx+/QGDk8sPuSfB3fhspRK3O5UYVkHaMwR98NsGVecU1ycw/jT/rAYVXGFKQCJnnKdb/MUxcXQXi431LSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXhG4jdF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXhG4jdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30E0C2BCB0;
	Tue, 12 May 2026 18:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608902;
	bh=Qsb9QsHapcmVTHEh+NweUdLgcEaMNGop8vC0YV9LdSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXhG4jdFIkGSDw+RVYKenBQ14bJRzy6KUhbS5neL7D6F0PSpppr7wF8qD6a77vP2V
	 ihSh2Im1ZS/NnsB4DZ9Qd4t1nHTn3RgAYCIPxSa0FefL2kVG23E5BxOhjScsl3bcJi
	 7IXCrVZ1ayRalLuQ9vUEHuwH/26U8TZcJIgkrHgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 218/270] mptcp: pm: ADD_ADDR rtx: fix potential data-race
Date: Tue, 12 May 2026 19:40:19 +0200
Message-ID: <20260512173943.035752349@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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
 


