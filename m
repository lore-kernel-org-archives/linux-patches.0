Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658D33C73F6;
	Tue, 21 Jul 2026 22:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674256; cv=none; b=XBpsev984a0XqKF67wFc0DDaiX1e0HMzrxL5DNXkiqqyaacLTxYJHk9cKo90I1brmIfI/r2n3gnX9vBHw1Y7AlZVeXJoBjQ/ilgI6/eji1F/WB4X8d6Q/+SoAhz/XmOw3w6/pzDl+Sinfq+H+L6+V8ZPHKzwOy4Jq2OOsXhTb0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674256; c=relaxed/simple;
	bh=p4d62AJrqnE4FBVWmsksOduJR1da7xZDNQWGdKEadRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUoebpjUYp9mInsUsdKl+mUaJwGmgKjFHQbLgEedRbzs8JrPQnDbK83RE0OQSGUKYjCuWxTb5hoyA8gCuMHhE3Ah1UM6Jv4kayMgJFFyEZfFndk/r+rirNbNsQ9miPjRlQseC9jD3/JQzr2ar2o5B96C8KXXNnkyZyNcbbOsDBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSqoYQsV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSqoYQsV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEC31F000E9;
	Tue, 21 Jul 2026 22:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674255;
	bh=m1nbnwHiRNCVZFyF5AzQK3fNC0NFyUXK+zIQB5h8UtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tSqoYQsV5eNxHJuA6mVh7dt6gvQntcBrgNNyx3qIunMFQX2qO+AVfnMZJ7lzcp99Y
	 KCqNQUY6WmcifjeZB0W8T7Z1Jq/KLoUalSV4Vzog2dRWaoxZOkXtBRh6vlcvyE+HOL
	 O0413Z1FjDmd8T3TCgaUhondy5t4g2JAjQh4phSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Alison Schofield <alison.schofield@intel.com>
Subject: [PATCH 5.10 472/699] nvdimm/btt: Free arena sub-allocations on discover_arenas() error path
Date: Tue, 21 Jul 2026 17:23:51 +0200
Message-ID: <20260721152406.344956393@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 13fe4cd9ddd0aacb7777812328be525a11ea3fea upstream.

Memory allocated by btt_freelist_init(), btt_rtt_init(), and
btt_maplocks_init() is not freed on some discover_arenas() error
paths. This leaks memory when arena discovery fails.

Add the missing kfree() calls to release the allocations before
returning an error.

[ as: commit message and log edits ]

Fixes: 5212e11fde4d ("nd_btt: atomic sector updates")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260519-nvdimmleaks-v1-1-592300fb7a43@cse.iitm.ac.in
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/btt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -923,6 +923,9 @@ static int discover_arenas(struct btt *b
 	return ret;
 
  out:
+	kfree(arena->freelist);
+	kfree(arena->rtt);
+	kfree(arena->map_locks);
 	kfree(arena);
 	free_arenas(btt);
  out_super:


