Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0905B1DA4C;
	Tue, 10 Sep 2024 10:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965152; cv=none; b=EYEwSzuAQj1/zAoSx60GatGPjfkkNfMX8o8BJwuuhyBYFwRuB1UOWrpm9CgAkllULI4zS6bPHqp2P+XP6mfNUs0v18eLIwrlYLLYC6tSRLFeVB0/xA4CkGZ3iI7zTDHEK5Eq+I5JEyPdosom6mUHJoGfz+QsvOmpMay/NcSJiaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965152; c=relaxed/simple;
	bh=N2LiIpdkhlc5Y6RcNOkjOl926eMiuKVpnEewtLexCNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6wuUBwE94aNj1uHosBqkORJEXpX1OnErYodNc90wZnq/2kKgkvD4Z38tqTKP4wFGPzUmuXKO7sKYCm0QH7edx8UIW+lvKpySdTIorMUxCcYi9Ysy7tKgf31cfIM4M+XvXI0cmWnYED9atnaQzP68c9F0T49D5ihqDzS1OYsmbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7wUq6X+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7wUq6X+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E47C4CEC3;
	Tue, 10 Sep 2024 10:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965151;
	bh=N2LiIpdkhlc5Y6RcNOkjOl926eMiuKVpnEewtLexCNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7wUq6X+jvO69d2/hfXg+C+iurrvtg8zUvopkDGn4x5PQ544e8YRGNXw76mCujWxR
	 +6CsqUqZ33wILxCw9FphjSwuPWqiYwgPeqIlSnv8oXp3W5MF9QJCN/treaxC1D36Fj
	 RoWvsqNj/xgLvg6mhZSPomGao7IS6cZPTtQ2Han4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Dembicki <paweldembicki@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/186] net: dsa: vsc73xx: fix possible subblocks range of CAPT block
Date: Tue, 10 Sep 2024 11:33:42 +0200
Message-ID: <20240910092559.811381791@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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
index 8a21902212e0..7c2780ccf9d6 100644
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



