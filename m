Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5830C19D8AC;
	Thu,  3 Jul 2025 15:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555910; cv=none; b=vE/t5U/EPl8xMItY+dnpNxPK96ZHNA3MmVjb5oBHllUBa7fk2ubuOLFwYuQ3LyXEkFFrx55fwuDBnO6DBMDrXM8JNKrvm/o3d9JQtE7p/QzQzqjgatVb9atGiK1WkYtvtqxXBoZbLY8qnrL28vF/sDUWgK0/c7Z2yIBQ7U3AXPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555910; c=relaxed/simple;
	bh=R8zlsvLfQ9yjek5/KN1maiNJxIMa4mk/BjAk2h9axo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpAA0CIuiUa1YLwqTYu8FHvWeWmJhLwWH/rGqJ90ka4Rq8JdxD3b0w6V4edqcA2i49A+G6wcge75SjJTByhk6bzGjiTDKgCQghm59OwpaXhsASWl7Mqrdo5GTVSI+yWL+kxKa1e+FiqYbSRVYxvFHfkGPzwn+mGGMYjr3TBrL7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wcmb56DB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wcmb56DB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B8DC4CEE3;
	Thu,  3 Jul 2025 15:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555910;
	bh=R8zlsvLfQ9yjek5/KN1maiNJxIMa4mk/BjAk2h9axo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wcmb56DBRIgUXSWJ5taZmq1KBAZqqogzIdUGjEBd24d0P5i0wpgu+Hf8GcxGZbNx8
	 0Ks8oj9Mlcard949mQo7n+SwxCuql2vz5DyRH4zLfhhAmdtUb5/ZqjAogOUztfjNRL
	 1EjJkbui9Tbr9Vq1lufsXtiJwBqxilWvRiq7YPps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/132] amd/amdkfd: fix a kfd_process ref leak
Date: Thu,  3 Jul 2025 16:41:45 +0200
Message-ID: <20250703143940.036289478@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2880ed96ac2e3..80d567ba94846 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -1340,6 +1340,7 @@ void kfd_signal_poison_consumed_event(struct kfd_dev *dev, u32 pasid)
 	user_gpu_id = kfd_process_get_user_gpu_id(p, dev->id);
 	if (unlikely(user_gpu_id == -EINVAL)) {
 		WARN_ONCE(1, "Could not get user_gpu_id from dev->id:%x\n", dev->id);
+		kfd_unref_process(p);
 		return;
 	}
 
-- 
2.39.5



