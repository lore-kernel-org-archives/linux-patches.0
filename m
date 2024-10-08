Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98CF185B58;
	Tue,  8 Oct 2024 12:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389711; cv=none; b=gwF0yeZhylnAquBRRBqcJHW74/ZfbmJoH9bPAORsjljDHez2KC02IGKGV1UngzoOVTVdo/cl8BY+NYtzAehkLYZLF4RL8J4XAHGA6JuUhaBjGXtdU1mQznTLt4U9AGAhtwo7fXD9lC2SLulmy/NISj4cS5ddVl/i4zFnyCWH4ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389711; c=relaxed/simple;
	bh=4vblZl7POhcR5bW7g2TJq4cCWLCfUw7eIip2TyGRMuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DfmuBhdRHHzfUdXlGw4MNoW/PFFQA9JGbdy13Vz2VGyDBkxqC3THPkHY7bYJCmwfC1XcGUJ7AydBu0Uy8Bl+vzt6GswPPcOZz9ou7NNe676BG2rNEIZp1kcjtAnuSYs+UIeiJoKKD4CwzLC0uQrBb9my57XD5Y7C9iueGAyJZB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w38qDv72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w38qDv72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F71CC4CECD;
	Tue,  8 Oct 2024 12:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389710;
	bh=4vblZl7POhcR5bW7g2TJq4cCWLCfUw7eIip2TyGRMuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w38qDv72ynALfUi9TPBs33RrOu6Y0Z/pLGBnSHiRUpi8CBhiIqnjs61ya1oUcn5uL
	 3C1pQW/E9fNvLhKMQUupBwvxtIPzlONjo5adZAL9shotY/L8kew3KfVbfRMVUp4QH/
	 Js83dA89IS08aGFMMK5EqZL2hEvL/GgweWFfCzXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+98afa303be379af6cdb2@syzkaller.appspotmail.com,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 073/482] wifi: ath9k_htc: Use __skb_set_length() for resetting urb before resubmit
Date: Tue,  8 Oct 2024 14:02:16 +0200
Message-ID: <20241008115651.179384506@linuxfoundation.org>
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

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 94745807f3ebd379f23865e6dab196f220664179 ]

Syzbot points out that skb_trim() has a sanity check on the existing length of
the skb, which can be uninitialised in some error paths. The intent here is
clearly just to reset the length to zero before resubmitting, so switch to
calling __skb_set_length(skb, 0) directly. In addition, __skb_set_length()
already contains a call to skb_reset_tail_pointer(), so remove the redundant
call.

The syzbot report came from ath9k_hif_usb_reg_in_cb(), but there's a similar
usage of skb_trim() in ath9k_hif_usb_rx_cb(), change both while we're at it.

Reported-by: syzbot+98afa303be379af6cdb2@syzkaller.appspotmail.com
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20240812142447.12328-1-toke@toke.dk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 0c7841f952287..a3733c9b484e4 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -716,8 +716,7 @@ static void ath9k_hif_usb_rx_cb(struct urb *urb)
 	}
 
 resubmit:
-	skb_reset_tail_pointer(skb);
-	skb_trim(skb, 0);
+	__skb_set_length(skb, 0);
 
 	usb_anchor_urb(urb, &hif_dev->rx_submitted);
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
@@ -754,8 +753,7 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	case -ESHUTDOWN:
 		goto free_skb;
 	default:
-		skb_reset_tail_pointer(skb);
-		skb_trim(skb, 0);
+		__skb_set_length(skb, 0);
 
 		goto resubmit;
 	}
-- 
2.43.0



