Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D69844AB9F;
	Tue, 21 Jul 2026 22:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673408; cv=none; b=ILgDetJ4lZSC70uHNBxcddepiFuaDsUjmg3I59nQOkC9mBWfkRhTsCI8xolj+CiizEDsI7RPRadIaPRVdRGBjpAgB+8hpuLXRyd2RFVPi4YD4qCkDeb+xuQunTPtIMtMDwgqAExkYOuRsLY2R9Iv+Dx82mHR9zdasmdjqxoGHI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673408; c=relaxed/simple;
	bh=Kao/+EEhUPLx8y3usdRSSEvZPy9gLVeqBjph92Z7fpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSzDEKqZ2zUCCyvIg4rfSokfM06g0hsTRIWSHKcos+C90A/VmFuam6u5yNQlwigExomA2fwNZ49rMwGncGpuRb6nMuJhH30DJII7ZNXC4+KUbDaVSBeA0XGoYNAaA0e50LRM+ZSohVD3dcFohVOyAQGftQPCSsdU+oS0E6bwxDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qm/7+mV2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qm/7+mV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2161F000E9;
	Tue, 21 Jul 2026 22:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673407;
	bh=oW15PbH0NFd6aqADEWdxbRi/OkiRhZ8mtjzzGF9tLnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qm/7+mV2rQ3kDcSGvrCoD6ExTI9DJ1nfVqP7/C6wWfEjehk5KCafVVrUfY0WYX9ut
	 8G0cSq5AJ/lP36xAlxLqDMx9TjcSGWHFUpGxw/ChD9IybPShM1kL/PCm9tVRVeRceJ
	 ec/QwPK88+DT61JOgA1GpKBC8hBDyt0+Wud+vwSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 151/699] Input: mms114 - fix multi-touch slot corruption
Date: Tue, 21 Jul 2026 17:18:30 +0200
Message-ID: <20260721152359.109610469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -159,7 +159,7 @@ static void mms114_process_mt(struct mms
 	unsigned int x;
 	unsigned int y;
 
-	if (touch->id > MMS114_MAX_TOUCH) {
+	if (touch->id == 0 || touch->id > MMS114_MAX_TOUCH) {
 		dev_err(&client->dev, "Wrong touch id (%d)\n", touch->id);
 		return;
 	}


