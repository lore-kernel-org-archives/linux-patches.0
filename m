Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2070013A863;
	Fri,  6 Dec 2024 15:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498255; cv=none; b=PAGr+9Wp1cLsWAoStoNMGKfIMRfCYNF640DD2fPU0wYlhC0Cl3IbmYa6tuTFGw24BihpqUQ1wnP7+AUcClUSNlbhATkEXjqDbUEDx7Ez1oTuiS83h7/HLr65JZSsWq28fMxpz30PnRvTXpSJ8rvArIJbflDttWJut/eYf5EoZwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498255; c=relaxed/simple;
	bh=PkUdku/QqzT7k64NowY412mfr4UIAfuup4EoKQe8DvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PeE1ppcStKI5hjICEyEfg5eZbBH4SCfRZmJLRNQFo60FSpdUB2atWCqfLnCTf0yUYMbhl68k9qGf6k3XzghihgT0+R4ifQcpLCS3FZ1ctbfxkA1jtHMDcGzpzQNasfOp5v5OiPvaHQrMO9s+cxdDbVr6UXkoPfwfoxl3jNGaaQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTaaYHGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTaaYHGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C94C4CED1;
	Fri,  6 Dec 2024 15:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498255;
	bh=PkUdku/QqzT7k64NowY412mfr4UIAfuup4EoKQe8DvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OTaaYHGMEEz0bsxWFGFqMB5vkPl3sEAo+x4vBjGGCAUjuOJoyy1qDNGPCfAuEkrnk
	 XSDOuvhQ40Lf9I0w8UM/HI+MnRC8E+EAMnlrno2FHnq1F4N1UIb77Tvu3YeFP9+9b2
	 +lebkpFZNp1KKcR20v8PHuyi8WGTM4HF4/IDa8M0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.6 531/676] media: wl128x: Fix atomicity violation in fmc_send_cmd()
Date: Fri,  6 Dec 2024 15:35:50 +0100
Message-ID: <20241206143714.104592299@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Qiu-ji Chen <chenqiuji666@gmail.com>

commit ca59f9956d4519ab18ab2270be47c6b8c6ced091 upstream.

Atomicity violation occurs when the fmc_send_cmd() function is executed
simultaneously with the modification of the fmdev->resp_skb value.
Consider a scenario where, after passing the validity check within the
function, a non-null fmdev->resp_skb variable is assigned a null value.
This results in an invalid fmdev->resp_skb variable passing the validity
check. As seen in the later part of the function, skb = fmdev->resp_skb;
when the invalid fmdev->resp_skb passes the check, a null pointer
dereference error may occur at line 478, evt_hdr = (void *)skb->data;

To address this issue, it is recommended to include the validity check of
fmdev->resp_skb within the locked section of the function. This
modification ensures that the value of fmdev->resp_skb does not change
during the validation process, thereby maintaining its validity.

This possible bug is found by an experimental static analysis tool
developed by our team. This tool analyzes the locking APIs
to extract function pairs that can be concurrently executed, and then
analyzes the instructions in the paired functions to identify possible
concurrency bugs including data races and atomicity violations.

Fixes: e8454ff7b9a4 ("[media] drivers:media:radio: wl128x: FM Driver Common sources")
Cc: stable@vger.kernel.org
Signed-off-by: Qiu-ji Chen <chenqiuji666@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/radio/wl128x/fmdrv_common.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -466,11 +466,12 @@ int fmc_send_cmd(struct fmdev *fmdev, u8
 			   jiffies_to_msecs(FM_DRV_TX_TIMEOUT) / 1000);
 		return -ETIMEDOUT;
 	}
+	spin_lock_irqsave(&fmdev->resp_skb_lock, flags);
 	if (!fmdev->resp_skb) {
+		spin_unlock_irqrestore(&fmdev->resp_skb_lock, flags);
 		fmerr("Response SKB is missing\n");
 		return -EFAULT;
 	}
-	spin_lock_irqsave(&fmdev->resp_skb_lock, flags);
 	skb = fmdev->resp_skb;
 	fmdev->resp_skb = NULL;
 	spin_unlock_irqrestore(&fmdev->resp_skb_lock, flags);


