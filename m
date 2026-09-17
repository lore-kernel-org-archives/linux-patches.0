Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72935503910;
	Thu, 17 Sep 2026 17:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667329; cv=none; b=TUFXzcydIdc23URSArfc23s6mSbPc10re//qWZntxIP8TexNOHaUKBxlfvViRRR/zsow9ImgLsUkucFghfMcTLYw7D3aBn/gCc4swaLbw8pi3CL+6jh2Rd7w8YuGJuUxQ2sglzHlH7RRZ42uaSJxknc+0dPInNN/uZrXbn/T8T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667329; c=relaxed/simple;
	bh=ucDAxXQRmBJEx7neLpTryY7Q4WW6ZXdXoccvBDVNi9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBkb6Ag93oYwk3E9RIDW4V5Aq+K2BtnQV2pbBJq2xIvyll87CexbdcQnXDGbGJXEC40xe8xYSfiMEG9UwHlfJ5BERUM+ezFMlWv5NriwPO6HbhtRzpbxdeFDwx6iwo0cDV2oWtIaikf3pTehBW+9GeIM7gV5zUBBKkxGu4m+cK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwR53zpv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwR53zpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9EBF1F000FF;
	Thu, 17 Sep 2026 17:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667328;
	bh=td4Pd2woWoSLdFn1+nLjc/BDHa0jT44TEuYEQ93qZy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GwR53zpvDMFKlpyQfsTkNPc57oUxOfBTERlTNAY6F26TOOK+osFSJIWM/HsunDZUP
	 wa4BPG+CJgvBeh4lMGp0lhrxcQo4iIrwBRHwRf9hD2OjxVl2F2EzdeXVOuo+SXP7k1
	 w25YuIgfRSgEnXG8nOj3ewF3WpzFvuZCckCr7Ba4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0057/1102] dlm: add usercopy whitelist to dlm_cb cache
Date: Thu, 17 Sep 2026 16:00:00 +0100
Message-ID: <20260917151540.884771775@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit b5314f2c6654a3616fd72777deb1ca766cc50618 ]

The dlm_cb slab cache is created with kmem_cache_create(), which
provides no usercopy whitelist. When a callback carries LVB data,
dlm_user_add_ast() copies the LVB into the inline lvbptr[] array within
the slab-allocated struct dlm_callback and redirects ua->lksb.sb_lvbptr
to point to it. copy_result_to_user() then calls copy_to_user() with
this pointer. With CONFIG_HARDENED_USERCOPY enabled, this triggers
usercopy_abort().

Switch to kmem_cache_create_usercopy() with a whitelist covering the
lvbptr field.

Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Acked-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/memory.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/dlm/memory.c b/fs/dlm/memory.c
index 5c35cc67aca4c..ee55994ce90d8 100644
--- a/fs/dlm/memory.c
+++ b/fs/dlm/memory.c
@@ -48,8 +48,10 @@ int __init dlm_memory_init(void)
 	if (!rsb_cache)
 		goto rsb;
 
-	cb_cache = kmem_cache_create("dlm_cb", sizeof(struct dlm_callback),
+	cb_cache = kmem_cache_create_usercopy("dlm_cb", sizeof(struct dlm_callback),
 				     __alignof__(struct dlm_callback), 0,
+					 offsetof(struct dlm_callback, lvbptr),
+					 sizeof_field(struct dlm_callback, lvbptr),
 				     NULL);
 	if (!cb_cache)
 		goto cb;
-- 
2.53.0



