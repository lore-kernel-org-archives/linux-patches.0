Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD2B1442EF;
	Thu, 13 Jun 2024 11:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278909; cv=none; b=V9EdkyzMmB14C5bsRnlow39kSZX5bYqOa458uybFAHXzJ9L836kQenhP2bV7nyrIypml5iXHS8xYV1phqQJqoIcMP0IGf2yF8H15Ug1chFi4EL89yl197GIUHfdOZbET+Yb16PV2JOGlNq7XacG4ARtjthrNxTrJK+M7RrUXpwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278909; c=relaxed/simple;
	bh=4zXlfaeweO5lB/FILbhLNYyPV/fOodGgcEY7SS3eQd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPq4touRVTIjnzw0ukuly/YSGD8MxW10sLmdIr0hXXqTRhmwU9EfixU7yYoLNbkZj50GCCKgEpSHlKz0ON+UBH3I9QwxqRBHGiFA7GUq6HMez3CBO1zRq4vWDo3SopemZPpAeUm8EyCwyvadR9rKy8HcIWcAaSrSvbgl5sWA5ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Azb8wPp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Azb8wPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CB3C2BBFC;
	Thu, 13 Jun 2024 11:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278908;
	bh=4zXlfaeweO5lB/FILbhLNYyPV/fOodGgcEY7SS3eQd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Azb8wPpRorurFODqDk8hKc1qe0RaY7fa/tmown5RySdA3p1vMafeEb1jVXw78n6Z
	 xVpDQHZmmnr0Nd7iVBCY9aDBF7Yv/w5v7QTXIOsnlc5j7CKj0YKST/5ENMhS6ISKAH
	 hWFvY3AgK9RhY3wqTGoRoKEMjo1SmL+CDGzrYNQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 109/213] Input: ims-pcu - fix printf string overflow
Date: Thu, 13 Jun 2024 13:32:37 +0200
Message-ID: <20240613113232.205832648@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 3d51175c4d720..ceb42b17bb948 100644
--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -47,8 +47,8 @@ struct ims_pcu_backlight {
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



