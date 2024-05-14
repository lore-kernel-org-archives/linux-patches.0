Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B612C54BFE;
	Tue, 14 May 2024 11:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685425; cv=none; b=s5sMVsyBLMKTeclyk7lJ0swUl4glPd9RmW8QM2zhbJd379aIxuEke1TwFDbDB4zCfGpbhR/oRKJbTinIEcgdKH2XRkfFkcL+WZcR68cqNoDIfcg86VafzmZUmSMV+uZIomwnAczXTWuMXlyPiyReajLq1qN50h7TpEighxqr7Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685425; c=relaxed/simple;
	bh=5tG0Hu25GxnflYGqLs4aVL4L7/67Ojxv1gxWT5qeUfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbOFuqxRFLQXLxJIuS5RIFbyyf52J037B5+298PtREvWQ6EhZrn/iYQ+kg8NxYHD6rg9R6bCylchBcsMGx02qPXiFVX+ShA4JQ2JGrKbWbLCjUjMqAj6G3RYU+h4+km22990zODoWBpFwBEX5biHzvDh1WO/yIiEjvQiQQeQnmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qcTQXNvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qcTQXNvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127F2C2BD10;
	Tue, 14 May 2024 11:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685425;
	bh=5tG0Hu25GxnflYGqLs4aVL4L7/67Ojxv1gxWT5qeUfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcTQXNvGM7belzPZTfZ59jZ2Q/LWaSN5J5zpfV+ZsUTIV5xoUp4dAluspS8NNynoQ
	 ZS50mn1X+Y7peCcqgk7qjCYKYYARudA2l4eoQkwG1KgCwccNRQjlySXGCGlgSH2rSF
	 1PuN+J+2Xv/7Tybs80bViZ3BMY/6nbQyx3GE6nSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Savic <savicaleksa83@gmail.com>,
	Marius Zachmann <mail@mariuszachmann.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 186/301] hwmon: (corsair-cpro) Use complete_all() instead of complete() in ccp_raw_event()
Date: Tue, 14 May 2024 12:17:37 +0200
Message-ID: <20240514101039.278526705@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 34136d1b04764..e65e3825af974 100644
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



