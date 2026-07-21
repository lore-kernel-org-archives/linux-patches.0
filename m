Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B982EBB8D;
	Tue, 21 Jul 2026 20:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667396; cv=none; b=FTmQ4s06PrDAnerJnTDJE2lpX2buT+rCDA6MlpU6Hk2rgQsr2fPdB0aciUVuCxVS4uPweTPpROEg9WmLxbyeo/RxnWwFUHrgy9gAckHa7/ajvaIx103o5NPQZX69V7X77FPFZtShbmQWG6zbv9k6XrVdrO9B2U5y6HxmE7Rg8ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667396; c=relaxed/simple;
	bh=LPE1ZX9mMRX5fYRIBi3EStfZiGNeaTCYmCfHoK4Cs44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMNY/NZRz890ZYbaOefO99Lbr7gyoJVhrrkJphXJAn5Gppq52dopelKcZwF5dN0yMuPS1rUVzmgk6a9tUUNKEwnuDhv+X+vPGyKPCxryIFWIkV7r6JsYLTuf1Wk9OTLI38Tkf4msyDAxBzsmu3jh1zxgk8PauEE6iMgoUuNNqkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bmMh9JzE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bmMh9JzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C5D1F000E9;
	Tue, 21 Jul 2026 20:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667395;
	bh=7ipwgKSFBuPgD+Y/knXXI2gMcdLoSqX803kJAlQ+KdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bmMh9JzELqmidjKOQ9hHJvAdGrF7/vInQ+JzW2EKGX2CIi1quh6d4yBMYLbKzOyr3
	 BS1IBG3p8UhwhuhehbMgYAfdg5BAXi9FUQ+C7FWLD7KvKaTK6FmVw/JDM5fhgQW9r7
	 +V87R0Fgyt437B1znkFgCooqM2pJJoQ7ZrKpSIgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Genjian Zhang <zhanggenjian@kylinos.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 1044/1266] dm thin metadata: fix superblock refcount leak on snapshot shadow failure
Date: Tue, 21 Jul 2026 17:24:41 +0200
Message-ID: <20260721152505.180690433@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


