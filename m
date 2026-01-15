Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A12A3A0E98;
	Thu, 15 Jan 2026 17:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498272; cv=none; b=V3jMz7yR1FgCrkd9zLEam9Ej81boyLn2WWz3dNnHsrl/tGyWZaVfFOh3eYVbQ2ksmr1dgMJBQ9DTKMja7IozS/F11BBYTJ+AMZX6hGVp0CNcMRIyu8HbkQr8aXgdvru+LSg+OjGgcigeaVSuFbglmeWS6VtXwGcRGZsabi9Cau0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498272; c=relaxed/simple;
	bh=IwjY0JnqA+WkD74y2Ow+DZPsrdinf+76nIxuGUEJJuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOGYNYNj2Mu6KF4bZrswjh9DPFlejE6ACgeM2KytFdqja+L3cQ8DiUv9AJDBBbnIpKCu9+wNRN81JbMGpVUDjq/vlEhfTVxGZ7aZcYO4jQ24taRhrv/7+wWy8sZpndxBi639ykHBdKG9GmSSc2NybX+wbO1Q0MnTerb/f+Et2X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y9bL0g/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y9bL0g/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB06FC116D0;
	Thu, 15 Jan 2026 17:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498272;
	bh=IwjY0JnqA+WkD74y2Ow+DZPsrdinf+76nIxuGUEJJuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y9bL0g/Bff1HjL2Uocc3CLz1GbnjYb+dw9X8Kjy1Dv1Cyot691IIg7inLSSk8TzKE
	 0QqdkXmVFsjohVoJ/1cgjmLCfGo15Vdo1gxJcYIL8n6NS5K0tIr7NdfiOAG2TlZxyX
	 3VghdIvLEmW4oqdZzUa06blqSJpOq4ooSlHFJwO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5.15 373/554] iommu/apple-dart: fix device leak on of_xlate()
Date: Thu, 15 Jan 2026 17:47:19 +0100
Message-ID: <20260115164259.732157797@linuxfoundation.org>
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
@@ -611,6 +611,8 @@ static int apple_dart_of_xlate(struct de
 	struct apple_dart *cfg_dart;
 	int i, sid;
 
+	put_device(&iommu_pdev->dev);
+
 	if (args->args_count != 1)
 		return -EINVAL;
 	sid = args->args[0];


