Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A741352029;
	Tue, 21 Jul 2026 21:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670297; cv=none; b=BzTHy7j355UEy2518OPng1Om/FG9A3h7AOWSlNzwE0vt2pePiHT5HlalfPfaFM3ki7tD4x95DHN5167rw6ROePeJTvNXi1v9lCQh5OsMol2Rz4BGeikDnKfU0eui2Ezd0TTapwNK7ZWonuoBE5qMbL/06SZxenXj31N/MQMuZtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670297; c=relaxed/simple;
	bh=tsTVanV6eMeAMathr0RDmqLZyOX0a5MURuG8yE51WsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UwfT4eLXqJa+0yy2Y7VhRgyon3IzcSY2gA5luKqG0+NRHwdHW3P6Yjod5oSr4HcD2/iA4UIBRgQfhxavAYxv/AhoVQqZLvdkn4YmUGhHVev+giAPyE55pFDdhNkZEWR45xzFU8OsZjIgd6zknFlmUTcSCBSMlLWohBx6ReOBpGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGOkjHX0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGOkjHX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCA81F000E9;
	Tue, 21 Jul 2026 21:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670296;
	bh=YxAjJO6/TCpdd6eC4S9s42aT6gxmtaESRqAYN+zdj5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cGOkjHX0JGt0iv4EvbOP/ol2sZo8xx3ym4wSRnavkgq4VFo4wzn+yo53w6ey9T4OY
	 vLjBCyxLb11JMBh/t9UEBay6DGComV/AuRkN+1UWyF+6qy7W2qma5pUzeZRxmai1c6
	 f+jeKp5lFm+Sbg/MnPEox6pEWriEvTsY2H6UE50I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Genjian Zhang <zhanggenjian@kylinos.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 0842/1067] dm thin metadata: fix superblock refcount leak on snapshot shadow failure
Date: Tue, 21 Jul 2026 17:24:03 +0200
Message-ID: <20260721152443.386408917@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1347,8 +1347,10 @@ static int __reserve_metadata_snap(struc
 	dm_sm_inc_block(pmd->metadata_sm, THIN_SUPERBLOCK_LOCATION);
 	r = dm_tm_shadow_block(pmd->tm, THIN_SUPERBLOCK_LOCATION,
 			       &sb_validator, &copy, &inc);
-	if (r)
+	if (r) {
+		dm_sm_dec_block(pmd->metadata_sm, THIN_SUPERBLOCK_LOCATION);
 		return r;
+	}
 
 	BUG_ON(!inc);
 


