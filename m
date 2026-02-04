Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BA6421F1E;
	Wed,  4 Feb 2026 15:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218546; cv=none; b=N6Lg03801yufprh+rkOAEUEvF5HbzEmDiFvpTVbFLEsgDZ0mzWdjiVrzWxZ0VngYWhwGaLOsPXuCUX8ARkZbbHwtDR7V47ZEax7+285zYuhZFPbpd7E6s16/dBMd19W7iCaVmuB+pKcwg09OOvvGwljoOvn7GhWHKmBgiK4Z6gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218546; c=relaxed/simple;
	bh=2zqryaA4699ni6ZDSwkOeniwwvT+cHkmv1sa+UaiaWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SnefEdXWTeYvh5zjzUSggcVPKf6SpFT04FlhF+N562UwEhyJRXokrhP9ucGswbp7PtpfE+SIjp0d/fPytevHJ9Btk+2R/oKFRP+/M1VeMAbRmzMdqW1og3zILpvb0QHKEhQZseUluxA5fxtRtvHqPLTyiIxr5hLgdglWDvJ/Ep8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVYcrjdH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVYcrjdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2982C4AF0E;
	Wed,  4 Feb 2026 15:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218546;
	bh=2zqryaA4699ni6ZDSwkOeniwwvT+cHkmv1sa+UaiaWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVYcrjdHLeymh8Msss5n9neJhDVaE6ECezWUf2//6fD5rbQlULH4mDBVgAFIjVXCA
	 HHT59qBchL3HFuHvngBo2VgDeDwqiSHIGbXVO2jVTlWnyDl815ivQ/zVd7Rvb7FshG
	 FhQvc6+YRCDq6tmiIIWOvEe7AMBwovbVR3qrp6Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Angaroni <marco.angaroni@italtel.com>,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 62/72] mptcp: avoid dup SUB_CLOSED events after disconnect
Date: Wed,  4 Feb 2026 15:41:05 +0100
Message-ID: <20260204143847.883889704@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit 280d654324e33f8e6e3641f76764694c7b64c5db ]

In case of subflow disconnect(), which can also happen with the first
subflow in case of errors like timeout or reset, mptcp_subflow_ctx_reset
will reset most fields from the mptcp_subflow_context structure,
including close_event_done. Then, when another subflow is closed, yet
another SUB_CLOSED event for the disconnected initial subflow is sent.
Because of the previous reset, there are no source address and
destination port.

A solution is then to also check the subflow's local id: it shouldn't be
negative anyway.

Another solution would be not to reset subflow->close_event_done at
disconnect time, but when reused. But then, probably the whole reset
could be done when being reused. Let's not change this logic, similar
to TCP with tcp_disconnect().

Fixes: d82809b6c5f2 ("mptcp: avoid duplicated SUB_CLOSED events")
Cc: stable@vger.kernel.org
Reported-by: Marco Angaroni <marco.angaroni@italtel.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/603
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260127-net-mptcp-dup-nl-events-v1-1-7f71e1bc4feb@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2554,8 +2554,8 @@ out:
 void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		     struct mptcp_subflow_context *subflow)
 {
-	/* The first subflow can already be closed and still in the list */
-	if (subflow->close_event_done)
+	/* The first subflow can already be closed or disconnected */
+	if (subflow->close_event_done || READ_ONCE(subflow->local_id) < 0)
 		return;
 
 	subflow->close_event_done = true;


