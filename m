Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3942C387562;
	Tue, 10 Mar 2026 11:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142064; cv=none; b=n5B3T0rX+ToSCoyQ36iM50nt5EVtFqyh6Ua01XBasod0DcPtH5aoka2rkNS5pXyj7ik9Hbx4NCfAvA4HO8zHsx9W9oGgYgvTXgkT9eObggIijiEYXNas0D5xdGZr1iushCldtCdv4OMGc/0uloZGSiAEsh2BoEsmmXi5WhzEsAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142064; c=relaxed/simple;
	bh=N/FDqJ801n+zSoAJ5T+ERA12dP8w6LYkj3S7yJjUTDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTCWM5DTeyskaAZaTt4Cfk0gXvBu7q6yJEkkCIvaqITZA2PTKPbsOiLA/o3vNzsuhxyoUp0dvq0LWhtaNuqR74X/6sMM1uKpannr+2tYRYrGPohZxFWPyL2RZ+6b8o4zQWbQYxKBiVelD/ATESCt+ENSIrrKQC8+LggHD+ocJ00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tdkFG9PU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tdkFG9PU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C54DC19423;
	Tue, 10 Mar 2026 11:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142063;
	bh=N/FDqJ801n+zSoAJ5T+ERA12dP8w6LYkj3S7yJjUTDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdkFG9PUwz2s8m3pMMTjFgDMyRgyP/Den29NtNuCnqUNK6t0dJLL2ReaZ4pty7H2x
	 yVrPvQT3zZDKbQZ+RFtDhdVU78goNcephd8gI7yRjD7EsNCbGyfRAA7buU/cgI2O7P
	 7ueRrSqEVMWX/p7wOQlShKhkA/rJXZeuteWnelqu/hTh7SD1RR8s6fDroaO1osyv/t
	 U3pEpNrwv0emV2/jVygf/v4RpzGhWt0HGy53wyU1hOAvRgiFHqmrcD0TnbW3/ZVB+D
	 ntbldEcg14u89GJ0KiITKCVUZ+Mtsk0+CVDjMiEPnjXEIObelc2iaJlwSRtd7uaA+G
	 0L3qcFllhn2Ug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Frank Lorenz <lorenz-frank@web.de>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 189/314] mptcp: pm: avoid sending RM_ADDR over same subflow
Date: Tue, 10 Mar 2026 07:17:28 -0400
Message-ID: <876bffd066c1dbe937c225c804eccd7d1f03620e.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit fb8d0bccb221080630efcd9660c9f9349e53cc9e upstream.

RM_ADDR are sent over an active subflow, the first one in the subflows
list. There is then a high chance the initial subflow is picked. With
the in-kernel PM, when an endpoint is removed, a RM_ADDR is sent, then
linked subflows are closed. This is done for each active MPTCP
connection.

MPTCP endpoints are likely removed because the attached network is no
longer available or usable. In this case, it is better to avoid sending
this RM_ADDR over the subflow that is going to be removed, but prefer
sending it over another active and non stale subflow, if any.

This modification avoids situations where the other end is not notified
when a subflow is no longer usable: typically when the endpoint linked
to the initial subflow is removed, especially on the server side.

Fixes: 8dd5efb1f91b ("mptcp: send ack for rm_addr")
Cc: stable@vger.kernel.org
Reported-by: Frank Lorenz <lorenz-frank@web.de>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/612
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260303-net-mptcp-misc-fixes-7-0-rc2-v1-2-4b5462b6f016@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c | 55 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 43 insertions(+), 12 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 9604b91902b8b..e22d53af0ffa0 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -212,9 +212,24 @@ void mptcp_pm_send_ack(struct mptcp_sock *msk,
 	spin_lock_bh(&msk->pm.lock);
 }
 
-void mptcp_pm_addr_send_ack(struct mptcp_sock *msk)
+static bool subflow_in_rm_list(const struct mptcp_subflow_context *subflow,
+			       const struct mptcp_rm_list *rm_list)
+{
+	u8 i, id = subflow_get_local_id(subflow);
+
+	for (i = 0; i < rm_list->nr; i++) {
+		if (rm_list->ids[i] == id)
+			return true;
+	}
+
+	return false;
+}
+
+static void
+mptcp_pm_addr_send_ack_avoid_list(struct mptcp_sock *msk,
+				  const struct mptcp_rm_list *rm_list)
 {
-	struct mptcp_subflow_context *subflow, *alt = NULL;
+	struct mptcp_subflow_context *subflow, *stale = NULL, *same_id = NULL;
 
 	msk_owned_by_me(msk);
 	lockdep_assert_held(&msk->pm.lock);
@@ -224,19 +239,35 @@ void mptcp_pm_addr_send_ack(struct mptcp_sock *msk)
 		return;
 
 	mptcp_for_each_subflow(msk, subflow) {
-		if (__mptcp_subflow_active(subflow)) {
-			if (!subflow->stale) {
-				mptcp_pm_send_ack(msk, subflow, false, false);
-				return;
-			}
+		if (!__mptcp_subflow_active(subflow))
+			continue;
 
-			if (!alt)
-				alt = subflow;
+		if (unlikely(subflow->stale)) {
+			if (!stale)
+				stale = subflow;
+		} else if (unlikely(rm_list &&
+				    subflow_in_rm_list(subflow, rm_list))) {
+			if (!same_id)
+				same_id = subflow;
+		} else {
+			goto send_ack;
 		}
 	}
 
-	if (alt)
-		mptcp_pm_send_ack(msk, alt, false, false);
+	if (same_id)
+		subflow = same_id;
+	else if (stale)
+		subflow = stale;
+	else
+		return;
+
+send_ack:
+	mptcp_pm_send_ack(msk, subflow, false, false);
+}
+
+void mptcp_pm_addr_send_ack(struct mptcp_sock *msk)
+{
+	mptcp_pm_addr_send_ack_avoid_list(msk, NULL);
 }
 
 int mptcp_pm_mp_prio_send_ack(struct mptcp_sock *msk,
@@ -470,7 +501,7 @@ int mptcp_pm_remove_addr(struct mptcp_sock *msk, const struct mptcp_rm_list *rm_
 	msk->pm.rm_list_tx = *rm_list;
 	rm_addr |= BIT(MPTCP_RM_ADDR_SIGNAL);
 	WRITE_ONCE(msk->pm.addr_signal, rm_addr);
-	mptcp_pm_addr_send_ack(msk);
+	mptcp_pm_addr_send_ack_avoid_list(msk, rm_list);
 	return 0;
 }
 
-- 
2.51.0

