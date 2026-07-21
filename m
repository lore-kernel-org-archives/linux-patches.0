Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAF9435A96;
	Tue, 21 Jul 2026 20:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665473; cv=none; b=cF7pdwpwaMwNQP1iThbpkEAnc+MMXyFjruP7Y910LgkJht4R4Lm4SEsXjsxLsIhSqSAAHBRxdXdlmuiD2pzD4csz0Hw3YZBbjZepE8iBlpSGLq4JzRrhtfT45B+l/ml59tiV5xGI38SelN0NzqVElHjSpB3nWV87g/E0/LH6Tyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665473; c=relaxed/simple;
	bh=bk2sUnWhBHmheXApjpRo2oSE0ktFEwjrtTgXlTcYpVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDAwJ6Ew+i6I99R/YM1cpz5hw1t5gX6/2eA4mjZsD8lQ8TfWvtaCPWIN2tNoOsCkkQmn9J+k2QCsSNv464LC5t0/E1UnshcuM7lHP2a1NiMUiWu9UsEzMGjgk/7vm6cFuZfURbHGxhSqhOjhLMBqmUDQTBzZS3AzDwztYqAIuO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ff1+NRm0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ff1+NRm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC071F00A3A;
	Tue, 21 Jul 2026 20:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665472;
	bh=5bFqD3Fl2TRMg8wdZilIrYWLMK0UOZLcbGhJTMfadm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ff1+NRm0jdtzwOHHuAmhdGSNZBIwT6//x2HAibNzOdFfx1tV4R9Kf0l1YT13B3Q2p
	 XF2q03U/D6wkUAmXiSMN+i/EeaOU0xuzBac9MPhxq0ra/wMKVpllBaHO2K99VKtL97
	 5/RqDFkwMRTKwuIRii9fYmfP10paNFBDIaSBqgPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 0315/1266] Input: mms114 - fix multi-touch slot corruption
Date: Tue, 21 Jul 2026 17:12:32 +0200
Message-ID: <20260721152448.884479312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


