Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DB93D9556;
	Thu,  2 Jul 2026 16:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009653; cv=none; b=HcITZuoYaeZvGi2v4aCrtYnUaqQyznJwncBcExUZaC9QHirAN5oNsri7XUyHfFLSKBfwYf+xSXoI7CzIoP9LiM1cXlh89wPNDDo1AaSbcLdvhdSWXFFnvUyErGcLDBjZSdsGLD9E4MA2WjzlG91qN7H+EpJDNUBr4ZaW1PkwiMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009653; c=relaxed/simple;
	bh=umVKHZE0b5OvUEn6b0994w4sdyrNFES69ExzdPtxqzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cG04RiWifXz3bifx0h9STipll0oOPZJLG4yZryYqVEoXJLc2TaHX6naPoqYRfGTSMImubDRVQzpEdb6LMslyDYMSilGH53TdGVqhpC8IHKn6cUNphPARj4SUKvLCakLyWf6JFzaE7nTozSEQfhEbtqw7p33zndJ2xqQHb6/iIFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvDLO8v/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvDLO8v/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44BA1F00A3D;
	Thu,  2 Jul 2026 16:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009649;
	bh=slg9E5ph3Loq8Kzwpyi1vmRHkbSoxQoFMeMYmhU8fq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tvDLO8v/mpxVvM1ctv0/MzYEE0y1qYV+U3yCOWFNcin95qZEIPWOXekfXFTyxzxMC
	 BQa94T7doFnvoG78CfdDp1r/CXeauSqmPY5uIb7gja2lSTfcsTInyW5fXlM4vox165
	 QZn8iNIHACT7EdzXBe77R5vGw+KSF+vNeuipIFZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 34/95] batman-adv: tp_meter: handle seqno wrap-around for fast recovery detection
Date: Thu,  2 Jul 2026 18:19:37 +0200
Message-ID: <20260702155109.924234565@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit f54c85ed42a1b27a516cf2a4728f5a612b799e07 upstream.

The recover variable and the last_sent sequence number are initialized on
purpose as a really high value which will wrap-around after the first 2000
bytes. The fast recovery precondition must therefore not use simple integer
comparisons but use helpers which are aware of the sequence number
wrap-arounds.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 1fc8d6e6f99b30..7385cd02abf9f0 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -733,7 +733,7 @@ static void batadv_tp_recv_ack(struct batadv_priv *bat_priv,
 		if (atomic_read(&tp_vars->dup_acks) != 3)
 			goto out;
 
-		if (tp_vars->recover >= recv_ack)
+		if (!batadv_seq_before(tp_vars->recover, recv_ack))
 			goto out;
 
 		/* if this is the third duplicate ACK do Fast Retransmit */
-- 
2.53.0



