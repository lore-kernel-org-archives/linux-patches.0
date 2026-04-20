Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5DB329C6D;
	Mon, 20 Apr 2026 15:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699978; cv=none; b=CGONeAohfWHz1dPNDpMATIQFX+itD4s3WCZOYnbFxXvVfO9C/6DGajO6tNrr33XQb1KAWWTify3Gesw8VtITWYgu6iY8imu+inGZuj72tWzxZFqXr7ZXL9aO+0MLnHHq1TFMDrN9Td3mDvbtUUGZH5GlsoJ/KD5oz9ny94t3vPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699978; c=relaxed/simple;
	bh=oDidoPwpAUjhSLJYpALyDYkVy0QaYh6EEQ3xZTpX0Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/fKIM3MBsnwxgalUpgWAaSL4H7A2gWs7ZzO77ViCb3eRcZJgNDMxR/TpcNygNXztp9xPS8GBwY08yaEDUeNRrsKswGwW+IWyLppTD0IOjwzAo0WWAVa0EXbBiQgRzPeGDwB0mc/fw6wGQqnEj2bzuWHo87RybhBQXwp4ivqGRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bsluzPcn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bsluzPcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E82C19425;
	Mon, 20 Apr 2026 15:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699978;
	bh=oDidoPwpAUjhSLJYpALyDYkVy0QaYh6EEQ3xZTpX0Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bsluzPcnw1vcSxAW1Na+9xMcIFahEd/8AV2Fq3FH+9hQ387yKv4E+L0JF0+qDTCZJ
	 894xLJgs6ifYTRuyVPJxzlD5Sl7ZFU2DYxjLdsalNVooLG981kJeH58a4B0AbbDGXn
	 KGhde3w7Ty8yUXKrJ5Ewn76tKiV47Xn8+WRLn6Ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 39/76] Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race
Date: Mon, 20 Apr 2026 17:41:50 +0200
Message-ID: <20260420153912.249596336@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 0c13ed77dd2bc1c2d46db8ef27721213742cccd8 upstream.

DAMON_LRU_SORT handles commit_inputs request inside kdamond thread,
reading the module parameters.  If the user updates the module
parameters while the kdamond thread is reading those, races can happen.
To avoid this, the commit_inputs parameter shows whether it is still in
the progress, assuming users wouldn't update parameters in the middle of
the work.  Some users might ignore that.  Add a warning about the
behavior.

The issue was discovered in [1] by sashiko.

Link: https://lore.kernel.org/20260329153052.46657-3-sj@kernel.org
Link: https://lore.kernel.org/20260319161620.189392-2-objecting@objecting.org [1]
Fixes: 6acfcd0d7524 ("Docs/admin-guide/damon: add a document for DAMON_LRU_SORT")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.0.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/mm/damon/lru_sort.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -79,6 +79,10 @@ of parametrs except ``enabled`` again.
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_LRU_SORT will be disabled.
 
+Once ``Y`` is written to this parameter, the user must not write to any
+parameters until reading ``commit_inputs`` again returns ``N``.  If users
+violate this rule, the kernel may exhibit undefined behavior.
+
 active_mem_bp
 -------------
 


