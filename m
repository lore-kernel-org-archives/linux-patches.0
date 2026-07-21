Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EF1470135;
	Tue, 21 Jul 2026 19:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663912; cv=none; b=f9Z8RER0TOKmqP+HNaw+DCFPscwdNLXJvwh2AtvxsFtrkOIZRSfVwnA5vYwjmQ1Am6Ezgjgf4ZzOd11cUkgVk9xFmrLZvqX4+bKHBwOUqQPy7K+97QUCfAgu3M2iKtnq94VkRJNzTIfbpBu7Dq1DpYqTeLDWdiTenoI6FyaGmws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663912; c=relaxed/simple;
	bh=bKkqxeyo4EoXmqCvyXPXBDDW3Q85+C493MrceEMLTRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W54SAKyA6L8IeRakpD7ZhkDSbpea5tyQ97/GEpY2/TmqcCqh5tYUOdNC2FUWO++QybrqLk84hfktB3BJOy5zybWFytYEeH44kQ44uta0+WCIqa5Q7Czo4bhek1NVYkotD1ybOqr+DXFfbd5Ef17qqFSWIq/8qWlsC91N6Iv5F6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cboLwuel; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cboLwuel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614061F00A3A;
	Tue, 21 Jul 2026 19:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663908;
	bh=1YVwV2/738rdvV2Yu+AtpQYIOwK1hvFmm5nXtQyosV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cboLwuelbD0tP7PpNv53XHUJcBrzxPm22aLNMtPh7zZrAtxgsQZ5aHatY9k1s7F5n
	 gMgqebdi793F2NvBLIUiEZ8NZSnCG2rUi4Ct1eBSNayviABs9YXKAAHQwSXijhb86n
	 gIq71gdZzZdQLJUWU5Kzflrfa/eEKojg6uI2wsNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Genjian Zhang <zhanggenjian@kylinos.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 1000/1276] dm thin metadata: fix superblock refcount leak on snapshot shadow failure
Date: Tue, 21 Jul 2026 17:24:03 +0200
Message-ID: <20260721152508.389996330@linuxfoundation.org>
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

From: Genjian Zhang <zhanggenjian@kylinos.cn>

commit 4b22d0801fadfcae2e106e6ba32e49439c7c7ebf upstream.

__reserve_metadata_snap() increments THIN_SUPERBLOCK_LOCATION in the
metadata space map before shadowing it. When dm_tm_shadow_block()
fails, a reference is leaked in the metadata space map.

Fix by adding the missing dm_sm_dec_block().

Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: cc8394d86f04 ("dm thin: provide userspace access to pool metadata")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin-metadata.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1353,8 +1353,10 @@ static int __reserve_metadata_snap(struc
 	dm_sm_inc_block(pmd->metadata_sm, THIN_SUPERBLOCK_LOCATION);
 	r = dm_tm_shadow_block(pmd->tm, THIN_SUPERBLOCK_LOCATION,
 			       &sb_validator, &copy, &inc);
-	if (r)
+	if (r) {
+		dm_sm_dec_block(pmd->metadata_sm, THIN_SUPERBLOCK_LOCATION);
 		return r;
+	}
 
 	BUG_ON(!inc);
 


