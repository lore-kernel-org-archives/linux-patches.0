Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE9B15990C;
	Wed,  5 Feb 2025 13:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763908; cv=none; b=MIUF3EpZez39v1bC2X8hx/u6Ct3C2bmLgQZ37gHnoAQhM/OU6qZ9Xi0dDrZJnpO25e7G/WVmPj4gAwciRrfJK2oOZCYShBVNPORiAPE49UTmbUgrBlIQGv5r0sbbLiHE6V/U9Q8dUnsPJAgJIwBbWYtef1kA8vOKkFMaRDrGy/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763908; c=relaxed/simple;
	bh=nsOHikgywB+6fEioPFanyDdz1D7kAD2Onhr9ZSIUsRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gof6pdCTeAFfUK0gnB1/WMNdY8NrB1dhjH9pLMyWWHpuHlhdiH1ThQzRQXm/EOCckCbZ28Nz6UcA5SqcAVkrwtgryIH3TDXIOiJDCL5w7DZjIq/5ASP2C8Gaxo0vsgk8nwXHHl6pp9mP9+Xor9CDX6NDSSp/a8eJ+vxhTho/Dxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iH3M5S41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iH3M5S41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC25C4CED1;
	Wed,  5 Feb 2025 13:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763907;
	bh=nsOHikgywB+6fEioPFanyDdz1D7kAD2Onhr9ZSIUsRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iH3M5S41NW5bFDg2+M1uk+XRbxTCl9hqqJ+iU9dgtldFfLDtavE4abK+ujG1RL4FJ
	 XX/PfkBi0BO8N033Vuq7LO76fr5yb99u2Trcvwp8FRdaybIfj1k2hGWeo6ymMVKjSP
	 X9CBbS5w5w47dlC7Vkh2VLJz7WWmSbA2DFDre0ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 029/623] nvme: fix bogus kzalloc() return check in nvme_init_effects_log()
Date: Wed,  5 Feb 2025 14:36:11 +0100
Message-ID: <20250205134457.342918674@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 170e086ad3997f816d1f551f178a03a626a130b7 ]

nvme_init_effects_log() returns failure when kzalloc() is successful,
which is obviously wrong and causes failures to boot. Correct the
check.

Fixes: d4a95adeabc6 ("nvme: Add error path for xa_store in nvme_init_effects")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 7c4a19f5c951a..12e7ae1f99e20 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3181,7 +3181,7 @@ static int nvme_init_effects_log(struct nvme_ctrl *ctrl,
 	struct nvme_effects_log *effects, *old;
 
 	effects = kzalloc(sizeof(*effects), GFP_KERNEL);
-	if (effects)
+	if (!effects)
 		return -ENOMEM;
 
 	old = xa_store(&ctrl->cels, csi, effects, GFP_KERNEL);
-- 
2.39.5



