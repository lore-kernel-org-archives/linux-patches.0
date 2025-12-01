Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECEB3043AF;
	Mon,  1 Dec 2025 11:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588544; cv=none; b=Lc0M5+Hm5WALyDLJgfWKG+w0TjrjWfWNr2X8KapODdkKACKPRmRiLeBvnUG04YXaqRBb/oa4ab16lb2FJa2oCpZRZVz3j04Bw8+IfQdvReAyHQVebJyVwRz3MhGuzOEriSWGm1Jh3si5vs01VFxXNAepcb+QjYheBrj6ChGhW70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588544; c=relaxed/simple;
	bh=Rhk6INrTg6d0SGEs62TNEIWsdEUNK1qjueZxMteghcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNtf18kELCE527e0gmfXuXngdCnZfB1XCunVbyFS5NK6jurT3ozrLs0iGOgEz9XnCgPUYV53UzSDtZTHlib+NGfGC97dVCGNnwfoI0Gm8ZuE3mnM7NKZc3ka9MAH2OiRLuuxfK3K0GBVri5FjCYPZpFpvQ6cla5WKpgPQ6tJ6hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NwETu1r4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwETu1r4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F58C4CEF1;
	Mon,  1 Dec 2025 11:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588543;
	bh=Rhk6INrTg6d0SGEs62TNEIWsdEUNK1qjueZxMteghcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwETu1r4Fs9z+yWv4ka9VCiffivvym3mF1J0dBHmkKH7VCnURK/nF6TuwUkqMcUhh
	 8nPjo2pszBj35+61Qu61tGyVh/QZAcpmJ6a2ZRi+MewQQdiotpYJIo9MgaJ2B60zkw
	 2vfdieR6jF+fOI+2QzLx6D7R7raZPKAoMelxsd8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geoffrey McRae <geoffrey.mcrae@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 052/187] drm/amdkfd: return -ENOTTY for unsupported IOCTLs
Date: Mon,  1 Dec 2025 12:22:40 +0100
Message-ID: <20251201112243.124586078@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Geoffrey McRae <geoffrey.mcrae@amd.com>

[ Upstream commit 57af162bfc8c05332a28c4d458d246cc46d2746d ]

Some kfd ioctls may not be available depending on the kernel version the
user is running, as such we need to report -ENOTTY so userland can
determine the cause of the ioctl failure.

Signed-off-by: Geoffrey McRae <geoffrey.mcrae@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index a845eda14ece3..548cd062b9cd3 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1796,8 +1796,10 @@ static long kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	unsigned int usize, asize;
 	int retcode = -EINVAL;
 
-	if (nr >= AMDKFD_CORE_IOCTL_COUNT)
+	if (nr >= AMDKFD_CORE_IOCTL_COUNT) {
+		retcode = -ENOTTY;
 		goto err_i1;
+	}
 
 	if ((nr >= AMDKFD_COMMAND_START) && (nr < AMDKFD_COMMAND_END)) {
 		u32 amdkfd_size;
@@ -1810,8 +1812,10 @@ static long kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 			asize = amdkfd_size;
 
 		cmd = ioctl->cmd;
-	} else
+	} else {
+		retcode = -ENOTTY;
 		goto err_i1;
+	}
 
 	dev_dbg(kfd_device, "ioctl cmd 0x%x (#%d), arg 0x%lx\n", cmd, nr, arg);
 
-- 
2.51.0



