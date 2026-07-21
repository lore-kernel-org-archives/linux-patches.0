Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD3F43C7AE;
	Tue, 21 Jul 2026 22:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674254; cv=none; b=ST8D51WRk+OWa9lfgEbMbtSiS99gpVSshjeT8dn8pJXJdM8fPDk0C+pgqXlb+twFu1iK9iOwMHSaXVPQrAlvNzI72KjpgJb4ZyCPd5QbLEGUXH5m591gZ+jngdtc1EI0zjDZ2bFgIGn2uKrOgOP2ul/NA5nYTTLzkFchoEquEsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674254; c=relaxed/simple;
	bh=OEkgd2l+ZZwTcZNxUZETXfKoA7SxKNnSbRVwxInN13I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsH7N2gkRsi+cPrt9gvwy6fWM+Cvhbe1XGCsmrEFaWwAdRsVnj+GGs1cLMx8ZQdtWMj68e5QIMPj1p7vNrcAufSEmHDN6s08Qk4Q/odCRlc8s1dMEHN/sDp7QId+9gKvHGlUZGHbGqzLO6y8xw+y4k0HYB44iSLoi8X7i4SGOSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eT8Mj2m3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eT8Mj2m3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301401F000E9;
	Tue, 21 Jul 2026 22:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674252;
	bh=yi02GQFwABJNZCOZ8d74/s2H/6C9NAW52NsFAcX8hec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eT8Mj2m3RFpRNMy/tGshEhoPAqL9WVO33N13W2AQtyRhaEmsF/0m2nJeHvBCnqil+
	 +XBw3ltW4Z8Y6uKsBHiwLKfItC5pkhUA1FMOazmHcS09a2Pbsyet+2rrE3BmGYTaSL
	 1kQ6a3LAWW0gpzIH7/rookPJQWrMBEVN0xYrpiuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Alison Schofield <alison.schofield@intel.com>
Subject: [PATCH 5.10 471/699] nvdimm/btt: Free arenas on btt_init() error paths
Date: Tue, 21 Jul 2026 17:23:50 +0200
Message-ID: <20260721152406.322755112@linuxfoundation.org>
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
@@ -1615,7 +1615,7 @@ static struct btt *btt_init(struct nd_bt
 	if (btt->init_state != INIT_READY && nd_region->ro) {
 		dev_warn(dev, "%s is read-only, unable to init btt metadata\n",
 				dev_name(&nd_region->dev));
-		return NULL;
+		goto err;
 	} else if (btt->init_state != INIT_READY) {
 		btt->num_arenas = (rawsize / ARENA_MAX_SIZE) +
 			((rawsize % ARENA_MAX_SIZE) ? 1 : 0);
@@ -1625,25 +1625,28 @@ static struct btt *btt_init(struct nd_bt
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


