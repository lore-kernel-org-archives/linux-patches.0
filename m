Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADCA1DDF5;
	Thu, 15 Aug 2024 13:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728567; cv=none; b=lqccuzri7jp2o7Hdx4TueqWDa/dMTNbIOSdDcx225R4EInK0Cj+6i5Zum7tfqgrCCuFtfZNw/GnXqtKNUumarzGdeb/zwZEs7xxS+5d+eTAn2/iR1BTPvGUgrHSexjAji3YNdj0iuAgxMnQwzNr8vEbfPuOlYLaC09vIisaYbdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728567; c=relaxed/simple;
	bh=gGpEhuRbO6N96CwyDd2gKJkF4snEfuKMsBTA8aiRsAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWy3gr/EcA/dxf2NWIB1kHp3rXd8T6wgyXjew6jgn0LTgpbekErI4Ckel4ZYIRfSj0BXjqvDFwM8jKCbrnISMWFlfmQuJn00aUbcXbUs/tRsDY7kaY3u6zdJHHoVovdySORPtMH6rEwnem/Ohe4Ex5EbtsrQXyBvmrD3fIWklgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pztO7ieY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pztO7ieY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE19C4AF0C;
	Thu, 15 Aug 2024 13:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728567;
	bh=gGpEhuRbO6N96CwyDd2gKJkF4snEfuKMsBTA8aiRsAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pztO7ieYaUkkCpEwo5r3SLbIjHneabBXc4CKS9wB0S9XJk4ri0XInFZK5DgFCxiWJ
	 qMpnPOCZBDZfeE/RcfZpH/qChWN25fxAzidyiLTraSS9eBv658Whkn6G4WkdY0J+CW
	 ihIDzc7+ujO198suaYCLw5Mw7gdz2zM5v8Lg5JSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 039/196] mfd: omap-usb-tll: Use struct_size to allocate tll
Date: Thu, 15 Aug 2024 15:22:36 +0200
Message-ID: <20240815131853.581611467@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 40176714c818b0b6a2ca8213cdb7654fbd49b742 ]

Commit 16c2004d9e4d ("mfd: omap-usb-tll: Allocate driver data at once")
changed the memory allocation of 'tll' to consolidate it into a single
allocation, introducing an incorrect size calculation.

In particular, the allocation for the array of pointers was converted
into a single-pointer allocation.

The memory allocation used to occur in two steps:

tll = devm_kzalloc(dev, sizeof(struct usbtll_omap), GFP_KERNEL);
tll->ch_clk = devm_kzalloc(dev, sizeof(struct clk *) * tll->nch,
                           GFP_KERNEL);

And it turned that into the following allocation:

tll = devm_kzalloc(dev, sizeof(*tll) + sizeof(tll->ch_clk[nch]),
                   GFP_KERNEL);

sizeof(tll->ch_clk[nch]) returns the size of a single pointer instead of
the expected nch pointers.

This bug went unnoticed because the allocation size was small enough to
fit within the minimum size of a memory allocation for this particular
case [1].

The complete allocation can still be done at once with the struct_size
macro, which comes in handy for structures with a trailing flexible
array.

Fix the memory allocation to obtain the original size again.

Link: https://lore.kernel.org/all/202406261121.2FFD65647@keescook/ [1]
Fixes: 16c2004d9e4d ("mfd: omap-usb-tll: Allocate driver data at once")
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Fixes: commit 16c2004d9e4d ("mfd: omap-usb-tll: Allocate driver data at once")
Link: https://lore.kernel.org/r/20240626-omap-usb-tll-counted_by-v2-1-4bedf20d1b51@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/omap-usb-tll.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index 446713dbee27a..269eeccb963bc 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -246,8 +246,7 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 		break;
 	}
 
-	tll = devm_kzalloc(dev, sizeof(*tll) + sizeof(tll->ch_clk[nch]),
-			   GFP_KERNEL);
+	tll = devm_kzalloc(dev, struct_size(tll, ch_clk, nch), GFP_KERNEL);
 	if (!tll) {
 		pm_runtime_put_sync(dev);
 		pm_runtime_disable(dev);
-- 
2.43.0



