Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B8C12A15E;
	Tue, 23 Jan 2024 00:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968758; cv=none; b=uka5gTA4F2mJ6+l6IZhbybMQyjI70A/eiPHgqNwvTXkS+lN0apKMRD5wpFjtzw4nvugaK7ikTyZSBiP6AuyL9fQC3FqafT3h0YhW6g6mQ8pdzoITjlrSmI4ULWixJqAtG8e9GCsKyv8cLczW/KVjsHEOeELcaHiBxTRjT/5MsPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968758; c=relaxed/simple;
	bh=TYaSrxCyKnm1TpnT/4+Jkdqkc3VdpIH08HFLS98UFRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2eeskDNrybDXe4C8Lh37m7XToM8V+qG0oIHoyekV9dCnLg4BVHf4B54+45puqpXxmoN3oWRG4ngga7kzuVGuvCO0nlJAID6yiJuGukKr7xdIDnPCuz6TDkGfyhEroXHkROoZakJ5fQVQCGaZ/dzqpVFL1xkwdaMT2mmDFWiKzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z2t2yr3A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z2t2yr3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4B4C43390;
	Tue, 23 Jan 2024 00:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968758;
	bh=TYaSrxCyKnm1TpnT/4+Jkdqkc3VdpIH08HFLS98UFRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z2t2yr3AVqbHWZ7t/D/zMsS6GGzZ5ba2aFa1YEQgZuKsIfX9v99o7uG98xvHMIv8z
	 ImJxRS7CI312eNU9vhdmm6wEBfDSWGhhyYa+tExydiBr/rNsQiGHH4v+31gNaiKkY8
	 jURCvXBleuVDiq32u//IrznLhPtD+DCFwayIM/mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 010/194] nouveau/tu102: flush all pdbs on vmm flush
Date: Mon, 22 Jan 2024 15:55:40 -0800
Message-ID: <20240122235719.637898009@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

[ Upstream commit cb9c919364653eeafb49e7ff5cd32f1ad64063ac ]

This is a hack around a bug exposed with the GSP code, I'm not sure
what is happening exactly, but it appears some of our flushes don't
result in proper tlb invalidation for out BAR2 and we get a BAR2
fault from GSP and it all dies.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Danilo Krummrich <dakr@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231130010852.4034774-1-airlied@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmtu102.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmtu102.c b/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmtu102.c
index be91cffc3b52..315000b2f8e3 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmtu102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmtu102.c
@@ -32,7 +32,7 @@ tu102_vmm_flush(struct nvkm_vmm *vmm, int depth)
 
 	type = 0x00000001; /* PAGE_ALL */
 	if (atomic_read(&vmm->engref[NVKM_SUBDEV_BAR]))
-		type |= 0x00000004; /* HUB_ONLY */
+		type |= 0x00000006; /* HUB_ONLY | ALL PDB (hack) */
 
 	mutex_lock(&subdev->mutex);
 
-- 
2.43.0



