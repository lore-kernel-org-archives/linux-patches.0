Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15C446F4AD;
	Tue, 21 Jul 2026 22:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672376; cv=none; b=ZBoQfZTNH97zeV1eEBjta1nRlZQ/+VUmI3mXj0Lua0074BNYSkGylyt9NEW6vLtL88QjznGvUwIb1KNBjH6xCTqOsd3ikmUJXiB9oLzUGPidbPL2OP7EZfH74pupSBoIvx+dPiOd1VvBthopLH4yTIMlQvUZaLYTEWDB5XBNZ7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672376; c=relaxed/simple;
	bh=THrAuILJZYSBtSG12fgQI1U3CwvO7j0y9gnBj3xkc1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+oPsRKrH2ac2LmxyDP4WvK9N8enIyrImwC5TNqVuLioPUcI3aH1wZvbAFEbQ60cTuy/MgU2Va039QadqxjDyPPfwdPtOr1yZh9dm8Ldh7/xq4TsdHL7Og+m/BDSd+espdJzrgz8jDj3KaLrqOgXHAzZA4AlaNlNfBc0FZohxyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fy6EibfP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fy6EibfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C151F00AC4;
	Tue, 21 Jul 2026 22:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672375;
	bh=vmRv/kyIsbifzcKk8lIWJmTJ1bEn4n8TLsfb/3E4CrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fy6EibfPWaQ357xQxtlERKr9OuPj6apAjD3+DTq2IiCyy+lIeLz52GKZSqfA+yVaL
	 0/JyofIM9mC5KaBqQOBZh2IjX/a1FhEXiKx1jcP95Q1fdKODrTEe6WqnXOuhT8nQMb
	 C99UR8df/GpheEdLj/lYqm+vyECEzcqCg0bEB2O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Alison Schofield <alison.schofield@intel.com>
Subject: [PATCH 5.15 602/843] nvdimm/btt: Free arenas on btt_init() error paths
Date: Tue, 21 Jul 2026 17:23:57 +0200
Message-ID: <20260721152419.593020642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
@@ -1604,7 +1604,7 @@ static struct btt *btt_init(struct nd_bt
 	if (btt->init_state != INIT_READY && nd_region->ro) {
 		dev_warn(dev, "%s is read-only, unable to init btt metadata\n",
 				dev_name(&nd_region->dev));
-		return NULL;
+		goto err;
 	} else if (btt->init_state != INIT_READY) {
 		btt->num_arenas = (rawsize / ARENA_MAX_SIZE) +
 			((rawsize % ARENA_MAX_SIZE) ? 1 : 0);
@@ -1614,25 +1614,28 @@ static struct btt *btt_init(struct nd_bt
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


