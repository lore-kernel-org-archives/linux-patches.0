Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436DF2F9483;
	Tue, 17 Jun 2025 16:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177238; cv=none; b=DCZPGUG7oPkw9NyZJFLnQz7mOcEsQoyqkWU2DJqmxyo4PyKZLkogYLCxUOjDwZJud08PUTPQ+2YX3hhwnQmQqIJWHdXIgIfY85iI4U1RDkGrSQAjv84g9AYbBHbuhnfhB9aWnXDwNOlWL/91InEjZVmyDGwMInDO3JzppMUGyFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177238; c=relaxed/simple;
	bh=FQhpJ5oatWvHtJcEATNn1sU7Z3R4zPar+BvDGDMx0GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJIKHoDij936zzdj7DXyffW73b2sRnYyYvSPmwwJsJfxcz4KFcbKprv8WtluqpVpT/WYA+hm1WyokRPsGGReOX80Xvy0Dq1DZaHLkjb14e0o9bochNePTsxJhYTqhSdD9UMLMNb/l28dEiFLxYG3ERa/MrSmDIWxjFXnbTuMQmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExI42M6q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExI42M6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DB0C4CEE3;
	Tue, 17 Jun 2025 16:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177234;
	bh=FQhpJ5oatWvHtJcEATNn1sU7Z3R4zPar+BvDGDMx0GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ExI42M6qqWzdaqSo9GWBXn4cIFW75xVCbdDJTwuK65rkbgfz3Ib1J39+Ozt9/bzn6
	 6r3DTiTc5py04D5Bgc8nYRQVEma7VGuLZ5P5kYtfoPtFopo6snbeYxpJWOKXGQQ8Rm
	 EyWBp3bOHTkm334PTfrWrz+1yqt6DMFLq861O2VI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 311/512] PCI: cadence: Fix runtime atomic count underflow
Date: Tue, 17 Jun 2025 17:24:37 +0200
Message-ID: <20250617152432.209859609@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Zhang <18255117159@163.com>

[ Upstream commit 8805f32a96d3b97cef07999fa6f52112678f7e65 ]

If the call to pci_host_probe() in cdns_pcie_host_setup() fails, PM
runtime count is decremented in the error path using pm_runtime_put_sync().
But the runtime count is not incremented by this driver, but only by the
callers (cdns_plat_pcie_probe/j721e_pcie_probe). And the callers also
decrement the runtime PM count in their error path. So this leads to the
below warning from the PM core:

	"runtime PM usage count underflow!"

So fix it by getting rid of pm_runtime_put_sync() in the error path and
directly return the errno.

Fixes: 49e427e6bdd1 ("Merge branch 'pci/host-probe-refactor'")
Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://patch.msgid.link/20250419133058.162048-1-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pcie-cadence-host.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/pci/controller/cadence/pcie-cadence-host.c b/drivers/pci/controller/cadence/pcie-cadence-host.c
index 8af95e9da7cec..741e10a575ec7 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-host.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-host.c
@@ -570,14 +570,5 @@ int cdns_pcie_host_setup(struct cdns_pcie_rc *rc)
 	if (!bridge->ops)
 		bridge->ops = &cdns_pcie_host_ops;
 
-	ret = pci_host_probe(bridge);
-	if (ret < 0)
-		goto err_init;
-
-	return 0;
-
- err_init:
-	pm_runtime_put_sync(dev);
-
-	return ret;
+	return pci_host_probe(bridge);
 }
-- 
2.39.5



