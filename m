Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336CE31618A;
	Wed, 17 Sep 2025 12:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113815; cv=none; b=G5sQtB/YzbzJfS/Wr8kN38WZ4vWfP/AnrZUzChp6AmB8MLlpjwkATyBgdFBSUNBzTpKMTIuVMbgTG3gBemHujgivHOgDRx02zPVpC/8/y04tIWeHxxjCOMx5mf7r0Z/N5ag5agF1WCU0UlTnZ3yp6I4Mki4BKVyQputJcfH3AvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113815; c=relaxed/simple;
	bh=KUq72v93eMSsA6ng1gWaKRnPviHFJ8ERVXiKgrFOQ7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JN55v16763oHumiVG56LltM+zyiu6XyKCn/3A9Li8bm+0k/FjN8lCyLdQqAxV65d3lFjKKWf0vSFXdDTGXLjCT9sCzo0CQe5aW3I3yUa2dvJf2BFH7srxPOeTTxnMR265n4kSbqyNDZqvXlc6KwTc4eY2RvtZuWpRh/vrJkXJp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYoBKlIu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYoBKlIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1FBC4CEF0;
	Wed, 17 Sep 2025 12:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113814;
	bh=KUq72v93eMSsA6ng1gWaKRnPviHFJ8ERVXiKgrFOQ7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYoBKlIu1V+uJqEVJ56rEpC3cPk2CNexkRP2pZwyiJRjgfbBSNg8jLN3/5ZEUyl1C
	 rUoKyHFkjknd6eyRuFF2R8o3yyu1D2Oi5ioY4bVGGkRoAOlnHv7Ghba8xvlgrbuT0c
	 /GWX9LnlTjMQ7bPwZijzUnhBpiUDk9Os/Se8fg60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff LaBundy <jeff@labundy.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 059/101] Input: iqs7222 - avoid enabling unused interrupts
Date: Wed, 17 Sep 2025 14:34:42 +0200
Message-ID: <20250917123338.270802182@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jeff LaBundy <jeff@labundy.com>

commit c9ddc41cdd522f2db5d492eda3df8994d928be34 upstream.

If a proximity event node is defined so as to specify the wake-up
properties of the touch surface, the proximity event interrupt is
enabled unconditionally. This may result in unwanted interrupts.

Solve this problem by enabling the interrupt only if the event is
mapped to a key or switch code.

Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/aKJxxgEWpNaNcUaW@nixie71
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/iqs7222.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/input/misc/iqs7222.c
+++ b/drivers/input/misc/iqs7222.c
@@ -2430,6 +2430,9 @@ static int iqs7222_parse_chan(struct iqs
 		if (error)
 			return error;
 
+		if (!iqs7222->kp_type[chan_index][i])
+			continue;
+
 		if (!dev_desc->event_offset)
 			continue;
 


