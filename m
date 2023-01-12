Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D5479C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C54C433EF;
	Thu, 12 Jan 2023 14:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533996;
	bh=Z27P/gi6NT29AN0woT3zGMsVpl9qRzHvmp/2G3ngZVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9YvIwXkVqPYTsMQPMfEC2Jgj3ZbjNuAqYVUY9iwevyQB1Lv5/N09UTsLGHv9Tatu
	 ehbplIbwYvSBzGRuVHkxbS09BaWDke+VEatbIpmZ28StJAfdv1H2ZNVSLm1fyq7Suk
	 K6mfl2qYhIRwgyVkv2i4tynnNWogJa4tGLcsd1pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.10 633/783] dm cache: set needs_check flag after aborting metadata
Date: Thu, 12 Jan 2023 14:55:49 +0100
Message-Id: <20230112135553.656882321@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Snitzer <snitzer@kernel.org>

commit 6b9973861cb2e96dcd0bb0f1baddc5c034207c5c upstream.

Otherwise the commit that will be aborted will be associated with the
metadata objects that will be torn down.  Must write needs_check flag
to metadata with a reset block manager.

Found through code-inspection (and compared against dm-thin.c).

Cc: stable@vger.kernel.org
Fixes: 028ae9f76f29 ("dm cache: add fail io mode and needs_check flag")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-target.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -985,16 +985,16 @@ static void abort_transaction(struct cac
 	if (get_cache_mode(cache) >= CM_READ_ONLY)
 		return;
 
-	if (dm_cache_metadata_set_needs_check(cache->cmd)) {
-		DMERR("%s: failed to set 'needs_check' flag in metadata", dev_name);
-		set_cache_mode(cache, CM_FAIL);
-	}
-
 	DMERR_LIMIT("%s: aborting current metadata transaction", dev_name);
 	if (dm_cache_metadata_abort(cache->cmd)) {
 		DMERR("%s: failed to abort metadata transaction", dev_name);
 		set_cache_mode(cache, CM_FAIL);
 	}
+
+	if (dm_cache_metadata_set_needs_check(cache->cmd)) {
+		DMERR("%s: failed to set 'needs_check' flag in metadata", dev_name);
+		set_cache_mode(cache, CM_FAIL);
+	}
 }
 
 static void metadata_operation_failed(struct cache *cache, const char *op, int r)


