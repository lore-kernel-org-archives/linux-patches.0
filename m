Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD967262A;
	Tue, 11 Nov 2025 01:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822935; cv=none; b=PtS5mmNIH6G9U62z46X89tsUpBUCPxYNKJUIXqu3cauIW4IwV1q0meYKDdo10c+3qaevoe4DWFq/KsT/yZ5RqfnVlRh1QoCBev8PVE+Xv8nZuhvBRFwImAaSIORelITeW4Z4k7ahT0UXtXEZxKH6BFijRlEVANNb7Bu4AG1z2xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822935; c=relaxed/simple;
	bh=gH/MrHJTwMIkDRVDV+mLbywgqhpghrnkeCfu57Ofltg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJQvRHvCpDb+f2nkzihEfCgS4ZXPVl0OPLwdukdybpt1d0kWi2Zp8rrLJz7YlhFzBg7ok+AmSCKiSpMXv8WDao/am2JFY3r5TvLukMDOKnyN26OGq90kZXFuPyH3d0iNzQyGGRTF7lgVsZeZui07Hx4OOIZ5426yHz06bBlEt6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMeBw2d1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMeBw2d1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049F3C19422;
	Tue, 11 Nov 2025 01:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822934;
	bh=gH/MrHJTwMIkDRVDV+mLbywgqhpghrnkeCfu57Ofltg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kMeBw2d1a01tuXnLKH1w/CI92xEBGmlh0p5nXsJFTvaO55H5lvv8522+02z08kF/v
	 f8PXqsofvXlM0VWtDRFRcgncL+tnydnc2y91O9BdwHp8vfSo6pItGR7P2BoC+O5Bzn
	 oI46Mys2CAcHdeu4vjiIrisXI/M/1MG+aK0Mn9nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 136/565] tee: allow a driver to allocate a tee_device without a pool
Date: Tue, 11 Nov 2025 09:39:52 +0900
Message-ID: <20251111004530.005540610@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>

[ Upstream commit 6dbcd5a9ab6cb6644e7d728521da1c9035ec7235 ]

A TEE driver doesn't always need to provide a pool if it doesn't
support memory sharing ioctls and can allocate memory for TEE
messages in another way. Although this is mentioned in the
documentation for tee_device_alloc(), it is not handled correctly.

Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/tee_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
index acc7998758ad8..133447f250657 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -889,7 +889,7 @@ struct tee_device *tee_device_alloc(const struct tee_desc *teedesc,
 
 	if (!teedesc || !teedesc->name || !teedesc->ops ||
 	    !teedesc->ops->get_version || !teedesc->ops->open ||
-	    !teedesc->ops->release || !pool)
+	    !teedesc->ops->release)
 		return ERR_PTR(-EINVAL);
 
 	teedev = kzalloc(sizeof(*teedev), GFP_KERNEL);
-- 
2.51.0



