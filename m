Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631A23F5BE4;
	Tue, 21 Jul 2026 17:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654321; cv=none; b=cHHTTQYc9Gci86A6jyxEGtiiIaFmRRyyq8ERwuG8b6mfxChxNj7oE19tGlKsaRe7mmrBiD/6V8+TceiCqXsAkeftoDOsjhTMnKWE5EVhX4jBucEoeL7TFoCYZbp2zEXcLUA//CYE2BEFzXAwYRaCodz1NCvbX75O4+abQ936cns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654321; c=relaxed/simple;
	bh=rIhLFXapevyYOPOiPOX9tOpZ/G+wiDLWYE+rB2tuzdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3uUVQ3awnG+fIAFwDpS23LguManXudEiePRQnSYGQaTjONTMaxgcADkqYZ3Ox+S/I/QMjBLmoI9IrYVKQiQfMTWoRHRTx94KT1o7++HnjllQcwo6l6/QZKYomgw9x6JEidgbS8IhhL0CXvL7IgdG5jqaXcG4E7hn27hbJtpXqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWe2rtAe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWe2rtAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A061F000E9;
	Tue, 21 Jul 2026 17:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654320;
	bh=xdaMir323TV4TLpnQkcxf0IvfQSl45mDGOD6IPOmBqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aWe2rtAevyFdc+q6SnMgzIGgGCM90ESmkXk+3T7EKfAKrmXOevCu+mW2QPOp1y9EF
	 NGruBf/hA01ow+TZOXc5HtqJ1rS9Wc+pKWUd5yLOZekTZ2Yo8rl66yVXWHQ2ZFIML4
	 WpYoY7HsMmZ7HwOPLKXRNCudud2weTU2M//FfeOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Alison Schofield <alison.schofield@intel.com>
Subject: [PATCH 7.1 1658/2077] nvdimm/btt: Free arenas on btt_init() error paths
Date: Tue, 21 Jul 2026 17:22:11 +0200
Message-ID: <20260721152631.853202079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 1a6b6442a982d0ca5fb6a1a39b6f6dfd760eda57 upstream.

The arenas allocated by discover_arenas() or create_arenas() are not
freed on some error paths in btt_init(). This leaks memory when BTT
initialization fails.

Call free_arenas() from the affected error paths to release the
allocations.

[ as: commit message and log edits ]

Fixes: 5212e11fde4d ("nd_btt: atomic sector updates")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260519-nvdimmleaks-v1-2-592300fb7a43@cse.iitm.ac.in
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/btt.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1589,7 +1589,7 @@ static struct btt *btt_init(struct nd_bt
 	if (btt->init_state != INIT_READY && nd_region->ro) {
 		dev_warn(dev, "%s is read-only, unable to init btt metadata\n",
 				dev_name(&nd_region->dev));
-		return NULL;
+		goto err;
 	} else if (btt->init_state != INIT_READY) {
 		btt->num_arenas = (rawsize / ARENA_MAX_SIZE) +
 			((rawsize % ARENA_MAX_SIZE) ? 1 : 0);
@@ -1599,25 +1599,28 @@ static struct btt *btt_init(struct nd_bt
 		ret = create_arenas(btt);
 		if (ret) {
 			dev_info(dev, "init: create_arenas: %d\n", ret);
-			return NULL;
+			goto err;
 		}
 
 		ret = btt_meta_init(btt);
 		if (ret) {
 			dev_err(dev, "init: error in meta_init: %d\n", ret);
-			return NULL;
+			goto err;
 		}
 	}
 
 	ret = btt_blk_init(btt);
 	if (ret) {
 		dev_err(dev, "init: error in blk_init: %d\n", ret);
-		return NULL;
+		goto err;
 	}
 
 	btt_debugfs_init(btt);
 
 	return btt;
+err:
+	free_arenas(btt);
+	return NULL;
 }
 
 /**


