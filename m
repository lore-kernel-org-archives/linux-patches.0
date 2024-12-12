Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72752236EB;
	Thu, 12 Dec 2024 17:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025513; cv=none; b=EX6MH4uUQ0OocNuYjE7jFsnxDddUn0+d8qyfpGqa5p4N51/3Rfh4H93XXnkqXYjbGidLfZp8XfUyYU2LhK/s3mvtQ9cROavC40Am4/lRDP9ttrqMrwIMrV5xWaE/yjw2r2VJv7/DlYhDFYo8+dfWb0frWrLiaz4BsxtLsxjrP/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025513; c=relaxed/simple;
	bh=rzzRR1Dk9KGSkqfIN27XMWCZlA0okrDpmSzNMj+bNUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PyHVjty3PbD/YyeriTFckeIInrq55aUE6DARmn0njpucXPx9UYmCjwEGZNB8dNctERAFNF84FY/YAalPDgLI5V3p4PDaGUvugJTSRtHyU8xMwJUeRwhjGSTajAiE9yMDgC2ZLq8V01q+b2m6S8NjFKFItiuljf8gjSKaMLRgNVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YeJv7ZtI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YeJv7ZtI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F971C4CECE;
	Thu, 12 Dec 2024 17:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025513;
	bh=rzzRR1Dk9KGSkqfIN27XMWCZlA0okrDpmSzNMj+bNUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YeJv7ZtIXq2NRuCxHOZOtjb8nm+Wj+LaHogRcwmVTC3ui6MIZRbqcNH03XeN9YET7
	 n/wry9I2NSqJvNwS3ygvasAHFlHN92JUUu3kvQHfkMSNWjw8B65y8Rh6w2Uko8mlfC
	 yuvqED3HYl3QM6c2TigJBbdyx9fIkXqVAw23e/wo=
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
Subject: [PATCH 5.4 194/321] 9p/xen: fix release of IRQ
Date: Thu, 12 Dec 2024 16:01:52 +0100
Message-ID: <20241212144237.645488302@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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
index f5b8f009b8a95..9328de8a5567e 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -306,7 +306,7 @@ static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
 		if (!priv->rings[i].intf)
 			break;
 		if (priv->rings[i].irq > 0)
-			unbind_from_irqhandler(priv->rings[i].irq, priv->dev);
+			unbind_from_irqhandler(priv->rings[i].irq, ring);
 		if (priv->rings[i].data.in) {
 			for (j = 0; j < (1 << XEN_9PFS_RING_ORDER); j++) {
 				grant_ref_t ref;
-- 
2.43.0



