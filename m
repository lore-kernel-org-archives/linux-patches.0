Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A703128A0;
	Fri, 21 Nov 2025 13:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732615; cv=none; b=mtu644Z1lcbbyDhC3ISqu+knrQkj6fXoagNlsKIN++K0IKYgyf7H4icfDjKAS00N8ddTVUvHuHMNN3U5GsLGdlvqeWwAhBPSh49cqcNzRSjq5OhsivPVe+BwlXJSqNyBg5aJ5DhC36eUOw3pxSKtI4Wf7xjB5x5FNrbV5cn8tQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732615; c=relaxed/simple;
	bh=WvGCMR+YAWbJ3DHaoDm2ZadZRhF9RyfqEkHNjQ1Qaoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzq3C15ilkE1/xA1MTqhk9w4QD5R4JHyiQHfkcagFBNOqtyWh1LIIw5AmTpmNMkj93k5f90L6ByLwVLCdLTNcikVmGVkRC1KQI4Y4GNsY8uLSYunhanvInuqlgj/FKeV5zN5Hcs9Bl8ObPm8I095bAOh6kSwmwnlJmWb/T4PTH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7bwwwMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7bwwwMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C34FC4CEF1;
	Fri, 21 Nov 2025 13:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732615;
	bh=WvGCMR+YAWbJ3DHaoDm2ZadZRhF9RyfqEkHNjQ1Qaoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7bwwwMoa5pJvPWMxT9fWRgzxeP/NQQRTDe36re0EmTJmPClR5071mHaqCZdNPP4j
	 p7XYsD/MDIt9NMN1Zju+wXlO0pOtBwYR6WGa9mldYfpEVHqCci5oZ6EGZeII7m6TJP
	 X+Ztx6rBwMgY+i9mgtNXYy3IcRj9SZ/ziyx0V+x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 184/529] drm/amdgpu: Allow kfd CRIU with no buffer objects
Date: Fri, 21 Nov 2025 14:08:03 +0100
Message-ID: <20251121130237.566769115@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 76196ab75475e..2e194aa608489 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -2572,8 +2572,8 @@ static int criu_restore(struct file *filep,
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



