Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7131E4E06FC;
	Wed, 30 Sep 2026 16:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785533; cv=none; b=PI4PRL+sbnhlLr6MNrjHr4fZpoW+DhShsVeKD2YV9ipZqRdAVUO8LerJUOB5+KDONvWhIDzA4ae3Hm8NL7aqvh5i/hlQ2NCzT7vbVBLMXICVFKNbm7+bz48n6Cz7IKPq2FM6aF11oRWh7Q1NUQGnKr7rkICCj+n6clnBKmzp2WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785533; c=relaxed/simple;
	bh=ortbGzceaJh/gsmGRZtioT0p0xg+rwOAxbXmUZBpEQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SluwWvuJTS+szPmmRWmo2Ea9fcNw8I6uz6L0eYSkI1L/VTPvhrgTeNLIXSBZWpJjWH6l5/FN3h/cyH65ova2fVYGVKVoQ5E4dGhekUyfLOcr2K8Os1zomwDtmch6t6tMQfLs5GazKgzR/fmwfMs1eq3E8m0FUJKVC2Nlm9SvjTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+iWhSq7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+iWhSq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A3B1F0089B;
	Wed, 30 Sep 2026 16:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785526;
	bh=IpUIlDOGu4zJkzGYIY0K5//TPQesL2xzDAlk9r8FUpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K+iWhSq7TRvw/PVKASEi8jGbHwrTTb/wnJciPW38LObqEt9XX/XanjIW7ZnP7NWLs
	 E65Cg3PjWdyg1Y99kLYz0gEKpTGbruSJNmtjHZJHUYz6MqGs4NDUzzG5HUtVx+0mNp
	 bhw77m6pcepnaABkZ9LTCWGoojfFfQbZTgBBBGcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Joe Damato <joe@dama.to>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 538/982] bnxt_en: Only restore LRO if the device supports TPA
Date: Wed, 30 Sep 2026 17:21:14 +0200
Message-ID: <20260930152428.326711044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Joe Damato <joe@dama.to>

commit 4e17b5007b6664559cdad2b2fe270526cf786b5b upstream.

With a P5+ device with firmware that reports max_aggs_supported == 0, it is
possible to make LRO settable by attaching and detaching an XDP program
even though the device does not support TPA.

Fix this by testing BNXT_SUPPORTS_TPA before restoring the feature bit.

Fixes: f0aa6a37a3db ("eth: bnxt: always recalculate features after XDP clearing, fix null-deref")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260828190900.1767611-1-joe%40dama.to
Cc: stable@vger.kernel.org
Signed-off-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260902015652.2421609-2-joe@dama.to
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4094,7 +4094,8 @@ void bnxt_set_rx_skb_mode(struct bnxt *b
 		bnxt_get_max_rings(bp, &rx, &tx, true);
 		if (rx > 1) {
 			bp->flags &= ~BNXT_FLAG_NO_AGG_RINGS;
-			bp->dev->hw_features |= NETIF_F_LRO;
+			if (BNXT_SUPPORTS_TPA(bp))
+				bp->dev->hw_features |= NETIF_F_LRO;
 		}
 	}
 


