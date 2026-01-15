Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7073A0E98;
	Thu, 15 Jan 2026 17:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498278; cv=none; b=DY8xrOr0PPIvb8kaxZFvKkHTBNSXh3xFt/ApB/Jooe7vr7WiJY0rxNQlJHD+C7gyqJPouG532RCAJSBSNRqCsRs2ZuRlMgaSl9Oe1M6NlrfpeWavxBtYXpw+0dhy4Z9tzUH1mj7AvZLb7m3TAldSjLvnMGTgTL3/jgEdLj8D1Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498278; c=relaxed/simple;
	bh=lcSPt9wL2jeRj174ajlm88brCefOOmTYJI8fBMQk/ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PauY8suqHcw/oc2+YsjuIg76sFDkmTPAtYs9f1BbYkXQCywtqwTEc11SQ+sNN1E878TRXqse2brNtuW1+MYKmRHbQoVG45dybg+avuRzFIpBTj/D6NysU8bdxoLet3KTEJvaNnNqWyzj8B4kq2Mu0OsH1+OHVuk2p+Xqqss9xX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ISb8xKAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ISb8xKAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7A0C116D0;
	Thu, 15 Jan 2026 17:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498278;
	bh=lcSPt9wL2jeRj174ajlm88brCefOOmTYJI8fBMQk/ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISb8xKAfYxjBruQekTKpRRkhYR7DP24VuUfuApdOzifPYiy116OsNJcbLvxolykRh
	 TQR2mV6JDV5swJ635G2DgtFaupN19YGd6q6SFd1uHBptbZ9VSSwmfHLSewIrNx5jhb
	 VT0ptQ9vp5gH20XQ7P2liQWLr4i6wQ3byXpgt02U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Damm <damm+renesas@opensource.se>,
	Robin Murphy <robin.murphy@arm.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5.15 375/554] iommu/ipmmu-vmsa: fix device leak on of_xlate()
Date: Thu, 15 Jan 2026 17:47:21 +0100
Message-ID: <20260115164259.806788038@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 80aa518452c4aceb9459f9a8e3184db657d1b441 upstream.

Make sure to drop the reference taken to the iommu platform device when
looking up its driver data during of_xlate().

Fixes: 7b2d59611fef ("iommu/ipmmu-vmsa: Replace local utlb code with fwspec ids")
Cc: stable@vger.kernel.org	# 4.14
Cc: Magnus Damm <damm+renesas@opensource.se>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/ipmmu-vmsa.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/ipmmu-vmsa.c
+++ b/drivers/iommu/ipmmu-vmsa.c
@@ -710,6 +710,8 @@ static int ipmmu_init_platform_device(st
 
 	dev_iommu_priv_set(dev, platform_get_drvdata(ipmmu_pdev));
 
+	put_device(&ipmmu_pdev->dev);
+
 	return 0;
 }
 


