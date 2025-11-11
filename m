Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8645334A790;
	Tue, 11 Nov 2025 01:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825338; cv=none; b=msClpCoCO73FFkriKH1KZqryy4EbTbIVyRkuYQPUU2T37308YHbtomxu9zIxbL+cmDajeXrQZQ8lodJJ22A9QzTHV4CCKZPps140zM0YexfrVxK5/8nXPHFtlH6Xqn9p9VPtqdal8t+sS7lN54xQM9cdPRPjWCteZAQsjaOFkcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825338; c=relaxed/simple;
	bh=qpGs6pJI7KmnothcuDfNPt+Eo9V57CkCHWeZc7xVkiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYV1Y8XxsLtb+022WSBgyNdyMOBIng4/bVdyE57BubUy/puJPSu9Am6TbH84ZL+JbFCUu1hB6jhbVbcNt0Zd9+eXBgfQ58jgLtD3CCoNMxE6vgZgJfeTkksNCCCtW//HT7N8fpieaN2p/Zr68PWK9e0ne4HwiJKsTH95OXUn32I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WddZbDj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WddZbDj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AF1C4CEFB;
	Tue, 11 Nov 2025 01:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825338;
	bh=qpGs6pJI7KmnothcuDfNPt+Eo9V57CkCHWeZc7xVkiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WddZbDj3DMZmiDFy/HksPiHN37GCwMX4IPfBo3RXJ52f7yu0xL+2zP9kXYQLDPwgv
	 I5StZVzyThYw7wTR0M/1S8paQ34XSNglvk/dfjM0L1C0aGSECUon8zemhRR6ub8uv3
	 d8IKQJgQ+m5H7FcOrkE09aX9SI50NTwVVHsNGqT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zsolt Kajtar <soci@c64.rulez.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 717/849] fbdev: core: Fix ubsan warning in pixel_to_pat
Date: Tue, 11 Nov 2025 09:44:47 +0900
Message-ID: <20251111004553.766207014@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zsolt Kajtar <soci@c64.rulez.org>

[ Upstream commit aad1d99beaaf132e2024a52727c24894cdf9474a ]

It could be triggered on 32 bit big endian machines at 32 bpp in the
pattern realignment. In this case just return early as the result is
an identity.

Signed-off-by: Zsolt Kajtar <soci@c64.rulez.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fb_fillrect.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/core/fb_fillrect.h b/drivers/video/fbdev/core/fb_fillrect.h
index 66042e534de77..f366670a53af8 100644
--- a/drivers/video/fbdev/core/fb_fillrect.h
+++ b/drivers/video/fbdev/core/fb_fillrect.h
@@ -92,8 +92,7 @@ static unsigned long pixel_to_pat(int bpp, u32 color)
 		pattern = pattern | pattern << bpp;
 		break;
 	default:
-		pattern = color;
-		break;
+		return color;
 	}
 #ifndef __LITTLE_ENDIAN
 	pattern <<= (BITS_PER_LONG % bpp);
-- 
2.51.0



