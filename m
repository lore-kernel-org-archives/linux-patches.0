Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D64470111;
	Tue, 21 Jul 2026 19:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663923; cv=none; b=SgE87IYrAgJAgnd6ZPV0/h33O2PVEFC+QOPRZIrFWtLZf3j0EkW5088GmfjUVyTinsjYOLeNeLPoipz1j8gSUXNGurG3oK8qV42thBLPwN9bPb1SP/LiP/SOwRh3go8isXs7R5j7GRaQXyT4nTx2CgQ2fhI9RHjKG+Mx/7CUnBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663923; c=relaxed/simple;
	bh=R2rHxRNrRQYEU/f8w5hwRsuXvARQjwk/OJYSEP7y0AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbQQWSJ6C7WxE2LPb/yC/Owp3Pi9O2jER4SBLKLjMWyk5aECxXpNRMf39qlXxympyDacDghX+jm8z/iJk9H36KXAHOx3QihHyFGdZRscrT/y9QiqQBNlJf/vlGIt9HoG1fS0jB2DIyEsdUyXEZvtIbi2c15w6+ghk7B7itqhlRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0fmZflu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0fmZflu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886041F000E9;
	Tue, 21 Jul 2026 19:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663922;
	bh=Vxgl61HcGBWkxGk5wBnpXsS/n6lq/UIbN3Yzlr89nXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W0fmZflumc7w+bxfjSInCl3DCpikKduuR84k1n77YJv9Pz+Bv2EDSlzVGBCGpUExP
	 O86A/wDJUibUbR5TwHJWJDBuxeVLAn6NOnYGd2Jl9r5mW2AqfEfchGnRAUU36cl0HM
	 YwBdwRSyuEsW+1NjclDZbm8Q/FoMrNezKemnpBJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 1005/1276] dm-log: fix a bitset_size overflow on 32bit machines
Date: Tue, 21 Jul 2026 17:24:08 +0200
Message-ID: <20260721152508.500329256@linuxfoundation.org>
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

From: Benjamin Marzinski <bmarzins@redhat.com>

commit 9743132a41f4d9d0e54c5f2adcb821b04796bab1 upstream.

Commit c20e36b7631d ("dm log: fix out-of-bounds write due to
region_count overflow") made sure that region_count could fit in an
unsigned int. But the bitmap memory isn't allocated based on
region_count. It uses bitset_size (a size_t variable). The first step of
calculating bitset_size is to set it to region_count, rounded up to a
multiple of BITS_PER_LONG. If region_size is less than BITS_PER_LONG
smaller than UINT_MAX, it will get rounded up to 2^32. On a 32bit
architecture, this will make bitset_size wrap around to 0 and fail,
despite region_count being valid.

Since bitset_size gets divided by 8, it can hold any valid region_count.
It just needs a special case to handle the rollover. If it is 0, the
value rolled over, and bitset size should be set to the number of bytes
needed to hold 2^32 bits.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: c20e36b7631d ("dm log: fix out-of-bounds write due to region_count overflow")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-log.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -425,6 +425,9 @@ static int create_log_context(struct dm_
 	 */
 	bitset_size = dm_round_up(region_count, BITS_PER_LONG);
 	bitset_size >>= BYTE_SHIFT;
+	/* Handle dm_round_up rollover on 32-bit systems */
+	if (!bitset_size)
+		bitset_size = 1UL << (BITS_PER_LONG - BYTE_SHIFT);
 
 	lc->bitset_uint32_count = bitset_size / sizeof(*lc->clean_bits);
 


