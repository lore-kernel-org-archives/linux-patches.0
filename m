Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFF31F669E;
	Tue,  3 Dec 2024 15:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238255; cv=none; b=s7U+eAjgSo3DzsDPVJbVN8QaR4ZzQBNmF95odU+teR4x/Q02iff55aCXrIQBIfr0XM7q4QGmA6eMexeUz7/YIlpe8XIBQ8zxH36FaAZNtlN3zJO4xCqRVdU2IPukwbG/X9q0PW5p14YUiidaoWheCJ5mhGss7lKN8D6JtPduTEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238255; c=relaxed/simple;
	bh=L0vUp9ASmUr4V4KWGxua4hNdkbtOhbJIdfzYt6+IXTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tj7/cRQgRBHvwcsQgXApw202yLml7gB+YdSCN6oZLFqRgxMxZpfz1KOBVsSdfto7dZWaiNYBPaD1iOU0beKmMOUtlLZ4u7mhEDx1LIsoiQCRXbhHlau1l9lV1hkP3xIhwylHs+iuGalQ4lWR4W7ybDiOoQ6NudwFiT9/WaVtjuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwQj7P8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwQj7P8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0B6C4CED6;
	Tue,  3 Dec 2024 15:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238255;
	bh=L0vUp9ASmUr4V4KWGxua4hNdkbtOhbJIdfzYt6+IXTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LwQj7P8squfqG06TnPoy1EfaDrQn8tEvHZZ4FFlFZFowym6VgjQO2Hk/YVF7wjk79
	 8/reS9AKg68DRTL79XyVvJwKmCg1gv5f95nWnfhlSuFBdvjocoxan+3jtTC9zg1+iv
	 ZKKDmaE4UbmCOLp88TndMMi3K5ekCkVnGa+aKfyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 216/817] drm/mm: Mark drm_mm_interval_tree*() functions with __maybe_unused
Date: Tue,  3 Dec 2024 15:36:28 +0100
Message-ID: <20241203144004.182212830@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 5ace481c19011..1ed68d3cd80ba 100644
--- a/drivers/gpu/drm/drm_mm.c
+++ b/drivers/gpu/drm/drm_mm.c
@@ -151,7 +151,7 @@ static void show_leaks(struct drm_mm *mm) { }
 
 INTERVAL_TREE_DEFINE(struct drm_mm_node, rb,
 		     u64, __subtree_last,
-		     START, LAST, static inline, drm_mm_interval_tree)
+		     START, LAST, static inline __maybe_unused, drm_mm_interval_tree)
 
 struct drm_mm_node *
 __drm_mm_interval_first(const struct drm_mm *mm, u64 start, u64 last)
-- 
2.43.0



