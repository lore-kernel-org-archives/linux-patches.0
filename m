Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BB978C9C;
	Sat, 12 Sep 2026 19:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241361; cv=none; b=IkGlcAFw33ySoLsJI5stGj4UkijZktu3LTPTYWEyyvhmiLFui2quvMFjnKPX04bt6Cmf6Rg5cqShfHOJ8HG7RQRyg4qZo/mOrfZUyRVvxZmM15C8v4RgoCqo5ovp3RmamYrDN4Tc0l3zqW7ytDBIcDTjKsHBQj5B8EQ8B8KejpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241361; c=relaxed/simple;
	bh=YR4h4Fzbbj2KnRH6bU4ua85U4GW7kgHPFFQC3Zsy2aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAOrq1AJQNjD3o67Ift3igmRYWHBaHBXj1FK1qhqWxRW7l5Wk5C4WiJk+J0X8SZFzeUNHgktRmicYO7IlI8yq9YMaB5i1+pQfbTbW8mGgK5vyXiF9ortoCxf6jsQ5BA49otdSNUHB0bYXH8Yuyj1nTR8Z1TIbualMr20Fdo7nn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HObKVF31; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HObKVF31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11AFD1F000FF;
	Sat, 12 Sep 2026 19:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241359;
	bh=y9OaVqLF56jbL4eDdq0526R2iH+2Nvs98PFZCwEBYEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HObKVF31ztQRZ+GPRrg6VClllM6GiyM46O8En8iDsJJLRbtUTp36eIR7VerC+5/e4
	 qB5IGRdWpr0rBNiSr/9a27xwR997aV4eG2QRsG8yAG2I2r2YrdizKsRwnLLNAWpE1e
	 usBgN76I45L1HBTGWg61vMmnESlGmyJYa6kGPKGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5.10 103/798] udf: reject VAT indexes equal to the entry count
Date: Sat, 12 Sep 2026 08:55:31 +0200
Message-ID: <20260912065519.316160237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lee <david.lee@trailofbits.com>

commit cac0cb07f29ccfb373fd4a36c81e908ef3ce608c upstream.

UDF 1.50 virtual partition mapping uses the VAT as an array of physical
block mappings. s_num_entries stores the number of entries in that array,
not the highest valid index. The valid VAT indexes are therefore below
s_num_entries.

udf_get_pblock_virt15() currently rejects only indexes greater than
s_num_entries. A crafted image can request index s_num_entries, pass the
bounds check, and make the kernel read one entry past the allocated VAT table.

Change the check to reject block >= s_num_entries, so the count is handled as
an exclusive upper bound.

A crafted UDF image reproduced this on origin/master commit
0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53 with a KASAN slab-out-of-bounds
report in udf_get_pblock_virt15().

Trail of Bits has a reproducer that triggers kernel panic demonstrating the bug, and can share it if needed.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: David Lee <david.lee@trailofbits.com>
Assisted-by: Codex:gpt-5.5
Link: https://patch.msgid.link/20260708101712.1706564-1-david.lee@trailofbits.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/partition.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/udf/partition.c
+++ b/fs/udf/partition.c
@@ -58,7 +58,7 @@ uint32_t udf_get_pblock_virt15(struct su
 	map = &sbi->s_partmaps[partition];
 	vdata = &map->s_type_specific.s_virtual;
 
-	if (block > vdata->s_num_entries) {
+	if (block >= vdata->s_num_entries) {
 		udf_debug("Trying to access block beyond end of VAT (%u max %u)\n",
 			  block, vdata->s_num_entries);
 		return 0xFFFFFFFF;


