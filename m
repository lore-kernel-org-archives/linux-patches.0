Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211CC372231;
	Sat, 28 Feb 2026 17:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301484; cv=none; b=nipq1FHF7A/CH1Xeta/pRQTGUTzbtIvIAWQg+2cv1gAWp7e0wOvUymrdA+LpFvO3rI/QVY+REJa3F+aGQXUPgz32HyRlNIARUE93m4anr0Opwe1hbffgd5LyTICrzfz/xXvdLBV+CUG/VtY7lCCyPXJinOkw11/YJfEtdWfbp6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301484; c=relaxed/simple;
	bh=rHQyhSkZLfruEDSRgKCaCdndA1wB7IyQXgtVqkS4znY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2nVUqcvNGt6gX0tiltiMEhVe0JyzC+THRyaM5iT1KMICmXJ+eDTJy5V8DB5LZ/SA8Yl30E+sU+I13rg3SwFla+QWXP1bUb8TL+48AkR6KNeH4WJsppt9ImdWaKX8sIdlb6l7ofqaZNUOtLvCL/n1lUCmLxEiyCqjNF1RDJt79s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dyVEmROY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dyVEmROY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559FFC116D0;
	Sat, 28 Feb 2026 17:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301484;
	bh=rHQyhSkZLfruEDSRgKCaCdndA1wB7IyQXgtVqkS4znY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyVEmROYzoHgyRbRpGTj0N49Ml3IUwpAjuoRqQb6k+wttIWyPYmGFr2lxLi9JxjdC
	 dH3sV7BjW850vE1OV1Nh6/S5WdzJq6kTwoZlFMtpNYdRv0m/D+2Y+9ECBOqeA0dxJD
	 xdEj91mRF6OOo4QpkOY+CBMtXj+JtRBysOolbNUin8DOvpvS6htCqfvYb7Ykt3nmdS
	 2aKiGNWJyHpnxH0ZdoENDbDXKBSMuvVe0t9JvkqhOnjl1Z/La5Gk2v/0ezK00girc9
	 lOangpKFamgk4RXJzn0eWs+dDITrh1LdR+PESG0jhbZ2KstIvRGNIENqAgULTd368i
	 vrLjrPoHhE9IA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sunday Clement <Sunday.Clement@amd.com>,
	Alexander Deucher <Alexander.Deucher@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 669/752] drm/amdkfd: Fix out-of-bounds write in kfd_event_page_set()
Date: Sat, 28 Feb 2026 12:46:20 -0500
Message-ID: <20260228174750.1542406-669-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sunday Clement <Sunday.Clement@amd.com>

[ Upstream commit 8a70a26c9f34baea6c3199a9862ddaff4554a96d ]

The kfd_event_page_set() function writes KFD_SIGNAL_EVENT_LIMIT * 8
bytes via memset without checking the buffer size parameter. This allows
unprivileged userspace to trigger an out-of bounds kernel memory write
by passing a small buffer, leading to  potential privilege
escalation.

Signed-off-by: Sunday Clement <Sunday.Clement@amd.com>
Reviewed-by: Alexander Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_events.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
index 82905f3e54ddd..261db87e86fe6 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -331,6 +331,12 @@ static int kfd_event_page_set(struct kfd_process *p, void *kernel_address,
 	if (p->signal_page)
 		return -EBUSY;
 
+	if (size < KFD_SIGNAL_EVENT_LIMIT * 8) {
+		pr_err("Event page size %llu is too small, need at least %lu bytes\n",
+				size, (unsigned long)(KFD_SIGNAL_EVENT_LIMIT * 8));
+		return -EINVAL;
+	}
+
 	page = kzalloc(sizeof(*page), GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
-- 
2.51.0

