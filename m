Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A860B1F709A;
	Tue, 17 Dec 2024 17:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456585; cv=none; b=eUDBaOnmgdQzxudRJV6E1jhI5pH5QRmZAOH88QPcis1slBFJIg1XDbt4QBYa/kciaex20agDz6uy2goRynaGKXy+BzGUo6+RjVTxY1/YpRozrRik2iYFQyvi9VZxvyhfnC4nOS3hSgR75gfM5VvrtNtyJG1nvhNcND959a4Y8CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456585; c=relaxed/simple;
	bh=gxX1NCJ9X0myvvRUV0+OsI9ivLx8o2+c+7oA39SNe30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnYSWMsleBS4GyDSXgXrcvVpqKwWL0miPGtChRZjzd71wD3SBayoSkBS4dqucYF6u2i6N7bbrR3FN2CEVwUWo0gajVJ7dzNvCjAZ0CY7xhP4uNy8U+JjJIUVVQgAkyinBGkE4aT3uVCgQTlioFvQ+Mrg9vej26Otr3IWpdXuDdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRSCtvCh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRSCtvCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7DFC4CED3;
	Tue, 17 Dec 2024 17:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456585;
	bh=gxX1NCJ9X0myvvRUV0+OsI9ivLx8o2+c+7oA39SNe30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRSCtvChNEt2QIX7wD78CbxciVesK5J7NAag8pFyYKaMyxUsHIp6BIaZfyfu1ybra
	 aYuoR4mOi/MxXMPKh1p1bxhvs3ydfokfN7ry00FjI5SvhF7/PMyLT6rmwh8kQfJmGL
	 BpHj2JweXo8hDmHYpGqcuDXD7lRHpRmcrCBzdePU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/172] net: mscc: ocelot: improve handling of TX timestamp for unknown skb
Date: Tue, 17 Dec 2024 18:07:40 +0100
Message-ID: <20241217170550.637730478@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit b6fba4b3f0becb794e274430f3a0839d8ba31262 ]

This condition, theoretically impossible to trigger, is not really
handled well. By "continuing", we are skipping the write to SYS_PTP_NXT
which advances the timestamp FIFO to the next entry. So we are reading
the same FIFO entry all over again, printing stack traces and eventually
killing the kernel.

No real problem has been observed here. This is part of a larger rework
of the timestamp IRQ procedure, with this logical change split out into
a patch of its own. We will need to "goto next_ts" for other conditions
as well.

Fixes: 9fde506e0c53 ("net: mscc: ocelot: warn when a PTP IRQ is raised for an unknown skb")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20241205145519.1236778-3-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.c b/drivers/net/ethernet/mscc/ocelot_ptp.c
index db00a51a7430..95a5267bc9ce 100644
--- a/drivers/net/ethernet/mscc/ocelot_ptp.c
+++ b/drivers/net/ethernet/mscc/ocelot_ptp.c
@@ -786,7 +786,7 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 		spin_unlock_irqrestore(&port->tx_skbs.lock, flags);
 
 		if (WARN_ON(!skb_match))
-			continue;
+			goto next_ts;
 
 		if (!ocelot_validate_ptp_skb(skb_match, seqid)) {
 			dev_err_ratelimited(ocelot->dev,
@@ -804,7 +804,7 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 		shhwtstamps.hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
 		skb_complete_tx_timestamp(skb_match, &shhwtstamps);
 
-		/* Next ts */
+next_ts:
 		ocelot_write(ocelot, SYS_PTP_NXT_PTP_NXT, SYS_PTP_NXT);
 	}
 }
-- 
2.39.5



