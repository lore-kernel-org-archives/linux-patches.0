Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC20114A086;
	Thu, 11 Apr 2024 10:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832088; cv=none; b=W6ZCyILNLf9j+ddOE7/iHpnwJhG9OItcfYgAvF+RCZ5MNqAAs0DtnqNWXLokeedG5o1mh7iQdcFyCByf+EvKNN2eV9hoA2amxVkyAIJf4jCUBuou2t8jmegqvu6U11VkjhqQJhLsnOGra73QnurnLJIBW2t6jB4+i3+sSrwraXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832088; c=relaxed/simple;
	bh=pP+WFeqjkfpDluRZEOl/ZZrraAUa9dLSJfaRBXVCiSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQ7/Jxk9dTjMAVYVcBPo1w7YtdHVVAVQNe+IGJyvZh2MxF5rar2svsYtCgpqxX68xvgOGsSFM0iFid/X1BfdhIVKEjMOQYYQGRAxZGjVRHHjN+JK5l1lno7NTQzgKzXI6ek5ckHUKblVz9RF8zXViAFNshRPkjiFqwNEXkqssCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G0sz9uq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0sz9uq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CCFC43394;
	Thu, 11 Apr 2024 10:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832087;
	bh=pP+WFeqjkfpDluRZEOl/ZZrraAUa9dLSJfaRBXVCiSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0sz9uq+kKEgRP+EYU4C4lNPHAgXfzB5iLyGRD6QdIJjEwCjOFb62O/ux+b5EfKtR
	 9O6cJY7MSqhQBL2zMrmzuJHMfjDbMarunu7fTdWC4jaStCfXbryET9EZ97a7TQHLqp
	 F1Nlj1mUYzTqrJxMyXlJmbdl50aO4NlaBhCYkj+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Justin Stitt <justinstitt@google.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 188/294] dm integrity: fix out-of-range warning
Date: Thu, 11 Apr 2024 11:55:51 +0200
Message-ID: <20240411095441.277039846@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 62cae34ca3b43..067be1d9f51cb 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3937,7 +3937,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
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



