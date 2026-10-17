Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48013A59A3;
	Sat, 17 Oct 2026 16:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253619; cv=none; b=NiLIAVvNxD9ao+HUWzglSdr08jmWDYVJjjwnoTHaek1qJ+x7cZXD26X2RE7rvykW8dC/vBiobyZpQ/v0M1qRJwF9CBvvo9t1HI8+JPmyjlZwY7Us8kTVK67Lq4bvFAifJQ3oslSO2jcGDHty0as4Etb1Hp9b71np/6XC3S9bQrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253619; c=relaxed/simple;
	bh=sN3R4TkGU2BckZ7dZwKyVk4icJMf8sUCVelc751Esjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G84HTciBfOJgaPKz2Xi2/1RBkW1ZOf6RPjkSCBVzmOZ6RUTUhkuSeG1BTAWwVmY9lUIGja0GDvXrUqAnaLF5mivXeZvocDs8mej45pkVxIk+Bi5leCvlpMDqLFu7zMCowZsrGq9yYn6eg1im67uOLnKuVS3TSXG6HFiYW8G2Ym8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XaTftjxq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XaTftjxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97CC1F000C5;
	Sat, 17 Oct 2026 16:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253613;
	bh=+V7oVmZuwGapsgA8wWCOFlUdKvdVbI8G334kOKQrsY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XaTftjxqZZpuk0FeSemggWUtiQGTC30FYOa3P5razrD2lH3DqABRxXieXWqUaoLGI
	 MzgjQurILMM/KiStLJlGOzQMcLKsDnen4Lmxpq5xoiwIBvvRAf/o4dHj9kb3tAqotq
	 gGcAoCS1m3nYfQ42w4/pdl4R3qa2Tw6oVYEROAkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 176/869] block: zero non-PI portion of auto integrity buffer
Date: Sat, 17 Oct 2026 17:50:17 +0200
Message-ID: <20261017160041.565356880@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit ca22c566b89164f6e670af56ecc45f47ef3df819 ]

The auto-generated integrity buffer for writes needs to be fully
initialized before being passed to the underlying block device,
otherwise the uninitialized memory can be read back by userspace or
anyone with physical access to the storage device. If protection
information is generated, that portion of the integrity buffer is
already initialized. The integrity data is also zeroed if PI generation
is disabled via sysfs or the PI tuple size is 0. However, this misses
the case where PI is generated and the PI tuple size is nonzero, but the
metadata size is larger than the PI tuple. In this case, the remainder
("opaque") of the metadata is left uninitialized.
Generalize the BLK_INTEGRITY_CSUM_NONE check to cover any case when the
metadata is larger than just the PI tuple.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: c546d6f43833 ("block: only zero non-PI metadata tuples in bio_integrity_prep")
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 04bab987b0878..c6721b95d0348 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -12,6 +12,7 @@
 #include <linux/bio.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
+#include <linux/t10-pi.h>
 #include "blk.h"
 
 static struct kmem_cache *bip_slab;
@@ -428,7 +429,10 @@ bool bio_integrity_prep(struct bio *bio)
 		 * memory to disk for non-integrity metadata where nothing else
 		 * initializes the memory.
 		 */
-		if (bi->csum_type == BLK_INTEGRITY_CSUM_NONE)
+		if (bi->csum_type == BLK_INTEGRITY_CSUM_NONE ||
+		    bi->tuple_size > (bi->csum_type == BLK_INTEGRITY_CSUM_CRC64 ?
+				      sizeof(struct crc64_pi_tuple) :
+				      sizeof(struct t10_pi_tuple)))
 			gfp |= __GFP_ZERO;
 		break;
 	default:
-- 
2.53.0



