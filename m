Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421612E7379;
	Sat, 30 May 2026 17:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162326; cv=none; b=H+k+FY8x59szu64mgaMp3y9srdWuZ3YZ8QB8OcKLTIZxlzVg1Nv4V0tZHgIejX6qp//JnhVxL5RIrSCpW+jkFxuQI3NtdOb7xbFjkWkay4ZECRnMbv5VhsF4ubc8mVZu2w4fPN6gFCsrm54PDNbTTgYcEg84cf6LrG72BBt1jt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162326; c=relaxed/simple;
	bh=v1OhRT48KWlgPrT7Jc8GgmS15Uv+gx8LELjCNZIT+5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYbLNYGGyHNFjXbeLropjCgqKZGc1pZ51r4d8SOpn189B0zQH2mWZWGNG8P5GnkC4/i1SGBscLPMjJiTkSLw45H+7gNwnNIf127ExGX+OAGT2Bmeny/yCS840p0K6e4IHXdPAiCp8A83QDkgqh9JOJa6y4rIFcHSHDTxVIvvmNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2Yg4WeD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2Yg4WeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BE21F00893;
	Sat, 30 May 2026 17:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162325;
	bh=4BDYuBDEEmXsdlAItaEcUK8qgoA22OaWq1u9iwiUHb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2Yg4WeD72aiMkd5SKKHwLVcWNBCr9cYlWzHWdMjzsLotsRw3unTLVBFhFfpOqY+w
	 kaZA2AqiB1aWxACUTLDxBU3B1+RnKy6Wn7i4sz3S7dlgIVikpAdnawCRzlavLSq8mJ
	 Lr1OAy0exuwGT5XmRG/5YqZwXLj8dbLL/JkkVKsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.1 887/969] batman-adv: tp_meter: avoid use of uninit sender vars
Date: Sat, 30 May 2026 18:06:51 +0200
Message-ID: <20260530160325.192444913@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 6c65cf23d4c6170fcf5714c32aa64689718cb142 upstream.

batadv_tp_recv_ack() and batadv_tp_stop() are only valid for tp_vars in the
BATADV_TP_SENDER role. When called with a BATADV_TP_RECEIVER role, it
proceeds to read sender-only members that were never initialized, leading
to undefined behavior.

This can be triggered when a node that is currently acting as a receiver in
an ongoing tp_meter session receives a malicious ACK packet.

Guard against this by checking tp_vars->role immediately after the
lookup and bailing out if it is not BATADV_TP_SENDER, before any of
those members are accessed.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Reviewed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/tp_meter.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -647,6 +647,9 @@ static void batadv_tp_recv_ack(struct ba
 	if (unlikely(!tp_vars))
 		return;
 
+	if (unlikely(tp_vars->role != BATADV_TP_SENDER))
+		goto out;
+
 	if (unlikely(atomic_read(&tp_vars->sending) == 0))
 		goto out;
 
@@ -1080,12 +1083,16 @@ void batadv_tp_stop(struct batadv_priv *
 	if (!tp_vars) {
 		batadv_dbg(BATADV_DBG_TP_METER, bat_priv,
 			   "Meter: trying to interrupt an already over connection\n");
-		goto out;
+		goto out_put_orig_node;
 	}
 
+	if (unlikely(tp_vars->role != BATADV_TP_SENDER))
+		goto out_put_tp_vars;
+
 	batadv_tp_sender_shutdown(tp_vars, return_value);
+out_put_tp_vars:
 	batadv_tp_vars_put(tp_vars);
-out:
+out_put_orig_node:
 	batadv_orig_node_put(orig_node);
 }
 


