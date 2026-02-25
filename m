Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940FF2D322F;
	Wed, 25 Feb 2026 06:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002564; cv=none; b=RHbbY9QQIh22TQH/oL6DI5GWbnA18euzqdCldXrCgcZrLMcKu3B5t8bcl5qp02m4rYxXRN37upFnYnQfOEjzTIwmuCqciERmsikD8b4gKDTaErD2imx2GV21ywGpyaVwyqImDHQOBlE7QgHP9I9nqQ3zIyrxYhMe12pc95e3NYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002564; c=relaxed/simple;
	bh=xekCzRQYIXcFm01+Ulwn5lHQeNigUXXqXCFdaKVFD/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0pkahZuLRXE9q4emD5DsSGPj3rQrzQlFpMOAmW47bjoc+c6Td+ftbXLe+g61zn0sd2GWmmyNgvkLrASLbep0cIcdeNZaCOXpPAX6TIWocxFH9W0Zb/nT5rKWAAbCgWZLrD4M9VPKrYGWdY/kFYSHTUsUeGR9nAZPQ6T24ekAfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVhEcd3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVhEcd3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7CBC19425;
	Wed, 25 Feb 2026 06:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002564;
	bh=xekCzRQYIXcFm01+Ulwn5lHQeNigUXXqXCFdaKVFD/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVhEcd3ss8ZYx0hXERf2zpSrBc2nXGlIEc+h2QNMRFD5gLKeVAtzKg+knksyAXOkY
	 ypPTQi5olbeltb7DVpzJxSUQ1i7oPMEXD3ZH+9VVYnAehOkoO41I7ZIQwdj7Bl5fht
	 Nx9n159JbWTOaSgdiCHddzf3bQX4sHbCp5PcJeqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 299/641] mptcp: fix receive space timestamp initialization
Date: Tue, 24 Feb 2026 17:20:25 -0800
Message-ID: <20260225012355.989080453@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 70274765fef555af92a1532d5bd5450c691fca9d ]

MPTCP initialize the receive buffer stamp in mptcp_rcv_space_init(),
using the provided subflow stamp. Such helper is invoked in several
places; for passive sockets, space init happened at clone time.

In such scenario, MPTCP ends-up accesses the subflow stamp before
its initialization, leading to quite randomic timing for the first
receive buffer auto-tune event, as the timestamp for newly created
subflow is not refreshed there.

Fix the issue moving the stamp initialization out of the mentioned helper,
at the data transfer start, and always using a fresh timestamp.

Fixes: 013e3179dbd2 ("mptcp: fix rcv space initialization")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260203-net-next-mptcp-misc-feat-6-20-v1-2-31ec8bfc56d1@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 8 ++++----
 net/mptcp/protocol.h | 5 +++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 15a70af7b776d..8f18509204b67 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2056,8 +2056,8 @@ static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied)
 
 	msk->rcvq_space.copied += copied;
 
-	mstamp = div_u64(tcp_clock_ns(), NSEC_PER_USEC);
-	time = tcp_stamp_us_delta(mstamp, msk->rcvq_space.time);
+	mstamp = mptcp_stamp();
+	time = tcp_stamp_us_delta(mstamp, READ_ONCE(msk->rcvq_space.time));
 
 	rtt_us = msk->rcvq_space.rtt_us;
 	if (rtt_us && time < (rtt_us >> 3))
@@ -3421,6 +3421,7 @@ struct sock *mptcp_sk_clone_init(const struct sock *sk,
 	__mptcp_propagate_sndbuf(nsk, ssk);
 
 	mptcp_rcv_space_init(msk, ssk);
+	msk->rcvq_space.time = mptcp_stamp();
 
 	if (mp_opt->suboptions & OPTION_MPTCP_MPC_ACK)
 		__mptcp_subflow_fully_established(msk, subflow, mp_opt);
@@ -3438,8 +3439,6 @@ void mptcp_rcv_space_init(struct mptcp_sock *msk, const struct sock *ssk)
 	msk->rcvq_space.copied = 0;
 	msk->rcvq_space.rtt_us = 0;
 
-	msk->rcvq_space.time = tp->tcp_mstamp;
-
 	/* initial rcv_space offering made to peer */
 	msk->rcvq_space.space = min_t(u32, tp->rcv_wnd,
 				      TCP_INIT_CWND * tp->advmss);
@@ -3652,6 +3651,7 @@ void mptcp_finish_connect(struct sock *ssk)
 	 * accessing the field below
 	 */
 	WRITE_ONCE(msk->local_key, subflow->local_key);
+	WRITE_ONCE(msk->rcvq_space.time, mptcp_stamp());
 
 	mptcp_pm_new_connection(msk, ssk, 0);
 }
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 30d5e57197936..27b1698c5aa2d 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -870,6 +870,11 @@ static inline bool mptcp_is_fully_established(struct sock *sk)
 	       READ_ONCE(mptcp_sk(sk)->fully_established);
 }
 
+static inline u64 mptcp_stamp(void)
+{
+	return div_u64(tcp_clock_ns(), NSEC_PER_USEC);
+}
+
 void mptcp_rcv_space_init(struct mptcp_sock *msk, const struct sock *ssk);
 void mptcp_data_ready(struct sock *sk, struct sock *ssk);
 bool mptcp_finish_join(struct sock *sk);
-- 
2.51.0



