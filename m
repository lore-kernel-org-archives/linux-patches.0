Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAC6423A8E;
	Tue, 31 Mar 2026 16:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976341; cv=none; b=dt8cNg1HG989UaosgT2P2uyFMAYKUK6C97WPEJu7Qqmqu/3FTVl0lfM38ABdAD8cUsxER1FIW4StCx+3pCtbSgoSrateW4kLaVpyiMQS+/k2FGzShHRWsSMpEmv2lL7zZLfJFbN1ck6oRrEP1w6daZRMkI9CbOFdfusLaJnZEu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976341; c=relaxed/simple;
	bh=1T9wx893O04FqG929rnw6paWFaEq5lFY/PZE1o2x2+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RiCcB9DR2+wT2NVuyKaHwaNj4aFIXY0bpl6/7zZn2wFixXpjIgIWHbViMg1uE1fzBbtbms+YmB0r7heo7RJDmMOGeK21skICBkV06K1dMHHcRTXdRnoqHooGXhmG++tajQGM5YRGEEVq1AYrOvoIwzfFVL8AApUNfCbf+hQ9QpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zOPtOMDk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zOPtOMDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EB0C19423;
	Tue, 31 Mar 2026 16:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976341;
	bh=1T9wx893O04FqG929rnw6paWFaEq5lFY/PZE1o2x2+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zOPtOMDkiZfFG+VB4oiod+ZVzUIM6orRNPb887hF/pchYiP4m5yU5gLedrG7Xq56Q
	 /3BML1kB8jV+kiIX7LVvD9ujv+QprLEklxChTzNXYCOtAdA5oOMF6BdSOwxDVq+Eyd
	 6ChmLK9R0b39o4t/F6Tpos7ZDXQ/iV+BQMuPqWNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 054/309] HID: apple: avoid memory leak in apple_report_fixup()
Date: Tue, 31 Mar 2026 18:19:17 +0200
Message-ID: <20260331161755.475596985@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Günther Noack <gnoack@google.com>

[ Upstream commit 239c15116d80f67d32f00acc34575f1a6b699613 ]

The apple_report_fixup() function was returning a
newly kmemdup()-allocated buffer, but never freeing it.

The caller of report_fixup() does not take ownership of the returned
pointer, but it *is* permitted to return a sub-portion of the input
rdesc, whose lifetime is managed by the caller.

Assisted-by: Gemini-CLI:Google Gemini 3
Signed-off-by: Günther Noack <gnoack@google.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-apple.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 2f9a2e07c4263..9dcb252c5d6c7 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -689,9 +689,7 @@ static const __u8 *apple_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		hid_info(hdev,
 			 "fixing up Magic Keyboard battery report descriptor\n");
 		*rsize = *rsize - 1;
-		rdesc = kmemdup(rdesc + 1, *rsize, GFP_KERNEL);
-		if (!rdesc)
-			return NULL;
+		rdesc = rdesc + 1;
 
 		rdesc[0] = 0x05;
 		rdesc[1] = 0x01;
-- 
2.51.0



