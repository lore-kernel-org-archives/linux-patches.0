Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C840469D2F;
	Tue, 14 May 2024 10:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683389; cv=none; b=gHHibLLZfTVCEDAS1yEYa2W9Maz8NhS3deM4QgfIUQOcH/z7SXA3Gu7npjfGid/iPGC7FOu7p5PMaO/1zFYtlfdFKqQy60ZWAaJED3tNywTtAZi/9NE0817C/4oCGU08xnPNx/FFzEBzenrDQkJGHc2xIG6fNZCu9zsk+8i6q74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683389; c=relaxed/simple;
	bh=fuMiy9Sr4Nnju//zgehr/mLKsVBYh25/RWcbTdMfKfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0mBr90bk69rxa9hWnxN7zdc5sm4JSTCtGO0i6Y1/WC5GQH4ICgT0LuCd4ihmvXNF5uXOyQDFNZFnTJrU5ua8xt+wUVYyb6X3o3w9Dr9dgBrInouRUJuiZOPNXAH5c6ET5bCs7/Ktnm79kcjAAr4hwUWHUrTMJAFhCKu7KOF0Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDHHxKyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDHHxKyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC54CC2BD10;
	Tue, 14 May 2024 10:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683389;
	bh=fuMiy9Sr4Nnju//zgehr/mLKsVBYh25/RWcbTdMfKfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qDHHxKyYu8qpp8InuxHz/auT6HyTVEHJqBMr7ZWx0/BrvQGcvHg1Ob3uIt4A7pt9S
	 H0wG9aHtPBq//KgJJfoqEG6wzxK+4LGT5th0Y8T4a82io2uj5pvlzO0P54AHrHbMIz
	 9gqh6NoTH1kSFANO84/+XPLwgmkEfHbfV2YZiNS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Savic <savicaleksa83@gmail.com>,
	Marius Zachmann <mail@mariuszachmann.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 208/336] hwmon: (corsair-cpro) Use complete_all() instead of complete() in ccp_raw_event()
Date: Tue, 14 May 2024 12:16:52 +0200
Message-ID: <20240514101046.458105206@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 8d85f66f81435..6ab4d2478b1fd 100644
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



