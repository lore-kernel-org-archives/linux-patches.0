Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943DD1922F1;
	Tue, 10 Sep 2024 10:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962955; cv=none; b=q91FBoYD49aO7rQeeh05cCJZcJGbV/N8O3nEbfk8TsUDsRcrZsh0grUQElG30jNTUyga1B+26ElCoxNXTzzvrCTDdp0JfPsO/1zC6QGZdZR5XdqmuwUenQfCsQO3VHndBux1zhK64dz6yTQrfJ/vyepwYsXi6AqTDsojMbcFXro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962955; c=relaxed/simple;
	bh=7Bs5c99IHmfGNaUZmLOSCknEZvHqOf1/TcBOnVJRMlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ux5u1O89t0tEk+Of4kNY+akXAlX+0wvUcVjEiU8ZI2YS6t8qoR80LmNgqu561kwLgZnB3cZ3+BCW20ebA4f1/kG+A+1ffPXIU3Y4xOo59V9feuxecGpeSBi6/lf4krQ1t0PJNsJlHFPf+NxN6QRhTETpzw1emgCHP54f6OTMbII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LiGRrs3Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LiGRrs3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0FEC4CEC6;
	Tue, 10 Sep 2024 10:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962955;
	bh=7Bs5c99IHmfGNaUZmLOSCknEZvHqOf1/TcBOnVJRMlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LiGRrs3Y7syeC7nwYWuQIhkXI/FmAkNVh/h/k4Lz5GWj95q6cQvCI9Ms1CGSI+vfh
	 ANSFarkwmoYPKCUbohsujcApv+KPb84lgMTE07PAALKt6YrJ/3F2/GYElA6H+u6irC
	 0yQUpnbtg92pFUn1XumeWkQsdohcPgtRIF5iI7Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Dembicki <paweldembicki@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 087/192] net: dsa: vsc73xx: fix possible subblocks range of CAPT block
Date: Tue, 10 Sep 2024 11:31:51 +0200
Message-ID: <20240910092601.581255925@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Dembicki <paweldembicki@gmail.com>

[ Upstream commit 8e69c96df771ab469cec278edb47009351de4da6 ]

CAPT block (CPU Capture Buffer) have 7 sublocks: 0-3, 4, 6, 7.
Function 'vsc73xx_is_addr_valid' allows to use only block 0 at this
moment.

This patch fix it.

Fixes: 05bd97fc559d ("net: dsa: Add Vitesse VSC73xx DSA router driver")
Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20240903203340.1518789-1-paweldembicki@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/vitesse-vsc73xx-core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index c8e9ca5d5c28..de444d201e0f 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -35,7 +35,7 @@
 #define VSC73XX_BLOCK_ANALYZER	0x2 /* Only subblock 0 */
 #define VSC73XX_BLOCK_MII	0x3 /* Subblocks 0 and 1 */
 #define VSC73XX_BLOCK_MEMINIT	0x3 /* Only subblock 2 */
-#define VSC73XX_BLOCK_CAPTURE	0x4 /* Only subblock 2 */
+#define VSC73XX_BLOCK_CAPTURE	0x4 /* Subblocks 0-4, 6, 7 */
 #define VSC73XX_BLOCK_ARBITER	0x5 /* Only subblock 0 */
 #define VSC73XX_BLOCK_SYSTEM	0x7 /* Only subblock 0 */
 
@@ -371,13 +371,19 @@ int vsc73xx_is_addr_valid(u8 block, u8 subblock)
 		break;
 
 	case VSC73XX_BLOCK_MII:
-	case VSC73XX_BLOCK_CAPTURE:
 	case VSC73XX_BLOCK_ARBITER:
 		switch (subblock) {
 		case 0 ... 1:
 			return 1;
 		}
 		break;
+	case VSC73XX_BLOCK_CAPTURE:
+		switch (subblock) {
+		case 0 ... 4:
+		case 6 ... 7:
+			return 1;
+		}
+		break;
 	}
 
 	return 0;
-- 
2.43.0



