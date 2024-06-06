Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D996B1991D0;
	Thu,  6 Jun 2024 14:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683670; cv=none; b=njU5kfrWHI2DUA9W+xlWyKP/Eq6cpKQZGZKYj5PXHESdUNKIfIMbpXXYmOir7ugBvExmRXlsmK+PsL8+bVzzHqsCHaSUnaFnHWsiMTQklZbHX7lCk7gTI+9a5GGCPnY8Ga8PMu/1DnnZ6NRRfCCBsubp82QcbzFYHGkzbvA316s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683670; c=relaxed/simple;
	bh=2foP6/qUVGhH0xBoVPUt/w8LZNaOk2dvZP+I2QCzWwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9ieXSq40vhVdpmTRhPlyoenm0V+PjKr5KcYBufCH7Zwyw5Bb/yxxKq5cxftFeKhNd0Ch0ODawZ20tXrAfHgaJASn+a6nrCNR8gQuOXjBv7vyjbTBgo3lObtLmOSqYsrho2RMo8XBcYB9/jV8mkSFNeiv2zTXqHPaoaa2drSCE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUTODIUD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUTODIUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9395C2BD10;
	Thu,  6 Jun 2024 14:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683670;
	bh=2foP6/qUVGhH0xBoVPUt/w8LZNaOk2dvZP+I2QCzWwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUTODIUDPRQk9Tdot7ovJrEkVFRopu/uqjttwecvGFhipp7T4C4ZS5GuPSvHZESLO
	 RojWhmykaUD/K/SAcfoBn8xBImhmRc90dFg6ghzCnxd9QzXjJoZHdqbnLyn5fRNdfg
	 S4f6ss08iK50IwWRDhdeEdEwBOgCN71t2bdjupm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 559/744] Input: ims-pcu - fix printf string overflow
Date: Thu,  6 Jun 2024 16:03:51 +0200
Message-ID: <20240606131750.392773124@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index b2f1292e27ef7..180d90e46061e 100644
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



