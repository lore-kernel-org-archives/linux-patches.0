Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D453A101DE;
	Thu,  3 Jul 2025 14:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554035; cv=none; b=qKu72APie9jg9QGmt9uwhARgaNf44Z36H4B7IVDJF//Nzxqy7m8Yd/SX7ka/u73iTc75STXjRoo2JNyPjxQZCCA8Yt6A+JY9vrqGdCzq9xZz7vybuXRjje7ZJflc6Yqn2EdD1N6a+sf09FtSPTQ1b824E4dioguU2n8wCVlc4rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554035; c=relaxed/simple;
	bh=lJlThIK6HiYYDoS+l5xdUGFaxvClZUVkBsBtZu0EIVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qr/sUNjEi2mSKxUOtlAuqEXA8Cygzq5/JYOR36e4J/jnKcE6iGcqax7Okajmbm+TcOHlRw80SnPmMET0OIK8kCz3YlxlvxgcKgCigD+zltm+eGsOh70vACapHrKWc/O2B3QZum+f6Cx0nuS+nHxaXTR06dYbRSIdeRZR4K5nQu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfQhKTva; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfQhKTva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A83C4CEE3;
	Thu,  3 Jul 2025 14:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554035;
	bh=lJlThIK6HiYYDoS+l5xdUGFaxvClZUVkBsBtZu0EIVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfQhKTvaDJIrJK76hlo8PUWPK/JoEHJYl6yHN3P1xGjFZ8diDvxC0fjTg6bfVVS9/
	 4l+LXtv/PC8dldJSWJ/+XjeVsiqjTf8VP6s4kaw4p97hE4OEgP54soeSJ7MzyjIZXh
	 RggJM7S5lk4oU+HsKzHKRFtXkk86eYTz7jbpHYAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/218] amd/amdkfd: fix a kfd_process ref leak
Date: Thu,  3 Jul 2025 16:39:37 +0200
Message-ID: <20250703143957.123363945@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yifan Zhang <yifan1.zhang@amd.com>

[ Upstream commit 90237b16ec1d7afa16e2173cc9a664377214cdd9 ]

This patch is to fix a kfd_prcess ref leak.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Philip Yang <Philip.Yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_events.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
index ea37922492093..6798510c4a707 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -1315,6 +1315,7 @@ void kfd_signal_poison_consumed_event(struct kfd_node *dev, u32 pasid)
 	user_gpu_id = kfd_process_get_user_gpu_id(p, dev->id);
 	if (unlikely(user_gpu_id == -EINVAL)) {
 		WARN_ONCE(1, "Could not get user_gpu_id from dev->id:%x\n", dev->id);
+		kfd_unref_process(p);
 		return;
 	}
 
-- 
2.39.5



