Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326C31DE8AD;
	Mon,  9 Feb 2026 14:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647611; cv=none; b=FD5RqeN0YJ50nsfFr63pKnGdrrzlhMCO+bvywXSdfSKg/itSux0Kvd0H8Ja5EGS9CAO15K5eLKuneIULcvwKUnMNii9kVwIq9oIyCtklzWWKvnHl8rbJEX/kHvcFCLAy2NxzY5VTEkGGzPQVLtHP5npb6rC01fmjhHfYtotStr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647611; c=relaxed/simple;
	bh=5dqpKJv8YUVDTh/o8xoNeiMvABN49Fd8KoLVNtwDmd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jmG0DgWaAC6A3vkvb1ZhceER+qkOnSV93w67SAqGdVGd9fcQN6WDB19hR7AOV+I4VTYcS2qlwfPow6SzOQFVE4M6Z+tOQsCuOkuilTNaPskh4FAaSH5MpvRLpSlvrmgu0pZuxwLv3U8heeNh2gCwjqGsQEn8x5T2nrHJCg5kqh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1zZvaSV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1zZvaSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3488C116C6;
	Mon,  9 Feb 2026 14:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647611;
	bh=5dqpKJv8YUVDTh/o8xoNeiMvABN49Fd8KoLVNtwDmd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1zZvaSVgRLNoUt1KqtfS6pSWIEZcDTDTA2lfJfrJNAdPI2KldsxRWhsDl4o8pIgm
	 V/3UGBTdO/IshK6s0s9KiUutF+2h2iwpnrCWpFCDBZnzcgGsw8eQK/nCNtCA1NPEum
	 eqqZW9oQsvl5yr+Nz98k06fnR2J9RWoVBGmOrcYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 151/175] drm/xe/query: Fix topology query pointer advance
Date: Mon,  9 Feb 2026 15:23:44 +0100
Message-ID: <20260209142325.931780594@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 7ee9b3e091c63da71e15c72003f1f07e467f5158 ]

The topology query helper advanced the user pointer by the size
of the pointer, not the size of the structure. This can misalign
the output blob and corrupt the following mask. Fix the increment
to use sizeof(*topo).
There is no issue currently, as sizeof(*topo) happens to be equal
to sizeof(topo) on 64-bit systems (both evaluate to 8 bytes).

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patch.msgid.link/20260130043907.465128-2-shuicheng.lin@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit c2a6859138e7f73ad904be17dd7d1da6cc7f06b3)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_query.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_query.c b/drivers/gpu/drm/xe/xe_query.c
index 2e9ff33ed2fe2..856089f64c341 100644
--- a/drivers/gpu/drm/xe/xe_query.c
+++ b/drivers/gpu/drm/xe/xe_query.c
@@ -491,7 +491,7 @@ static int copy_mask(void __user **ptr,
 
 	if (copy_to_user(*ptr, topo, sizeof(*topo)))
 		return -EFAULT;
-	*ptr += sizeof(topo);
+	*ptr += sizeof(*topo);
 
 	if (copy_to_user(*ptr, mask, mask_size))
 		return -EFAULT;
-- 
2.51.0



