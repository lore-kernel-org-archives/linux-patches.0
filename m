Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2194034EF15;
	Fri,  4 Sep 2026 05:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499413; cv=none; b=a/5fmxhtYzuL0412Yttty/sNWu2ag/8bsCPZEPjvAki+kG2U+abRNpgIoQtcJKVIRZjW4Xhd8jazxYmxvqRwE0gsrB4zkuzHLLBErrARCxcrG1A5MyJ22lhzilC06XmswKt2h0/kJ6UcAowKGB85hTciAHkDEjfQ3Nrv25MSlj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499413; c=relaxed/simple;
	bh=Y4dXVFYW7dKJy5ybEUS3EtP6TrtfB1s0LDVpy/bsHpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtonHlelamw2BmmXfD3KNEYHsSci4mNWsT5M40uBETGamLZlONlCaNe1gQZU2R9+4GjJBkcxBpnj3eQszha9QL4mWm+vF1rYHMGIItwn6/7yCkuG/8mMrhBZ+SlK8E1BMAzVubiyEtY8K/kBzyJ46fa+4xjxzWb2DaKFwroVBTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9Yje1Sb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9Yje1Sb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A89C1F00A3D;
	Fri,  4 Sep 2026 05:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499412;
	bh=VfXfkUJdSHxN8rPewixOk5ErEQ5Xk3y22KBPZeyVwHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k9Yje1SbzppOgaaE2V1bzTEZmuzFpLpbQvShTn0FVopWMXw2+Iaf7dbwPMjKs721g
	 dZ0YNz4vFWKajx+NP0QGasiiKQy5zikS1yWGI7IDsF/4vWeOLIEHxLq8LWykcL5yfJ
	 mmluEI/TVtTYXepgQ9xVU8taQSQBjTCwuj8aEdBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 7.2 401/713] udf: reject VAT indexes equal to the entry count
Date: Fri,  4 Sep 2026 06:56:09 +0200
Message-ID: <20260904045812.813887656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -55,7 +55,7 @@ uint32_t udf_get_pblock_virt15(struct su
 	map = &sbi->s_partmaps[partition];
 	vdata = &map->s_type_specific.s_virtual;
 
-	if (block > vdata->s_num_entries) {
+	if (block >= vdata->s_num_entries) {
 		udf_debug("Trying to access block beyond end of VAT (%u max %u)\n",
 			  block, vdata->s_num_entries);
 		return 0xFFFFFFFF;


