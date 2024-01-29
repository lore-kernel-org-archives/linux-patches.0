Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFF07222D;
	Mon, 29 Jan 2024 17:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548511; cv=none; b=lFYXw2kzkXSAPOMA6knsslgmMLm0W5sv4Pa5iFbIyP21a/1wS4PYF6axXWmtVVOyCOhxon5SKfQ0ep/LH1cl6TWiDae866z6vrDLcEp4WA3LJXA+G1Qi2mmYTUbwH5D96a4VYUA3nPdzSuUPS7vAFfZehL9U3ueF7PchB0rY+/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548511; c=relaxed/simple;
	bh=92pVYgjW2+zEhN4JsnnCXWcO0R03HAX1Rw03yaebuTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BvJXBL8SqH1CTmrlU8pk1UZQmryIBbUoGsm5UHq4/vFbOxw7/2IWnY9+puF4juez8GxywD5ZEKdsdRzVlM05cg3OOCaPX7vfh3cKiN52rypsDHCg/d/fHP93YqsZJ+bd+2EfgOCPYzhDrCVChbDZoI79reBZvRmaqvw4958dSNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y2e0eUOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y2e0eUOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3F0C43399;
	Mon, 29 Jan 2024 17:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548510;
	bh=92pVYgjW2+zEhN4JsnnCXWcO0R03HAX1Rw03yaebuTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y2e0eUOh88PelvtsiCwA3qR7xm95CDRwZHzJy8AIqLOqywbqSco4D+4QT1QdV2/mE
	 ZH8FYQyGOlWqkjL7mj6ZCORMzSCnOBU04erqeWe6Os1imXlm/SzEouMA4wGnTeiOtl
	 HOzdB75jfZcUkEb7vpC1vflbxyBMYSL/6d+Qobuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 117/331] rtc: mc146818-lib: Adjust failure return code for mc146818_get_time()
Date: Mon, 29 Jan 2024 09:03:01 -0800
Message-ID: <20240129170018.351896856@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit af838635a3eb9b1bc0d98599c101ebca98f31311 upstream.

mc146818_get_time() calls mc146818_avoid_UIP() to avoid fetching the
time while RTC update is in progress (UIP). When this fails, the return
code is -EIO, but actually there was no IO failure.

The reason for the return from mc146818_avoid_UIP() is that the UIP
wasn't cleared in the time period. Adjust the return code to -ETIMEDOUT
to match the behavior.

Tested-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Reviewed-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Acked-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Cc:  <stable@vger.kernel.org>
Fixes: 2a61b0ac5493 ("rtc: mc146818-lib: refactor mc146818_get_time")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20231128053653.101798-2-mario.limonciello@amd.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-mc146818-lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -138,7 +138,7 @@ int mc146818_get_time(struct rtc_time *t
 
 	if (!mc146818_avoid_UIP(mc146818_get_time_callback, &p)) {
 		memset(time, 0, sizeof(*time));
-		return -EIO;
+		return -ETIMEDOUT;
 	}
 
 	if (!(p.ctrl & RTC_DM_BINARY) || RTC_ALWAYS_BCD)


