Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706BD2DC350;
	Tue, 11 Nov 2025 01:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823209; cv=none; b=DuUIHA/hWG89uva6nE+JA+6/Mr7ClXSbnsneV+/0B/RNGqwMq6BiKlHRbtja/XaetgdXwSKVfKM5ZH/Cr7ku6UUJc6tMnX6pKu5CMLAF2c5xnEPQfR2bNVZw+SBFGExTCvoskkYCNvA5d/abwRYPnWLih0AThodUUa/vuqJUCLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823209; c=relaxed/simple;
	bh=KJNjKRDthoFFJipdVWmaAN+472HYx+5IFPHIOVYnEpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONE7wZlyeBSEN8Y50ElSl4kVlSFQJQmusdb4aDUepIgXIVleejVRnmVh7NEg2q7bA3LRf+4rFieWUEbQtty8eHaeYGablZl5Zvp3K706G9l4QJORAqaQXx2sggHdXuqt+kv5fRXtG028A2g6e9mrCiJNO+RJfeE8TtNPcaPC19M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0upo4dne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0upo4dne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DA9C4AF09;
	Tue, 11 Nov 2025 01:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823208;
	bh=KJNjKRDthoFFJipdVWmaAN+472HYx+5IFPHIOVYnEpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0upo4dneAUOuy6mXwn/9pOS/vJyccMZ46SCw+L/CQ4D8YMKJHs3aBIXbVSVNNIeho
	 KnAzlB6SKIxtloDlCWEqIkyEsouVOaT60pBJIta+LT9mYAS8hwnriuN1rfBmafQtpD
	 /JAsCgcjJ1eFkvPad99Lh/6peXDpnoAwDkfQX95M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geoffrey McRae <geoffrey.mcrae@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 197/565] drm/amdkfd: return -ENOTTY for unsupported IOCTLs
Date: Tue, 11 Nov 2025 09:40:53 +0900
Message-ID: <20251111004531.360105997@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 67b5f3d7ff8e9..fc473e3ba2d00 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -3253,8 +3253,10 @@ static long kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	int retcode = -EINVAL;
 	bool ptrace_attached = false;
 
-	if (nr >= AMDKFD_CORE_IOCTL_COUNT)
+	if (nr >= AMDKFD_CORE_IOCTL_COUNT) {
+		retcode = -ENOTTY;
 		goto err_i1;
+	}
 
 	if ((nr >= AMDKFD_COMMAND_START) && (nr < AMDKFD_COMMAND_END)) {
 		u32 amdkfd_size;
@@ -3267,8 +3269,10 @@ static long kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
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



