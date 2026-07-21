Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09FB473C6C;
	Tue, 21 Jul 2026 22:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672508; cv=none; b=H/niuUfYnxO1edCtTJI+D40+OjoX/Rggq7kqxxmhF2V2wTOIpfERkTlFFCYFRAilJv0yMXAzlF+LIudVcws89REAYpZz2LAsa5zgzkRosZR7MbRnIEpKqrkuJb8asH+phTLsYQEWISwUsliJdYtPdTd2e8YCNEYlejo1S3prxxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672508; c=relaxed/simple;
	bh=mfcCFpTAg0zgLCV2hYVNxjZgHGie2Dq78TNOSxuOV2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMqO+0nevrsRAqdCSdA0a4jHIsz/dbnRZiETMZNNhSEpnE1SjatD9jWWnWOnvGEUm1CD436RfOSlzGo/7XviNG2tAQnYulIOin9FCz+Rze6ZaqYjdScbd3cxFcfWnmfv4j80WNLPOWY2804ULGu4n9alVsj3W3KfFsWoCmEqyAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yvssuj2m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yvssuj2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219F51F000E9;
	Tue, 21 Jul 2026 22:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672507;
	bh=Fq2F0PCHm/QhsIDZ3EuHjfnWVXqbMfNAGJYS5e74JrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yvssuj2mJTvEWGFRtuwhyXndeinHaMgTJJka7JbooUkPC2kW6092pXYmONCAooxkd
	 S6ix1Lstax5ra/Y+3jpCXP999xDmqD8mqtYUWiIfiSqdI0H/4muARkuFxbcqDoysKY
	 JBWDPmAs7kBWT5OQm5BPoGVaDnicbdJ9EUlNP4G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Genjian Zhang <zhanggenjian@kylinos.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 651/843] dm thin metadata: fix superblock refcount leak on snapshot shadow failure
Date: Tue, 21 Jul 2026 17:24:46 +0200
Message-ID: <20260721152420.713027173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1331,8 +1331,10 @@ static int __reserve_metadata_snap(struc
 	dm_sm_inc_block(pmd->metadata_sm, THIN_SUPERBLOCK_LOCATION);
 	r = dm_tm_shadow_block(pmd->tm, THIN_SUPERBLOCK_LOCATION,
 			       &sb_validator, &copy, &inc);
-	if (r)
+	if (r) {
+		dm_sm_dec_block(pmd->metadata_sm, THIN_SUPERBLOCK_LOCATION);
 		return r;
+	}
 
 	BUG_ON(!inc);
 


