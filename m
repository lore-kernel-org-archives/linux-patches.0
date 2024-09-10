Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A97318B49E;
	Tue, 10 Sep 2024 10:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962538; cv=none; b=YP1QPaZKnKjUALxoNqY3eLy1VXpiZH/LxoKk03h5klK6ma428eAuuT+eywFDSE1T42T12KjteRr2syZD3Qb9P+U5xHtCgQnT9N3g86mrzjsLVoG6LsPm4vHnjs7yAyVUe89S5tUTummpdmpjGI6dZYOiUHHmDoSRkVUOQCHRzu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962538; c=relaxed/simple;
	bh=Uy8x4pAiN2DJ+tCJtkzvA4Ua/nbuvWxgg4HMrfEcihM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQrtN9pYltB6iRd6b3orn9Chp99xxxB/5IU0ABdLQiknqzumZzZsSDRRyX9yOihOFSLsBM/gt0FQLRpdIT/tQJBHxbYNES4X0ro2Pw927SFuWliC+sN36XAURx1I4TivU0GFOkH9fYGxkkCWXJvrVEPKkGAAplKqLfpBx9J9KJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekjLRakd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekjLRakd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79EDC4CEC3;
	Tue, 10 Sep 2024 10:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962538;
	bh=Uy8x4pAiN2DJ+tCJtkzvA4Ua/nbuvWxgg4HMrfEcihM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekjLRakdKXZt/3LZW/9pa+7/KZ4/aw8SPpm5FbbhiR6wWTCh1VbMt8skINif8Wgc9
	 wHXqu5tqEcAzpgxUV3zX2UshHWo3q+CejjQJb7Rd4li1a0JkbWeglnz6yBnoXfBxMf
	 MNO+/9PwuUfM15Va2kIF8WVvPsx98JY/c1ZnG8VM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Dembicki <paweldembicki@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/121] net: dsa: vsc73xx: fix possible subblocks range of CAPT block
Date: Tue, 10 Sep 2024 11:32:23 +0200
Message-ID: <20240910092549.093274976@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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
index a1dd82d25ce3..b95e7920f273 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -34,7 +34,7 @@
 #define VSC73XX_BLOCK_ANALYZER	0x2 /* Only subblock 0 */
 #define VSC73XX_BLOCK_MII	0x3 /* Subblocks 0 and 1 */
 #define VSC73XX_BLOCK_MEMINIT	0x3 /* Only subblock 2 */
-#define VSC73XX_BLOCK_CAPTURE	0x4 /* Only subblock 2 */
+#define VSC73XX_BLOCK_CAPTURE	0x4 /* Subblocks 0-4, 6, 7 */
 #define VSC73XX_BLOCK_ARBITER	0x5 /* Only subblock 0 */
 #define VSC73XX_BLOCK_SYSTEM	0x7 /* Only subblock 0 */
 
@@ -360,13 +360,19 @@ int vsc73xx_is_addr_valid(u8 block, u8 subblock)
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



