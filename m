Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B5318CC12;
	Tue,  8 Oct 2024 12:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389701; cv=none; b=pLeQnRhA43uFBEd7vn4CtuPKuDWUnHxyrb2uatvOr/pb7Xhi3ibFzcV6txbuBr+MrK8UfPSL7P/k+CML/PD+F3bOO8Dm+7TWIg9p8LFr854+NohpBpsOVmMsSai+W/IzHYraGUmMH6WmKRAGQPlJcJhWNW4AQcc0XnHe3eHTvjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389701; c=relaxed/simple;
	bh=rQdGw9UpYTIKtAPMaT1/ze4wnaFzJ1EMugXOicqQyf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oypgy9pfIdRQSzz+FEHDfyYKJ7gMSZBmDOx/PGDA3yaCtDTq/x6w+j3kE0tQvm7Y7DiM+WDraEhxGr4ZstmsFmJgmBSysuPdc8BqCr26EadIMsHAffCrgRaOovKpUm6sU8tegippwZgxbC2tE2mTAZTQiQ7JxZtrLOU/ue0FuAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KlxvcaoF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlxvcaoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF16C4CECC;
	Tue,  8 Oct 2024 12:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389701;
	bh=rQdGw9UpYTIKtAPMaT1/ze4wnaFzJ1EMugXOicqQyf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlxvcaoFBdKaW9Te0mOgo4IGCyKvbCeTk1sCkSAfCPoLcyksTbWujnRjrIcEynJYO
	 WjC7BwcnvO5NxPy0LsTdCsMYimCfAEFQz8wyBPuj1jyE+5opcBnNk8VWqF5h1ndE+m
	 3+DxaFhTiCKb7iKLFxCa8MkS1A3+/sSCw1NMSUsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Kandybka <d.kandybka@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 071/482] wifi: ath9k: fix possible integer overflow in ath9k_get_et_stats()
Date: Tue,  8 Oct 2024 14:02:14 +0200
Message-ID: <20241008115651.101358650@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Kandybka <d.kandybka@gmail.com>

[ Upstream commit 3f66f26703093886db81f0610b97a6794511917c ]

In 'ath9k_get_et_stats()', promote TX stats counters to 'u64'
to avoid possible integer overflow. Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Dmitry Kandybka <d.kandybka@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20240725111743.14422-1-d.kandybka@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index bf3da631c69fd..51abc470125b3 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1325,11 +1325,11 @@ void ath9k_get_et_stats(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	int i = 0;
 
-	data[i++] = (sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BE)].tx_pkts_all +
+	data[i++] = ((u64)sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BE)].tx_pkts_all +
 		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BK)].tx_pkts_all +
 		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VI)].tx_pkts_all +
 		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VO)].tx_pkts_all);
-	data[i++] = (sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BE)].tx_bytes_all +
+	data[i++] = ((u64)sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BE)].tx_bytes_all +
 		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BK)].tx_bytes_all +
 		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VI)].tx_bytes_all +
 		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VO)].tx_bytes_all);
-- 
2.43.0



