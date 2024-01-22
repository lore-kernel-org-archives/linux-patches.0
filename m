Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBAC1487CF;
	Tue, 23 Jan 2024 01:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972072; cv=none; b=YgiX+ZVaWdLodGkO4J2ZsolhnQI4dHMDxgfsp9qUAktRdfd8tQdDL+vss9BnNQbDWyrd2CDkavWHkP7AgIQbIaepIfjnOCNyuCPmgWCpOp6TLgAxkUoibySKMw4m52HSp8wclWBMhbE4hR+UiSb+aepK49XXJy7WSjhLRbfpPBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972072; c=relaxed/simple;
	bh=NFQyQaORWnc9XDWtL8PciVP5J8u3cYgFHXDJYDBp0XA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5V5/sy65NO6XXC2rvTScP3JoZmNu0xzC/BzLvPCdo5VuCvyQIa+We6pTFscH+1t9soKDbLvNk7R2sHwCFuYqlir/IIFkD49Th1g7S88qU1rXkvkenaKrpFa8/CEhy0o0yVWZgrqqTkDziz0NRQKxCHumKtRVdEwlik+FDoml2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d2ciXU+E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d2ciXU+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC4CC43390;
	Tue, 23 Jan 2024 01:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972072;
	bh=NFQyQaORWnc9XDWtL8PciVP5J8u3cYgFHXDJYDBp0XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2ciXU+EEioS6znEUSvUB1V//BZe5qxt3Hcss2SweHCymEMxbWqyzvGryKqwMJJWD
	 JaMcGOolR+lHipiJ7MgQEW5B4GtrOkTqFojp/eGgKRXBeHIi1X4MVE/pHO3xZspEzM
	 x18VTM/hRcRiZ8boAaIDdqBPxj1TnQDEJks7BXtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/374] nouveau/tu102: flush all pdbs on vmm flush
Date: Mon, 22 Jan 2024 15:54:32 -0800
Message-ID: <20240122235745.193655119@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6cb5eefa45e9..5a08458fe1b7 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmtu102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmtu102.c
@@ -31,7 +31,7 @@ tu102_vmm_flush(struct nvkm_vmm *vmm, int depth)
 
 	type |= 0x00000001; /* PAGE_ALL */
 	if (atomic_read(&vmm->engref[NVKM_SUBDEV_BAR]))
-		type |= 0x00000004; /* HUB_ONLY */
+		type |= 0x00000006; /* HUB_ONLY | ALL PDB (hack) */
 
 	mutex_lock(&vmm->mmu->mutex);
 
-- 
2.43.0



