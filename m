Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C634F2BF012;
	Tue, 22 Jul 2025 14:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193526; cv=none; b=nfkiRg/NKf28+fCkkfU1CBiivyi+/2mMm3J9h6wAZIcaGU03WcEs3V420E9NUyT1ux365JFsxi5WqjBWon3bOUUzqjhQ9C3tX6B8C7RZJiUaDimUjkw/k8Yl7ZSfxrMc6GFOY+pgE30BK2u02TSC8OUF0DZux0t6IwB10b8RcFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193526; c=relaxed/simple;
	bh=lZQ5eYF+ZLovwsJYfXPCFnBCp+mOLrBj7jWSTmSK2ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OpgZWXUMHL5DEQsRQK0Bi4mXGzudYtPqMQh0UHekrOPXd3sOOIafHDiu8yuNuxDfTP3e/gvj+GS0RSd0wOfzt8+EYdih/WOOhr0uWJ/QmiJ4nWgFiPySqwmSzAKamqkgH4bwEu9UnPbtLRgxEe9z2KkjN7QKX86PJYzjJu2D9Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZQuRh3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZQuRh3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D2BC4CEEB;
	Tue, 22 Jul 2025 14:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193526;
	bh=lZQ5eYF+ZLovwsJYfXPCFnBCp+mOLrBj7jWSTmSK2ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZQuRh3Nwwd3JYIaTHvbByCyVhGbSlj4TwvDkzH6h/qd76K0nV3B3xrangaQjSRAO
	 tf7HEq1HrLSRzyq1w2dkwcEmI/FrpJupta8oDqugTX7MKG7Ds2bMyba5mXWUhnI3iM
	 zuGkeMPXEnaD2Cyqw2waECk0UYRjrOuwk8dzDOJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Alan Adamson <alan.adamson@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 120/187] nvme: revert the cross-controller atomic write size validation
Date: Tue, 22 Jul 2025 15:44:50 +0200
Message-ID: <20250722134350.225898481@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 1fc09f2961f5c6d8bb53bc989f17b12fdc6bc93d ]

This was originally added by commit 8695f060a029 ("nvme: all namespaces
in a subsystem must adhere to a common atomic write size") to check
the all controllers in a subsystem report the same atomic write size,
but the check wasn't quite correct and caused problems for devices
with multiple namespaces that report different LBA sizes.  Commit
f46d273449ba ("nvme: fix atomic write size validation") tried to fix
this, but then caused problems for namespace rediscovery after a
format with an LBA size change that changes the AWUPF value.

This drops the validation and essentially reverts those two commits while
keeping the cleanup that went in between the two.  We'll need to figure
out how to properly check for the mouse trap that nvme left us, but for
now revert the check to keep devices working for users who couldn't care
less about the atomic write feature.

Fixes: 8695f060a029 ("nvme: all namespaces in a subsystem must adhere to a common atomic write size")
Fixes: f46d273449ba ("nvme: fix atomic write size validation")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alan Adamson <alan.adamson@oracle.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Tested-by: Alan Adamson <alan.adamson@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 8ba56017f917e..89a0f2a6c6268 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3354,15 +3354,6 @@ static int nvme_init_identify(struct nvme_ctrl *ctrl)
 		if (ret)
 			goto out_free;
 	}
-
-	if (le16_to_cpu(id->awupf) != ctrl->subsys->awupf) {
-		dev_err_ratelimited(ctrl->device,
-			"inconsistent AWUPF, controller not added (%u/%u).\n",
-			le16_to_cpu(id->awupf), ctrl->subsys->awupf);
-		ret = -EINVAL;
-		goto out_free;
-	}
-
 	memcpy(ctrl->subsys->firmware_rev, id->fr,
 	       sizeof(ctrl->subsys->firmware_rev));
 
-- 
2.39.5



