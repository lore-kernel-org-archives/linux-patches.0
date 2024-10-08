Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32D11DF744;
	Tue,  8 Oct 2024 13:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393224; cv=none; b=CENSUTxgaBu0PLY/wm2zOcHfHHCq+ane1M8ojdWTqsQGcrIcpyk3NdzKxBeJV7k5LSK4PdshGrczPP2jsLv10FXjcuqHvvDG8CEN+wpXkuMLkY1oPxUUYCuikgIgMK5k7LxA8ULyMhwDLqBNC7XSN6XNhcDLnwKT/NwVcwrnSp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393224; c=relaxed/simple;
	bh=plKSOGMd6XJrP6Z2daoG9+W/4qxT7X+fCUiQILjIgOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oFGj9gu8dCMjYVZ/rA6Fwg3tONojGfNGYPSNJfGAh4li51XJP0kWzUCPaLEZ+fTvZYhekEcXTugZ9pQhhn1cQGdgjs9do5xnexhTbq4cqJl6huexTMhd8+2tUOx+YgcZOaJyJ8moUnI+2x4lJP2/XQwQXJPOFPFdgPTkqz1QpQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRlXd6pw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRlXd6pw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF51C4CECF;
	Tue,  8 Oct 2024 13:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393223;
	bh=plKSOGMd6XJrP6Z2daoG9+W/4qxT7X+fCUiQILjIgOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wRlXd6pwKjUXDAYEGQT/CyndYTe4aqXItVOewkmtPp494kzyzvBzqLeaYiqwmXkIX
	 1roOVdUROWVE1dUC0PttqNjBSOJkvW9x/tdoMdhFXBj6UdxpAs4bWIijytz2zBOb58
	 Ekd7DMRnET9zs1qPjrPxYZHpkQ4h26dl+W7PSby8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+98afa303be379af6cdb2@syzkaller.appspotmail.com,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/386] wifi: ath9k_htc: Use __skb_set_length() for resetting urb before resubmit
Date: Tue,  8 Oct 2024 14:05:03 +0200
Message-ID: <20241008115631.752438966@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e5414435b1414..ab728a70ed279 100644
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



