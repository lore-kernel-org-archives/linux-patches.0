Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11161078F;
	Tue, 30 Jul 2024 16:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358294; cv=none; b=N5TCuLl3wkTdpBYjMIa99Jidl+ERFOU/CWPu1y/fFcXqHMRltbsjswvHNpdZ5W59leYtPUhf4y37e8nx+gpw85kDL7r+SwfdNotntN7xa8ky+0MlLVZcJy/WHapjgPYva8b21n4tJaNMvRkTGGsI4MflfnP9xpRCg0ly1QnZst8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358294; c=relaxed/simple;
	bh=He09Z96QXrqAtSVOpxUw2BtXhFIVhUJUuUi8M9dyrqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D97N7xCRtKO4p6U22Pu+rvkBfzSIOhtKiK0Qh6csYgQl9j1tpj1jQl6j9tlUSRaiVPcdUV5P+/0V10sp4YtR6icOD6Usj7LtyiMKxAgSf75q+n/TiegxevS17C2Il4iHQD2LwxTLz/g3/Fi9+id7K24Hex2OsF/5yl8AK1J3LsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WLNkQPeB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WLNkQPeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688A7C32782;
	Tue, 30 Jul 2024 16:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358293;
	bh=He09Z96QXrqAtSVOpxUw2BtXhFIVhUJUuUi8M9dyrqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WLNkQPeBLspMSH1sjyg/WXycVX5CoBpl4H4xs3aEcUeCc5HPGYx1v60plNK8CqdAT
	 igh42zxulfEZTth3l8aBZ4TTYXl0FnZpLOcj6+YOXXJM6FFSwGdi34PRS1BZeUHXDs
	 qjHLEBhUQ/koKnuwfz+hDqisyEMdISnO0wWaKy4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	Csókás
Subject: [PATCH 6.6 348/568] rtc: interface: Add RTC offset to alarm after fix-up
Date: Tue, 30 Jul 2024 17:47:35 +0200
Message-ID: <20240730151653.470589408@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Csókás, Bence <csokas.bence@prolan.hu>

[ Upstream commit 463927a8902a9f22c3633960119410f57d4c8920 ]

`rtc_add_offset()` is called by `__rtc_read_time()`
and `__rtc_read_alarm()` to add the RTC's offset to
the raw read-outs from the device drivers. However,
in the latter case, a fix-up algorithm is run if
the RTC device does not report a full `struct rtc_time`
alarm value. In that case, the offset was forgot to be
added.

Fixes: fd6792bb022e ("rtc: fix alarm read and set offset")

Signed-off-by: Csókás, Bence <csokas.bence@prolan.hu>
Link: https://lore.kernel.org/r/20240619140451.2800578-1-csokas.bence@prolan.hu
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/interface.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 1b63111cdda2e..0b23706d9fd3c 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -274,10 +274,9 @@ int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 			return err;
 
 		/* full-function RTCs won't have such missing fields */
-		if (rtc_valid_tm(&alarm->time) == 0) {
-			rtc_add_offset(rtc, &alarm->time);
-			return 0;
-		}
+		err = rtc_valid_tm(&alarm->time);
+		if (!err)
+			goto done;
 
 		/* get the "after" timestamp, to detect wrapped fields */
 		err = rtc_read_time(rtc, &now);
@@ -379,6 +378,8 @@ int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 	if (err && alarm->enabled)
 		dev_warn(&rtc->dev, "invalid alarm value: %ptR\n",
 			 &alarm->time);
+	else
+		rtc_add_offset(rtc, &alarm->time);
 
 	return err;
 }
-- 
2.43.0



