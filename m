Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BDF176238;
	Fri, 15 May 2026 15:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860565; cv=none; b=YqJtQbbugqEB+rjaEdRavprN1AcVMLCL3H17INfDDMYpG0F+LtkITXfDjmh43fhDnmqbi0J4yXu2KUa/9hDnij4267Z08TMxM3TZeViKwT54RXEJimmiQxb3qwgSD0Jj+EheVD0BidGAEmChGEVCBizJT45auZcFvBuM35//iW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860565; c=relaxed/simple;
	bh=mpewDWqVBy6Cpweqoje8XGB7IpxJTE4p5QrVQ/cxpIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2VJCkrDo6JvE/fBK5HZUcPQVfAawNHANrYn/ZxqStHtfmD+ApK6FnC672yH4CXAVt+y1hp/0Y7pDY3UKDyOfkOnv2ub0Vb3ORP9WmQ4yE+XUoy10lP9fMCYR+Knsow42VvN1It8Y+mMjOp1oIHCFFm28tRR38QQPPjXMFoxMFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ro1/Mc/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ro1/Mc/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CABC2BCB0;
	Fri, 15 May 2026 15:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860565;
	bh=mpewDWqVBy6Cpweqoje8XGB7IpxJTE4p5QrVQ/cxpIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ro1/Mc/Xi37VotGY5NL4Qi2z7b+JvEpiAIlUxiOtWSDJuh82N6cpG21BbzmNok6mW
	 QUtpsbTAd4BxFvr2VkfjhEw0glF8MDw2EU95vlBuRbtyQ+qzbSBz3bXtOn1KaBquaj
	 BUjzrmLy+O7qIvFjwbp+Br1TTlBZJi1T+5H+2t8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.12 137/144] batman-adv: tp_meter: fix tp_num leak on kmalloc failure
Date: Fri, 15 May 2026 17:49:23 +0200
Message-ID: <20260515154656.699540858@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/tp_meter.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -994,6 +994,7 @@ void batadv_tp_start(struct batadv_priv
 
 	tp_vars = kmalloc(sizeof(*tp_vars), GFP_ATOMIC);
 	if (!tp_vars) {
+		atomic_dec(&bat_priv->tp_num);
 		spin_unlock_bh(&bat_priv->tp_list_lock);
 		batadv_dbg(BATADV_DBG_TP_METER, bat_priv,
 			   "Meter: %s cannot allocate list elements\n",
@@ -1366,8 +1367,10 @@ batadv_tp_init_recv(struct batadv_priv *
 	}
 
 	tp_vars = kmalloc(sizeof(*tp_vars), GFP_ATOMIC);
-	if (!tp_vars)
+	if (!tp_vars) {
+		atomic_dec(&bat_priv->tp_num);
 		goto out_unlock;
+	}
 
 	ether_addr_copy(tp_vars->other_end, icmp->orig);
 	tp_vars->role = BATADV_TP_RECEIVER;


