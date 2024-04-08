Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394A67E57F;
	Mon,  8 Apr 2024 13:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582232; cv=none; b=M3LG2QR/apOgTueUv/1DOhZWsEnZv0eK7UaMB08w+7T9Vv5C1g9KpXfWXAM6fRF7y6FhOr5F66DzCjgfxTo13UEXQXgsxJAvxdIwqyXTI3RBmEdSU4M59z+aH9hC1Iq2wlrCN08rvoTW+1L7kKpaH2SCjudOE59BSJxmbqlyKnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582232; c=relaxed/simple;
	bh=ET198wi5LGRCXZUxme0+u6qoA7OWQc0TP5gtEw1DO5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HH8LxnbmWeS55oCuy0Kshh9DstxTnRrstFZwlukkDiIGcvpt0APXXvjMpbzkY8BodsivPsIfeL2sU7nC2oX2bql9336QbsFym+MM6AVElaWD5fFKLzW4TEeacz12Siyw+mhmPz/J51+7/seqAOugk1LospFsnUm0bpHaJWwdBjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tyd23kqQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tyd23kqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FD0C43399;
	Mon,  8 Apr 2024 13:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582232;
	bh=ET198wi5LGRCXZUxme0+u6qoA7OWQc0TP5gtEw1DO5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tyd23kqQysW2/IFffmEKwyxxN+2VNB98CM/aCf7mk2cjZGtuAthKHjwQIixeLkRPV
	 40dZPbj9ImLPcsnrI/I7i+oDgVYd8jcg+WT0FzyQtvL2KRmnqvcbeX/U2kRkNuU1j/
	 O+k2tnJX1H4Afm2e9OWkTvCMvMw04X2l0zj3G7kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Justin Stitt <justinstitt@google.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 058/273] dm integrity: fix out-of-range warning
Date: Mon,  8 Apr 2024 14:55:33 +0200
Message-ID: <20240408125311.102274108@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 8e91c2342351e0f5ef6c0a704384a7f6fc70c3b2 ]

Depending on the value of CONFIG_HZ, clang complains about a pointless
comparison:

drivers/md/dm-integrity.c:4085:12: error: result of comparison of
                        constant 42949672950 with expression of type
                        'unsigned int' is always false
                        [-Werror,-Wtautological-constant-out-of-range-compare]
                        if (val >= (uint64_t)UINT_MAX * 1000 / HZ) {

As the check remains useful for other configurations, shut up the
warning by adding a second type cast to uint64_t.

Fixes: 468dfca38b1a ("dm integrity: add a bitmap mode")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 47cf1ab34941f..3b4218a2e750d 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4221,7 +4221,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 		} else if (sscanf(opt_string, "sectors_per_bit:%llu%c", &llval, &dummy) == 1) {
 			log2_sectors_per_bitmap_bit = !llval ? 0 : __ilog2_u64(llval);
 		} else if (sscanf(opt_string, "bitmap_flush_interval:%u%c", &val, &dummy) == 1) {
-			if (val >= (uint64_t)UINT_MAX * 1000 / HZ) {
+			if ((uint64_t)val >= (uint64_t)UINT_MAX * 1000 / HZ) {
 				r = -EINVAL;
 				ti->error = "Invalid bitmap_flush_interval argument";
 				goto bad;
-- 
2.43.0



