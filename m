Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4965C189BBA;
	Tue, 10 Sep 2024 09:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961092; cv=none; b=Iw1Mw+Q7OGNE2qU+YFXo08kfrunC5Pf3bXzOfE0vFjL5khrkgc2bdlacQdLo+qDslLjKOq00Rt7+GfKeeuh/DV98HsyP7ygPssVZozodhVHFGiAOvoKQmrY68WYXLWJi0RTChjlaz5MJGHE21bvsaETgPpVPW47g5zuGHinBf8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961092; c=relaxed/simple;
	bh=v/jGjQhHXWhkRYYsy5NtXj5jcR0sqZ30roB7n5tUNFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxMSp1p8b0lHwYbkD068ELyq96lntKEpsHDytT2VFa2LgwOjThQ4BHg1kDnAntdFKUCZKbOWSvYSTuXlBJp037FjbviP9mneRIOOACBD5qhfKt8KIZZceHApTzJh/klJiykDOm7EgOTX7bn7gUoXe0dPrnz/q2JYN9sndVHVEGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iOeE+PmE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iOeE+PmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5ADFC4CEC3;
	Tue, 10 Sep 2024 09:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961092;
	bh=v/jGjQhHXWhkRYYsy5NtXj5jcR0sqZ30roB7n5tUNFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iOeE+PmEml2pLP6LxH2msV64/nvKBb0J41vSjMakZhrf+p38HwvUEFxaPioo+oZX4
	 TXG6LxMa8lrx+PckU/ZZRRDXFFtU5uOKx4psfd0EVCGjstruN0GTa3l/BZErdMNFEP
	 5ryIIwYis5lDoLNhiuVvfYEzKz8AIzGel8+xtBYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Dembicki <paweldembicki@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 51/96] net: dsa: vsc73xx: fix possible subblocks range of CAPT block
Date: Tue, 10 Sep 2024 11:31:53 +0200
Message-ID: <20240910092543.764521564@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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
 drivers/net/dsa/vitesse-vsc73xx.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx.c b/drivers/net/dsa/vitesse-vsc73xx.c
index eaafb1c30c91..c91f989165ad 100644
--- a/drivers/net/dsa/vitesse-vsc73xx.c
+++ b/drivers/net/dsa/vitesse-vsc73xx.c
@@ -38,7 +38,7 @@
 #define VSC73XX_BLOCK_ANALYZER	0x2 /* Only subblock 0 */
 #define VSC73XX_BLOCK_MII	0x3 /* Subblocks 0 and 1 */
 #define VSC73XX_BLOCK_MEMINIT	0x3 /* Only subblock 2 */
-#define VSC73XX_BLOCK_CAPTURE	0x4 /* Only subblock 2 */
+#define VSC73XX_BLOCK_CAPTURE	0x4 /* Subblocks 0-4, 6, 7 */
 #define VSC73XX_BLOCK_ARBITER	0x5 /* Only subblock 0 */
 #define VSC73XX_BLOCK_SYSTEM	0x7 /* Only subblock 0 */
 
@@ -385,13 +385,19 @@ static int vsc73xx_is_addr_valid(u8 block, u8 subblock)
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



