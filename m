Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C513176E4;
	Wed,  8 Apr 2026 18:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674644; cv=none; b=esrrdp1XRCJTuQa0HQgpRgZgS7in4IFbWceDMJZWnGWGjhBxqs/x6nHFb/n1FQFztctLMcIYn7oiJ4HyuRr1yvcZ5EvS0mT6TVSdyN/m+uJobSMquNoVE0gBsRIJoXKIOiWINIfYBR6/WwJgF06UUPD6U1I7riEuCtvXjCWbM0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674644; c=relaxed/simple;
	bh=qOTkJLKvsL09Cn7cndlgV2DH4VlGfEfUjCtiWU2jQWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMYltOdAsQ4jGuRzRvujQrb55+KHFNEYM2I6zhCreHJr+Zon4/YhKSa/q1Ur/brIAaQIhzWc1qJhzaMkk0CTMbyojrJSguFoxxNQlYBOPXKxrBzEmurE/E92KOppFOeNrNaf/MI5nfEJSW+/NcEEIwctsVpVCDfC5X2ulBtQP0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aIuz48WU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aIuz48WU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47B0C19421;
	Wed,  8 Apr 2026 18:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674644;
	bh=qOTkJLKvsL09Cn7cndlgV2DH4VlGfEfUjCtiWU2jQWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aIuz48WUyheBD3au49dyRXxLqSXpNT3dAXBPbcVaYB49Bt1nUZLsW/doB160Zb4Q2
	 X/T7Pg3hioobV3mVmErhTEYCdLfD6Z41Yd7vdgRuGAWIq0tFBEYUnSPpkL18pBJKHJ
	 PHUf9HI3DiIwX42KXuwK0jx0R14ERvDWdwbk7S5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 144/311] drm/xe/xe_pagefault: Disallow writes to read-only VMAs
Date: Wed,  8 Apr 2026 20:02:24 +0200
Message-ID: <20260408175944.789416498@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cavitt <jonathan.cavitt@intel.com>

[ Upstream commit 6d192b4f2d644d15d9a9f1d33dab05af936f6540 ]

The page fault handler should reject write/atomic access to read only
VMAs.  Add code to handle this in xe_pagefault_service after the VMA
lookup.

v2:
- Apply max line length (Matthew)

Fixes: fb544b844508 ("drm/xe: Implement xe_pagefault_queue_work")
Signed-off-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Suggested-by: Matthew Brost <matthew.brost@intel.com>
Cc: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260324152935.72444-7-jonathan.cavitt@intel.com
(cherry picked from commit 714ee6754ac5fa3dc078856a196a6b124cd797a0)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pagefault.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_pagefault.c b/drivers/gpu/drm/xe/xe_pagefault.c
index afb06598b6e1a..0b625a52a5984 100644
--- a/drivers/gpu/drm/xe/xe_pagefault.c
+++ b/drivers/gpu/drm/xe/xe_pagefault.c
@@ -187,6 +187,12 @@ static int xe_pagefault_service(struct xe_pagefault *pf)
 		goto unlock_vm;
 	}
 
+	if (xe_vma_read_only(vma) &&
+	    pf->consumer.access_type != XE_PAGEFAULT_ACCESS_TYPE_READ) {
+		err = -EPERM;
+		goto unlock_vm;
+	}
+
 	atomic = xe_pagefault_access_is_atomic(pf->consumer.access_type);
 
 	if (xe_vma_is_cpu_addr_mirror(vma))
-- 
2.53.0



