Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85090159591;
	Mon, 29 Jan 2024 17:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548256; cv=none; b=HOO6VJq+OIa/9aSEKoUX0+bV0F4RYW4A3wo9IzB+9l+CC9G9dgpHWvMKb5uICeRS82S7LzVsWhgkKd6Xw7PlOxeYa2pIHc/GXj+qiChI1/j6FFbi2fvCBg/hIw/8p7eTKFKoTljdu2/Blvsb5fSpTU4kQfvBrisiR7u/QL2t2jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548256; c=relaxed/simple;
	bh=XNgvlxoqmVzkSXUjRF4cof8bG1XWvHYDhcfnjmhgInc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JzkEQgT4c7VizI79cnDOdLvb7KkAxLScRp5DbJhVKJqRjoaeeagb4CarcI67r4LzsVHqgnJtyAI85btHJusQS+Wr0qde3lzvHQYasIesIbmLzryz/CYjfXOwvejtUiUXCCWhiFF4N8xeyymJtyJ7XMbh69l05BckrqQSOfkVcQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x12Gie37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x12Gie37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4EEC433F1;
	Mon, 29 Jan 2024 17:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548256;
	bh=XNgvlxoqmVzkSXUjRF4cof8bG1XWvHYDhcfnjmhgInc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x12Gie37CA9hRsWq9WN2g7eiCCvREQclVAIXoegVHwpTZZmmiscq3KVWuyBxn9DUk
	 +xnQIPZr4bWnNjA/SCLwgJIWW4mLibVvmtoKEVB1KIBEFx4e+xQQujwARch6dFUAT5
	 mg6Fxahoj3hOFZed8BbXm1tZv/C3Lt2kNxgQ18/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 050/185] rtc: mc146818-lib: Adjust failure return code for mc146818_get_time()
Date: Mon, 29 Jan 2024 09:04:10 -0800
Message-ID: <20240129170000.204120398@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


