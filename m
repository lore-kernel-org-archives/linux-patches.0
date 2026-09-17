Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096E7583AD6;
	Thu, 17 Sep 2026 15:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660604; cv=none; b=Dmbv1j+FkfzKntWeT8ecl2nIVW/HciuTYxWLeNGHmjYmVfPegtSZJ5PfZCR18SrEX1HPcrkgtAKq9ExyiQDl+pSBqKB5nUreTsEMdJNBJ0nwJT84VmY22DuJSZiaabriTLR1iqmuxwZycf9KLwMXAJPmzILyi4sj35xkcJOXBQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660604; c=relaxed/simple;
	bh=sm4FTTh0i3EiAweGIWy0mXdFBSgMjJQHZjRo8I2N4pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNTWVXtE0fQxlvabkrLtKaJAqMWtT/GYgLJspyVV0X403K+sGtBhGBMq9HePLlRDxL6RUzW5WgY//b/Gkr14alj4Jp9S3w+o8g0sdoV8njkieDZHttWdSQbT6lW6UVgrQmztJ+A4Lbe2KcltAypyNe/FvtV1l0hFVNKhFFUUye0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uplJE5vr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uplJE5vr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3CC1F00893;
	Thu, 17 Sep 2026 15:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660602;
	bh=fui5Qn/4ahpA/E7oc7vhDfklioTY6mt0V3P3TTjeRj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uplJE5vri+DZMXT+ty6t63CTk7qgQGLcNYRbhpSBZ5vGQSumI+aZIHbCZEmZx4bh1
	 XHwkTZ6yBEebzc+xDaW2f9S+mAclD9P1euhb6SzT4ZHXhSf7MRA4KBcex5ZMRSd1ux
	 O9Nq2A/riKPoCJQmDTZ4K6k9Ni9rzsC7GELE4cgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 620/733] mptcp: prevent race between disconnect() and rtx
Date: Thu, 17 Sep 2026 16:15:28 +0100
Message-ID: <20260917151407.983321669@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 85c580b0d8590520ae00a15c29e9fb9c99427a3e upstream.

Sashiko noted that the two event can race, leading to inconsistent
status. Prevent the race using the synchronous timer stop operation.

Cc: stable@vger.kernel.org
Fixes: b29fcfb54cd7 ("mptcp: full disconnect implementation")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260908-net-mptcp-misc-fixes-7-3-rc1-v2-6-df1de70348b6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3456,6 +3456,7 @@ static void mptcp_destroy_common(struct
 
 static int mptcp_disconnect(struct sock *sk, int flags)
 {
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	/* We are on the fastopen error path. We can't call straight into the
@@ -3468,8 +3469,13 @@ static int mptcp_disconnect(struct sock
 	mptcp_check_listen_stop(sk);
 	mptcp_set_state(sk, TCP_CLOSE);
 
-	mptcp_stop_rtx_timer(sk);
-	mptcp_stop_tout_timer(sk);
+	/* The later subflow close can not kick again the tout timer,
+	 * as the msk is already in closed status.
+	 */
+	msk->timer_ival = icsk->icsk_rto_min;
+	sk_stop_timer_sync(sk, &sk->mptcp_retransmit_timer);
+	icsk->icsk_mtup.probe_timestamp = 0;
+	sk_stop_timer_sync(sk, &icsk->mptcp_tout_timer);
 
 	mptcp_pm_connection_closed(msk);
 


