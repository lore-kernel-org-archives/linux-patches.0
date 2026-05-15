Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0923BED47;
	Fri, 15 May 2026 16:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862841; cv=none; b=SoyPtsNvCPkfsvtq8Zpwz2Sb7k0M7VlTOPFjBpFt3yrmP9yES6c6ePOgvbPFJH5j3HLQsNabdIGx+9dIFsDwMP0gQLutYr6llcixC10LltPmFXAzHyN5yMonuXgKhVKCVLbvQFb/AOhMmYpNO820w3gkHuPUQGAIx0DR+nBodTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862841; c=relaxed/simple;
	bh=LeujJc6ty9v0I87g+J2BAeLOctVDfh+xYnC5kKG1K6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=un7CSkG9+oSmqBy7y+9f9R3+ObWlCY3kYlaJ2vwqdHeEUNoL7XhCpGLhQ6Dso9mPBL4emIEIWjL5PljScfcTMVuM6dQGPP5SOF7moP9//aiO90EA6guMcOtm3PNm0Ns3YtmnMHZDgdTltcaSk9Y2jjLleo0TRkTGUPzUu0yEb1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qGkcOE4i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qGkcOE4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEFEC2BCB0;
	Fri, 15 May 2026 16:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862841;
	bh=LeujJc6ty9v0I87g+J2BAeLOctVDfh+xYnC5kKG1K6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qGkcOE4iF8Gjkzz3Iz9uDdx3WmSNauFFMcM/Nn+taEV7spBEKNuvBP13W594c6q1q
	 VLtr3TFVKpk2PKZ0Vtr5wqsOJyzdoz59h8DiFoqBSJKHGte6/FfH5buR9ciSt91ImX
	 TUq/yZA8GuOCCzqXMTEDsFGe8BWxl+Gr/p3YcpY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.0 177/201] batman-adv: tp_meter: fix tp_num leak on kmalloc failure
Date: Fri, 15 May 2026 17:49:55 +0200
Message-ID: <20260515154702.411755238@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit ce425dd05d0fe7594930a0fb103634f35ac47bb6 upstream.

When batadv_tp_start() or batadv_tp_init_recv() fail to allocate a new
tp_vars object, the previously incremented bat_priv->tp_num counter is
never decremented. This causes tp_num to drift upward on each allocation
failure. Since only BATADV_TP_MAX_NUM sessions can be started and the count
is never reduced for these failed allocations, it causes to an exhaustion
of throughput meter sessions. In worst case, no new throughput meter
session can be started until the mesh interface is removed.

The error handling must decrement tp_num releasing the lock and aborting
the creation of an throughput meter session

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/tp_meter.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -994,6 +994,7 @@ void batadv_tp_start(struct batadv_priv
 
 	tp_vars = kmalloc_obj(*tp_vars, GFP_ATOMIC);
 	if (!tp_vars) {
+		atomic_dec(&bat_priv->tp_num);
 		spin_unlock_bh(&bat_priv->tp_list_lock);
 		batadv_dbg(BATADV_DBG_TP_METER, bat_priv,
 			   "Meter: %s cannot allocate list elements\n",
@@ -1366,8 +1367,10 @@ batadv_tp_init_recv(struct batadv_priv *
 	}
 
 	tp_vars = kmalloc_obj(*tp_vars, GFP_ATOMIC);
-	if (!tp_vars)
+	if (!tp_vars) {
+		atomic_dec(&bat_priv->tp_num);
 		goto out_unlock;
+	}
 
 	ether_addr_copy(tp_vars->other_end, icmp->orig);
 	tp_vars->role = BATADV_TP_RECEIVER;


