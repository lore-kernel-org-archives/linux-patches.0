Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7916543C063;
	Tue, 21 Jul 2026 22:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671285; cv=none; b=Mc0U6yO8evZdI73sOsf928q0l1U3KWapiLT8Ir2r8i8n8KnPZjfyx1m0Gd6rVARxlaXcg8Xs0utvyijES4SnW7R44oeo3tL+b4Z3lgBvfzW4MI8fRdraL3225vUIY8yHUFZqIt0GNR0P5rDBUerYzOjIWmDQzo2KDxmBpOwEdC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671285; c=relaxed/simple;
	bh=9wc6zj1Ij4cQZP1MocQPADC1ow3CEbaDQ+giUCyiIF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTx2SOFApwRktnR8uApwSXPqOv/N15cI2WY6NnQKmqeBDs+x/pOnnDyWMWGOFY9AgUJ3x/SQkqUJAk00q80qHh1LuceMgd6YvsVN2Ts8qn1eLJmi1vbPDRxXSBVkiMx57YBWvzvHnN4Lf3GYIL5dmBuBp1L0evAtdwgF+qel9d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTGIm6Y+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTGIm6Y+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECD71F000E9;
	Tue, 21 Jul 2026 22:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671284;
	bh=5URK7IkGdRjBiSPGM9GVNZcGECbutYDPyw95/rrqvLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HTGIm6Y+1vuzcHnFfCvbyekKVtr3R41HnZlNl2x+6CKHrnv+FcYur/zG5qDeK4TDj
	 WVhcMO1E2pQciIMJb8csoVDlZik5XzCqnVHXzGjlk3bsjzTE8xfzPxlToXlb1far3L
	 j+uAT0IjOAPQ4rt+FdAPm+45zb1sisyrWO4cB1EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 189/843] Input: mms114 - fix multi-touch slot corruption
Date: Tue, 21 Jul 2026 17:17:04 +0200
Message-ID: <20260721152410.267420920@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -162,7 +162,7 @@ static void mms114_process_mt(struct mms
 	unsigned int x;
 	unsigned int y;
 
-	if (touch->id > MMS114_MAX_TOUCH) {
+	if (touch->id == 0 || touch->id > MMS114_MAX_TOUCH) {
 		dev_err(&client->dev, "Wrong touch id (%d)\n", touch->id);
 		return;
 	}


