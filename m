Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A3F34B1B0;
	Wed,  3 Dec 2025 16:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777687; cv=none; b=FmNMswfoNsLa/yRghlxB2UpF7JKVULfGRo+9u2+918j3IB7zbDY4rOhfuUaYT41TDiH1Wx1+n4X3GphMT4EYawgPRIiKR1y9JbrPoR9vGxCEGDCNsxriCGY1BwHdv7YeHHRidvEV2MV87VD5VsYLf0jaXrLYDn8rJvK0Mlc6aFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777687; c=relaxed/simple;
	bh=k21pjHh+SZOom5ij6K1L7WC8NrdUm5i+ZswtDIQq4d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hpk1YSNHGVYimy6MYAZG379i3QRggV/X8UmIMGMaXubM1vG1sTAhMupgXbAfim7m0LIa4hRJnapRbvH/wh2QpiR8tpfRW1IlfnFNKmjQBRGaRz6rvi2UgmpfTi+FRevdZIwrdZYvbmcGdFoYjF5rwRGGKc8y5y3N8sx+P6e0TJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vX9M5gUu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vX9M5gUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706D8C4CEF5;
	Wed,  3 Dec 2025 16:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777686;
	bh=k21pjHh+SZOom5ij6K1L7WC8NrdUm5i+ZswtDIQq4d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vX9M5gUuGfDxbo3tFlQGLSPv/w7xuRkw8J1JcGqA5nQxFEf1WH56YLSfOqF0Y3k+L
	 cWcZOLgSPiKpC40BPu6EuZD+1qou9bR7x0pxYpvRpEWGbH0pfQq6EllLp136eAeZx7
	 BrvCD3ncnZAsOGDGn1lPYca4jls0YqKW/p4GVy5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geoffrey McRae <geoffrey.mcrae@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/392] drm/amdkfd: return -ENOTTY for unsupported IOCTLs
Date: Wed,  3 Dec 2025 16:24:07 +0100
Message-ID: <20251203152417.670279437@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7b2111be3019a..4f60ba2db1811 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1947,8 +1947,10 @@ static long kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	unsigned int usize, asize;
 	int retcode = -EINVAL;
 
-	if (nr >= AMDKFD_CORE_IOCTL_COUNT)
+	if (nr >= AMDKFD_CORE_IOCTL_COUNT) {
+		retcode = -ENOTTY;
 		goto err_i1;
+	}
 
 	if ((nr >= AMDKFD_COMMAND_START) && (nr < AMDKFD_COMMAND_END)) {
 		u32 amdkfd_size;
@@ -1961,8 +1963,10 @@ static long kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 			asize = amdkfd_size;
 
 		cmd = ioctl->cmd;
-	} else
+	} else {
+		retcode = -ENOTTY;
 		goto err_i1;
+	}
 
 	dev_dbg(kfd_device, "ioctl cmd 0x%x (#0x%x), arg 0x%lx\n", cmd, nr, arg);
 
-- 
2.51.0



