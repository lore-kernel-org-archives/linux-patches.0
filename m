Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B84371048;
	Wed, 20 May 2026 18:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301724; cv=none; b=DPDZ1yd6NIy6lzgNyp+VZ9pltBouNFuA8BThpBbfFAJDnP9NK0hZHliiGZZ08cgtGrI8FDPdvNbodxF5FQsHZTFLEcMdRWI3pzMfEtwSczMdMQdjITrAe8dnPxuZZxS/sVr6PJakyV/YWOxPEx3MBR9RSgYPU8TvRL65X2QSf6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301724; c=relaxed/simple;
	bh=RsRNF40sFQGqiAeQDMWVLZ3eM6V/DMyUvtwg506z6mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODuApN/7UNGvn7IPX/Na8J+bDK/5GUwfd9dARR2/ijELiW1lIJR1URN6KNRvhmwHmoBJkC7ohSyaScpGrrBf1C9X/En/CXQhct3SDuRUBQUoFPiJfRDFJDgxRUrfdv+gHfbSIT+GPsNMpEIloCmP0fS0Nn0XAFk47RHU3D3jTcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlz9N8m0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlz9N8m0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9261F00893;
	Wed, 20 May 2026 18:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301723;
	bh=KrPw0AMmVDeWcJjIjkS+YMeyt5f+uBjRd+AvZm0OGb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlz9N8m0WX/ybiK1XSu4PD8fv5OC6ovTaT1Bxz52Whm/UzNdrr64KqAWAYIgrVK74
	 AHv7c7lq8hKHXxCv5bybCBCzXt+tQYQaKmaHXz3rrife5fNi8Tej1tOtt2dSNeGz3V
	 gtAxterwipgLZwYdaTTv3OGzV1w3uNz/9MJmJ8Qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 664/666] mptcp: pm: kernel: correctly retransmit ADD_ADDR ID 0
Date: Wed, 20 May 2026 18:24:35 +0200
Message-ID: <20260520162125.683614985@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit b12014d2d36eaed4e4bec5f1ac7e91110eeb100d ]

When adding the ADD_ADDR to the list, the address including the IP, port
and ID are copied. On the other hand, when the endpoint corresponds to
the one from the initial subflow, the ID is set to 0, as specified by
the MPTCP protocol.

The issue is that the ID was reset after having copied the ID in the
ADD_ADDR entry. So the retransmission was done, but using a different ID
than the initial one.

Fixes: 8b8ed1b429f8 ("mptcp: pm: reuse ID 0 after delete and re-add")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260505-net-mptcp-pm-fixes-7-1-rc3-v1-1-fca8091060a4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ applied to net/mptcp/pm_netlink.c instead of upstream's pm_kernel.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -590,6 +590,8 @@ static void mptcp_pm_create_subflow_or_s
 
 	/* check first for announce */
 	if (msk->pm.add_addr_signaled < add_addr_signal_max) {
+		u8 endp_id;
+
 		/* due to racing events on both ends we can reach here while
 		 * previous add address is still running: if we invoke now
 		 * mptcp_pm_announce_addr(), that will fail and the
@@ -603,19 +605,20 @@ static void mptcp_pm_create_subflow_or_s
 		if (!select_signal_address(pernet, msk, &local))
 			goto subflow;
 
+		/* Special case for ID0: set the correct ID */
+		endp_id = local.addr.id;
+		if (endp_id == msk->mpc_endpoint_id)
+			local.addr.id = 0;
+
 		/* If the alloc fails, we are on memory pressure, not worth
 		 * continuing, and trying to create subflows.
 		 */
 		if (!mptcp_pm_alloc_anno_list(msk, &local.addr))
 			return;
 
-		__clear_bit(local.addr.id, msk->pm.id_avail_bitmap);
+		__clear_bit(endp_id, msk->pm.id_avail_bitmap);
 		msk->pm.add_addr_signaled++;
 
-		/* Special case for ID0: set the correct ID */
-		if (local.addr.id == msk->mpc_endpoint_id)
-			local.addr.id = 0;
-
 		mptcp_pm_announce_addr(msk, &local.addr, false);
 		mptcp_pm_nl_addr_send_ack(msk);
 


