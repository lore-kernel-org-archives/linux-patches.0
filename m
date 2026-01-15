Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0819F3D1CCC;
	Thu, 15 Jan 2026 17:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499676; cv=none; b=ZNzxPBuYYtW7mAWOK+H6bxJa+GLPMiRPIgEXekHxLMxiDXQ5NU4hkPFIxexV0hejkxT+qOD0GZ8g9Zld8zp9v3VDTWK7niCZ0MLyRjKju3J5kJnqk2M241d3cXEt1X7dlW3Fex29MxQSHU7CXIVa0K0Auuhat7FKzBtz9IV6jFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499676; c=relaxed/simple;
	bh=8tjjm8i0zTkDcIO0nJ4WX9UGEX8hydomso/d4x79jzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CT9mli4Mk2igGLkPPJV/DAu6kQMxCQN55o9kLbOP+s7NWlCcNBcv7WHM3erplzbQ0xIJEiSgtvFvdOue3uHBDqxeFFTLhlcWT3+qTwe/tEGO95cpQGGJgRv4zRwwMBFtG8zh+KDG4VVWVgMW3lJfxfAGIItiBfe1UIisqGcPz7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4WPWQbT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4WPWQbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC17C116D0;
	Thu, 15 Jan 2026 17:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499675;
	bh=8tjjm8i0zTkDcIO0nJ4WX9UGEX8hydomso/d4x79jzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4WPWQbTqn42rHR4LLABNVuzXNmJRiwErhljeDSivQ32m3aYTW5XqW1b121Gkc6hG
	 ubBXRHmYBY39c2u4j9PpI5EM/IskS6Am+kDpKCu3Tv+ysB/0UyHV6KP68DDfqtxAef
	 tmb3DF+BKPheKwJa34PupBeyfo/otxkdoUJgyiq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Damm <damm+renesas@opensource.se>,
	Robin Murphy <robin.murphy@arm.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5.10 303/451] iommu/ipmmu-vmsa: fix device leak on of_xlate()
Date: Thu, 15 Jan 2026 17:48:24 +0100
Message-ID: <20260115164241.855505585@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -732,6 +732,8 @@ static int ipmmu_init_platform_device(st
 
 	dev_iommu_priv_set(dev, platform_get_drvdata(ipmmu_pdev));
 
+	put_device(&ipmmu_pdev->dev);
+
 	return 0;
 }
 


