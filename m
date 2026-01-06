Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB4323F42D;
	Tue,  6 Jan 2026 17:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721918; cv=none; b=SS35lGN4Vc8N1Zy5ABy2cmOG7Z19bGBBZXCPVXOfw40RUgWAeY6/OwVkomVJOhB7kOMA+ZP7zgzonY1zmI5pMsCjwNeFgw1+H/yxIW2xTDGsxWMRt+uUu3zGzU9kBfRnkQgdVAPGycNGj9HBh1GnQp4Zw6R60uijPgLrKnvv6o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721918; c=relaxed/simple;
	bh=bwVkeK+em79Q8hrcTjBcqVHMAypAN6MhPRBYPpgUjI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ag6kHsfL3PgoN1CN6okEtxVmAnvfgFI3GjMayO/4Kpbt9vDuRga5yq6QLTLbM4fiLnTear6zXnEPBCYvvols7/VoU06L00DOX8SW45GBxIvW62In3pMjGKsVM7sazmzrwgrYkGr+M6+QefKDIIV51yz0BGHVhl3CefDSgQzgc+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jlg3AOm1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jlg3AOm1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069C5C116C6;
	Tue,  6 Jan 2026 17:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721917;
	bh=bwVkeK+em79Q8hrcTjBcqVHMAypAN6MhPRBYPpgUjI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jlg3AOm1v2wcXILo3bViy0K4s3+6QuN2KE7UPO1ctCSclw0MvoR883oO/qDgB02Dq
	 boe4wCDtkp1fe5tSPy2YZHlEPuVGP85BeZwLT4+BHdHdqT/VHmN80JcNV6CBPTUwba
	 UNz84WFZjiSQ8E7v1uBArI5PrMHgXmihOGco+YNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.18 110/312] iommu/apple-dart: fix device leak on of_xlate()
Date: Tue,  6 Jan 2026 18:03:04 +0100
Message-ID: <20260106170551.814696732@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit a6eaa872c52a181ae9a290fd4e40c9df91166d7a upstream.

Make sure to drop the reference taken to the iommu platform device when
looking up its driver data during of_xlate().

Fixes: 46d1fb072e76 ("iommu/dart: Add DART iommu driver")
Cc: stable@vger.kernel.org	# 5.15
Cc: Sven Peter <sven@kernel.org>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/apple-dart.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/apple-dart.c
+++ b/drivers/iommu/apple-dart.c
@@ -802,6 +802,8 @@ static int apple_dart_of_xlate(struct de
 	struct apple_dart *cfg_dart;
 	int i, sid;
 
+	put_device(&iommu_pdev->dev);
+
 	if (args->args_count != 1)
 		return -EINVAL;
 	sid = args->args[0];


