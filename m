Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6AC47F3A1;
	Sat, 12 Sep 2026 13:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220501; cv=none; b=V888MJHNcRv46vJeLScOnfSAEK0Qg/TDqYqYiFvZCjMAc9Rrr9eXNsf/brYpZjNvSNGVbULypcP1f5rs6DQXWK3tdxNN/BlK9DgfMap5Xrzwtx4afCvcEYf9K+9pmmMtXTCiTAzOro0GttpOJsJbX2IQdnirBm8aPFfldbbaV0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220501; c=relaxed/simple;
	bh=C3SDh27bkjCglXRj9nQR8sf8lPaELAmi2w/Uo5jDQIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3JhcJsJ41YvpM6yEYohZEzVn4XXA32GQZ4KGOMfNV9PW4ChBfWIvWTIifZtS2JnH0zI5C6fvtfjeMbAaRdCUETXucNWKVgNJJgBzdqSrysNa0Vbpzqt7tRp91MT6vQnlWxCY0xXMnNKw5ePk45hSvgnBcjt/2aDUT8Wz5ZQs8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gpR4oJI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gpR4oJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B421F000FF;
	Sat, 12 Sep 2026 13:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220500;
	bh=p8APn+1jLqv97DDcFtd55rERKQDPAQrORhszgDfQzzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0gpR4oJIvR3tWtqqqQXHGEvgBkvbbmZKnPj56XhHAVFiQRNP1wpfNsC6X50dgqb3y
	 OW8Gmyu4pHMb/qZUw+iog/UWcYVh5lON1b81noRIXmodAndGAPSNYIS5HVCyNFFUi0
	 KMdN39sQfD8YRlG7lPeZgRe0JhFDy6yrh0jSI14c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.6 0163/1424] udf: reject VAT indexes equal to the entry count
Date: Sat, 12 Sep 2026 08:43:15 +0200
Message-ID: <20260912065610.945397559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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


