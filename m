Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4BA1F75BC;
	Tue,  3 Dec 2024 15:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239945; cv=none; b=gsdSF/uc4anbPGsfpP55ieYpRjX9pxCURUYQWCfO90AQGKANGRc2f3nyJ9jpEsNqiC8Mxz7/TN9ts6aTsRPmcgywzVDJxStIvgpVX81nrDBe5PtXalWyhXix+3StelELQ3jNftZJ9EvzUlCfxq2r39z0lVMY3r+Umy4pdNrutmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239945; c=relaxed/simple;
	bh=h++HOUxONkOieDi95IVxqsfyoLjWpI8zicyQgU32/FI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tt5S9DfpcO+3KSILfph/wlTkpiuWU3oiZmFtb1Ssq1vBT8QRGaY3rAMNO4YDiskMqOmLvqNgLLDfCWp3Qow8mPQbyFR9VXeb8FPWT1R0bw9/YIBrADZWrJL74fMrb4d+ZgxCIhlrA2iA1MiCVKpYfCIaq5fJ45qrZYlN8yGrm+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bfN2xV7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bfN2xV7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64831C4CED6;
	Tue,  3 Dec 2024 15:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239945;
	bh=h++HOUxONkOieDi95IVxqsfyoLjWpI8zicyQgU32/FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bfN2xV7ttOREt8a9eOmCpPiheKVTCVRHzWv5Q41URKRugaWwqb7r5BHqbkfGhzwfK
	 4C5bXjRkKkPrlscHkO8ExFlKqtRCVQ9LcKnEjz2ez9+HUZ+KwztNWWwVOHYcH7VPRr
	 wDzZw75l1iHK8Z5rczokuBahshdeMC7BoDyktQaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Zenla <alex@edera.dev>,
	Alexander Merritt <alexander@edera.dev>,
	Ariadne Conill <ariadne@ariadne.space>,
	Juergen Gross <jgross@suse.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 789/817] 9p/xen: fix release of IRQ
Date: Tue,  3 Dec 2024 15:46:01 +0100
Message-ID: <20241203144026.809675376@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Zenla <alex@edera.dev>

[ Upstream commit e43c608f40c065b30964f0a806348062991b802d ]

Kernel logs indicate an IRQ was double-freed.

Pass correct device ID during IRQ release.

Fixes: 71ebd71921e45 ("xen/9pfs: connect to the backend")
Signed-off-by: Alex Zenla <alex@edera.dev>
Signed-off-by: Alexander Merritt <alexander@edera.dev>
Signed-off-by: Ariadne Conill <ariadne@ariadne.space>
Reviewed-by: Juergen Gross <jgross@suse.com>
Message-ID: <20241121225100.5736-1-alexander@edera.dev>
[Dominique: remove confusing variable reset to 0]
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 0304e8a1616d8..b9ff69c7522a1 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -286,7 +286,7 @@ static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
 		if (!priv->rings[i].intf)
 			break;
 		if (priv->rings[i].irq > 0)
-			unbind_from_irqhandler(priv->rings[i].irq, priv->dev);
+			unbind_from_irqhandler(priv->rings[i].irq, ring);
 		if (priv->rings[i].data.in) {
 			for (j = 0;
 			     j < (1 << priv->rings[i].intf->ring_order);
-- 
2.43.0



