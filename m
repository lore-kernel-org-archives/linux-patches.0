Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A1613B2A2;
	Tue, 27 Feb 2024 13:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040958; cv=none; b=IqHZMADNY9NE6xdDBIEBvL74RXeqREKIgbaA3tguM5OL+7CTQsVFIzPQOOqHNCuV+nMRE4gfkm5/HZ6aVdgGrLGl42ZHh2/c2IGoeX25Kz2/rxYce7XWcjrCIoY9hoBrpXdAMTYvg/hc9LJ4ZOdS48WemMQM3b7q5ccc0dcc7H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040958; c=relaxed/simple;
	bh=snM10prcJ9J23b+hUKye1Upumjxf6XpV5MDISzB2GBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zw7Ys+yhVrYL2nQsMOcg1/FSyN+4KU+FpH3Do2+AxlrGR0L57VEsGpQwzHKTj4ypRk1TMPkoABpKg/jZOrv40EMPvKCD1qQ7Rygxr7V9q/OaMMBE2224VoaV2y7LYbOGHQ8n72sGBT4bV6V1lhfg8lXFFa4IkUDKLHrEgAqYndQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kv1cdjtN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kv1cdjtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2817FC433C7;
	Tue, 27 Feb 2024 13:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040958;
	bh=snM10prcJ9J23b+hUKye1Upumjxf6XpV5MDISzB2GBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kv1cdjtN19drhHfi2YIjt/tnm/Y4ifa/XoZWZMQ+M+HMcvt0OpsqOTQaxg/GO70dp
	 UvP5jqBh9RCoMfrY2TR+kl1oAoIfaBXW0bbP/bBUaLQlbWeKfDfkeaYeFM3W9Xsr95
	 2KrC3ZGIkNAN5M5QfKve8b/XmEl2ZNE/2ykfqK+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.7 168/334] scsi: target: pscsi: Fix bio_put() for error case
Date: Tue, 27 Feb 2024 14:20:26 +0100
Message-ID: <20240227131635.948414961@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -907,12 +907,15 @@ new_bio:
 
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


