Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB241F2381;
	Thu, 12 Dec 2024 17:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022909; cv=none; b=fKnPk0iKLRCaiNAf2WDr4XusVVXMBpDJVLoRU6dQhlnuoSCSeQvWxWBzV1dsgGi3AFDAa8LLFrTSHEf0KzNk5l0+jpN+L3Yokl40dCofi+SFQbwKyEawmVpRDPi6zXIq333Rqj8d47p6zGJna/yc2/+SpcaT7onhNDlDx2/BCSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022909; c=relaxed/simple;
	bh=D8KTVv1erkcDuGVwF4RrDMCIMdOYBhhyY2D1BxYKEV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFJlyhwnlhpNHdtopcVLQt0jdmVdlrwPnE/eadG4kozoCIuZ1vX+VtQRr11ERkVviejwy10ZHlj/NQ5jIn2rMGbYV5p2c6USBPpHuYf3/zPGeTpLqA/6ssfOWbu6bfYlwwyYAMk+nRj/Q0oVEACNjj3sEtGpK3RCZnA2cvDJzWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=faa2dxDu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="faa2dxDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5AA1C4CECE;
	Thu, 12 Dec 2024 17:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022909;
	bh=D8KTVv1erkcDuGVwF4RrDMCIMdOYBhhyY2D1BxYKEV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=faa2dxDuJrOOUpJj1hnEr1mmr7vBrHNbvdkJ7huMrFg2gjrJjw0lISIU/zmS3GId2
	 Hp46ViHbHPZpEm0uyWHTWRkED2o7h+gCphAGNxghZT4gct/yHdlSIw5ZOj2YQqgpuX
	 rB6JX8y7orw4pfhh7TSt4Q1OaRpZPJhEWNSK1YX0=
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
Subject: [PATCH 5.15 367/565] 9p/xen: fix release of IRQ
Date: Thu, 12 Dec 2024 15:59:22 +0100
Message-ID: <20241212144326.129553118@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 716736046a18f..6644ae8cc55ad 100644
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



