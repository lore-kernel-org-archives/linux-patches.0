Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D57A39E199;
	Thu, 15 Jan 2026 17:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498292; cv=none; b=AyRf367WgnxY+aRJwADqLZuJnUpVkURig8IhbpBED4b6vHN5jOxzJA2h7LVU0JsngPMm1MR33xDnK9MF2Nu4FkdmU+s5ODvSEWz4olTGO5KEqyGbO5LC33CVG/5DeNv25qDbWJ5BMZnSoP84pRP0rorbS8j3qMoeRvwtnWd0jOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498292; c=relaxed/simple;
	bh=+xHIXcL4u8gR04yGIQ87cO7TdokEfuJIG93hOBVbwnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXLkBmyEQ/gVqkxRTYy/PGRI3etVNvR8fvinck4Zd+fpz1ZuI9264TtHiN6kBl5Nq8LGNVA4m34ZBQjTvIPoqexXD49LfzULBcDoX0AaurdbBhPJftwuFFN1k4V22Oz8TT5Dnb1cafI+X5rbRDAcFsb8H3flo2LWqAhlWOybRJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRUxsh1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRUxsh1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE66C116D0;
	Thu, 15 Jan 2026 17:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498292;
	bh=+xHIXcL4u8gR04yGIQ87cO7TdokEfuJIG93hOBVbwnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRUxsh1YUXwYhN8zESU4KpeEdD4pLBVHHkbRr1ajPVDUmxsF0MVTEvhSk+z7yt54y
	 LzvzW+2QsUbdJbwM/4mYjQiJSAqIjkJ0QfRrEd30Snt5sJFyXBoRrlLGzr5VvK13QB
	 5n8V8/kKsFd7aUIBqmy3stZ/7INH7b0+/NULm97M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5.15 379/554] iommu/sun50i: fix device leak on of_xlate()
Date: Thu, 15 Jan 2026 17:47:25 +0100
Message-ID: <20260115164259.954162288@linuxfoundation.org>
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

commit f916109bf53864605d10bf6f4215afa023a80406 upstream.

Make sure to drop the reference taken to the iommu platform device when
looking up its driver data during of_xlate().

Fixes: 4100b8c229b3 ("iommu: Add Allwinner H6 IOMMU driver")
Cc: stable@vger.kernel.org	# 5.8
Cc: Maxime Ripard <mripard@kernel.org>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/sun50i-iommu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -756,6 +756,8 @@ static int sun50i_iommu_of_xlate(struct
 
 	dev_iommu_priv_set(dev, platform_get_drvdata(iommu_pdev));
 
+	put_device(&iommu_pdev->dev);
+
 	return iommu_fwspec_add_ids(dev, &id, 1);
 }
 


