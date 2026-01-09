Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98BC33372B;
	Fri,  9 Jan 2026 12:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962683; cv=none; b=Lx7phDawpHbx0mc5NgKBw0UIRP5NMhSnq0dJPPcL+wVWyiqNJEXJIjwDRdKORf6vkkawbnarX65TXblXwvCYKdBUTqAae7yr0ClRuV+v2O99rdBvAYfi7XodOU9pVt70tq71dfOKC/TMXS5p68XxNoit3B7e4nDV/BcKQhJH7Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962683; c=relaxed/simple;
	bh=vRTCZn91d0Vbw9UmarYJp7mvhBvMHMQP/cyz4ajlGZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTppFZLBGoHkpP9SG9zphxE8QLmx2q0d2jbYemeRcW3H7+tqCzKXZIiU4lpuH/jCxnNF/x6Xfw4Dlg8ef5TEpMbY6ONoDXMxwn+p8R1yXTRVO5mHBsKboquMQcDfIB/RH22/KAtkxmkdCEh9CcpXi2Nn733UCkpeLQ927M/OAzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HjUbzJE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HjUbzJE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726A2C4CEF1;
	Fri,  9 Jan 2026 12:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962682;
	bh=vRTCZn91d0Vbw9UmarYJp7mvhBvMHMQP/cyz4ajlGZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjUbzJE+4eqfbB6ZkRLjW8Hmkw2PHfDXktv3ElUdSLR84Zi5sXurhHcKT95PV3/Pw
	 z6oBcOtGpg26Nb2Oj8VBQApLplVdcjzPr5Opn/l832o3Q87LRrmS82Qb9lHZLam/Rr
	 IOd3X369ROpJp037DL39+XzCqAsk1ttIt4bPc53Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.1 450/634] iommu/apple-dart: fix device leak on of_xlate()
Date: Fri,  9 Jan 2026 12:42:08 +0100
Message-ID: <20260109112134.473673810@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -634,6 +634,8 @@ static int apple_dart_of_xlate(struct de
 	struct apple_dart *cfg_dart;
 	int i, sid;
 
+	put_device(&iommu_pdev->dev);
+
 	if (args->args_count != 1)
 		return -EINVAL;
 	sid = args->args[0];


