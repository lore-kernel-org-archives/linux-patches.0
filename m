Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF182F24;
	Mon, 23 Jun 2025 13:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684820; cv=none; b=XhqcKt4KnmxlXhGHBJKNLOrWpVEc7L5HYL+HAGQNHtCk9mLfLXcrghUZQeQNubOhwIcq8cWhsNfx3nU4znxQsgo4ibo8h5UCKElwLQMkSKD+AtK/vJuG3M+RpbkXNiaKrwjlPZYF7gFZPC4C06oeYavypcoEJCTkZyI7HucHVlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684820; c=relaxed/simple;
	bh=TDOhGNvUPfdG/EOzzCdBZS2SCj6KvKWG/mvSBp30sCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LcT04bYpzOFQL6Ca00uIxlVwlWuH7Jztfyz9P+xM2NdsbCh9y7T1nmSiH0DEfax3IQqtClDE+dju/G7jwhv/FEaYORygSIm8ctFbCx7Q0uTHzGSwcsCv7AKp8ks2CnJNbCB4+sLhhdy5no8NkR5EFhxFGvg35237XZjh9WfBuAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmVsbuAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmVsbuAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3B7C4CEEA;
	Mon, 23 Jun 2025 13:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684820;
	bh=TDOhGNvUPfdG/EOzzCdBZS2SCj6KvKWG/mvSBp30sCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmVsbuAOFkApOnoBRVq3NGHVlX4h9kFTaFsCVIN6gYWXVYdAE3fgBLz/p9Oy/bkut
	 OATLMZbvCmhbwHJI16M/Wj1ubkFB4FYJ5EMVsI0GivE0FhgAVoO3/pFYieuFkq7WZX
	 VFilih8XQt2juJOgaRrFfOAAk+1+iL2ktqDlkBL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/222] wifi: ath9k_htc: Abort software beacon handling if disabled
Date: Mon, 23 Jun 2025 15:06:10 +0200
Message-ID: <20250623130612.954933315@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@toke.dk>

[ Upstream commit ac4e317a95a1092b5da5b9918b7118759342641c ]

A malicious USB device can send a WMI_SWBA_EVENTID event from an
ath9k_htc-managed device before beaconing has been enabled. This causes
a device-by-zero error in the driver, leading to either a crash or an
out of bounds read.

Prevent this by aborting the handling in ath9k_htc_swba() if beacons are
not enabled.

Reported-by: Robert Morris <rtm@csail.mit.edu>
Closes: https://lore.kernel.org/r/88967.1743099372@localhost
Fixes: 832f6a18fc2a ("ath9k_htc: Add beacon slots")
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20250402112217.58533-1-toke@toke.dk
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index f20c839aeda22..6db484ee7ee08 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -290,6 +290,9 @@ void ath9k_htc_swba(struct ath9k_htc_priv *priv,
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	int slot;
 
+	if (!priv->cur_beacon_conf.enable_beacon)
+		return;
+
 	if (swba->beacon_pending != 0) {
 		priv->beacon.bmisscnt++;
 		if (priv->beacon.bmisscnt > BSTUCK_THRESHOLD) {
-- 
2.39.5



