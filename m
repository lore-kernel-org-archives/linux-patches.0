Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DDF315785;
	Sat, 12 Sep 2026 13:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221418; cv=none; b=uKt0U7Do9JMxDDSCXXvCaHRIxnGJTXyKyg38iXhmbS4syPn3RT00IC2wV/rdnhEq5K0vvFmW4dUQcQQMOKy8QKcs1ykVdRDgxxmKgtYvk1U4D0xM0UrZA1eVbHgC+hdpw9/Oc8TElw0ZE7yzX1N2MyhDUlrbHLffZTTS7e4Ffq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221418; c=relaxed/simple;
	bh=sSAjFf1AxwNtvaVEvSEabGKZB7W+rjN0BeXsQ4L8EYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCdyv3yIcAOHMkqP9XagQtNh5RcBvXLUbS9fd6C4tJNA7QKi0feSrBzKien4EI9hO7X2FndP3rhOMbu5wLPz2aRRd16hR1x+VbvAFq8lJbFVvC+ANL6+VAEJ7hSYF/Hg88FTawq5ImfXNp0bYpCQUg8oL7PsqMxW+JRq2FiAH6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WT/Y61gn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WT/Y61gn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966261F000FF;
	Sat, 12 Sep 2026 13:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221415;
	bh=k0hoRdYYwssoDPfXOwPv9gM3hFDd5M8XuxwO8PHsjbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WT/Y61gnF+9r64aIGEjV6Lr0hT/M/Q+dz/P+pidk9J9CCRZk8C5qJZClmMr8TpOeP
	 9Lm7OBqEcHb6Z2gGzN8pMvzRaVuymQhl6K32YYT+AV7rmayoyoAAHMD9UmriM1p9vt
	 2MehDjacM3Dm1s0USDMiVpzalGGLbhJ85fndo+Uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Alison Schofield <alison.schofield@intel.com>
Subject: [PATCH 6.6 0377/1424] nvdimm/btt: reject an arena whose nfree is below the lane count
Date: Sat, 12 Sep 2026 08:46:49 +0200
Message-ID: <20260912065615.734467494@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -886,6 +886,14 @@ static int discover_arenas(struct btt *b
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


