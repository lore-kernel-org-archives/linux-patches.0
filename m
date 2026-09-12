Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E681C2E6CA6;
	Sat, 12 Sep 2026 20:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243244; cv=none; b=cXKaHVbjHalqnLTomPrZ3BsPglxf2W32fo8hPBnRM+ZFHbV/ooiif6NtCxIE6umEJ4F4qpQFn7tuXcbrKFlHKnpcMNcKH7GdKPhDqTPwDQ1eh++E9dmU8BpzCy9zvAtcQCr91iuVyyVQyt4j4UrHgMUt0sq6ZfHxZEOur5gbK1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243244; c=relaxed/simple;
	bh=9CSqWNhb/6J2RTfq/sW/CJLaOdqeJc3yixKOMzICt6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jcbQjRYuTEQ1eho08qfNg1DCVw6ZUIW8YUP4kBrfzHwGafW7zQxVW/CMOSjU2h6NWSCcLWnQI++IBTlakIlPNFmnFieM0L8U3lX7YjzUocyV/zx33XEUOUcJXTmk03CN3jsE+raX1PXaf15IcTfh7oGUknjlP2hpBfDrpoawKyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rre3r6pI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rre3r6pI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0691F000FF;
	Sat, 12 Sep 2026 20:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243242;
	bh=uOd0OkzDOnAnklum/4PlZcyAGpl5YugskrIwq6DOtzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rre3r6pIUcJTkaJTOjFsNdVTkCq7PVMUH4cDOirprimkci1AlLlQ9L5yAoyDnwwHh
	 4TchNyZKO0CYIkJIaQfsn2KQXun024wC5ciUGlfJXOJ03H9tcprRLmEPOaJ7kxV2yr
	 1AICDRwgI5Oft4YNkOGbMtZYWaPfp45qitTjImUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 686/798] UBI: fastmap: Pass to_be_tortured when reusing old fastmap PEBs
Date: Sat, 12 Sep 2026 09:05:14 +0200
Message-ID: <20260912065532.825331776@linuxfoundation.org>
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

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit be04fce9945aac2a843f5d16725391eb80d948ef ]

In ubi_update_fastmap(), when no fresh PEB is available to replace an
old fastmap PEB, the old PEB is reused by erasing it synchronously
via ubi_sync_erase() with the torture flag hardcoded to zero.

However, old_fm->to_be_tortured[] may be non-zero: it is set during
fastmap scanning when ubi_io_read_data()/ubi_io_read_ec_hdr() reports
UBI_IO_BITFLIPS, meaning the PEB showed signs of bit decay and should
be tortured to verify it is still reliable.

When the old PEB is instead returned to the WL sub-system via
ubi_wl_put_fm_peb(), the to_be_tortured flag is honored. The
synchronous reuse path is inconsistent: it silently skips the torture
test for PEBs that exhibited bit-flips.

Fix it by passing &old_fm->to_be_tortured[i] to ubi_sync_erase().

Fixes: dbb7d2a88d2a ("UBI: Add fastmap core")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/fastmap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 94af66c8a9417..bdb83eb87d162 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1488,7 +1488,7 @@ static void return_fm_pebs(struct ubi_device *ubi,
  */
 int ubi_update_fastmap(struct ubi_device *ubi)
 {
-	int ret, i, j, torture = 0;
+	int ret, i, j;
 	struct ubi_fastmap_layout *new_fm, *old_fm;
 	struct ubi_wl_entry *tmp_e;
 
@@ -1530,7 +1530,8 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 
 		if (!tmp_e) {
 			if (old_fm && old_fm->e[i]) {
-				ret = ubi_sync_erase(ubi, old_fm->e[i], &torture);
+				ret = ubi_sync_erase(ubi, old_fm->e[i],
+						    &old_fm->to_be_tortured[i]);
 				if (ret < 0) {
 					ubi_err(ubi, "could not erase old fastmap PEB");
 
@@ -1582,7 +1583,8 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 	if (old_fm) {
 		/* no fresh anchor PEB was found, reuse the old one */
 		if (!tmp_e) {
-			ret = ubi_sync_erase(ubi, old_fm->e[0], &torture);
+			ret = ubi_sync_erase(ubi, old_fm->e[0],
+					     &old_fm->to_be_tortured[0]);
 			if (ret < 0) {
 				ubi_err(ubi, "could not erase old anchor PEB");
 
-- 
2.53.0



