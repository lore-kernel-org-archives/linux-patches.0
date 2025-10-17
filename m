Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93EE332912;
	Fri, 17 Oct 2025 15:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714161; cv=none; b=RPQWKxgV6LgWBfJ8dB22HT26vaqdisSPOqJFjHAWfbnQIO6S1Ul4BHohbUKrRLrQWhnasuVi6r7e6Wj/gQKR/8tOY3DmGmCNoQnGX9SpIZH45BDjPmvbynTUozcibb92uXYATwBU3WN9BtBQzSILlfjSgILQS6ubxZdl6XaibGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714161; c=relaxed/simple;
	bh=dpIX9f4kzzNW/VICsSW3L8uSkqW3ZKxjGbBEZkU73d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9ooh/rnoKoY3ZlmI5YMEdfbCHrXyG1ZpZqRWFz/495feomU9Hi0EEuMnhyqojgswm0AmSkwBT41/jc8GS+H3Lf0ImcoLYWdUy1+/6bOerBnTltI4kcfe0oUcRbUvo4/rdcjobY4yDtA04e8nblWdWhhyyrLDzQ0kriszlmIKDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9xFaCDL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9xFaCDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2304C4CEFE;
	Fri, 17 Oct 2025 15:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714161;
	bh=dpIX9f4kzzNW/VICsSW3L8uSkqW3ZKxjGbBEZkU73d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S9xFaCDL06QqxOXXjDrf/GH9AUT/kaA5UKPjypdx+EJ5nQFF/+XwjLbB5GDcpBYtf
	 RdXJ6KoBtJpWiO2Dlz0xTpjL7iDKExbIY0rdKaCcle623617s3UBSRB3OnSOw0hhOc
	 1XRM7267o29JZR7eriC8Zww/HlyufL5T7cU/IsLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francois Dugast <francois.dugast@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/277] drm/xe/hw_engine_group: Fix double write lock release in error path
Date: Fri, 17 Oct 2025 16:50:55 +0200
Message-ID: <20251017145148.901352533@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 08fdfd260e641da203f80aff8d3ed19c5ecceb7d ]

In xe_hw_engine_group_get_mode(), a write lock is acquired before
calling switch_mode(), which in turn invokes
xe_hw_engine_group_suspend_faulting_lr_jobs().

On failure inside xe_hw_engine_group_suspend_faulting_lr_jobs(),
the write lock is released there, and then again in
xe_hw_engine_group_get_mode(), leading to a double release.

Fix this by keeping both acquire and release operation in
xe_hw_engine_group_get_mode().

Fixes: 770bd1d34113 ("drm/xe/hw_engine_group: Ensure safe transition between execution modes")
Cc: Francois Dugast <francois.dugast@intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Francois Dugast <francois.dugast@intel.com>
Link: https://lore.kernel.org/r/20250925023145.1203004-2-shuicheng.lin@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 662d98b8b373007fa1b08ba93fee11f6fd3e387c)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_hw_engine_group.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_hw_engine_group.c b/drivers/gpu/drm/xe/xe_hw_engine_group.c
index 82750520a90a5..f14a3cc7d1173 100644
--- a/drivers/gpu/drm/xe/xe_hw_engine_group.c
+++ b/drivers/gpu/drm/xe/xe_hw_engine_group.c
@@ -237,17 +237,13 @@ static int xe_hw_engine_group_suspend_faulting_lr_jobs(struct xe_hw_engine_group
 
 		err = q->ops->suspend_wait(q);
 		if (err)
-			goto err_suspend;
+			return err;
 	}
 
 	if (need_resume)
 		xe_hw_engine_group_resume_faulting_lr_jobs(group);
 
 	return 0;
-
-err_suspend:
-	up_write(&group->mode_sem);
-	return err;
 }
 
 /**
-- 
2.51.0



