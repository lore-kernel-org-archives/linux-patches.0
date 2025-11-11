Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4162D94B7;
	Tue, 11 Nov 2025 01:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823613; cv=none; b=IB/T7HC/nwjD/ODKrmjE2jdjurBUOTm7QJWRcgLF3xIQ3UCFgZ9weFoJGcuZ7rAanjuig3CdRUYzd5WRpEZJduJbv20zm+cNGAjoJsDThyUBVdpRZhcFKx0YnmdQ3EKcPkYNU/OHJUtDW4YMEpkpHzyvIi35PokSVC9wfh2pINk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823613; c=relaxed/simple;
	bh=v+w0jCj7nOO57CbLDZg9gBz8IDEhDaCWECn18/gpho0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OlXXLLkTmPjzYJw78Ru0BICD2HNodt+oldSrthpar/k0fe5AENyetszlT9XwUCZSg1lQvX4KDtKOBNVy3/rIuPxLtLNwGSjqeQoFIVSqAt+C/KSjeBODqkzAUArHeulkpBtjXpC4iDGoEfrz1wzy2ZPtcdaUnDd6clkKFGxh7S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhKkc+ec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhKkc+ec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78F4C4AF09;
	Tue, 11 Nov 2025 01:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823613;
	bh=v+w0jCj7nOO57CbLDZg9gBz8IDEhDaCWECn18/gpho0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhKkc+ec7LB0uVCQ71AX008tlnrkSRoOVYEaTtfpukvOMpapTKYBiYaR//HtJTLMs
	 3P/Z8dxU7ctfBmI2mK5nihVIrcT9DCIi9CJqIVTzALTyHnAsTDWyGmXcCe1FnWBtwi
	 KRnUuchi259vHv3yabagnCU4BPuajyFCG7cJbCPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 286/565] drm/amdgpu: Allow kfd CRIU with no buffer objects
Date: Tue, 11 Nov 2025 09:42:22 +0900
Message-ID: <20251111004533.312065661@linuxfoundation.org>
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
index 7fbbc67adfd9e..0e73ec69192c3 100644
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



