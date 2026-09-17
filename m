Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8088511E99;
	Thu, 17 Sep 2026 16:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661168; cv=none; b=aNHsim0JowDMyOSQdOOCscivJVt3EpR75NFldBUVmv9VRdztU1sIxV3Pvkln4zgMGXfFizzmAE43QSYetEaLea7ToHeNp45/nSFOj2WspNvYXn4MRUhIlU3pwbbfMCi+JeVv7P3B4I7CdC34apHZAcSljqhy6T8e/yf/SIYTwEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661168; c=relaxed/simple;
	bh=72pdhABWERZqR02v27vqPK4HEVrCXjSp8F2zKfBdvVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ontJvmSGNTz9g1ntmnlc66ZFBWd2NY0lSaWwGiPZPkGluzoTtfXKSOJ7avdUBHRMTZoLRPWgUbCh4S9RdsTp2WFJ9FD1u1hpquVSLfquMtofvNtM4PuYkfwk+7hPbjVIDAvX5cemL+W+ck/jGepmU0UPSuRxFdVcHCjDzFxDgCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oB8Oazn6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oB8Oazn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C111F00898;
	Thu, 17 Sep 2026 16:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661167;
	bh=Mc0iAJmcb0XdYXhH23FQ5oRnuesaUHYSjk/AvkpmnXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oB8Oazn60aJliMpU7e/8R3gUiRTYFvAwo0liF0Vdc1EqUmmLqRr5gBU7TuzCjhuuz
	 3tlgxeLfVeYTjzlLQNnOOruI1EANyyDSwNmol41PQwcU9G8PbNIPpwdnjtyrK7jIzj
	 MpG2Bgt5WLLChm7N0WaGwmTduKMnOM9oFpj12K2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0078/1250] dlm: add usercopy whitelist to dlm_cb cache
Date: Thu, 17 Sep 2026 15:57:53 +0100
Message-ID: <20260917151554.078371580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



