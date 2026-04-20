Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F75233F8D6;
	Mon, 20 Apr 2026 16:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701031; cv=none; b=mXH/fj7k/G7ClDrVwFt+ymrsCGAO0DgB3Mv3zTTdIcEVm4aUu6yl+YZIKsSCReiKt1wuxKh4+tZSx3OdBfLmzLcb/CXPz0WySVc9w1Tui/laFatoH9Z37GQvLtmiS8ZgbxE7KoIp1nGMyaswvE4CrBk1ocIJ63tuNM6GMnKG+I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701031; c=relaxed/simple;
	bh=KaLfJt+LPR+wDo9CQctMA3r3rvlABa4wh1Ei+rVw1go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBuRd3ZlvUCxj1cT6HGnAcGAvGg5ScoC72MNcc1uX0ctw45+QHEhrFnmQQFcH412+Esq0RNbiu6gQtL7YjiHCoVfksRaLrciivLoyj24B24KQ6h4xdLr4eXgkSPQ08/1Reg9N4RSN1HlV8v3lMlmNlCl31erXJC955ZvtPThnK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s0t7A8tA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s0t7A8tA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F67C19425;
	Mon, 20 Apr 2026 16:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701031;
	bh=KaLfJt+LPR+wDo9CQctMA3r3rvlABa4wh1Ei+rVw1go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s0t7A8tAkOmOLV1qyzZL074Fo7Y5AYC0mS0OhPOU9Y+13DZ9P8MLrh7unkH5GdP9o
	 4qMkjGTYhyjUnN/mzxMDONsXkjryIKuq9DuCIIJKOhQqjuBf4z1oT9KF2qqh3fVbWQ
	 6J7WUXD0AjUln6cnEEPuNLX2ZTW/BcncuXjZ/LpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 155/198] Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race
Date: Mon, 20 Apr 2026 17:42:14 +0200
Message-ID: <20260420153941.188019346@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit 0beba407d4585a15b0dc09f2064b5b3ddcb0e857 upstream.

Patch series "Docs/admin-guide/mm/damon: warn commit_inputs vs other
params race".

Writing 'Y' to the commit_inputs parameter of DAMON_RECLAIM and
DAMON_LRU_SORT, and writing other parameters before the commit_inputs
request is completely processed can cause race conditions.  While the
consequence can be bad, the documentation is not clearly describing that.
Add clear warnings.

The issue was discovered [1,2] by sashiko.


This patch (of 2):

DAMON_RECLAIM handles commit_inputs request inside kdamond thread,
reading the module parameters.  If the user updates the module
parameters while the kdamond thread is reading those, races can happen.
To avoid this, the commit_inputs parameter shows whether it is still in
the progress, assuming users wouldn't update parameters in the middle of
the work.  Some users might ignore that.  Add a warning about the
behavior.

The issue was discovered in [1] by sashiko.

Link: https://lore.kernel.org/20260329153052.46657-2-sj@kernel.org
Link: https://lore.kernel.org/20260319161620.189392-3-objecting@objecting.org [1]
Link: https://lore.kernel.org/20260319161620.189392-2-objecting@objecting.org [3]
Fixes: 81a84182c343 ("Docs/admin-guide/mm/damon/reclaim: document 'commit_inputs' parameter")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/mm/damon/reclaim.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -71,6 +71,10 @@ of parametrs except ``enabled`` again.
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_RECLAIM will be disabled.
 
+Once ``Y`` is written to this parameter, the user must not write to any
+parameters until reading ``commit_inputs`` again returns ``N``.  If users
+violate this rule, the kernel may exhibit undefined behavior.
+
 min_age
 -------
 


