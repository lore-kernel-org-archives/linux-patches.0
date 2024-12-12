Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28041487CD;
	Thu, 12 Dec 2024 17:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023833; cv=none; b=WSAXYWqmcwrl3p3xelNufyyENeMl0OJp8Z3yDdldjHP9A2lox04gK9QpMlkktj+6XhCqvzx67znJVyoN2x95JebnV04m9ZgRFDwOU4T6nG28jSf6cqswfQrhnYCIMUWNDm3CgbYfbY0nVx9NAOZJkZmg+SeTvHzDS1Y/KUNXsKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023833; c=relaxed/simple;
	bh=hAhDP4pZwv8m11z8znIRXclH86hq4arMq/2RmQXm8Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uACEANagLc4vuVOYLz0ezr5Jx3O9KycZUeyYW4YeK4Va4r8z6vYogcpwcUTlTrUjW+XY+5tEZX+XY+jOB/RtqLr6iZ4y0q/mHw4b9SrTg9SHlECIFLZ3G6PBVeLGsYWll1ISNadTca4lgKEIm3E/5SISwcrDvHvh9QXdSQzeEI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bl5czQET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bl5czQET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51011C4CECE;
	Thu, 12 Dec 2024 17:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023833;
	bh=hAhDP4pZwv8m11z8znIRXclH86hq4arMq/2RmQXm8Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bl5czQET262A3IYoEBXOZPXQ12Hd0hw2LrDVS1/cd+sd1J+ws9jLuG+19eSvvPaP0
	 znC+islGZCtHnOeSUCoKKWl+/iimaisPWArOinvEhPhLQAin8V+2HhQgEtQHPtlt8Z
	 tP7yeTQAwRq9By8EHHlc3HZTE0LLHML4vAjZGw0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/459] drm/mm: Mark drm_mm_interval_tree*() functions with __maybe_unused
Date: Thu, 12 Dec 2024 15:57:16 +0100
Message-ID: <20241212144257.381678821@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a4a04d2461353..7c25a8e38830b 100644
--- a/drivers/gpu/drm/drm_mm.c
+++ b/drivers/gpu/drm/drm_mm.c
@@ -154,7 +154,7 @@ static void show_leaks(struct drm_mm *mm) { }
 
 INTERVAL_TREE_DEFINE(struct drm_mm_node, rb,
 		     u64, __subtree_last,
-		     START, LAST, static inline, drm_mm_interval_tree)
+		     START, LAST, static inline __maybe_unused, drm_mm_interval_tree)
 
 struct drm_mm_node *
 __drm_mm_interval_first(const struct drm_mm *mm, u64 start, u64 last)
-- 
2.43.0



