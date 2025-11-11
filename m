Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A07926FDBD;
	Tue, 11 Nov 2025 01:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823341; cv=none; b=ArxQlyVT9m8SDaVEpMqfZFXvr6iQLvmzLwCMfh5BVjzLl30vSx2X5a+ZzyguX1VkvSfhPygmJjyM0J3Lv/JcIa967fGD2bxzVtlknGL7Tov2ryt+E1cGDlW+EAb2KjkownNOQgKAfO1hQlmO9C5+MY4KzancfVtnIkOl3zFuAIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823341; c=relaxed/simple;
	bh=tG3Eyo1KGnaDhRirrHi4zuwuqVhI7F2XacxMMleK7zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOj8bdY/vUfek6Y/SkXbFGF3wF8t7CddcQEONN++cKHkktjc8NCC9SjFpe1YFYuGUbJOHdNh4StLKDv7apqeK8bs1UlAIkXpCnJNvdirypGIbYyQkRN4ib7L+aPGiIehurCV28bCswevyiJkRHOT92RqtV2g9a9XQzGymK8weJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ULLGiIDT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ULLGiIDT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1407C19422;
	Tue, 11 Nov 2025 01:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823341;
	bh=tG3Eyo1KGnaDhRirrHi4zuwuqVhI7F2XacxMMleK7zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ULLGiIDTaVMgyMTHKVjg/R6InoRN+3t4NFFMrp9axV1iFfUeVo9aK9Wgps2TYvo4E
	 jry7H7qNpap4610qeqso4J12A+wT1AUGtScBh9SgGTOq0kiKCYW8iUmxkeBQxTZbGN
	 sWhIrJoJHMrk0N3DZBLu0TFw3xRW4v4c9psPVoho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geoffrey McRae <geoffrey.mcrae@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 279/849] drm/amdkfd: return -ENOTTY for unsupported IOCTLs
Date: Tue, 11 Nov 2025 09:37:29 +0900
Message-ID: <20251111004543.170751749@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 828a9ceef1e76..79ed3be63d0dd 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -3252,8 +3252,10 @@ static long kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	int retcode = -EINVAL;
 	bool ptrace_attached = false;
 
-	if (nr >= AMDKFD_CORE_IOCTL_COUNT)
+	if (nr >= AMDKFD_CORE_IOCTL_COUNT) {
+		retcode = -ENOTTY;
 		goto err_i1;
+	}
 
 	if ((nr >= AMDKFD_COMMAND_START) && (nr < AMDKFD_COMMAND_END)) {
 		u32 amdkfd_size;
@@ -3266,8 +3268,10 @@ static long kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
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



