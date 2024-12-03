Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7CB1F4735;
	Tue,  3 Dec 2024 14:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236602; cv=none; b=gxqu1h1PSSIPlEfGv7pzYW9b/24QBirpTHM1PKpobScRqWxwgBQFqhlds9nn2tU+fyE4DDAJkR8OY6V63Z2wcm6bliUUkuhBvn2Eae3t8GyhhrhKLVFNK1I4OvNfW66spRlMUQzgQsiYfmUw1VJxv19tQo5lqdt0OjmDorFOylA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236602; c=relaxed/simple;
	bh=rnwTXKM/Fz9U94yV2jigSJqcozwh1lJ9HrnHsYwv8sM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhFrQ2CRAaWKSNZ3iPIkFUXiyUeYzC7s2fGpcM6Fk6xLyK/loGh0oufwqNXSa9n/oPwJBsGp6KvX2fvdbKGdwmH/D//g+lQ6971YHWv4D7b2RH/5ZzpJBNoeMCMhNKyvZ7oQPkTMQQV1DMUli33x3jf0L5hDp0EdVlWHb7tNjzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=isAksinc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="isAksinc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B492C4CED8;
	Tue,  3 Dec 2024 14:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236601;
	bh=rnwTXKM/Fz9U94yV2jigSJqcozwh1lJ9HrnHsYwv8sM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=isAksincdT8dNpWrNejGWECr4I8G+cjnGb251EOBy/95BMouXegl1LGTigmiQh7z4
	 yOGJdX9Z0yfwGTriPr3V8N/UMwbq0Z1v78XZs6rbUi56s5atiE48/rAaX1sYWXZYGm
	 G6IeEsHwxIAt9aevP+ssXkITFVH225ibPq6Qri/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 036/138] drm/mm: Mark drm_mm_interval_tree*() functions with __maybe_unused
Date: Tue,  3 Dec 2024 15:31:05 +0100
Message-ID: <20241203141924.936570788@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 53bd7c1c0077db533472ae32799157758302ef48 ]

The INTERVAL_TREE_DEFINE() uncoditionally provides a bunch of helper
functions which in some cases may be not used. This, in particular,
prevents kernel builds with clang, `make W=1` and CONFIG_WERROR=y:

.../drm/drm_mm.c:152:1: error: unused function 'drm_mm_interval_tree_insert' [-Werror,-Wunused-function]
  152 | INTERVAL_TREE_DEFINE(struct drm_mm_node, rb,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  153 |                      u64, __subtree_last,
      |                      ~~~~~~~~~~~~~~~~~~~~
  154 |                      START, LAST, static inline, drm_mm_interval_tree)
      |                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix this by marking drm_mm_interval_tree*() functions with __maybe_unused.

See also commit 6863f5643dd7 ("kbuild: allow Clang to find unused static
inline functions for W=1 build").

Fixes: 202b52b7fbf7 ("drm: Track drm_mm nodes with an interval tree")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240829154640.1120050-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_mm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_mm.c b/drivers/gpu/drm/drm_mm.c
index 3cc5fbd78ee20..d7d9fc093c30f 100644
--- a/drivers/gpu/drm/drm_mm.c
+++ b/drivers/gpu/drm/drm_mm.c
@@ -164,7 +164,7 @@ static void show_leaks(struct drm_mm *mm) { }
 
 INTERVAL_TREE_DEFINE(struct drm_mm_node, rb,
 		     u64, __subtree_last,
-		     START, LAST, static inline, drm_mm_interval_tree)
+		     START, LAST, static inline __maybe_unused, drm_mm_interval_tree)
 
 struct drm_mm_node *
 __drm_mm_interval_first(const struct drm_mm *mm, u64 start, u64 last)
-- 
2.43.0



