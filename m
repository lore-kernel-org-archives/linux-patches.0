Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984387CF1F;
	Wed,  3 Jul 2024 10:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003529; cv=none; b=EB//u/2qC4hTZc3lwQN42IfK3e3bI5JTZQm2/OgHSqC2zaLVNqD1MiuHn84foivD7LlSXlDgYcH5LLzTuRTmzMHEvo7akO7hRqIsLjwLAyaP0LgD4poepdakTxLFQaShocinff6yPvd44D49JoWEnPGPcjRqvbLVfAw054qrcq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003529; c=relaxed/simple;
	bh=W01tHAbl8U4wYy4CgYJGiC7zuEenyGJS+4NNJ+z59mE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJSeZrxs0CAoa3aa8MbZz0YqrKDLFW4Ty9euXEYMaPboB0vniYmpCb+CAdjO0tmwZr9PdvXICAI61CG5wk/uV0mfHA2lHt+7+y8qBcRekSIeZdHRu5aSW+Q7q2x2RqBgUE8J1sSlMzrRDpxNLnPcMo005BznO6Tbbhsw5jclHFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gjeh+Bx/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gjeh+Bx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5A0C2BD10;
	Wed,  3 Jul 2024 10:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003529;
	bh=W01tHAbl8U4wYy4CgYJGiC7zuEenyGJS+4NNJ+z59mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gjeh+Bx/mnG7CepsgGIDO5xb3Jvh/zePWUk7mdo3I1zcaq6ogoZd1lZnTZadILt3z
	 FCE0HZUx4VvUagMfSRuz3RIWBH4KH35a/RJx6C8ACOlUTkYzhtpxKY2DvYwP3K58Kl
	 Gq2n44bzdgMX8lhzq6CTW0XcSyk0pT20vzxUKYFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Shubin <n.shubin@yadro.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 078/139] dmaengine: ioatdma: Fix missing kmem_cache_destroy()
Date: Wed,  3 Jul 2024 12:39:35 +0200
Message-ID: <20240703102833.386215246@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Shubin <n.shubin@yadro.com>

[ Upstream commit 5422145d0b749ad554ada772133b9b20f9fb0ec8 ]

Fix missing kmem_cache_destroy() for ioat_sed_cache in
ioat_exit_module().

Noticed via:

```
modprobe ioatdma
rmmod ioatdma
modprobe ioatdma
debugfs: Directory 'ioat_sed_ent' with parent 'slab' already present!
```

Fixes: c0f28ce66ecf ("dmaengine: ioatdma: move all the init routines")
Signed-off-by: Nikita Shubin <n.shubin@yadro.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20240514-ioatdma_fixes-v1-1-2776a0913254@yadro.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ioat/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/ioat/init.c b/drivers/dma/ioat/init.c
index 0fec3c554fe35..673d0e32f589a 100644
--- a/drivers/dma/ioat/init.c
+++ b/drivers/dma/ioat/init.c
@@ -1429,6 +1429,7 @@ module_init(ioat_init_module);
 static void __exit ioat_exit_module(void)
 {
 	pci_unregister_driver(&ioat_pci_driver);
+	kmem_cache_destroy(ioat_sed_cache);
 	kmem_cache_destroy(ioat_cache);
 }
 module_exit(ioat_exit_module);
-- 
2.43.0



