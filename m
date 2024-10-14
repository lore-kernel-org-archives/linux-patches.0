Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF1319E802;
	Mon, 14 Oct 2024 14:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917038; cv=none; b=Cc9FmzNRBiB+XVGP1OwIOQ0FmoJRz909SuAKBLL9ogMhT98MuFSaXlmqvouARAbCps7DgpvHuClZ8Wbeces87zFsekCb/zxL9F+yviWDHUBdfbfbH+FB2bPUu7DeXxh91AinPWxvX05NzKaXgc1WiPd2vH0+XmmKqV2d/EIbcRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917038; c=relaxed/simple;
	bh=AwMWXfJbt1oSU2yMscpTmnJxWXJEBGPcN5Fv9rW0m0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Etdzl8be/s5SOK+JAzdRvF8AKZ4bhAZ8pqYbLGg6flHoa/dRRKRyXB7LVYxtSgCdhJMZSI7gpwA6VYd6rmKi+5TeWCs9CvZqlmmi/NWN/oEk3wZcsYad3yShcsrEPT6qN2oCN4nFJjuHhU3vA56wrGEN9SemwDpWp/LsfrGQ/vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FMiqtXWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FMiqtXWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA9BC4CECF;
	Mon, 14 Oct 2024 14:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917037;
	bh=AwMWXfJbt1oSU2yMscpTmnJxWXJEBGPcN5Fv9rW0m0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FMiqtXWJKmB53R4vtrDaMXLRAsanvo4tpSO/XO15CBeKkJL5Papaj1Nx+PSAWZFdY
	 tcMDoOWnGoyhUrxJ5PeWl76H/fxb4S5seahsoKoKqnpG7JEbZwh6NoVl3AzlAifMJ9
	 sFvEkv2OxSQCJDaUpFHM/PrCKU0t54vPe1UGXk2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonatan Maman <Ymaman@Nvidia.com>,
	Gal Shalom <GalShalom@Nvidia.com>,
	Ben Skeggs <bskeggs@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/213] nouveau/dmem: Fix privileged error in copy engine channel
Date: Mon, 14 Oct 2024 16:20:40 +0200
Message-ID: <20241014141048.199539409@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonatan Maman <Ymaman@Nvidia.com>

[ Upstream commit 04e0481526e30ab8c7e7580033d2f88b7ef2da3f ]

When `nouveau_dmem_copy_one` is called, the following error occurs:

[272146.675156] nouveau 0000:06:00.0: fifo: PBDMA9: 00000004 [HCE_PRIV]
ch 1 00000300 00003386

This indicates that a copy push command triggered a Host Copy Engine
Privileged error on channel 1 (Copy Engine channel). To address this
issue, modify the Copy Engine channel to allow privileged push commands

Fixes: 6de125383a5c ("drm/nouveau/fifo: expose runlist topology info on all chipsets")
Signed-off-by: Yonatan Maman <Ymaman@Nvidia.com>
Co-developed-by: Gal Shalom <GalShalom@Nvidia.com>
Signed-off-by: Gal Shalom <GalShalom@Nvidia.com>
Reviewed-by: Ben Skeggs <bskeggs@nvidia.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241008115943.990286-2-ymaman@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_drm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index c39284dc7d73b..ac15a662e0604 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -343,7 +343,7 @@ nouveau_accel_ce_init(struct nouveau_drm *drm)
 		return;
 	}
 
-	ret = nouveau_channel_new(&drm->client, false, runm, NvDmaFB, NvDmaTT, &drm->cechan);
+	ret = nouveau_channel_new(&drm->client, true, runm, NvDmaFB, NvDmaTT, &drm->cechan);
 	if (ret)
 		NV_ERROR(drm, "failed to create ce channel, %d\n", ret);
 }
-- 
2.43.0



