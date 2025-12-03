Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42828307AD9;
	Wed,  3 Dec 2025 15:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776668; cv=none; b=HjUQi0WRuD+HrLhz8ZgTvjDxRHzDi3wXWLsGLQwhziHwWFtUbKI3t8bBygiziBACmhFw/D9GYnbAO1/nxBmOvPLQKWQUkNNS84o/Fsj8uS6nm03DgyDgEeRl5CN3s8HEDnqbR9Z0iG7hFXhwXzsAvtyG3rRZi7wq3M8cTxR9y0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776668; c=relaxed/simple;
	bh=g2SSj6ebSggiQV5jcl+gR6k8H3hhz4DqEmr5G49ojX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRy5nXJw2os8Shgk3Wu8by4B97N0tev2s4p94CGq1Ejx/X3VnIxhl4K3qt33uvls7BJgGxDO9h9qBS2e1G0p3cZGPyYGaDugwOe3NxU4MpujeHQZ78/NchVEuo0kSJyuNa4i/oj3qk86y4HQKmL77tvSyE2bGEYWMWTFgd/oO0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pH/MLKTB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pH/MLKTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481A5C4CEF5;
	Wed,  3 Dec 2025 15:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776667;
	bh=g2SSj6ebSggiQV5jcl+gR6k8H3hhz4DqEmr5G49ojX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pH/MLKTBqbqsZ/zut3/VF32uwBqxfjhzzkxziKo3P0f6pGaiqmg9uZkQJteEnJgyJ
	 rHOKyul/Y8ukkmxYEWQh/EFzieZtpgFLA8qDIZ1H6Eg/7JvD/NBhMQiGcyXvmY3o2y
	 sTgiNiksBDy9oFX0W/wE/gluU3pbWy2P9NZLZIxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 252/300] mptcp: do not fallback when OoO is present
Date: Wed,  3 Dec 2025 16:27:36 +0100
Message-ID: <20251203152409.972318212@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 1bba3f219c5e8c29e63afa3c1fc24f875ebec119 ]

In case of DSS corruption, the MPTCP protocol tries to avoid the subflow
reset if fallback is possible. Such corruptions happen in the receive
path; to ensure fallback is possible the stack additionally needs to
check for OoO data, otherwise the fallback will break the data stream.

Fixes: e32d262c89e2 ("mptcp: handle consistently DSS corruption")
Cc: stable@vger.kernel.org
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/598
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251118-net-mptcp-misc-fixes-6-18-rc6-v1-4-806d3781c95f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ patch mptcp_dss_corruption() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -477,6 +477,15 @@ static void mptcp_check_data_fin(struct
 static void mptcp_dss_corruption(struct mptcp_sock *msk, struct sock *ssk)
 {
 	if (READ_ONCE(msk->allow_infinite_fallback)) {
+		/* The caller possibly is not holding the msk socket lock, but
+		 * in the fallback case only the current subflow is touching
+		 * the OoO queue.
+		 */
+		if (!RB_EMPTY_ROOT(&msk->out_of_order_queue)) {
+			MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_DSSCORRUPTIONRESET);
+			mptcp_subflow_reset(ssk);
+			return;
+		}
 		MPTCP_INC_STATS(sock_net(ssk),
 				MPTCP_MIB_DSSCORRUPTIONFALLBACK);
 		mptcp_do_fallback(ssk);


