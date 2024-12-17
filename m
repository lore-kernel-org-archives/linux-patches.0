Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD521F76C3;
	Tue, 17 Dec 2024 17:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456761; cv=none; b=COnPTOH3eVmoX0n87GTS4bfbLJJ4k84VKp8vUKkPwegzXSna7agVNJ+ckMLhVAJLHcSW0MyzhKr2Mxw6pZZMbRrgdJxL876gHBKiqnRpS/dMFRGriEeJARVUPZL/0bxY5OzXOkPx0lVj2+bqLm9zgg+uw8s/dfnMbRlxkS8mdak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456761; c=relaxed/simple;
	bh=0/0gQf4lRUsEZGk1uj2SqM2H8ipgEs1YzZO7C4isX2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h19IIfdtO9w1G/gh8fFp5f0z2aUh8LB/FKbWfaBkNzKsLsAQDElr1P2+dpTYHlNRuD6BvnAvpE9Y6oWyMtyQyCUv776iZOTAIXq58EyflcTP3IGz+/RV/lcyvn1Q47n2ZP3Hcdo3UStMwEJzwpRVwZH8OTP+9qLdDOQoxEa9QtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KQPSofmt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KQPSofmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69B7C4CED7;
	Tue, 17 Dec 2024 17:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456761;
	bh=0/0gQf4lRUsEZGk1uj2SqM2H8ipgEs1YzZO7C4isX2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQPSofmtAQBJ0p+Xwvlz5KBR0ci3y03KCxte2FgRxCAKD0K30FpNZZhTk8ddLVPOO
	 HFhulgFMlGNb6kXHxcAwxDn6IobO442+aXltgdtvRGYWIl3uemS5n0b0yZKhNy4vVQ
	 vpjVLBH1Yf/ONWvLEmg5OAy2JEt7gVo+yh+5ExnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mtodorovac69@gmail.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 157/172] drm/xe: fix the ERR_PTR() returned on failure to allocate tiny pt
Date: Tue, 17 Dec 2024 18:08:33 +0100
Message-ID: <20241217170552.844833508@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mirsad Todorovac <mtodorovac69@gmail.com>

[ Upstream commit ed69b28b3a5e39871ba5599992f80562d6ee59db ]

Running coccinelle spatch gave the following warning:

./drivers/gpu/drm/xe/tests/xe_migrate.c:226:5-11: inconsistent IS_ERR
and PTR_ERR on line 228.

The code reports PTR_ERR(pt) when IS_ERR(tiny) is checked:

→ 211  pt = xe_bo_create_pin_map(xe, tile, m->q->vm, XE_PAGE_SIZE,
  212                            ttm_bo_type_kernel,
  213                            XE_BO_FLAG_VRAM_IF_DGFX(tile) |
  214                            XE_BO_FLAG_PINNED);
  215  if (IS_ERR(pt)) {
  216          KUNIT_FAIL(test, "Failed to allocate fake pt: %li\n",
  217                     PTR_ERR(pt));
  218          goto free_big;
  219  }
  220
  221  tiny = xe_bo_create_pin_map(xe, tile, m->q->vm,
→ 222                              2 * SZ_4K,
  223                              ttm_bo_type_kernel,
  224                              XE_BO_FLAG_VRAM_IF_DGFX(tile) |
  225                              XE_BO_FLAG_PINNED);
→ 226  if (IS_ERR(tiny)) {
→ 227          KUNIT_FAIL(test, "Failed to allocate fake pt: %li\n",
→ 228                     PTR_ERR(pt));
  229          goto free_pt;
  230  }

Now, the IS_ERR(tiny) and the corresponding PTR_ERR(pt) do not match.

Returning PTR_ERR(tiny), as the last failed function call, seems logical.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Mirsad Todorovac <mtodorovac69@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241121212057.1526634-2-mtodorovac69@gmail.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit cb57c75098c1c449a007ba301f9073f96febaaa9)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/tests/xe_migrate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/tests/xe_migrate.c b/drivers/gpu/drm/xe/tests/xe_migrate.c
index 1a192a2a941b..3bbdb362d6f0 100644
--- a/drivers/gpu/drm/xe/tests/xe_migrate.c
+++ b/drivers/gpu/drm/xe/tests/xe_migrate.c
@@ -224,8 +224,8 @@ static void xe_migrate_sanity_test(struct xe_migrate *m, struct kunit *test)
 				    XE_BO_FLAG_VRAM_IF_DGFX(tile) |
 				    XE_BO_FLAG_PINNED);
 	if (IS_ERR(tiny)) {
-		KUNIT_FAIL(test, "Failed to allocate fake pt: %li\n",
-			   PTR_ERR(pt));
+		KUNIT_FAIL(test, "Failed to allocate tiny fake pt: %li\n",
+			   PTR_ERR(tiny));
 		goto free_pt;
 	}
 
-- 
2.39.5



