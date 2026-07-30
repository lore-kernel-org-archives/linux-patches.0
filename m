Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6983B383983;
	Thu, 30 Jul 2026 16:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427327; cv=none; b=Ine5EFwtSVkfYV83DY6RjxTG76ge9mz7dBBF9Bmh+4rqGkuO3wtzPfYBkYNpid5mHNG3PdGNrh0540eOY/A839bnECsViBSXRWeAAUWIZANpyFoXeXgUOjhXO7VEw2ddFCCinHsgqVi3wYh23H63JKkLzjFSpRlEW7NRMoSBTT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427327; c=relaxed/simple;
	bh=h6DEWstQFvKl5HtZ6nk257h6TReHOqfcOPZQfb7AUbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmDDvPsuRAHHEbRGwcdcFLV/GZQPf7uSsvzDH6Bd8tZSuAav/Hvo38VBK/nmLVfLLislTHQ8YJXljeaQ5pP1lr5h8zf3bHoFreU0efaQ5Bm0c7/fJewjXyWS/SDpec/RCtnxV9Tl9ByVNzwtblvO7t21eXRn3yZ0XBdj52WM5fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vxaa46OZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vxaa46OZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C1D1F000E9;
	Thu, 30 Jul 2026 16:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427326;
	bh=fzGuE+FCDawa3ra1NZsDkuqz+Dy9liSM2dwWfIK4q5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vxaa46OZAqXvEbBYy7xjH61vVwE8DDEB4hwLAmNYk+rCHHbHh7BQAZ5wRkFxXPueT
	 Lg4LRzpDN1eKfHpV74+fGh4iOqz5iXfBSsx7J1PRxqfqswtztq2x+Z/Fi4AJgXEr/v
	 Fay3/w2aQj82pS7HyFZV+lKHDwPBBK8dQqzBSnxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/484] wifi: carl9170: fix buffer overflow in rx_stream failover path
Date: Thu, 30 Jul 2026 16:10:26 +0200
Message-ID: <20260730141426.260492517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit a1a21995c2e1cc2ca6b2226cfe4f5f018370182a ]

The failover continuation in carl9170_rx_stream() copies the full tlen
from the second USB transfer instead of capping at rx_failover_missing
bytes. When both transfers are near maximum size, the total exceeds the
65535-byte failover SKB, triggering skb_over_panic.

Limit the copy size to the missing byte count.

Fixes: a84fab3cbfdc ("carl9170: 802.11 rx/tx processing and usb backend")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=5c1ca6ccaa1215781cac
Link: https://patch.msgid.link/20260421134929.325662-4-tristmd@gmail.com
[Fix checkpatch CHECK:PARENTHESIS_ALIGNMENT]
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/carl9170/rx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index 9a25c2a540b95f..bda30b1f940459 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -918,7 +918,9 @@ static void carl9170_rx_stream(struct ar9170 *ar, void *buf, unsigned int len)
 				}
 			}
 
-			skb_put_data(ar->rx_failover, tbuf, tlen);
+			skb_put_data(ar->rx_failover, tbuf,
+				     min_t(unsigned int, tlen,
+					   ar->rx_failover_missing));
 			ar->rx_failover_missing -= tlen;
 
 			if (ar->rx_failover_missing <= 0) {
-- 
2.53.0



