Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C984BC002;
	Sat, 28 Feb 2026 17:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301348; cv=none; b=nFh87medDnS9C9ROei8iP46S/HMpfBkbYMpFCmAC+g47IAspsIluRR5k8iaaqmdyQn1HC3FrCUbmoq1xQnvs6/wqLs5U0aDeK1ekCsG7yab43J/NAoOZPlw0zNABdV07FqKIYnKOKJFD8mcXwZWNHhlvIzCA8OIlBbKEC7uRCNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301348; c=relaxed/simple;
	bh=zMaUWkm3qmMDz0eMNZ10dyiuX56BqHuh7Glw3mA865Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iI0qQzs1DCzO6I48AJCrTpPnUFo3c44PX3uJgDvr7PA3xHKX8S5WISGzPyLC1oaK6UNVHDnXGnNy7TNvZGlrfwN3iJIG3XVQbITbS8kzcX6rW7FtIw4dfcNIVAT820JGQKVKSiX6zTirrFICvZJ68o4GqaQMA4D7odrjluEMLN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SoWPOWRa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SoWPOWRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19FDC19424;
	Sat, 28 Feb 2026 17:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301348;
	bh=zMaUWkm3qmMDz0eMNZ10dyiuX56BqHuh7Glw3mA865Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SoWPOWRabGjJu8OYF+elaqtCbxf+S4qrSny68KXj4EpYITvHcSV4/aFXqjtbaQnYy
	 SE51vyGkPeQITf8P3RevuWX737/NDgohKYeMXA68vWgSC7GeUtoo+2yir5/mAgKa0H
	 siuOQ/ZqdtmjnDnyNZ1/BVte8UX7EavFaI0ieMlxsU1bFlYTXepRjN3+hELgfYfASx
	 rslwb7V9gRcXKt9J5+nNjOSZMt4jf5+vXy5F0O16F6cZFdUPS0I9WDrkFgtcjXzgR4
	 Bu+YvJ+WS/UYy3ZVEHmE7XJAot7SyD7U/OrIvp3f615Tk5tgs+/3aB5+lciMsN+fwt
	 8D822AnrQwYXg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Bingbu Cao <bingbu.cao@intel.com>,
	Stable@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 535/752] media: staging/ipu7: Call synchronous RPM suspend in probe failure
Date: Sat, 28 Feb 2026 12:44:06 -0500
Message-ID: <20260228174750.1542406-535-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Bingbu Cao <bingbu.cao@intel.com>

[ Upstream commit 1433e6ccc25e9ea596683ab66e1c51f37fc7d491 ]

If firmware authentication failed during driver probe, driver call an
asynchronous API to suspend the psys device but the bus device will be
removed soon, thus runtime PM of bus device will be disabled soon, that
will cancel the suspend request, so use synchronous suspend to make
sure the runtime suspend before disabling its RPM.

IPU7 hardware has constraints that the PSYS device must be powered off
before ISYS, otherwise it will cause machine check error.

Cc: Stable@vger.kernel.org
Fixes: b7fe4c0019b1 ("media: staging/ipu7: add Intel IPU7 PCI device driver")
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/ipu7/ipu7.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/ipu7/ipu7.c b/drivers/staging/media/ipu7/ipu7.c
index 6c8c3eea44acb..fa5a1867626f8 100644
--- a/drivers/staging/media/ipu7/ipu7.c
+++ b/drivers/staging/media/ipu7/ipu7.c
@@ -2620,7 +2620,7 @@ static int ipu7_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!IS_ERR_OR_NULL(isp->isys) && !IS_ERR_OR_NULL(isp->isys->mmu))
 		ipu7_mmu_cleanup(isp->isys->mmu);
 	if (!IS_ERR_OR_NULL(isp->psys))
-		pm_runtime_put(&isp->psys->auxdev.dev);
+		pm_runtime_put_sync(&isp->psys->auxdev.dev);
 	ipu7_bus_del_devices(pdev);
 	release_firmware(isp->cpd_fw);
 buttress_exit:
-- 
2.51.0

