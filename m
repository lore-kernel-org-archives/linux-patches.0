Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C0F47142D;
	Tue, 21 Jul 2026 20:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664598; cv=none; b=Mwp4SfRhjOVsVaspFdlpfeqVkzww7eEMjrfCpkH10CLVGpH8s8q0dEkGuSnf+kjUeTnpgFkbIrNFq69sgRP81fKFZDVGTPctOxHKQrjhyf5UvB28rebZ0aMghgIgqKpQho0Lcp2Ynm55kJtxzSNNkjy8f5RQExekuo5Wvrwda38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664598; c=relaxed/simple;
	bh=R0jY9YHuVzD4sI/t0Wcx06feW6qAtwDTbVuXOoQxldY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVNBW1ntwXzRUgb6zAG1odiP6NOVsb0sbFA2ra7za7IYaK5UpBh4zzQp7H8lLn4HCVwhhvBUp3KoqQDGSce+s5gij/ng5FL3V8QyzJD0gmgEDRq09PyjZYAQvI55+0ejK2ZKH/SDkeYVEB3aGC4zXXG+4z8KHAT7cGHpmcIjaGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJFto+Ob; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJFto+Ob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19F01F000E9;
	Tue, 21 Jul 2026 20:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664596;
	bh=kNJ5rdwtIdx57t933xn8L59Gm21BD1Lc760DPz0W9YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WJFto+ObTvRyKcEYZcNV3F9tx2QZzyzh8bqPhu/zARBqDr2235Gu5XnYgQkThwjfT
	 wp1c1RsTzNZQVey1ntbV/F9UjuxhMdYlMvi5XjUivv7QI4mAECKKsCqxTuajc8i/HC
	 0jgiwvrQSR/E6mi6mykA7mdk6MBHBTWZOuV7FJLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 1261/1276] crypto: ccp - Fix dereferencing uninitialized error pointer
Date: Tue, 21 Jul 2026 17:28:24 +0200
Message-ID: <20260721152514.310710440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashish Kalra <ashish.kalra@amd.com>

commit 0fa766726c091ff0ec7d26874f6e4724d23ecb0e upstream.

Fix below smatch warnings:
drivers/crypto/ccp/sev-dev.c:1312 __sev_platform_init_locked()
error: we previously assumed 'error' could be null

Fixes: 9770b428b1a2 ("crypto: ccp - Move dev_info/err messages for SEV/SNP init and shutdown")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202505071746.eWOx5QgC-lkp@intel.com/
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sev-dev.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1271,9 +1271,11 @@ static int __sev_platform_init_handle_in
 
 static int __sev_platform_init_locked(int *error)
 {
-	int rc, psp_ret = SEV_RET_NO_FW_CALL;
+	int rc, psp_ret, dfflush_error;
 	struct sev_device *sev;
 
+	psp_ret = dfflush_error = SEV_RET_NO_FW_CALL;
+
 	if (!psp_master || !psp_master->sev_data)
 		return -ENODEV;
 
@@ -1315,10 +1317,10 @@ static int __sev_platform_init_locked(in
 
 	/* Prepare for first SEV guest launch after INIT */
 	wbinvd_on_all_cpus();
-	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
+	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, &dfflush_error);
 	if (rc) {
 		dev_err(sev->dev, "SEV: DF_FLUSH failed %#x, rc %d\n",
-			*error, rc);
+			dfflush_error, rc);
 		return rc;
 	}
 


