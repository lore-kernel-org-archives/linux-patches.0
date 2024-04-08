Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19CC7F470;
	Mon,  8 Apr 2024 14:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585063; cv=none; b=nNNU698+6mrbOw005UO4gjGg5LFYi2qBCK1+YbRl1EBR7sp0M7JFWADI6D8fZ5n9Mn4cTcBm4ql1qgd7inbpANPuNkJUJkh3VOdn1bE/b+weJgxYREXtm+5S6vZ4pL8/CbECg9uJQaTDUOl9aoYqd9ndZ0T6854JkX7ycXzQIpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585063; c=relaxed/simple;
	bh=Bi7gqDYRBFmi/RjvUQVDMeNewEdtZCehkLBzGmzJ3zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLkqfXOIeiVMKS1whe5CX0bB24om/zWvOjlwL5W/pk/WRXtuvginKlEn3xU60UGincJUUG7UGYIj3v5xqCNb5k4dDvjPoIUj6V6B207ZKqBu/+8erC/Vopc3GO6rDkCaEDqqCKZb9qxcJX9zZaT13GpK7b3AT7L2dDhljaV8Fec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fl5IpkMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fl5IpkMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596BEC433C7;
	Mon,  8 Apr 2024 14:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585063;
	bh=Bi7gqDYRBFmi/RjvUQVDMeNewEdtZCehkLBzGmzJ3zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fl5IpkMR3AxUb9lEFV6cv2Hrr5baGhEvUi99NuyhPxiYTkOhho7oVuC7jJE5DVneV
	 c9lbsWTAuWlj4QqSyvCp2R56UD7A4cPiaZdJ73U9jbtmin6aXhxER+AWKll/uNTPPb
	 EkhFhm+LQchwdVRmaFwUbUBYAqScOy+T3OJaHXSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Justin Stitt <justinstitt@google.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 620/690] dm integrity: fix out-of-range warning
Date: Mon,  8 Apr 2024 14:58:06 +0200
Message-ID: <20240408125422.094059048@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index df743650d8a9d..ae372bc44fbfc 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4083,7 +4083,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
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



