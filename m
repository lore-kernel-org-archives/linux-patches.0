Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065362F003C;
	Thu,  3 Jul 2025 15:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555470; cv=none; b=Kxa9odDTkXKZFpAQBY29JngTO27bTt5dXsGJm3xeqBO/u+jy762+5O1djd3XNxf38/RB1wgHL4pvFMP4U/ecikIezL+bSWc1HjhxlrwDFXNeDLwA19y9iduAcxPNtRsEIrkgJP8sfQO8+k3xBJV+docynH41j29TSiXFRsHa3KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555470; c=relaxed/simple;
	bh=MUtsHCYYcqQQX+VGU/hemmnuVrKc7eROnJqGB6PNMfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nk03jrjnd9+Hh6n8rHUlIX2jH1ALU8gi23yGdAi/AYB426GJ4B8H2ZKErAjn8/5Yybkw0wBGOztU2lp95olY//DhmLq9jTKCt/zyFmsQOAJDx8OaQXs6pWK0iD/EQOb0KZnAUXTDpPS3SFRMle7xDYGTLHPpmAcgqenRpkoxWE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kCDcPdmS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kCDcPdmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CD1C4CEED;
	Thu,  3 Jul 2025 15:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555469;
	bh=MUtsHCYYcqQQX+VGU/hemmnuVrKc7eROnJqGB6PNMfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kCDcPdmSda2gDgYkWwwYZq+3F0Tj5mAg3fSjzbWZfNckX/cqSjA+Z0huab/LZV+rN
	 jBCoY2L1N6HTOE9kZg2Q4UrMORD9TDDlyWnqjP9w7sg8rAmsH2ZaZspfj1dc8RCBeX
	 G3SfBxhkV+h/OEKBz+y5EC8fL1EZXDtITuM2+bR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/139] amd/amdkfd: fix a kfd_process ref leak
Date: Thu,  3 Jul 2025 16:41:26 +0200
Message-ID: <20250703143942.089231134@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0f58be65132fc..2b07c0000df6e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -1287,6 +1287,7 @@ void kfd_signal_poison_consumed_event(struct kfd_node *dev, u32 pasid)
 	user_gpu_id = kfd_process_get_user_gpu_id(p, dev->id);
 	if (unlikely(user_gpu_id == -EINVAL)) {
 		WARN_ONCE(1, "Could not get user_gpu_id from dev->id:%x\n", dev->id);
+		kfd_unref_process(p);
 		return;
 	}
 
-- 
2.39.5



