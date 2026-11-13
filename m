Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591453;
	b=CIM9R041+UZOuhJQ7903WVLHdB8PvDqHwopRLKeNxlYP3gNrL1t8Ex76nMGHdeXyn1/o
	 Wk8UESQe/pL0XykpzlneGADtgiLzFD1Km1BdXt3LWmV6/oOCtkYwph8MMug9JlhoyUS5m
	 AWW1IMLyu4wtHGDQsWXxincH1N4dUioNqnk5oQsz9vz5nFahzlRBMvFswUla63AqAI1Kb
	 J3ThRy+xBvrI2mlZNzMDTlXzSTia/C+Onuwx2+ZR3nU+YySgoZP36JL3gPgyghYT2hqNA
	 2YX5mcMA0sVXbfUSmDvMEPOWocsWHQyClgkSIOuMpDMKW330BGQWOyQGERk/I+FEq2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+0VFSKt0atQtaEiEfUMzs5ZN0oZyCCC4yMbDh6SHnaM=;
	b=hDFFqqWpSFxRsgSOxsyYvFD8/aLi1UU8AKz92NcuKkJdsSIrH8riUIZX+4mwUXs2OXeJ
	 nda3/ky1XBYXqPZ2w23/XG++4jOLJavOvJe/VjaCnVUwfgxJ5fWLUdlrvm4EnJIje4Ozg
	 BoTTODkhMOni17oEH/OIkOOaqem7dkoVygVPRmvKrHcm6w9qucplX+x5/Pa5J9/00+4fx
	 s4vClsuAp1f1s7EiNndxBlSVMt3sw8fsXDn4Cz9U5ZDJhGBP4zbfjqbOEp83f2tHghBx1
	 AAI3h3PqdvdbuJIKeEjEVgn1WaGocEvkrE3Ogw3NmqNTwQw1eIU0hbmeL93+Yh6jNgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gdKFpz9V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B58607C353;
	Fri, 13 Nov 2026 17:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gdKFpz9V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCD21F000C4;
	Fri, 13 Nov 2026 17:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591453;
	bh=+0VFSKt0atQtaEiEfUMzs5ZN0oZyCCC4yMbDh6SHnaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gdKFpz9VEESU0BEr/rRjwv11jfUZY8F9dIvkLJq66wYxcbGBnbaAYDh6MU2bzIfSk
	 qe07TAZI2kN9s6i6M1YrvWk7iqV4N5D0xvMavQf2jYiXU2AjOBk0gzFkVtmcAvQSi4
	 jSY8BzmjR1OzE7YTecyqbqALz7spAENLcIw9VynM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 541/670] xfarray: dont crash when sorting if array element crosses a folio
Date: Fri, 13 Nov 2026 10:51:45 -0500
Message-ID: <20261113153830.229222461@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 329750292e9dfbb594b375d7b30cf5ddb58b7bb9 ]

LOLLM points out that if an array element crosses a folio boundary,
xfile_get_folio returns a NULL folio pointer.  If this happens,
si->folio is also set to NULL, and calling folio_pos/folio_address will
just crash the kernel.  Teach this function to handle this condition by
falling back to reading the array element into scratchpad memory.

Cc: stable@vger.kernel.org # v6.6
Fixes: cf36f4f64c2d4e ("xfs: cache pages used for xfarray quicksort convergence")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: inlined the upstream helper in xfarray_sort_scan() using folio_pos() + folio_size() instead of folio_next_pos() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/xfarray.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index ccf7cfb63bbc8..3cf1ab618f2ee 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -819,7 +819,7 @@ xfarray_sort_scan(
 	    (idx < si->first_folio_idx || idx > si->last_folio_idx))
 		xfarray_sort_scan_done(si);
 
-	/* Grab the first folio that backs this array element. */
+	/* Grab the folio that backs this array element. */
 	if (!si->folio) {
 		struct folio	*folio;
 		loff_t		next_pos;
@@ -830,6 +830,10 @@ xfarray_sort_scan(
 			return PTR_ERR(folio);
 		si->folio = folio;
 
+		/* No folio?  Read into the scratchpad. */
+		if (!si->folio)
+			goto read_scratchpad;
+
 		si->first_folio_idx = xfarray_idx(si->array,
 				folio_pos(si->folio) + si->array->obj_size - 1);
 
@@ -838,14 +842,24 @@ xfarray_sort_scan(
 		if (xfarray_pos(si->array, si->last_folio_idx + 1) > next_pos)
 			si->last_folio_idx--;
 
+		/*
+		 * If this folio still doesn't cover the desired element, it must
+		 * cross a folio boundary.  Read into the scratchpad.
+		 */
+		if (idx < si->first_folio_idx || idx > si->last_folio_idx) {
+			xfarray_sort_scan_done(si);
+			goto read_scratchpad;
+		}
+
 		trace_xfarray_sort_scan(si, idx);
 	}
 
+read_scratchpad:
 	/*
-	 * If this folio still doesn't cover the desired element, it must cross
-	 * a folio boundary.  Read into the scratchpad and we're done.
+	 * If we don't have a folio mapping the entire array element, read into
+	 * the scratchpad and we're done.
 	 */
-	if (idx < si->first_folio_idx || idx > si->last_folio_idx) {
+	if (!si->folio) {
 		void		*temp = xfarray_scratch(si->array);
 
 		error = xfile_load(si->array->xfile, temp, si->array->obj_size,
-- 
2.53.0



