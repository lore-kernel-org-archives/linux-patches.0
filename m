Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AB14195A3;
	Fri,  4 Sep 2026 05:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500548; cv=none; b=CTuZnaw5nAjmt91OrO6yUkEhWRQfIlLibFDBlugaUZRzDSU/WZucuRpkEVODFbxpmOJ2qcmHXzuoRLw8PDB22DlmUnL2Em7uM0OQZy8+KgVlHi7ADNbvmipFXa2mHrPjnmWPf6KxNKAFmrf0A3H+JjsCcXsImjAB7g2aFe4i28A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500548; c=relaxed/simple;
	bh=TYDdxtY+USdF1MhUZxZURWnnSKza5hqrRa6iqMmWAkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEJG6ZmwwZtW9W1S+VgD55KX9spzFpuCof2IaHsUMsxdXMvE09WlJw96E6oBcU4ZRvkOgim+leLXJh85S9AQ+GZ0PefsmGFvuOkrHQgTrNJ5VeWMKw9OVA9Kd/cgizrcxBd6jBYPEsbQXIDqi576vOTIw8bQxe46446Ie9bODDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLquPGsT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLquPGsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C86D1F00A3D;
	Fri,  4 Sep 2026 05:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500546;
	bh=HZkaKi+08Wt0wpsQrtI6/qspmX4Rin/uDatvmIFbicE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLquPGsTqGZViNXFwyuGwdSETRcDcmApXIC2Cid8jP7igbl/ltw7//EMW3d9wH8vh
	 QZtlPoWgVJIP5bNNN61fXwJW2xrb0hvr44OPutLB+4DMtnUxVJVuluJ2/TNm2zOO4p
	 ZtgFVA1L+Jrgaj71LzwTZ0sLMuIqPjV/JiTHomOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Haoqin Huang <haoqinhuang7@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 095/552] zram: validate deflate params
Date: Fri,  4 Sep 2026 06:54:12 +0200
Message-ID: <20260904045750.046555270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Sergey Senozhatsky <senozhatsky@chromium.org>

commit ec7607ac4717ff521c9c1e9d8271c26293345513 upstream.

We must validate user-supplied deflate winbits before we pass it to
zlib_deflate_workspacesize(), which triggers BUG_ON() if winbits value is
outside of valid ranges.

Link: https://lore.kernel.org/20260729045745.775973-3-senozhatsky@chromium.org
Fixes: dc75a0d93bd5 ("zram: support deflate-specific params")
Link: https://sashiko.dev/#/patchset/20260728092935.31139-1-haoqinhuang7@gmail.com
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Haoqin Huang <haoqinhuang7@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/backend_deflate.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/backend_deflate.c
+++ b/drivers/block/zram/backend_deflate.c
@@ -24,8 +24,16 @@ static int deflate_setup_params(struct z
 {
 	if (params->level == ZCOMP_PARAM_NOT_SET)
 		params->level = Z_DEFAULT_COMPRESSION;
-	if (params->deflate.winbits == ZCOMP_PARAM_NOT_SET)
+	if (params->deflate.winbits == ZCOMP_PARAM_NOT_SET) {
 		params->deflate.winbits = DEFLATE_DEF_WINBITS;
+	} else {
+		s32 wb = params->deflate.winbits;
+
+		if ((wb < -15 || wb > -9) && (wb < 9 || wb > 15)) {
+			pr_err("invalid deflate winbits: %d\n", wb);
+			return -EINVAL;
+		}
+	}
 
 	return 0;
 }


