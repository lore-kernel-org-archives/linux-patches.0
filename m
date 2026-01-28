Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D875A2857CD;
	Wed, 28 Jan 2026 15:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615711; cv=none; b=Yh+U5uLC2nWJOQP+Q934qPczMuLavHQe9Jk/2nXBgZ23V9Q0Ykd3Qmi8sbLoEV+iol5c2rby/atSsBOHusDAHSfpn7oNJsx71BgintP3HcaRR/wpa5pOBAcAA/LMFgJoipF+mNh9UMAFRq0oDBLzgsqncHlmWonAu9wBJnT1Ddo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615711; c=relaxed/simple;
	bh=pkXGO+Hm6y+ZfImnuETDJ/iOmWxW+MmVsybg3SiKCIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IYzMJuOrIIslq7WogiI1xyD4BXkxZY1wOzck5Kat5+XKhxVSTwDnZA+oFLfRoamdaXrG6sJwBgRBvyB+sJuMnu4Qb4+B/JjzskBYFiVFOXcseG/5QpXNBjJ71vJiB+Z4jRLoVGtv41w6OvSPRZA+9wDb17kX28oF6136PVCq9XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PujbZ5z/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PujbZ5z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2F0C4CEF1;
	Wed, 28 Jan 2026 15:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615711;
	bh=pkXGO+Hm6y+ZfImnuETDJ/iOmWxW+MmVsybg3SiKCIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PujbZ5z/5r7I0G2tRhvW4VS489rTwEyQIkjZIa6QiHXg93w9dLA0aQdM3bBdjJ+eK
	 6s5pdqmht6FAJfM9KlaDEfLvULenoCnDHGc7oDtDVp8hXAxbpEXOjed3uc1P0jaYLn
	 v8duWZSA9IoxwuHQ/nN0lHgLKMqSv3ppbq35wveA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>,
	Zilin Guan <zilin@seu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 091/227] platform/x86/amd: Fix memory leak in wbrf_record()
Date: Wed, 28 Jan 2026 16:22:16 +0100
Message-ID: <20260128145347.609097305@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 2bf1877b7094c684e1d652cac6912cfbc507ad3e ]

The tmp buffer is allocated using kcalloc() but is not freed if
acpi_evaluate_dsm() fails. This causes a memory leak in the error path.

Fix this by explicitly freeing the tmp buffer in the error handling
path of acpi_evaluate_dsm().

Fixes: 58e82a62669d ("platform/x86/amd: Add support for AMD ACPI based Wifi band RFI mitigation feature")
Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Co-developed-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Link: https://patch.msgid.link/20260106091318.747019-1-zilin@seu.edu.cn
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/wbrf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/amd/wbrf.c b/drivers/platform/x86/amd/wbrf.c
index dd197b3aebe06..0f58d252b620a 100644
--- a/drivers/platform/x86/amd/wbrf.c
+++ b/drivers/platform/x86/amd/wbrf.c
@@ -104,8 +104,10 @@ static int wbrf_record(struct acpi_device *adev, uint8_t action, struct wbrf_ran
 	obj = acpi_evaluate_dsm(adev->handle, &wifi_acpi_dsm_guid,
 				WBRF_REVISION, WBRF_RECORD, &argv4);
 
-	if (!obj)
+	if (!obj) {
+		kfree(tmp);
 		return -EINVAL;
+	}
 
 	if (obj->type != ACPI_TYPE_INTEGER) {
 		ret = -EINVAL;
-- 
2.51.0



