Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85B21A76A4;
	Tue, 30 Jul 2024 17:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359809; cv=none; b=Ob9uudv19oB7WeeVxVyvJuaUVSKCtbWGg4PGm6BzuXDUKs0KQb6AT/o/TqfXdkq1spEj978FtuFG5V9dg+WMOBmwEQM0aajXzvCjcVGMbSPTFhVW4Ega7UCpRidmUVSfQroOnfUv7ITW8Bzj6xJjjFrR+1eMOAfO2SMKE5TDA0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359809; c=relaxed/simple;
	bh=pGbBrexbyea6SbFFQFvw+5MtneppeL60d4/2gIeP2A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RM7hPsdyoUaJ6vK145mXApGzPzQMqoAHDwWWz0BoqZiAhpbARaQhCcyrwWIW9fyOrLZkabTuCDURHtYghZ0F+hfrW2jJ5+da6In0iZVD8no7N/c45Rn+QmrAO9YJdcSL/v8+Ur8d0thT8XmdWAEuH4iGxgzpGBsPNXyGS5nPsW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j24jsTYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j24jsTYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70269C32782;
	Tue, 30 Jul 2024 17:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359808;
	bh=pGbBrexbyea6SbFFQFvw+5MtneppeL60d4/2gIeP2A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j24jsTYE+3h9QSFVMzHKuIXjxAlv/W3pwy1n6jrY9eRlhtJvGUaWaPTCxdE01ClnX
	 UjWDYdSY06bzmcdMO6g1PBJy/yCx0fXLi6Bkr3ScGwh8ICQ/gYJ2HR1p7nBc3hr97T
	 CIIfW+vPVhnd9QpIz9EqVynijZkPc65bACtuouKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	Csókás
Subject: [PATCH 6.10 513/809] rtc: interface: Add RTC offset to alarm after fix-up
Date: Tue, 30 Jul 2024 17:46:29 +0200
Message-ID: <20240730151744.997765883@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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
index 5faafb4aa55cc..cca650b2e0b94 100644
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



