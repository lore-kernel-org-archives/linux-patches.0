Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655B03B2FE4;
	Fri,  4 Sep 2026 05:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498636; cv=none; b=u9KqjerEiTK+jdXcZlkI7Xj1zkxVb71fDnxhtkyVM00Ub+EvFTiuUw5+TqAYYJ1cu9NatM6KlXaNDwXk5Ry4frFCkFiokbHRrSM41JBjstumeueD7yZi7bpPQTYxqpO3VtyRMkx1BfSJwRJOqiy74PL3cpYx55sPkM0mRBhwEGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498636; c=relaxed/simple;
	bh=WrLdK6ogOuBvYjir/0bHspf4/7oOkDBPMOkNc/XgT3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2TK/Vib1eCcQ9HD1cpL66kN/26D2OScf8LwCho8xfqnz9W37IIauSsbcnS0Yc0Nu7MeC2fpt/TUeuCSycJMLtsUYEBvVojrq55lmJAnyHmUQ7Ssjf72VuIiKaY5H2bnYfmNTcUXlLZfrFp7jgywSCIzkNV7S2sDkcchgdU8f74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NU1u4bPL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NU1u4bPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDE31F00A3E;
	Fri,  4 Sep 2026 05:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498635;
	bh=4xI2abJs8B8KFyJqy2O1LM2JDNtdNRbFT5F/6aW2FcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NU1u4bPLTNMDWEHFs096e192DZzFpcgYe7E2GC6CinEEkwXWHalgeR2UTlFx5w2HN
	 0FrrfTKYX6D2qo5eMl1Nc/ZFdYtJaNn31QCngvXzCr3Mh1zBq4OXEeydtT562MzTu2
	 k/6odHJ+6pyLd2imOJJPpzCLoj1wyTInf9FHw46k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Haoqin Huang <haoqinhuang7@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 134/713] zram: validate deflate params
Date: Fri,  4 Sep 2026 06:51:42 +0200
Message-ID: <20260904045806.835189891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


