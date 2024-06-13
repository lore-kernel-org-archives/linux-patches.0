Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8A944C6F;
	Thu, 13 Jun 2024 12:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280136; cv=none; b=U2/edjFmirG5ayJXoDkLR377bDcSV7r2rUQ7kcwWKWDTr24UaXoFqlcSQg0ND2nbQ4rV20hWiNqmFPAAdGVf/v2ngiik8VDLzVzv82awCeK1iPcebYUzYUhtcoQFPSrS57o38aIi9UUh1JjJyclsjcs3j6JlmN02hN0HtznV2Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280136; c=relaxed/simple;
	bh=jEwlagI5KE8tT1BM6moWcVAOWZvZxFT33B6Y7/zXZ0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hx4VTVNXzCjB11JY4ZndEDhFcF0pk09ueiIfEOi1+aGtHbTu6xzGx87THQO/qfwv4pGrsrE3FT32FLMYgAyc22ECpGpigGSDbNS35UZMs3TX3mOO8ZLnKSdoYDZru0rk1jAiiN0VgRNk2RqwdWk9fyBjnkm0Q4O4iRAnrFlumqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w4m24B9I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w4m24B9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4B9C2BBFC;
	Thu, 13 Jun 2024 12:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280136;
	bh=jEwlagI5KE8tT1BM6moWcVAOWZvZxFT33B6Y7/zXZ0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w4m24B9IckkOFEixPS3wdsU5D6JIjGI2Mv1gmApbKH5OE0Baes156PKw9iPEoeD7b
	 5g0F8PqgR59SFMMvupyu4bt1vAD0ROiDEfMSLvmBluJnxqrBMK7wEirqBlaQen+iC0
	 aeRKBDRRdQ8NW91rW38YZ/cFDUf14j515jR7IOQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 124/202] Input: ims-pcu - fix printf string overflow
Date: Thu, 13 Jun 2024 13:33:42 +0200
Message-ID: <20240613113232.548148919@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit bf32bceedd0453c70d9d022e2e29f98e446d7161 ]

clang warns about a string overflow in this driver

drivers/input/misc/ims-pcu.c:1802:2: error: 'snprintf' will always be truncated; specified size is 10, but format string expands to at least 12 [-Werror,-Wformat-truncation]
drivers/input/misc/ims-pcu.c:1814:2: error: 'snprintf' will always be truncated; specified size is 10, but format string expands to at least 12 [-Werror,-Wformat-truncation]

Make the buffer a little longer to ensure it always fits.

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20240326223825.4084412-7-arnd@kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/ims-pcu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/misc/ims-pcu.c b/drivers/input/misc/ims-pcu.c
index d8dbfc030d0fa..4dfed127952d3 100644
--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -42,8 +42,8 @@ struct ims_pcu_backlight {
 #define IMS_PCU_PART_NUMBER_LEN		15
 #define IMS_PCU_SERIAL_NUMBER_LEN	8
 #define IMS_PCU_DOM_LEN			8
-#define IMS_PCU_FW_VERSION_LEN		(9 + 1)
-#define IMS_PCU_BL_VERSION_LEN		(9 + 1)
+#define IMS_PCU_FW_VERSION_LEN		16
+#define IMS_PCU_BL_VERSION_LEN		16
 #define IMS_PCU_BL_RESET_REASON_LEN	(2 + 1)
 
 #define IMS_PCU_PCU_B_DEVICE_ID		5
-- 
2.43.0



