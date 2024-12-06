Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06236149C69;
	Fri,  6 Dec 2024 14:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496989; cv=none; b=s0z8gA4Hyhv+YyoVSKZ+IpaXs21iF18B66FkRLCy0kl3JKfpIpWfV4ZX61DduTz+N5CkswcUP/PQi7X9tqhg6LAUo+87RNTgWJdf7AEy2wRKhjA3ZsYUYI2GOg6NgQiFA0+bIhVQyd745E0zioaEeoPgIhFWb6NEEnnuqDTNZTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496989; c=relaxed/simple;
	bh=2t59jc3rHSgjj/iARvd6Z+l8VpTXj3CB6p+hxrqc2iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cL2ZwONUcHh8Xv6sF3iZCottYqhhxyhLf8fcq7FppzZWujvEDcO4OvVdHKl3KUD0df99m98Foqc1RoIy98J/rcbfuXaarQFw3jpzUecRMsLxJLgv2/0iRqPzrTjcVcrM6muX7byyyIUUs0EFPBwD4dcCFvwkL08UO1nmwICRmSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vFwBk8a5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFwBk8a5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69548C4CED1;
	Fri,  6 Dec 2024 14:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496988;
	bh=2t59jc3rHSgjj/iARvd6Z+l8VpTXj3CB6p+hxrqc2iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFwBk8a57zJVNfauNEdVZ3b8as04QjEGznwDxHLDhbC2xrMPt10w6gJPwUVcgDDnx
	 OFCYUujAx7M4D9BxSgeOEFLvy7Ju54dLELGpMgXX4aY7ulL6q4mu0qdIcoA/Kh4O5G
	 pGOPi4q9BDvCAJIQfASReVbiFjYmbPOhO7TwZ5Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 164/676] drm/mm: Mark drm_mm_interval_tree*() functions with __maybe_unused
Date: Fri,  6 Dec 2024 15:29:43 +0100
Message-ID: <20241206143659.758649102@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8257f9d4f6190..22a373eaffefd 100644
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



