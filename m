Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9560A38DE5;
	Mon,  1 Apr 2024 17:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991168; cv=none; b=quKqs4imrdySFXKMwweIsefBTQDAjQWBfOqh655S3uBQECYHFmYrdCtPdcF4rwgOzKY7CbbECg6gDHWrEhTEGL6/V378hVjht6yLTlAWfohCAd6cAus7NQzICYpAzw09ddK9X8HpGIrmGASaWTZq4bxeBoGv6pwLupzqabcrUZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991168; c=relaxed/simple;
	bh=Mnwek2ccX+5EtknIU0vdJFjyCVDv+3cD3tY9AO/ltbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QohQ8cX8UTTgbE6+GHgK72E7V8zL9TCLDmZymaMvBDZT/g451t0wEoStczrDpry1I8eZ2eulzQ2KgbiZJpU7JN7SXMuFA9qAn76riQ+cStkzP3FBMS+EyZkUw03BEfRYEHGl2HcS1ZGXMBciayL5PPqA9Kss0YpePpe1mXgzsM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OesLGJpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OesLGJpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032FFC433C7;
	Mon,  1 Apr 2024 17:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991168;
	bh=Mnwek2ccX+5EtknIU0vdJFjyCVDv+3cD3tY9AO/ltbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OesLGJpLuowiHEbDk9YdmJ0T+TgMVy585X0uqtuQeEsTgwuY4kNjyX2hWNKsM1D8m
	 IvG/SwN3Cu4apMMJxBsXHW4n/aTR+gd99d2Gd+p1q1ja905uCaP4GKhYCokGuhUuD+
	 2wiGJct0d24AsBNs6pLCoIGHUGawZAJjNXhwi3Ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Shawn Lee <shawn.c.lee@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.1 155/272] drm/i915: Check before removing mm notifier
Date: Mon,  1 Apr 2024 17:45:45 +0200
Message-ID: <20240401152535.546798734@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoy.das@intel.com>

commit 01bb1ae35006e473138c90711bad1a6b614a1823 upstream.

Error in mmu_interval_notifier_insert() can leave a NULL
notifier.mm pointer. Catch that and return early.

Fixes: ed29c2691188 ("drm/i915: Fix userptr so we do not have to worry about obj->mm.lock, v7.")
Cc: <stable@vger.kernel.org> # v5.13+
[tursulin: Added Fixes and cc stable.]
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Shawn Lee <shawn.c.lee@intel.com>
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240219125047.28906-1-nirmoy.das@intel.com
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
(cherry picked from commit db7bbd13f08774cde0332c705f042e327fe21e73)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
@@ -378,6 +378,9 @@ i915_gem_userptr_release(struct drm_i915
 {
 	GEM_WARN_ON(obj->userptr.page_ref);
 
+	if (!obj->userptr.notifier.mm)
+		return;
+
 	mmu_interval_notifier_remove(&obj->userptr.notifier);
 	obj->userptr.notifier.mm = NULL;
 }


