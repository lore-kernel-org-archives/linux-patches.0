Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CA344AB60;
	Tue, 21 Jul 2026 21:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668712; cv=none; b=KdDazMFXN8xiIyKhrWNFFLNcKOfQ5eORNrYeXlkFX/1hUHvrmXuZ53tZYbmZbPimDHts/XS0iOk/MD0l1GL3eY4C+orvkit62Hwjd+PtFyDidTjetYy5GfRGWLgDN4aB/9YamlTtDUDNrUVqmZqYjyjXtLYNSKlj4r2xluCj4SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668712; c=relaxed/simple;
	bh=7rVQIMS8SUW6BT7Np1pRwFGumC+PhkoltbYM54w3Bd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GsjR6K00qL4R0BdabxruRjGO1Fi+z1402kWbYEbHpGSZujc6+enTsJZ5ciW5MCzWo6hjHUHKBPfq1FNNMqpG8vMfP/SOkVlCIZ2wpuq80Wvqv7v0Sp+mjMHg5wM7izfVc14kuJw2Vvo6lA8EHc2wqI16iCWQCgK2s3ossXVNQ1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zap06yV2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zap06yV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACED1F000E9;
	Tue, 21 Jul 2026 21:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668710;
	bh=zdXadwuzdo7dc+XMW37QryNoeQdv8KnthlX5qo2jkow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zap06yV2BYmfzVjl0cNAkKUtscRwhE0D/Nfskyc4CoFL10hw9X6mrzpGwzyrD1frD
	 R2PlD6B2wIxfLLAaxLr+o0srUKAW/pVwoRpXq+JiPIcph/t7qq3tzUMTzaqvbZLYns
	 eqdvBNQSVOk2OE5pdAXQKpr3s8mlbx/OmflLzeJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 0242/1067] Input: mms114 - fix multi-touch slot corruption
Date: Tue, 21 Jul 2026 17:14:03 +0200
Message-ID: <20260721152430.015682138@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


