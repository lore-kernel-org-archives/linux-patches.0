Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CE53242DF;
	Sun,  7 Jun 2026 10:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829781; cv=none; b=uR2i+6doVcgfJfCoOMev8a9FsyxuEOclIXZtcEdNum/w/WBgN+rFXvDTxU1wfUHIy9jPY1Mso+Jf9ietutyH+stdGcwD4wb0oFckzuq1gc01eKkyonRkeuOhk+Bcy6Z2cab/yxFh3xJt9DBeum23mz5k92el3zedRtoZRgvgDSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829781; c=relaxed/simple;
	bh=ZMO/y7VSlwnJXMzQ/JqZ0P/pXkenxSIhBLvqlBDgDwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZkSs0L3RMUvh5J1CIdnMGLq+8bvkQ6FYtU4PDAowoAi6y8IOARtUEJ5FsgsX2iTFsfUVepbbPSYqUfw6c+QzoY+7B8R0ySXNDebF0JqBEAFS3HGJ5l+Z2hShW1/TwInVlaaXDepQvyG6+9goHvJd+SziT00kUNeSf79Wc4tmP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9Nf3QP0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9Nf3QP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A75D1F00893;
	Sun,  7 Jun 2026 10:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829780;
	bh=KmiPo//A1fXut/DV1EjkbaReEWzFM1wD6cDbL7eqkn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y9Nf3QP0GUhWdvnttAScT6wquOlKofhhzxb3zmyoKyKo0XwmQOjwk0mT0Yb97Ph39
	 y2wTW0/XxbYvyeohxpECy0DTmevehxBUjUrCU8ssdqQdYxW87adIWwFDkhnj5qD4yy
	 VldeQXt+hPvBbzh89DcyHxzR/BJN/2fbzP5G+p5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 253/307] drm/amdkfd: fix NULL pointer bug in svm_range_set_attr
Date: Sun,  7 Jun 2026 12:00:50 +0200
Message-ID: <20260607095736.982651325@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Eric Huang <jinhuieric.huang@amd.com>

commit e984d61d92e702096058f0f828f4b2b8563b88ce upstream.

The process_info could be NULL if user doesn't call kfd_ioctl_acquire_vm
before calling kfd_ioctl_svm.

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 83a26c812e0529eb040d31a76f73e33e637243d4)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -3668,6 +3668,9 @@ svm_range_set_attr(struct kfd_process *p
 
 	svms = &p->svms;
 
+	if (!process_info)
+		return -EINVAL;
+
 	mutex_lock(&process_info->lock);
 
 	svm_range_list_lock_and_flush_work(svms, mm);


