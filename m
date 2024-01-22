Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17C360269;
	Tue, 23 Jan 2024 00:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970779; cv=none; b=nEpNOT88mT2Ny4JiQTxNo9vO1v9nvi90JXT5utcMxK7kkNyDMPea125tutolqGO7Iwn+uUCMA06ABWco03KzOZuEUOo+a+RKA6pnp0LF/Ah5Kt4ZqN145kkMN4uEw5ejdPn4vlG7PEzcjG4ElAlIiWvUsVWWbd/embElmKoeTzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970779; c=relaxed/simple;
	bh=CeAeoLEWyiZ0zPO7Ce89W5VH9dDVAD4E+sgE0xt+wnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCqYBzlqHrudYr/oilYqJbUmdVdtVPCRoyH3qOee/f1IFgh4PhQClIwaH0TUCMS9/KxBUEI0ZWUHJkCHxQ23gtUDSYa5DaPqIm5oFRyxvm+hSyMuOqL4mQAB4/X7RuILr11RO7ZRbt3YGCO1uOJNTqi6deuuGN/PkHo0Bu2/+F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1jWmWdl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1jWmWdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C911C433C7;
	Tue, 23 Jan 2024 00:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970779;
	bh=CeAeoLEWyiZ0zPO7Ce89W5VH9dDVAD4E+sgE0xt+wnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x1jWmWdlBl3Fg5ehJLjL6kx10kyMEEJ6nwIqrYe244ZMxaA2zQsenp5+1h1rYMiSk
	 uiaky1c6Xtxh/bocZtuLCFoJjyp5HgUb0Hz0e9IoUUTvHbsl16hhoWq+5nh8y4Mhn4
	 zHSuWqKEgX6aCfWFtzUa/mPjix7E9ROx2h7+CSfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/286] nouveau/tu102: flush all pdbs on vmm flush
Date: Mon, 22 Jan 2024 15:55:21 -0800
Message-ID: <20240122235732.607133352@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b1294d0076c0..72449bf613bf 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmtu102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmtu102.c
@@ -32,7 +32,7 @@ tu102_vmm_flush(struct nvkm_vmm *vmm, int depth)
 
 	type |= 0x00000001; /* PAGE_ALL */
 	if (atomic_read(&vmm->engref[NVKM_SUBDEV_BAR]))
-		type |= 0x00000004; /* HUB_ONLY */
+		type |= 0x00000006; /* HUB_ONLY | ALL PDB (hack) */
 
 	mutex_lock(&subdev->mutex);
 
-- 
2.43.0



