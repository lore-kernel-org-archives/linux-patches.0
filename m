Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F451D88D7;
	Tue, 27 May 2025 17:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366602; cv=none; b=Jjcoc/+psACranPJjiZcE5GQR5b696cBtYIfy5nUZiKQG60BqmC5+y5LpNJoLgOMedUc6fbfQJN9WcQZeLaOV5y1OtpeE6A2n4evnDNmZq/mS1EMIh3eHfoa1QifkI5PnWALF2m0ZNivW1vM1dAPRHzJutmgl50sHRKFi3fVYMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366602; c=relaxed/simple;
	bh=bc07nCwUzFd3xHMnZSVIk2qUJT4PF+8+U1xpkiSPWXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odkdGasl4tDg4eeDKEPEr1x4zr72xmTvgkBEpJecZ+wgLMXRmS+1LF0SC9dMCXTMP68hHs6z/EV728NqS93Z/fvagIjLUGNcg5r5vzZ/RmyjIgcypSoTG/EGLJPJ151GYAap4SoFjVwmo3IwV2SNO/i0XHPqZGl06SMe0Ivta+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKtHcAhp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKtHcAhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08879C4CEE9;
	Tue, 27 May 2025 17:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366602;
	bh=bc07nCwUzFd3xHMnZSVIk2qUJT4PF+8+U1xpkiSPWXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKtHcAhpEuV28l2miLonwHpx+PIEeCCd6vKa9HYECFfKTWBgzFMlK11lyKjAxtUMd
	 QpV4u5BKUm0lIZjwVtVUTffk1TiSQOGGDKwlzcYpn/u4r4pQlN+hyQEZ77+f8uDliX
	 uyOfdLyL7ekaS8MLxTePTRGzV8SAybMCIis44qIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hsu <Daniel-Hsu@quantatw.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 081/783] mctp: Fix incorrect tx flow invalidation condition in mctp-i2c
Date: Tue, 27 May 2025 18:17:58 +0200
Message-ID: <20250527162516.436706826@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Hsu <d486250@gmail.com>

[ Upstream commit 70facbf978ac90c6da17a3de2a8dd111b06f1bac ]

Previously, the condition for invalidating the tx flow in
mctp_i2c_invalidate_tx_flow() checked if `rc` was nonzero.
However, this could incorrectly trigger the invalidation
even when `rc > 0` was returned as a success status.

This patch updates the condition to explicitly check for `rc < 0`,
ensuring that only error cases trigger the invalidation.

Signed-off-by: Daniel Hsu <Daniel-Hsu@quantatw.com>
Reviewed-by: Jeremy Kerr <jk@codeconstruct.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index d74d47dd6e04d..f782d93f826ef 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -537,7 +537,7 @@ static void mctp_i2c_xmit(struct mctp_i2c_dev *midev, struct sk_buff *skb)
 		rc = __i2c_transfer(midev->adapter, &msg, 1);
 
 		/* on tx errors, the flow can no longer be considered valid */
-		if (rc)
+		if (rc < 0)
 			mctp_i2c_invalidate_tx_flow(midev, skb);
 
 		break;
-- 
2.39.5



