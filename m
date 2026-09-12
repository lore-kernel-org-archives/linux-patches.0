Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F791490C0E;
	Sat, 12 Sep 2026 18:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237481; cv=none; b=i856P9Ovi/PHtvgi2w66bzaf3OIQioe2Xya2Wx5yu0rw6y7t82EzotBK/tYYIqLvpgvdLL05DURKI8HTdwCmFSKcqWBM5XX+kJLNOFyCTG8zcU1oSg6T9tZXbIT051/XUFbkpugfdjJYyB2+Q/PT60kVN/lu3gW61Eggxd63xcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237481; c=relaxed/simple;
	bh=znEhIbbMMHjFG/FCelhSxeJHBTxVWagt5WiWi240bq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nb5zSB8yE7yf/jhzXhvbRgqthlqPg5ypDrofYqNrYo7AKUWzrY7vnzFB3XQgfMZYeDH76ABvekQvVHfPbM2VLkhDKEpq/FojxiVqnSYMBLNRv7LPc+5hTAUQjedwahRMCnTSqeLe/+0eb6oQriIGdzL9c1pnzCdRXuJDcO9M6mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pKEAjuLU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pKEAjuLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41E21F000FF;
	Sat, 12 Sep 2026 18:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237480;
	bh=tyKe/6lQ5hWDVD5TYaHveaxJOp63n4mQSYSGzGo4fmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pKEAjuLU5cjFsWcFF1GUZs/REUBPTTfK13Hml+yExJJl3ijJuhXpbPy6Q8T3cPLpE
	 CKTZx8qtn2lndrx321NlW0pNE/jIobK6QnIxlbB64ynAG4EYZV50lzTb40WxjXtQsT
	 5UI8ZBTJFEVNPDUi2MlraxkVhErXtf/zFBk9+xVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Alison Schofield <alison.schofield@intel.com>
Subject: [PATCH 5.15 268/935] nvdimm/btt: reject an arena whose nfree is below the lane count
Date: Sat, 12 Sep 2026 08:54:58 +0200
Message-ID: <20260912065532.970597974@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 6a1f2e5ed9267ca19187038ac635393c165213ac upstream.

The BTT info block's nfree field, the number of reserve free blocks, is
read from the medium without validation.  btt_freelist_init() and
btt_rtt_init() size the per-lane freelist[] and rtt[] arrays by nfree,
but the I/O path indexes them by the lane from nd_region_acquire_lane(),
which is bounded by nd_region->num_lanes (ND_MAX_LANES), not by nfree.
A crafted or foreign arena whose nfree is below the lane count makes
freelist[lane]/rtt[lane] run past the allocation: an out-of-bounds write.

btt.rst documents the nlanes = min(nfree, num_cpus) invariant, which the
code does not currently honor: num_lanes is ND_MAX_LANES regardless of
nfree.  Reject an arena whose nfree is below num_lanes at discovery,
before the per-lane arrays are allocated, enforcing that invariant.

Fixes: 5212e11fde4d ("nd_btt: atomic sector updates")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260620-b4-disp-88b2514b-v1-1-3834e707d232@proton.me
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/btt.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -887,6 +887,14 @@ static int discover_arenas(struct btt *b
 		arena->external_lba_start = cur_nlba;
 		parse_arena_meta(arena, super, cur_off);
 
+		if (arena->nfree < btt->nd_region->num_lanes) {
+			dev_err(to_dev(arena),
+				"nfree %u smaller than lane count %d\n",
+				arena->nfree, btt->nd_region->num_lanes);
+			ret = -ENODEV;
+			goto out;
+		}
+
 		ret = log_set_indices(arena);
 		if (ret) {
 			dev_err(to_dev(arena),


