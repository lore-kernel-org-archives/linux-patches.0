Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D2366B5E;
	Tue, 14 May 2024 11:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687398; cv=none; b=ukZTYy+dcjf7y4uDPXCFH3DpYQO+VdbVAfzGMVqP3ew35v454NjE6L0J5Ly8nEyRVe6TOVAPfMJszpyFyCxeOTHBcJP95wajAiYUDvwBielFI+0upNX/gppmjku0cIrjocz1e+YAbJkYzTEL2PH5FV94Eb7kY1jFQQtbAJA6lOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687398; c=relaxed/simple;
	bh=DAeinNjlOLEv/NB1u7UUSuttkD9GPpiPiwN41MT5qJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S98yyyzLxkZj0xlAiPkeHeYaGCRzY59HmdnWL5cERyIhj9OTobVia9igy8Kp0fJF6eeP1OnlQ+hG4VCC50KfPznh1eiAKOy0PXnHAnN6nZwSx66b2JfmdUPGyZqTGnT8014a3Zy8njFn/0Q4NGcgNENUY6XV0r1gQ4GW8oU/BEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Es/adYI9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Es/adYI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60876C2BD10;
	Tue, 14 May 2024 11:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687397;
	bh=DAeinNjlOLEv/NB1u7UUSuttkD9GPpiPiwN41MT5qJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Es/adYI9NvQI48QcZVqnHhm6rQoVgdyN+n9pxhTkPYpqTxRVjmsv0HPGifhNTeahC
	 XNtrN+FxAlLKl9k+N2sAJ+dvZJsH9+orzDTDJ27dyXA9y0kXkTqIYEm1oK6VDdzk0I
	 GiKHgoWgV+kDY4d5toAQ/pu9dqkh3vI61POgYU6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Savic <savicaleksa83@gmail.com>,
	Marius Zachmann <mail@mariuszachmann.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/111] hwmon: (corsair-cpro) Use complete_all() instead of complete() in ccp_raw_event()
Date: Tue, 14 May 2024 12:20:20 +0200
Message-ID: <20240514101000.248789394@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 78c93c142fecf..7000a6af5092d 100644
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



