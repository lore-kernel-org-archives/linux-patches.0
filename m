Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8153057EDB7;
	Wed,  9 Sep 2026 14:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963346; cv=none; b=lt0SdRAsx8LrP/g69+fTQl1ByfxdxPIF+QdZME6ClwPIoGe18ZDmVvRNBmrErNHhBRVWwtq6HvJlkbemLNAowsSAJfdr2HTbAADuF8C6dVxw6RLV4eph9fkeyR67Js31F5ChF9LJAni0/xvOc1/9mvNtxm8SksXKueu+1am+s0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963346; c=relaxed/simple;
	bh=sTmtE095mAZuHM/t1ANLEKsRGX6Xlu3TYDC6sGW34+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDiLYhAuEDT/RLGL7HkEPOZ8ZCs//1BXE4PXv2VzKg55xVc7FXbIjeKeL4sMNOCnPqywiDMgdbS8dVCjSyfGMl3QnWZjCcW/Aki/xljlwP1BY8heKMVbytTev4rweuiZSdBF4mgEMgO3NjFVrwWagOCdLdQLBgB3zuKD9EyjXuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/sFLaoo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/sFLaoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D935A1F00A3A;
	Wed,  9 Sep 2026 14:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963345;
	bh=/e4ImYnHzA8iCMv1SAc9CJPtqvnxp6HBNOxufuogfBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G/sFLaoouWThZJ9ihrGA2VGqY9uqxuta8QHX5qGD4XkwpPO0DVP0eyMCaevyECcIf
	 nCdNsLMUtxTbDwt2Ciu+5cn4K9MLyzqQ+v9+QkylAcT/ty0q2COWN+SyYeBdv2wjVN
	 nhju33VniYWZEAh5IozLzg3dVIVC0ULsI9CTHhH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 048/583] samples/damon/mtier: handle damon_start() failure
Date: Wed,  9 Sep 2026 15:35:33 +0200
Message-ID: <20260909134239.622298555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

commit c7230d08ee79b13127bd2b45a3648d361ac912fc upstream.

damon_sample_mtier_start() callers assume it will clean up resources when
it fails.  And the function does the cleanup for context buildup failures.
However, it is not doing the cleanup for damon_start() failure.

As a result, when damon_start() fails, it could leak the memory for DAMON
context.  Also, if damon_start() fails for only the second context, the
first context will indefinitely run, and avoid starting other DAMON
contexts since it is running in the exclusive mode.  Stop possibly started
DAMON context and free the contexts in case of the failure to fix the
issues.

Note that the issue can reliably be reproduced because the module calls
damon_start() in the exclusive mode.  For example,

    $ sudo damo start
    $ echo Y | sudo tee /sys/module/damon_sample_mtier/parameters/enabled
    $ sudo cat /proc/allocinfo | grep damon_new_ctx

Because the first command is running another DAMON instance, the second
command fails the damon_start() call because the new DAMON instance cannot
exclusively run.  And without this fix, by repeating the second and the
third commands above, we can show the memory consumption is only
increasing due to the leaks.  It requires the sudo permission though.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260628215447.96166-4-sj@kernel.org
Link: https://lore.kernel.org/20260608112455.274231F00893@smtp.kernel.org [1]
Fixes: 82a08bde3cf7 ("samples/damon: implement a DAMON module for memory tiering")
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/damon/mtier.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -177,6 +177,7 @@ free_out:
 static int damon_sample_mtier_start(void)
 {
 	struct damon_ctx *ctx;
+	int err;
 
 	ctx = damon_sample_mtier_build_ctx(true);
 	if (!ctx)
@@ -188,7 +189,15 @@ static int damon_sample_mtier_start(void
 		return -ENOMEM;
 	}
 	ctxs[1] = ctx;
-	return damon_start(ctxs, 2, true);
+	err = damon_start(ctxs, 2, true);
+	if (!err)
+		return 0;
+
+	if (damon_is_running(ctxs[0]))
+		damon_stop(ctxs, 1);
+	damon_destroy_ctx(ctxs[0]);
+	damon_destroy_ctx(ctxs[1]);
+	return err;
 }
 
 static void damon_sample_mtier_stop(void)


