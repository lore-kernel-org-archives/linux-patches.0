Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C08306D2A;
	Wed,  3 Dec 2025 16:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780533; cv=none; b=YqNHY6+yRBf8uY2BQIychop1eluy2MTh6+dltCWE3p47EuTgG29RIf1kbj/x/RajUyClSNeXzyu9SwpzFh38x3dLaZHy6ZH1qqld9g8Hyxjolr6sqy9kOx7IXq/3asq3Cra1TjbctjPoT1zGZbA6V+FTnQUG6Hiz5CIh7gOKCkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780533; c=relaxed/simple;
	bh=ikPK/AMR10G2F0l2Vm7KVGor4NnHedVsdH5vtP/U1vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pad/uqi/9LHREU4mKFILlBaVr6cRll63M4q85RmDNEqG+vBhc/5rLGib2JtahIbNsxTkgMWjkjGNDBypBSi3zCigXBEHmsSNeHXqJ0RGRY6EVjBC2o1q4QEGS02/i3kVmkZvkToAtopfzFGmCDPicfg9Try7jnUCIzGVHw9sZv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1oGYOyMV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1oGYOyMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1027AC4CEF5;
	Wed,  3 Dec 2025 16:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780533;
	bh=ikPK/AMR10G2F0l2Vm7KVGor4NnHedVsdH5vtP/U1vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1oGYOyMVOugXhdEimv44OCbZjhVEtRVyBhOhiBO+C50Nl1cWhbsrFQWvvTC1UERvz
	 rBhjqMXNMLmgIh4sNOylBrPqmRWlFKgcNYIUHFBh3Pn2vUc82zYiFRJrk/hZ3Cw1dj
	 ZKXQsBUU7K4Y12IkR4BzMfqQr6RRUpumes9tBpy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/132] platform/x86: intel: punit_ipc: fix memory corruption
Date: Wed,  3 Dec 2025 16:28:14 +0100
Message-ID: <20251203152343.860638823@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 9b9c0adbc3f8a524d291baccc9d0c04097fb4869 ]

This passes the address of the pointer "&punit_ipcdev" when the intent
was to pass the pointer itself "punit_ipcdev" (without the ampersand).
This means that the:

	complete(&ipcdev->cmd_complete);

in intel_punit_ioc() will write to a wrong memory address corrupting it.

Fixes: fdca4f16f57d ("platform:x86: add Intel P-Unit mailbox IPC driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/aSCmoBipSQ_tlD-D@stanley.mountain
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/punit_ipc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/punit_ipc.c b/drivers/platform/x86/intel/punit_ipc.c
index cd0ba84cc8e4a..9e48229538a5e 100644
--- a/drivers/platform/x86/intel/punit_ipc.c
+++ b/drivers/platform/x86/intel/punit_ipc.c
@@ -283,7 +283,7 @@ static int intel_punit_ipc_probe(struct platform_device *pdev)
 	} else {
 		ret = devm_request_irq(&pdev->dev, irq, intel_punit_ioc,
 				       IRQF_NO_SUSPEND, "intel_punit_ipc",
-				       &punit_ipcdev);
+				       punit_ipcdev);
 		if (ret) {
 			dev_err(&pdev->dev, "Failed to request irq: %d\n", irq);
 			return ret;
-- 
2.51.0



