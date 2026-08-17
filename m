Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4FE13C9C4;
	Mon, 17 Aug 2026 14:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976520; cv=none; b=P8lV66MxtsXgKHtQY2vLlf4K7IfPrxJ4J1ll/6eHtK4h47grILsLtW9SMbXfm7V/d4hKgrZLLq/5VLggb10A81s9A2cYoGlpAFND1ksGpWC3DZFKpIkIq8VUyrCYHJs4ayahp77EzMoVpSP0RJxJ3+hobm7YjGaWh1fuFCn20T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976520; c=relaxed/simple;
	bh=URiWiV808sy2JvQzmg1QIlUSkhPWC8aJ5SOykLWGn3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H7g11VN9gsgk9dca1oW7/HUKnDWrtzPGdLXzSw2zVSLzTMa7I6GQdEO36R9awpUcxcalAYDLIMkvym4YvnL94awwy1GWG++ri80YT4+ov8+pR4OvvlkQCBXdIcnzxaVc0ljftzj8oBTazAbv3tK6TO7ILqZrphBOYFGJk5MYrn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhQuOWk7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhQuOWk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300A41F000E9;
	Mon, 17 Aug 2026 14:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976519;
	bh=Ma6SOMj2enHrJk0uj3beZCdNZe41p75n6pq9wfmGxUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LhQuOWk7NDP5s9/X7r58o21vrkRcJLxFyJ9JefztVx0v11klxaKf94aljvWmlcPHU
	 MS/It6EoqKJjnWDNZiZdmRlB1KVwcUSnwjC0NeL5A7P6Co0wLlIpeLsDB1leheZ39t
	 aMgT2WfSrCYuRxh+GSl/32c7HU5UJ0wE3mHHi7oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/456] IB/mad: Drop unmatched RMPP responses before reassembly
Date: Mon, 17 Aug 2026 15:26:42 +0200
Message-ID: <20260817132540.374741646@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit d2e52d610b9b09694261632340b801a421e0b0c5 ]

Kernel-handled RMPP receive processing starts reassembly for active
DATA responses before the response is matched to an outstanding send.
The normal match happens later, after ib_process_rmpp_recv_wc() has
either assembled a complete message or consumed the segment.

That ordering lets an unsolicited response that routes to a kernel
RMPP agent by the high TID bits allocate or extend RMPP receive state
before the full TID and source address are checked against a real
request. A reordered burst can therefore reach the receive-side
insertion path even though the response would not match any send.

For kernel-handled RMPP DATA responses, require the existing
ib_find_send_mad() match before entering RMPP reassembly. The matcher
already checks the full TID, management class and source address/GID
against the agent wait, backlog and in-flight send lists. If there is
no match, drop the response without creating RMPP state.

This leaves the RMPP window behavior unchanged and only rejects
responses that have no corresponding request.

Fixes: fa619a77046b ("[PATCH] IB: Add RMPP implementation")
Assisted-by: Codex:gpt-5-5-xhigh
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/3170ff3bc389a930bb1641f2caa394a0b2241579.1780774907.git.michael.bommarito@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/mad.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 242434c09e8d8f..bddb1c607aff62 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1778,6 +1778,24 @@ void ib_mark_mad_done(struct ib_mad_send_wr_private *mad_send_wr)
 			      &mad_send_wr->mad_agent_priv->done_list);
 }
 
+static bool is_kernel_rmpp_data_response(struct ib_mad_agent_private *agent,
+					 struct ib_mad_recv_wc *mad_recv_wc)
+{
+	const struct ib_mad_hdr *mad_hdr = &mad_recv_wc->recv_buf.mad->mad_hdr;
+	struct ib_rmpp_mad *rmpp_mad;
+
+	if (!ib_mad_kernel_rmpp_agent(&agent->agent) ||
+	    !ib_response_mad(mad_hdr) ||
+	    !ib_is_mad_class_rmpp(mad_hdr->mgmt_class))
+		return false;
+
+	rmpp_mad = (struct ib_rmpp_mad *)mad_recv_wc->recv_buf.mad;
+
+	return (ib_get_rmpp_flags(&rmpp_mad->rmpp_hdr) &
+		IB_MGMT_RMPP_FLAG_ACTIVE) &&
+	       rmpp_mad->rmpp_hdr.rmpp_type == IB_MGMT_RMPP_TYPE_DATA;
+}
+
 static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 				 struct ib_mad_recv_wc *mad_recv_wc)
 {
@@ -1796,6 +1814,18 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 	}
 
 	list_add(&mad_recv_wc->recv_buf.list, &mad_recv_wc->rmpp_list);
+	if (is_kernel_rmpp_data_response(mad_agent_priv, mad_recv_wc)) {
+		spin_lock_irqsave(&mad_agent_priv->lock, flags);
+		mad_send_wr = ib_find_send_mad(mad_agent_priv, mad_recv_wc);
+		spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
+
+		if (!mad_send_wr) {
+			ib_free_recv_mad(mad_recv_wc);
+			deref_mad_agent(mad_agent_priv);
+			return;
+		}
+	}
+
 	if (ib_mad_kernel_rmpp_agent(&mad_agent_priv->agent)) {
 		mad_recv_wc = ib_process_rmpp_recv_wc(mad_agent_priv,
 						      mad_recv_wc);
-- 
2.53.0



