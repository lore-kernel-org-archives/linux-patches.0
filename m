Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB4413CA81;
	Thu, 12 Dec 2024 17:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024454; cv=none; b=cYwC1Z0xSGCl9eexOCuMmxGUByVBJwtY82UJsaT/J24A0BZs77pKQAnnWdiBIpfL8sc+4R9DFvEYPB6h7y8a7ktw9Bk/iFjYHuX+UiysvtuiflHJWmi0tI4vW4XONgjtwL5truNVsKobpmTug6R4DFds0GJOEmEHKTJfPKmDfmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024454; c=relaxed/simple;
	bh=y4WIcnaqE21R3xrP4KaK84k7rx+I6fC/8QPJtv6hNSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHOhUkiCJHoFgnlQRtd+vyMm8MO/+Fxm0xX9oqC5dp5ef8E5Qt9JxBkzZH97tRBIk/JapVX8IT8j3zDvF+XtiSeATynyE4COMrCgHXCJYbrwuxufof6deBE5/l0RYgg83g8g8hgtu4o1JOO+xx48dwR3AFWino7cxvcdZpWuObs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLeLGETF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLeLGETF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F30FC4CED0;
	Thu, 12 Dec 2024 17:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024454;
	bh=y4WIcnaqE21R3xrP4KaK84k7rx+I6fC/8QPJtv6hNSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLeLGETFh0fyq2XX60MKCHGdQkfOuaflUwdb0mEo3p+mv4z6SQq/NvSPCoqi986Rg
	 Wkvedmy+ln1dHm3o5IfnX9x/4bvBZpnKtF7KduX9RX5eMu97QbhtkokmBDaHayKiYO
	 edVjgamyDmjt1fiMHH/ovQXOycEV7/6L16AzyLVA=
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
Subject: [PATCH 5.10 301/459] 9p/xen: fix release of IRQ
Date: Thu, 12 Dec 2024 16:00:39 +0100
Message-ID: <20241212144305.536358750@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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
index dc8702024c555..5ff1892edbf2e 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -307,7 +307,7 @@ static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
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



