Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA7A320CB6;
	Fri,  9 Jan 2026 12:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960859; cv=none; b=El9swImMiTpOU03AUlYcLWaiELThBNM1lcMkZ7kHD6nsriuIuv7KIOtiWyEtpVMbT9ph2FA+zgzxA9gM69Ie8sE9hU3C1iGVR//6VVCrJ8IsnI3zpYFx2E61Ono6eKttlWL5W3LR3TwdRgXGia0BKOJ3X0m8wIAjz5P3bEpw6G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960859; c=relaxed/simple;
	bh=8qeqEmuAlFyfUM7oXg4QG7BFb+neT6ZbqF0+Y6jxLpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGgH2HNO8YZHZagjJ5SRzloxHjlzdk8g5Y6jyyduaDmXcX3rMBtBMfwu6QP+6i8Yeo5WJkmg8wUEKZ+wSf5xTCHmxSVmxOuplsR5sZrJK1BbcRwErtQ5Z49R5QmzHaEUgpOrOan9y7klMI0D9u3CsuzpBlW7yiLyGe1yYziXgDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1hdDQOMu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1hdDQOMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F341C4CEF1;
	Fri,  9 Jan 2026 12:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960859;
	bh=8qeqEmuAlFyfUM7oXg4QG7BFb+neT6ZbqF0+Y6jxLpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1hdDQOMunHPyOYOpUut/DzlsrQtipM+gHMNQsPuZiawD+wuGx5Tm6oJl+e8zqehFC
	 /YRI6NZSZZcIlJDcusq719SwmgVJjhd+3ecbBIkIJNdfIJ8wTjjbTrzABf0hiQRAzW
	 mLbrm6C8F3CuVCB+flQkVjHrxqJmrE9jCdOtiMJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.6 550/737] iommu/apple-dart: fix device leak on of_xlate()
Date: Fri,  9 Jan 2026 12:41:29 +0100
Message-ID: <20260109112154.685470185@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -758,6 +758,8 @@ static int apple_dart_of_xlate(struct de
 	struct apple_dart *cfg_dart;
 	int i, sid;
 
+	put_device(&iommu_pdev->dev);
+
 	if (args->args_count != 1)
 		return -EINVAL;
 	sid = args->args[0];


