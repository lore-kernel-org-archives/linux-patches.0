Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624549;
	b=PMx7NfZVkYAJrOvaTaYwxoYB8B3lx32YcMW2Xv1aArAeTaLPWTEW3jHqoOBiiUa4sJav
	 YjaiWnqR+FmWF4BtapDAg3RvBiRGLf+M+zrPtQq0NlwvgRR0ftzRCtbY1muZuvTR/szdm
	 553Azfyo7naDGf+t6L4Ah4QzEHRmO2y4QBSAtU0nrYZaNfS+cItv2b5dRApcjAeYmYi2o
	 kWtxX0uiHWUJdfnvGgUAd70ldqXHdy9HwTky11fjukI9jZuFJznYuPu8h0xwSRNZ5sMn0
	 tesQ8EM84zXDnz9ZW+4WRdb6QLgXllhLGSBmHBtt2G5jHaTA2LjHTKXy4dW+LYg8j0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+R/VNMfYOxdSpN4AGz4fu84O6fkaa6DuROxkUtlVZ6w=;
	b=uA8czdKbKSRFcF2fc9mQZS6Dt0oG9JcHUQpN7NHRGPsnhAcJFoN61NLm2pG+F/inB0Zu
	 AK3JaGawBEhvwfw9taalW95LQoMrSS/gHd9bzzNsj5nD82dHq0eC6aiX3lpxzpgsn9D1S
	 sePCUHnZoeKfjd9EXa/cyOA1HH0X01GtR9kDaxbV/XHi178Q1uCKhEFGD+De+iEE/qlOH
	 wvUI39Ks6ijITc4OIVofgmVq2tp/t+fOW9zdG6Xbd6hYWAFGCf5YQ+GvIEpgpqGt1IqY6
	 /CiBF0pg5uDmT+p+JheouAqsZRNl2vmq2N0+u2lb95Ya0unRBeXnKpwbv0IY6R4w86Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0m4gdvVG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C74606A339;
	Wed, 25 Nov 2026 16:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0m4gdvVG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B051F000CF;
	Wed, 25 Nov 2026 16:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624548;
	bh=+R/VNMfYOxdSpN4AGz4fu84O6fkaa6DuROxkUtlVZ6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0m4gdvVGbvVjN+WZwcDcOnszRClcOKBv39qnPz775qOjho0eh9VVPW4G5M/XWVtN3
	 kxpYD+jslnFQMLWHm9ITrVj+jkivYqPbCGs9HETaWv8P/DLmuJrhqVN7C80ctGPB3G
	 qgJSOG6uWwcSmYlZEXgPOYhydL9+lWftTadiAIy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 184/816] block: partitions: reject GPT entries with starting_lba > ending_lba
Date: Wed, 25 Nov 2026 15:28:52 +0100
Message-ID: <20261125143853.456653357@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7acba66eed481..d88321f6400ab 100644
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



