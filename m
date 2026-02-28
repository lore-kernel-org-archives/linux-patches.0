Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8EB36C9C4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302233; cv=none; b=DrD6DdDKbmj0eZww66D1vn/sHe8fhvclxMoz91665AnaPcWSgl50jJhR92YLTtEacZEMRjEYIIrVWWb09I6tFMDRN1wkuuShUW5FweyBtakIlWkMAk5YZJSVjI72tqVBb9rkM976HgipqTShjTTDH98pjq66+RWLs4n9lGYBY7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302233; c=relaxed/simple;
	bh=4AwoelBZJMd0R7cRlpxDNuMNhGVSFnCshXZ0wn10ivo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWkhPtPkSmfH4Z+r0zUSmEtmSrVQclCkjZUfAsGddrnas0pqCeyZVxYJT2BUgGR8Gn69UVj5QfPvc/wGoVGLj+5XM933Jn28DkfexOKUPwY08+ZRKVQpm4r7lSk2BIDopLiWdNTiI4otmiVIebPq3g1mwqtDtVT1vaAXnefJhC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=erNIFuyX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="erNIFuyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C002C116D0;
	Sat, 28 Feb 2026 18:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302232;
	bh=4AwoelBZJMd0R7cRlpxDNuMNhGVSFnCshXZ0wn10ivo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=erNIFuyXpjBD75Bw4l9n41Czfy3W86L2PJ6zFvc28FCpNdRTELs9K1TlNTs61YMhN
	 gkweUaxm1gaQkpRc8fYWllmauBrgiQN+kpSgKOlzX4aNbmNFEIaPtCjlwLoKvq1uWl
	 dJAAYLb53ISznR8mNQoFcFh/Tvwo0SBe/38xO84MNCrXFwT3/1zKwfJLuIoIQ6U5BW
	 UMNmRuXRLTvv/PdHq7/nC4WiQO4hLC9ya2uITZ3fdmPUkn4mF5MCs9xCT5d6Oo9t2/
	 CSQcDl03reMA2eneAWGHUg+wGzI2i9nNcUkdm2iXbfb2b4VgG5hBC5AmekJ3uesZJW
	 qOxLoq7EWQFBA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 243/283] usb: bdc: fix sleep during atomic
Date: Sat, 28 Feb 2026 13:06:25 -0500
Message-ID: <20260228180709.1583486-243-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit f1195ca3b4bbd001d3f1264dce91f83dec7777f5 ]

bdc_run() can be ran during atomic context leading to a sleep during
atomic warning. Fix this by replacing read_poll_timeout() with
read_poll_timeout_atomic().

Fixes: 75ae051efc9b ("usb: gadget: bdc: use readl_poll_timeout() to simplify code")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260120200754.2488765-1-justin.chen@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/bdc/bdc_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/bdc/bdc_core.c b/drivers/usb/gadget/udc/bdc/bdc_core.c
index 35a652807fca8..c2e3fa997842a 100644
--- a/drivers/usb/gadget/udc/bdc/bdc_core.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_core.c
@@ -35,8 +35,8 @@ static int poll_oip(struct bdc *bdc, u32 usec)
 	u32 status;
 	int ret;
 
-	ret = readl_poll_timeout(bdc->regs + BDC_BDCSC, status,
-				 (BDC_CSTS(status) != BDC_OIP), 10, usec);
+	ret = readl_poll_timeout_atomic(bdc->regs + BDC_BDCSC, status,
+					(BDC_CSTS(status) != BDC_OIP), 10, usec);
 	if (ret)
 		dev_err(bdc->dev, "operation timedout BDCSC: 0x%08x\n", status);
 	else
-- 
2.51.0

