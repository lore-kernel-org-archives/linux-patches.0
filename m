Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3BB15705C;
	Mon, 29 Jan 2024 17:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548576; cv=none; b=QMktyTrlDy7XNZ6VklXAR3b/2Hv1E5V6BbklvFqLYs0HmPbqQBdTgc3x8vsCZqEcF+wxXoI4AO/FnVU9G0Qd5ZBDXGwv3syt7an2FYbxltxfxvutv9+GfEuC70redFkPHAEn7HTfczERzVfW6kcfwKWJ9YYr6yfzxcjIKcepGx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548576; c=relaxed/simple;
	bh=igIZPu6FJJaC4Mlwy+P7SiAnnoeaS2broH/WYKtRSB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fh20CD7LcySt85hDn9p91Zy3JIgPsDCziz7glW3lcaLtp2eCNCNB3BwwIykCPzPPTXZ0iJiEZTEanvnuDDBn745HZ++s8FPRWRYyEYBniEfhqOmW18P3GkdWeQ/eqjdkpUrtxMJq8WiOwIu4/mIVTUTr3y4MemJHmddqkoWyDiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sr2vYO7B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sr2vYO7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82A7C43399;
	Mon, 29 Jan 2024 17:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548576;
	bh=igIZPu6FJJaC4Mlwy+P7SiAnnoeaS2broH/WYKtRSB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sr2vYO7BO6cMQeEQWK9nNDLjbcC5oG5GmXNpVB30RpOonzFO69e5qvbdhhrfOmb0R
	 n2PwMOCv77Jvl6J7JRVb0HhzPSsDJn3p6sr1GoFLbai5vUMWqPsPPnH+1X2JCgdkP3
	 L6skWJiVPMwCqvSPoWMNJ7wZARgJK4YeNaEztmo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 229/331] tsnep: Fix XDP_RING_NEED_WAKEUP for empty fill ring
Date: Mon, 29 Jan 2024 09:04:53 -0800
Message-ID: <20240129170021.583431704@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Gerhard Engleder <gerhard@engleder-embedded.com>

[ Upstream commit 9a91c05f4bd6f6bdd6b8f90445e0da92e3ac956c ]

The fill ring of the XDP socket may contain not enough buffers to
completey fill the RX queue during socket creation. In this case the
flag XDP_RING_NEED_WAKEUP is not set as this flag is only set if the RX
queue is not completely filled during polling.

Set XDP_RING_NEED_WAKEUP flag also if RX queue is not completely filled
during XDP socket creation.

Fixes: 3fc2333933fd ("tsnep: Add XDP socket zero-copy RX support")
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 9fea97671f4b..08e113e785a7 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1711,6 +1711,19 @@ static void tsnep_rx_reopen_xsk(struct tsnep_rx *rx)
 			allocated--;
 		}
 	}
+
+	/* set need wakeup flag immediately if ring is not filled completely,
+	 * first polling would be too late as need wakeup signalisation would
+	 * be delayed for an indefinite time
+	 */
+	if (xsk_uses_need_wakeup(rx->xsk_pool)) {
+		int desc_available = tsnep_rx_desc_available(rx);
+
+		if (desc_available)
+			xsk_set_rx_need_wakeup(rx->xsk_pool);
+		else
+			xsk_clear_rx_need_wakeup(rx->xsk_pool);
+	}
 }
 
 static bool tsnep_pending(struct tsnep_queue *queue)
-- 
2.43.0



