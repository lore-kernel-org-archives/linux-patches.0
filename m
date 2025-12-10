Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C81D27B4E1;
	Wed, 10 Dec 2025 07:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352005; cv=none; b=sHZHwfwzUDG7fP/MbukhDN+5341Dzp+Ii1IuADpdTjr0tpjauLiAP+mpPH4zyWMyvtOsBpqIleFgJZCCQvzlhU5jiR3A2qiN1eSkwPAvSgLBZCOHgr9Yu11jSCMcVrIi0uJfolq72nu7W+jyv6QnpV74bZNL9AJk7NtM+4sDXq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352005; c=relaxed/simple;
	bh=e+S388PRkdtZ0W2dDSjx4KOLipXYBFDs7TrM70mgKhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=faxcIAnXXvD7GP1GkCc1i8zEM3Tpo2ayFrabCyAhSwk/gYtg3L5TTHe/8ShjRsecilr5PjllYiqPwdz0ruF9AHVi5nwSrqOlIYiOuIEN1aBP2dOq5sD4RSBmkcOtWBID28tinaK6PPJll4AocCHH/OGrnlU/0EVbYlb++taz+JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRfKTZwc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRfKTZwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42953C4CEF1;
	Wed, 10 Dec 2025 07:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352004;
	bh=e+S388PRkdtZ0W2dDSjx4KOLipXYBFDs7TrM70mgKhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RRfKTZwcw7XXnol3yfFpkbPZldbvjQoBFeBDXGhZ4BzpRBwLFIcqVV18uu2RNqgBg
	 LwBiNuJBw1ndTiRC+M6vFwGLP7phiD9mkaVYJ4SbEOO/u19qbgt/uw82RefRFq3rJy
	 8/u2p9oQQ6gQ1BN9+dAWH9aX3sBe5333AtKUDGlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.17 06/60] crypto: zstd - fix double-free in per-CPU stream cleanup
Date: Wed, 10 Dec 2025 16:29:36 +0900
Message-ID: <20251210072948.004709340@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

commit 48bc9da3c97c15f1ea24934bcb3b736acd30163d upstream.

The crypto/zstd module has a double-free bug that occurs when multiple
tfms are allocated and freed.

The issue happens because zstd_streams (per-CPU contexts) are freed in
zstd_exit() during every tfm destruction, rather than being managed at
the module level.  When multiple tfms exist, each tfm exit attempts to
free the same shared per-CPU streams, resulting in a double-free.

This leads to a stack trace similar to:

  BUG: Bad page state in process kworker/u16:1  pfn:106fd93
  page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x106fd93
  flags: 0x17ffffc0000000(node=0|zone=2|lastcpupid=0x1fffff)
  page_type: 0xffffffff()
  raw: 0017ffffc0000000 dead000000000100 dead000000000122 0000000000000000
  raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
  page dumped because: nonzero entire_mapcount
  Modules linked in: ...
  CPU: 3 UID: 0 PID: 2506 Comm: kworker/u16:1 Kdump: loaded Tainted: G    B
  Hardware name: ...
  Workqueue: btrfs-delalloc btrfs_work_helper
  Call Trace:
   <TASK>
   dump_stack_lvl+0x5d/0x80
   bad_page+0x71/0xd0
   free_unref_page_prepare+0x24e/0x490
   free_unref_page+0x60/0x170
   crypto_acomp_free_streams+0x5d/0xc0
   crypto_acomp_exit_tfm+0x23/0x50
   crypto_destroy_tfm+0x60/0xc0
   ...

Change the lifecycle management of zstd_streams to free the streams only
once during module cleanup.

Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")
Cc: stable@vger.kernel.org
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/zstd.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/crypto/zstd.c b/crypto/zstd.c
index dc5b36141ff8..cbbd0413751a 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -75,11 +75,6 @@ static int zstd_init(struct crypto_acomp *acomp_tfm)
 	return ret;
 }
 
-static void zstd_exit(struct crypto_acomp *acomp_tfm)
-{
-	crypto_acomp_free_streams(&zstd_streams);
-}
-
 static int zstd_compress_one(struct acomp_req *req, struct zstd_ctx *ctx,
 			     const void *src, void *dst, unsigned int *dlen)
 {
@@ -297,7 +292,6 @@ static struct acomp_alg zstd_acomp = {
 		.cra_module = THIS_MODULE,
 	},
 	.init = zstd_init,
-	.exit = zstd_exit,
 	.compress = zstd_compress,
 	.decompress = zstd_decompress,
 };
@@ -310,6 +304,7 @@ static int __init zstd_mod_init(void)
 static void __exit zstd_mod_fini(void)
 {
 	crypto_unregister_acomp(&zstd_acomp);
+	crypto_acomp_free_streams(&zstd_streams);
 }
 
 module_init(zstd_mod_init);
-- 
2.52.0



