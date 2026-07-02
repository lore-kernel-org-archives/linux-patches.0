Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC22D3ABD82;
	Thu,  2 Jul 2026 16:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009962; cv=none; b=GfJVdmfMGt41S+VkLLKBEhPiW53VlVr1yOTHpapuJLzOBbHLkjePM9hE4V0BEQaHtgc34zkvWHIBe74X5XRqiZzTZNiwViCmk0p/jdhtpjYYEkKKNZXrzA3SxFPURKxvndNcq9IhuT9ywrJ4rlIS4R6Dwqk1xi9EnMpDOdgzP5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009962; c=relaxed/simple;
	bh=dDKan8nHEX0Pb4knLNIHPXGUVMNTVXIOca8kzXwbHO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gLYeu2drmnfZOAL/DEKw7QrHXZX//hXrRkzx8nmbYjlC3Eza4WggeDxpHeY8/gcYCk8R3yfMxUItcx5KV+KQZn9J4f6KShtzjhlgpbx8DOlkGJqxaXQc73cJz0AVfwYOOEO1A3OvB+zxqVwotWHrc+ZCp9G6KK34KjC7wVGp6bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zYt3UVnz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zYt3UVnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3951F000E9;
	Thu,  2 Jul 2026 16:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009961;
	bh=RjosFLLmrLQm+gXDCkh7us26VMPDvPYdL5im+34bgSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zYt3UVnz8Dr9UysRmeu7mqIhvodnXzdMy990wcRdGV77rEtt2jsLstjUM2TvwpV8n
	 IyFmYUQf6KeKJeHRx/9tGse7z33tU7HGKjTw3D1dkr+6lTyZw/VKou4OElry3p8IBv
	 Icjr3Zf3T9ERMuJdCAULsqdUh4UNqO67zs273B0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/129] batman-adv: tp_meter: handle seqno wrap-around for fast recovery detection
Date: Thu,  2 Jul 2026 18:19:35 +0200
Message-ID: <20260702155113.305438854@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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
index c79352cfddc4ae..089ac7cc9fbebc 100644
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



