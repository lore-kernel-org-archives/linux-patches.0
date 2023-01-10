Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA387474
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4931EC433D2;
	Tue, 10 Jan 2023 18:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375750;
	bh=GeIU/RfEM1DKdtrrxhN+tEBZak4N4wNsk+Ouw2aFx9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F10P/htnHYwfC3HDm3D/Inx8JpTOFkenh8z6j9U+ABav+E0qxx7amPctEqfEIfEFr
	 uwL3FNtDcbiBpXvQhOBrgTwq3c0QR5vOghu6Bz7hPgc8D+JVagvr823UimGCyQH1BE
	 DRJakeyNJNatKnFAr+QSWq/bfVb3yyLNkk1qqX8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 5.15 290/290] drm/mgag200: Fix PLL setup for G200_SE_A rev >=4
Date: Tue, 10 Jan 2023 19:06:22 +0100
Message-Id: <20230110180041.912212964@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jocelyn Falempe <jfalempe@redhat.com>

commit b389286d0234e1edbaf62ed8bc0892a568c33662 upstream.

For G200_SE_A, PLL M setting is wrong, which leads to blank screen,
or "signal out of range" on VGA display.
previous code had "m |= 0x80" which was changed to
m |= ((pixpllcn & BIT(8)) >> 1);

Tested on G200_SE_A rev 42

This line of code was moved to another file with
commit 877507bb954e ("drm/mgag200: Provide per-device callbacks for
PIXPLLC") but can be easily backported before this commit.

v2: * put BIT(7) First to respect MSB-to-LSB (Thomas)
    * Add a comment to explain that this bit must be set (Thomas)

Fixes: 2dd040946ecf ("drm/mgag200: Store values (not bits) in struct mgag200_pll_values")
Cc: stable@vger.kernel.org
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20221013132810.521945-1-jfalempe@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mgag200/mgag200_pll.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/mgag200/mgag200_pll.c
+++ b/drivers/gpu/drm/mgag200/mgag200_pll.c
@@ -268,7 +268,8 @@ static void mgag200_pixpll_update_g200se
 	pixpllcp = pixpllc->p - 1;
 	pixpllcs = pixpllc->s;
 
-	xpixpllcm = pixpllcm | ((pixpllcn & BIT(8)) >> 1);
+	// For G200SE A, BIT(7) should be set unconditionally.
+	xpixpllcm = BIT(7) | pixpllcm;
 	xpixpllcn = pixpllcn;
 	xpixpllcp = (pixpllcs << 3) | pixpllcp;
 


