Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE38D8F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BABC433C8;
	Sun, 16 Jul 2023 20:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539750;
	bh=i0VCj0JBDD7guuucNIYX3frg34Yi1S8G1cgOp3IwSj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xo7/h5T5f/KwyfaZaqnrUo2hdL8PYi+uezgwcPGbx8Qw8bz7OvvTaLhjB2vV089P7
	 cV6QDKj56RzhKy4VWGEH/HnUHUIlDBK6YOeS0bYAvXgL0yqgTffa4zMK2TfW16Kz0X
	 hK3sbSs5Xl79nkwccUnelc5cxNMEXjpHSw4My+Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/591] wifi: ath9k: convert msecs to jiffies where needed
Date: Sun, 16 Jul 2023 21:44:18 +0200
Message-ID: <20230716194926.955316273@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 2aa083acea9f61be3280184384551178f510ff51 ]

Since 'ieee80211_queue_delayed_work()' expects timeout in
jiffies and not milliseconds, 'msecs_to_jiffies()' should
be used in 'ath_restart_work()' and '__ath9k_flush()'.

Fixes: d63ffc45c5d3 ("ath9k: rename tx_complete_work to hw_check_work")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230613134655.248728-1-dmantipov@yandex.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7f9f06ea8a05f..6360d3356e256 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -203,7 +203,7 @@ void ath_cancel_work(struct ath_softc *sc)
 void ath_restart_work(struct ath_softc *sc)
 {
 	ieee80211_queue_delayed_work(sc->hw, &sc->hw_check_work,
-				     ATH_HW_CHECK_POLL_INT);
+				     msecs_to_jiffies(ATH_HW_CHECK_POLL_INT));
 
 	if (AR_SREV_9340(sc->sc_ah) || AR_SREV_9330(sc->sc_ah))
 		ieee80211_queue_delayed_work(sc->hw, &sc->hw_pll_work,
@@ -2240,7 +2240,7 @@ void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop,
 	}
 
 	ieee80211_queue_delayed_work(hw, &sc->hw_check_work,
-				     ATH_HW_CHECK_POLL_INT);
+				     msecs_to_jiffies(ATH_HW_CHECK_POLL_INT));
 }
 
 static bool ath9k_tx_frames_pending(struct ieee80211_hw *hw)
-- 
2.39.2



