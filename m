Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851E930FC33;
	Thu, 16 Jul 2026 14:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211515; cv=none; b=M1mYk0BNYlku4Q379Il9UdJA/Wisvesc/R+hAqtDIG703DgbiHvCeOE4SN6saKtT/JuxlXnfSdTkNOBzqL9TH1fLGxs8ECljY8Y9qNyyumBrVcQFdFexOuo5rdeHOhQodxKrigYm4sUsFydn3xVkAyvivDpmpckK+LunP0sxBlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211515; c=relaxed/simple;
	bh=2JgCpRtNIep1BGC1E0fjoAjcX8EAYbtDjRmdcaIwjFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aINWyMXpNcJl9keQKLK04zShcxBNlOgf5jaEHh3wirox74KAeFhXEwOXSeVE5KHRVdUnnX0wdDEeaXPGA3y8zDvqR47bRYpEu95WtVUGwieJPBmp33yH1EHG2/Z+hDfusmC6pjyHjI3u+YATiBXv1YBOee77t1zZefTlCgi8G58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLTWWfOh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLTWWfOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2761F00A3D;
	Thu, 16 Jul 2026 14:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211514;
	bh=o7uNQCdAdP3vGZfjzBYJRKOpLTtjSD6/tS8GvhpfQwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLTWWfOhCxLSOYOt4zKiErxIN/uSml4MLIVW5SD8OSmQz08S/SblxU9Mlmwm4Pek2
	 6cs97RKjHT6MBXJC7kgPq9pt0FIa+q56Wxlt58F4ReP0DaqkV2qf3MgqEbAIwIMQVk
	 EHKF/5Rok/PFGUurZQWmq5kS8q+j0yUaX/rS1CQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 455/480] Input: mms114 - fix multi-touch slot corruption
Date: Thu, 16 Jul 2026 15:33:22 +0200
Message-ID: <20260716133054.667976116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


