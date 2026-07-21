Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F543C4B81;
	Tue, 21 Jul 2026 18:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658629; cv=none; b=JPrXDc0q94TSqzdpbWyud6zXgTAqbBljIS1YvssSsdFA3V07SbjE+mWy9aVuh0P2MKNPyQ3cPZcDcEu4juWuQwbs8jBbV4r+7e8rG7IQe+3+HQF3PURHL0KLwQIWdnlK7S+/5JLhwZD3DNap5j1zGTSGdXN898/+skSnfDY5+4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658629; c=relaxed/simple;
	bh=gbtNAZeCf4b/LIiKI9OxbvJdLELSENEUyZFjOXgaJVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgfgGZmBlCpLARGVz4tCLBX5h4+j9m0V3r9uz+H0WdJm1wA6rJBfNwepU9Tth0GGUlkXit+GKbgc/ZwwV0t0oQBIObLINT7eqtbkJUvQ5CfR2AuH1Kz8vgA+U1fMYAgzldKpWooTepz9SRzHLssd9IWvNE12n1ABnJywQODpD+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUcDoMb4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUcDoMb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0B31F00A3D;
	Tue, 21 Jul 2026 18:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658628;
	bh=B32duYgzQ8fUefC1VxwyS+PXUrd7t4N3t+A9UMLQ9lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UUcDoMb4bcdk7Xl7ggXXMDac/3u/BFo4kWecvZzTveq7XmGwosD/yrlRRWmFh6mAM
	 IAzmWEZw5WLQRfxAgJP1O66exr9n9ssb+AUt0tmy2fQE3+rPq/EhH61aL9q17PxTMk
	 ZMKRapfC3gS2FisQcOE7GyqhlTXgmMkekMTWTrhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Alison Schofield <alison.schofield@intel.com>
Subject: [PATCH 6.18 1216/1611] nvdimm/btt: Free arena sub-allocations on discover_arenas() error path
Date: Tue, 21 Jul 2026 17:22:12 +0200
Message-ID: <20260721152542.786750413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -921,6 +921,9 @@ static int discover_arenas(struct btt *b
 	return ret;
 
  out:
+	kfree(arena->freelist);
+	kfree(arena->rtt);
+	kfree(arena->map_locks);
 	kfree(arena);
 	free_arenas(btt);
 	return ret;


