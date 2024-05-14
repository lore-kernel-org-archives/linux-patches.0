Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7DCF9D4;
	Tue, 14 May 2024 11:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687885; cv=none; b=IWDwsxyz+SCUu05rXLxvSJvW/qq6QkcNutoB0oUo96LJ4mQJc18RTTsfcdmsWuNxO70MsxivDerhYqiSYQuxiCAPsOya6Zbsm+izjmQq0prDAZV6BfqCSObV2I+cWHGR2u2RbMG1dnmEHygNChopTBsWZw33u2gybqaQcH9r9Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687885; c=relaxed/simple;
	bh=ISeYqwm0IIkRcfq+yxMWEZePu5AiDAab+mtztrHIxVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYBS/jS4CpqM1yEIlDRVHKtmV08qNMsfkUv54gQ21wdE2xOKBrB+5alVzvDLqiabjMrVzk2KezQG0clyvckUEBbWj4kx2Ql9WoM2FZXEXiANHB1RlsMcWTu8K/oJVaDRZAms0U+OH1S8WQC9/o+Os3fGRpBvljRRBexfqN9+kzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZIOIplF+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIOIplF+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66466C2BD10;
	Tue, 14 May 2024 11:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687884;
	bh=ISeYqwm0IIkRcfq+yxMWEZePu5AiDAab+mtztrHIxVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIOIplF+NbhLoTawaYb4wCe4+SQd1uQIzEWkC8odKKjbRrXH7wgd7BcggsvuUvjFd
	 IefjL2UfEJbSP1BUodqvE9FWg5Vjl+dD1o7OfXjabJSsCt5h+QcKHoPpq9y4WPJGct
	 gXLvsmNk1infCw+V96VKmDOg/gA7AeGjn+RGoxJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Savic <savicaleksa83@gmail.com>,
	Marius Zachmann <mail@mariuszachmann.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/168] hwmon: (corsair-cpro) Use complete_all() instead of complete() in ccp_raw_event()
Date: Tue, 14 May 2024 12:20:09 +0200
Message-ID: <20240514101010.874715286@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Aleksa Savic <savicaleksa83@gmail.com>

[ Upstream commit 3a034a7b0715eb51124a5263890b1ed39978ed3a ]

In ccp_raw_event(), the ccp->wait_input_report completion is
completed once. Since we're waiting for exactly one report in
send_usb_cmd(), use complete_all() instead of complete()
to mark the completion as spent.

Fixes: 40c3a4454225 ("hwmon: add Corsair Commander Pro driver")
Signed-off-by: Aleksa Savic <savicaleksa83@gmail.com>
Acked-by: Marius Zachmann <mail@mariuszachmann.de>
Link: https://lore.kernel.org/r/20240504092504.24158-3-savicaleksa83@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/corsair-cpro.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/corsair-cpro.c b/drivers/hwmon/corsair-cpro.c
index 0a9cbb556188f..543a741fe5473 100644
--- a/drivers/hwmon/corsair-cpro.c
+++ b/drivers/hwmon/corsair-cpro.c
@@ -140,7 +140,7 @@ static int ccp_raw_event(struct hid_device *hdev, struct hid_report *report, u8
 		return 0;
 
 	memcpy(ccp->buffer, data, min(IN_BUFFER_SIZE, size));
-	complete(&ccp->wait_input_report);
+	complete_all(&ccp->wait_input_report);
 
 	return 0;
 }
-- 
2.43.0



