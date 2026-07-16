Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6E23BCD11;
	Thu, 16 Jul 2026 13:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210291; cv=none; b=RFmpEuvz9WjGUN18RKMWY2DkeCdg1nDhRNKrOomXwuZpEwvETwpt77iMsBucfSJmmUi6denbIwq8z3xDx9vsiNaipEOlI0HA9R6HA9AIu2/3i2oWtPbOyGFLrEsF/0UimaQEocBaOsn62e06NVfEfetFY/kzxac7zStgknj8zpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210291; c=relaxed/simple;
	bh=cRB2Nw+PgIllDYKx3TorW7yQ5YwZYpSO8YxWNON5ZA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIQ3j/a2JdqNrAfFpdLPd+/MdjxKIyfrLB56AAezqOvgAdOBfbzhhtsM/nUYiWpl2Bwdln2l2bbQZ0STX00NUoBymRK0jV5eLSi07Yel8ZZVFsSVheBnEUy3glAmck8hsHxKFOwx38+R3fKFHjQanaEJRqte0XASn3QPP4CO2fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+SPk6WX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+SPk6WX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A911F000E9;
	Thu, 16 Jul 2026 13:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210287;
	bh=x4VmuXejiZjboRdwBHx9WKdY5VzM4gAP6o8gDFN3z4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M+SPk6WX/qGQMyhsklLsKJV8n+AVAf9T6G+LV8QyE9Qb5/h/FFccQYWW3waMwNbaS
	 bq9Ssd7WlGFOfs17xiMUdbUWr8Xs4kBULGEam8c5o+sd5aT3IjHqIat8Mmsw8ZdFs/
	 DQToOeELf7mnUJXtU1neHnqoX+kRmObXTaKyMFt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 492/518] Input: mms114 - fix multi-touch slot corruption
Date: Thu, 16 Jul 2026 15:32:40 +0200
Message-ID: <20260716133058.608642274@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit adea84ee6cdea611146c4251d3c1616f5a09feca upstream.

If the touchscreen controller reports a touch ID of 0, the driver
calculates the slot ID as touch->id - 1, which underflows to UINT_MAX.
This is passed to input_mt_slot() as -1.

Since the input core ignores negative slot values, the active slot remains
unchanged. The driver then reports the touch coordinates for the previously
active slot, corrupting its state.

Fix this by rejecting touch reports with ID 0.

Fixes: 07b8481d4aff ("Input: add MELFAS mms114 touchscreen driver")
Cc: stable@vger.kernel.org
Reported-by: sashiko-bot@kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Link: https://patch.msgid.link/20260704060115.353049-1-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/mms114.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/touchscreen/mms114.c
+++ b/drivers/input/touchscreen/mms114.c
@@ -165,7 +165,7 @@ static void mms114_process_mt(struct mms
 	unsigned int x;
 	unsigned int y;
 
-	if (touch->id > MMS114_MAX_TOUCH) {
+	if (touch->id == 0 || touch->id > MMS114_MAX_TOUCH) {
 		dev_err(&client->dev, "Wrong touch id (%d)\n", touch->id);
 		return;
 	}


