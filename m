Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577501386CB;
	Tue, 27 Feb 2024 14:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043401; cv=none; b=EzMCon40dSIJYM9Z0gTB5ouqi0ekch18zWLyTU2vl8VEwC+BjxMAjgw9oxgUYyNFAF9O4zH7VHjQ614LYh+bVDzhO+7eG7+yVI/KPZO7/6Q6mv4HZQCUuAs3N7gW0E/gQPKROiD8HGUv99W/i71b5cGmTlmzwMRidsW8b7jbqmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043401; c=relaxed/simple;
	bh=CAb4yWSPlP3MFnS3ypSsQELrPENJZMjFu1hKiKb2rxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GeC97CICsy6kbiL8BlKaurqiWODvImp5iQi5U5aWNt/7rtL5kJQNoindvT4nROFXPEZgKtf5STl5hNc5MnpB9nV68/MOH6Qy6A9oaU8/RRZ3GtMJoZkdlwM/tyv7NDiRiE7w2oTvR2+PPTECcVAWhTCPYzxBZLse5gMCEpHTgLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6kWjfyR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6kWjfyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB0CC433F1;
	Tue, 27 Feb 2024 14:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043401;
	bh=CAb4yWSPlP3MFnS3ypSsQELrPENJZMjFu1hKiKb2rxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6kWjfyRGxuollts+v2SHY9EKDePhtfhU18c614ZhHvEU+ApBLaLl+J6tyOsLk7Ro
	 xmd8z+I2tKFye4Gsqw4eefUwZSZADDdg1WCdUTRj6ao/lKdD97gnsyIOAZLqSxKcMK
	 7emW3RCJMyUz4kSh+/R8wFmRRts6LkkCtzIyRPIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 094/195] scsi: target: pscsi: Fix bio_put() for error case
Date: Tue, 27 Feb 2024 14:25:55 +0100
Message-ID: <20240227131613.581282754@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

commit de959094eb2197636f7c803af0943cb9d3b35804 upstream.

As of commit 066ff571011d ("block: turn bio_kmalloc into a simple kmalloc
wrapper"), a bio allocated by bio_kmalloc() must be freed by bio_uninit()
and kfree(). That is not done properly for the error case, hitting WARN and
NULL pointer dereference in bio_free().

Fixes: 066ff571011d ("block: turn bio_kmalloc into a simple kmalloc wrapper")
CC: stable@vger.kernel.org # 6.1+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Link: https://lore.kernel.org/r/20240214144356.101814-1-naohiro.aota@wdc.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_pscsi.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -910,12 +910,15 @@ new_bio:
 
 	return 0;
 fail:
-	if (bio)
-		bio_put(bio);
+	if (bio) {
+		bio_uninit(bio);
+		kfree(bio);
+	}
 	while (req->bio) {
 		bio = req->bio;
 		req->bio = bio->bi_next;
-		bio_put(bio);
+		bio_uninit(bio);
+		kfree(bio);
 	}
 	req->biotail = NULL;
 	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;


