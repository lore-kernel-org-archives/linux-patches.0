Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120E72D9787;
	Thu, 28 May 2026 20:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999676; cv=none; b=oKWfDa/CSbLKwhSte5IMCviSpTSrATsMR7qPbT/1FMmEHPBmYNNTTvgUdIqmLzc6wyDdyN2rqxpDo/Wh4PKCosKJ4Yr9TRMH4XD/FbEv570JASPqwrFCz+VIs+rM54xtYAaCucW+yAvATlcxrha7Jh6kAJbXSqBh+dVhHb6zlVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999676; c=relaxed/simple;
	bh=VIvoIWgvhbbjMuRHyPNj7+y9uoMfAxq4nWssr43UHH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMX4F+uzUWGXh7faemRAvDwYCbhoyj5UvF4VABEoUIyXo3A0ML4sWWIlF26cdt0ZjRVLoBvw11aJ9h1ftSzdy8KWhYFPA8Juk2n4g0Rfhw1j9lWXNsqu3SC4GPUbb9l1ZaXxNqf7C2wLWKPtRwcE/1GpXXNm8xJmXr7kbelcmcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grxyYRs+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grxyYRs+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D4D1F000E9;
	Thu, 28 May 2026 20:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999675;
	bh=cwDw2tlNPXY5ysc27aWiOUmKfORkMSKICEmSuxAVqVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=grxyYRs+aBWjLFhP46f4t7+SuOLqnc+IcesVlcKS/CKgPfSTWSrrjVhNqHbsFXt86
	 JoWT/LSI3LQNppIFnTWhXlQg0Nq5kXNC1jcegmsERQBgyi46JXd19Tdcus4wpvOWwA
	 0/0LnPAFzKzRSrSiBg5/4dL92iunifuvlI9hwejE=
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
Subject: [PATCH 6.18 150/377] batman-adv: tp_meter: avoid use of uninit sender vars
Date: Thu, 28 May 2026 21:46:28 +0200
Message-ID: <20260528194642.733036091@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
@@ -663,6 +663,9 @@ static void batadv_tp_recv_ack(struct ba
 	if (unlikely(!tp_vars))
 		return;
 
+	if (unlikely(tp_vars->role != BATADV_TP_SENDER))
+		goto out;
+
 	if (unlikely(atomic_read(&tp_vars->sending) == 0))
 		goto out;
 
@@ -1100,12 +1103,16 @@ void batadv_tp_stop(struct batadv_priv *
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
 


