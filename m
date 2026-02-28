Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E880379EF1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302049; cv=none; b=G26pvOBY3Gp/lsLQh3wXV92FmjohUh1/HVbTVK/CUAJJ6VER4KRA09Q5Wd/XVAjGWnl2Y5bYF+B4hiK9N0LOskVzLdmpzPzOMfC+wfr1cN/GnZz95tsaZ7FPmeyMWk1UrqV7HkKrs54baiKCTc0/LKg29dQ7yjGiTayY6IVswBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302049; c=relaxed/simple;
	bh=4aIeTImStaS5QuL/sWUjQivKC4NYdyFGlsiRCkbyiso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGffSchcYkhDiSaExF35zP9ezj8ZyUHubZ2MyVGBPUkWkft8xtFJPazV4tNRdhPv56Y4rnWMgZTXfvZb76nas1kSLGnyTLg3Akx8rlx7pAt6F/MtKf87hP2moGbcHemdvu8cTWVBWfeoPFeXy0cj6TLsQwtllRYjqPDKcf+KAIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ikxVq7LW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ikxVq7LW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0673C116D0;
	Sat, 28 Feb 2026 18:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302049;
	bh=4aIeTImStaS5QuL/sWUjQivKC4NYdyFGlsiRCkbyiso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikxVq7LWG23aBiIAJE8HDQgzsA7daYhnMK0hpGLSeF2mqrIv0uZ9P55ecnpYoSEUW
	 LI2SZKgn9ycBQ8Ze8dBtzlhfftcZJTLx4n4CESpTxHry5By1dOErxB9EpQqTq1mIaM
	 HW6UH1hx14b8FvgXhI18971dHUs1Lt4lc1miL+5TNZtZ/EytmEayvWairkKQBdPB4N
	 dciVm+E4e/Qin6zxNxgM1VguAplwAitE52yli43hr4UsLakC76+0ZhV+WiUSsaANnL
	 HpKFFLuTjJtOEAVV+7Z6NSzHJvAksCsr7JkMwuZpMANjOXsNB9cMtKkOmoEv8yhpOg
	 a+zew8m5MqmSQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Teddy Astie <teddy.astie@vates.tech>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/283] xen/virtio: Don't use grant-dma-ops when running as Dom0
Date: Sat, 28 Feb 2026 13:02:45 -0500
Message-ID: <20260228180709.1583486-23-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Teddy Astie <teddy.astie@vates.tech>

[ Upstream commit dc8ea8714311e549ee93a2b0bdd5487d20bfadbf ]

Dom0 inherit devices from the machine and is usually in PV mode.
If we are running in a virtual that has virtio devices, these devices
would be considered as using grants with Dom0 as backend, while being
the said Dom0 itself, while we want to use these devices like regular
PCI devices.

Fix this by preventing grant-dma-ops from being used when running as Dom0
(initial domain). We still keep the device-tree logic as-is.

Signed-off-by: Teddy Astie <teddy.astie@vates.tech>
Fixes: 61367688f1fb0 ("xen/virtio: enable grant based virtio on x86")
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <6698564dd2270a9f7377b78ebfb20cb425cabbe8.1767720955.git.teddy.astie@vates.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/grant-dma-ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/grant-dma-ops.c b/drivers/xen/grant-dma-ops.c
index 76f6f26265a3b..12fbe89382593 100644
--- a/drivers/xen/grant-dma-ops.c
+++ b/drivers/xen/grant-dma-ops.c
@@ -362,7 +362,8 @@ static int xen_grant_init_backend_domid(struct device *dev,
 	if (np) {
 		ret = xen_dt_grant_init_backend_domid(dev, np, backend_domid);
 		of_node_put(np);
-	} else if (IS_ENABLED(CONFIG_XEN_VIRTIO_FORCE_GRANT) || xen_pv_domain()) {
+	} else if (!xen_initial_domain() &&
+		   (IS_ENABLED(CONFIG_XEN_VIRTIO_FORCE_GRANT) || xen_pv_domain())) {
 		dev_info(dev, "Using dom0 as backend\n");
 		*backend_domid = 0;
 		ret = 0;
-- 
2.51.0

