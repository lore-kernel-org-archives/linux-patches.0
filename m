Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34ED81D416E;
	Wed,  6 Nov 2024 12:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895226; cv=none; b=Jv8+k0cUgp8HQtxVYlHK8swzvoTMx+Ozisk3PtPuQ7qC5LhGqArxQkxGotk8IR3PUR2Xl3tJgAdguYFNhjELel7/MYGH9rbO4/mrXH3LgYU0/N12MoJNPdqECScC0jNZ1DYyo8Ub2VMzJ55vroPmp7igYm216394Kz5c3WfBvFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895226; c=relaxed/simple;
	bh=EUWyvczp4Ffc78dzm5PnrS2YOjgpvpFqqacYIGorask=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uvmisp5PuZUWCCSSJvN2IpWeNP+UZKWtfEmeUN3lYWChg0NemFDEJIMUGnU8apGo1XRwal+ky0Gsz+I8aCQtV16JugUPBpLVtxk2xvyA5+gP79KCkkbTnYgpLqy7QC2/2d5FP8nMxDq3PGuGdnBassV1IfuyCOYmx+1uAqplAHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FOJ8pylQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FOJ8pylQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B028BC4CECD;
	Wed,  6 Nov 2024 12:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895226;
	bh=EUWyvczp4Ffc78dzm5PnrS2YOjgpvpFqqacYIGorask=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOJ8pylQu45s4TCrevNSXGAsgvLRDBPZCCe9KL60cPZL+05VdGTTZCiHUu+2mYNHF
	 FpsBJlgTUUKQ04ndGjEjwSPVMajO9mX+iS5b4wWzUWY/+LoBdyLK1OBYHffQ0e3lBb
	 /DjaZUJfRyjrkMRZVLhcywyh3QHtYXFRgXS+tSsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+98afa303be379af6cdb2@syzkaller.appspotmail.com,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 147/350] wifi: ath9k_htc: Use __skb_set_length() for resetting urb before resubmit
Date: Wed,  6 Nov 2024 13:01:15 +0100
Message-ID: <20241106120324.547403622@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 3aa915d215545..24059a5178a9d 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -718,8 +718,7 @@ static void ath9k_hif_usb_rx_cb(struct urb *urb)
 	}
 
 resubmit:
-	skb_reset_tail_pointer(skb);
-	skb_trim(skb, 0);
+	__skb_set_length(skb, 0);
 
 	usb_anchor_urb(urb, &hif_dev->rx_submitted);
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
@@ -756,8 +755,7 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
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



