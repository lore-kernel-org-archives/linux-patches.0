Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705131;
	b=H30ytR1xF6oj/49kNowwcuVgziN6nl5o516Pw+UxWhJYdSXG8se32h5ilMKNVbVza0gs
	 zW5edY/LZFj+ulU5fnvXh/p849E9eTJkEoCdK6nHmENKqmLi91IR9My7Us4bVrMyRBbTH
	 4RWK434ojoHjxspKzeB0uv24yP8MGlWIlOFMUCdyp2w9bu5H3CtHHVvB6co772D1xKbQ/
	 2NT3BH8Znx9fPEt2zp6VCjnN8tXbgFymVPPDWaPtdgZteOxB2I6I98ALqhtwN8309biNx
	 29pfnZjMImGOvKYIGlO1vgJk8izu7rDSgYDbOGD2F8A1RkkqO61tHUDLSY6m7pYM6Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dBBDDUzoOdi7DujT/sHrpWN41dtLTzEFt3JK5ji8RGA=;
	b=iT1Awg6sYrCLneCwTSCgtwGqikJSS3zFYfRMsDFk2iKqWJrIXR58jj3d5KCcNvzIkCOy
	 XKQRnExs6OznWFyW6A5vRdiNgTLFgn3kWkVbuz6KcSGqgnJUaoRCAsBTjc7NbRcobVubc
	 qx7idg1kdggmRa+i4JrUgVSjQDZFFwEdskmPf0AF86uMM2xpSX7WSw1KAUlynwfqgECCP
	 IN1lWBjQlJFaMiiteDFUPJfcoZj4RxhQKK3HuixR90IljlnarrtQwE0cNzmYrvaVf3HWt
	 toGvrYwS+LdHUnAQpx61nKn9nQBsZV3KkkWyXdLHbdjlreFEP0FI+RdcrtIeONf2ECA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SKCDE0H0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDFA606A321;
	Thu, 26 Nov 2026 14:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SKCDE0H0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1F61F000C0;
	Thu, 26 Nov 2026 14:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705130;
	bh=dBBDDUzoOdi7DujT/sHrpWN41dtLTzEFt3JK5ji8RGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SKCDE0H0xjLOuygSAzcDTB0n0GGwcsiqUk0FV7jzVhzfo9IN9qFhN8tBycvoY4HeF
	 eXSaKt+lQACc0pJUnzNFyeokfS3hWGvxWG56rlt+p7fA+phb1rbZ7QS/cxQI8hjuoC
	 p6fb5Nv484/4PHemolnHnL3jRBGr4qMWOJDC8MMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/319] block: partitions: reject GPT entries with starting_lba > ending_lba
Date: Thu, 26 Nov 2026 15:37:24 +0100
Message-ID: <20261126144008.455821146@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 7e3801d12ebabaa3db6e2685ccc80b6e6f6d1ff7 ]

A GPT entry whose starting_lba is greater than its ending_lba is accepted,
and the kernel creates a partition with a bogus size. The bogus sector
count defeats the end-of-device check, so I/O through that partition is not
confined to it and can access sectors outside the partition on the same
disk.

is_pte_valid() only rejects an entry when its type is NULL or when
starting_lba or ending_lba is greater than lastlba; it never checks that
starting_lba <= ending_lba. For a reversed entry both field checks still
pass, but efi_partition() computes size = ending_lba - starting_lba + 1 in
u64, which underflows to a huge value. That value also wraps in the
end-of-device check in blk_add_partition() (from + size) and does not fit
the signed i_size, which turns negative.

Reject entries with starting_lba > ending_lba in is_pte_valid(), matching
the head-level check against last_usable_lba < first_usable_lba.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261102080442.3775061-1-wozizhi@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/partitions/efi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index c945695858387..2d98263141a35 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -461,6 +461,7 @@ static inline int
 is_pte_valid(const gpt_entry *pte, const u64 lastlba)
 {
 	if ((!efi_guidcmp(pte->partition_type_guid, NULL_GUID)) ||
+	    le64_to_cpu(pte->starting_lba) > le64_to_cpu(pte->ending_lba) ||
 	    le64_to_cpu(pte->starting_lba) > lastlba         ||
 	    le64_to_cpu(pte->ending_lba)   > lastlba)
 		return 0;
-- 
2.53.0



