Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F370A33F371;
	Tue, 11 Nov 2025 01:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824013; cv=none; b=IiRpINH/yUhpK5bVtTBZgiCr1lAxH75Sriro7z2x1q1b9qGxD+YINmp3qjynX5Kzv1je8yW7c0nKITlUIoVtYPSTFfirTwVkAeY521TC183MvKP3IJeHnBI9oJLqmqVHHncV9TPFoNubsVdXC+tq+voGeTeH7zseug8UFiGKdRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824013; c=relaxed/simple;
	bh=mWHmHFvzy+Yi7zQF+60t/vDRNJXmAB2Gy2/uuvTokrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fj/7WF0HbWbgWRcXdXHE9KoQ2K85Xz0wBW+varfgcoAORM2QUpx0H/2Kn0+OYiZjsJOUiIiDut+6SYNSYvQObQJExutNcCWUkIVUtDDjNbkQ4OFkNBY5s1XYbELate7JE0wGxq8r0mfDAcGP07M6i92393dX4ig6yTa7Jx07Z80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DIVd/QEJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIVd/QEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCF9C4AF09;
	Tue, 11 Nov 2025 01:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824012;
	bh=mWHmHFvzy+Yi7zQF+60t/vDRNJXmAB2Gy2/uuvTokrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DIVd/QEJZcgMhDIJNGfBxIQHjbPgj/EJvrII94xupxoD1KimsKmp39uA9Uzzpd5xU
	 8kpsB9wMZ2d6sVks+m/XWAI7fGUq8IZKhTF6vHkGCbxmfvohpXQH8sj8v43u5ISsNb
	 kCSFdl1/CAZy7B78VMAWfSj5ynG+BDX+i5c1Rpe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 420/849] drm/amdgpu: Allow kfd CRIU with no buffer objects
Date: Tue, 11 Nov 2025 09:39:50 +0900
Message-ID: <20251111004546.597417466@linuxfoundation.org>
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

From: David Francis <David.Francis@amd.com>

[ Upstream commit 85705b18ae7674347f8675f64b2b3115fb1d5629 ]

The kfd CRIU checkpoint ioctl would return an error if trying
to checkpoint a process with no kfd buffer objects.

This is a normal case and should not be an error.

Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: David Francis <David.Francis@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 43115a3744694..8535a52a62cab 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -2571,8 +2571,8 @@ static int criu_restore(struct file *filep,
 	pr_debug("CRIU restore (num_devices:%u num_bos:%u num_objects:%u priv_data_size:%llu)\n",
 		 args->num_devices, args->num_bos, args->num_objects, args->priv_data_size);
 
-	if (!args->bos || !args->devices || !args->priv_data || !args->priv_data_size ||
-	    !args->num_devices || !args->num_bos)
+	if ((args->num_bos > 0 && !args->bos) || !args->devices || !args->priv_data ||
+	    !args->priv_data_size || !args->num_devices)
 		return -EINVAL;
 
 	mutex_lock(&p->mutex);
-- 
2.51.0



