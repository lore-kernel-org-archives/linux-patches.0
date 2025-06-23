Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6347615ADB4;
	Mon, 23 Jun 2025 22:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717365; cv=none; b=iMDMt7eAytwnwFGlq53jgcxa4xQjIg+2mrNbJFMgDt5z6TrFQvlTgGv6wtPC6aesNAWM2ZK+F6X7qGPPS++xJScbmO3O+MllROSI23RhzXkJcBZRJO4ejRxa9F0H1cTwUyEZVxkWbWcU76VYiQOUB2graOx/kgdmJf3otEVyquY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717365; c=relaxed/simple;
	bh=ZtmRi5YLwOf0YHwcmxICyq31hP3upUgKzXCQN295NHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pdzcs2uv+c8sUyKlFSXF9TamD4FUlA+YP5BW11vT2I20nP4moWjy8ZJ//FqTkkD7bRa8HySPKS2nuIu/IWwPx0QIv8kG+ghZQHyd+wG7ftwfSeOaUCdGNIEtECDA98hjwEVdk2xTYvK7v3b2DrxvkAS4EmPuS0leC9leXbMvRhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iO3iqvhd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iO3iqvhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9F7C4CEEA;
	Mon, 23 Jun 2025 22:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717365;
	bh=ZtmRi5YLwOf0YHwcmxICyq31hP3upUgKzXCQN295NHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iO3iqvhdfoIy/tcqfhVoMSbI3JUzA9qdWUA1bkyYUdJwJ8geuBnTMdskn60mq2lTE
	 +O1Td9Laf4btchxMw+d28get/JPGFk2toB8mMajrB9iX6dFHKbGmuOI22m8scxp5Tc
	 XSUAjuXc1KFzlggZ5e74AUNO1dzDn3vr0lgGC15g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 412/508] wireless: purelifi: plfxlc: fix memory leak in plfxlc_usb_wreq_asyn()
Date: Mon, 23 Jun 2025 15:07:37 +0200
Message-ID: <20250623130655.353958354@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

[ Upstream commit 63a9a727d373fa5b8ce509eef50dbc45e0f745b9 ]

Add usb_free_urb() in the error path to prevent memory leak.

Signed-off-by: Salah Triki <salah.triki@gmail.com>
Link: https://patch.msgid.link/aA3_maPlEJzO7wrL@pc
[fix subject]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/purelifi/plfxlc/usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/purelifi/plfxlc/usb.c b/drivers/net/wireless/purelifi/plfxlc/usb.c
index 311676c1ece0a..8151bc5e00ccc 100644
--- a/drivers/net/wireless/purelifi/plfxlc/usb.c
+++ b/drivers/net/wireless/purelifi/plfxlc/usb.c
@@ -503,8 +503,10 @@ int plfxlc_usb_wreq_async(struct plfxlc_usb *usb, const u8 *buffer,
 			  (void *)buffer, buffer_len, complete_fn, context);
 
 	r = usb_submit_urb(urb, GFP_ATOMIC);
-	if (r)
+	if (r) {
+		usb_free_urb(urb);
 		dev_err(&udev->dev, "Async write submit failed (%d)\n", r);
+	}
 
 	return r;
 }
-- 
2.39.5



