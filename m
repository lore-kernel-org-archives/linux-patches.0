Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FE7490BE6;
	Sat, 12 Sep 2026 19:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240066; cv=none; b=KhLEdrx55atnNrX6nYXkFe2FGHVBx+gf6RQV+TMu5Pfj8e+bAQWFl5HewRA8rAYfySzGAVJoSMV6XFimMy8laYufXpoOdtrYbNThTqW/93wyJIS6tlgl+1b++OVyL6K568dt9m/9eTsgOW+Bo7O6r9cA7KW7KJJ2po3Ytqz4VZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240066; c=relaxed/simple;
	bh=jXwgGYU/7PRwU8YU8+1Cn0jiQDfD+80StIZVaCyfimc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2+kWy1D6Q5chRkgdStwunrFW9tSV9kVrHjCJIpokzmJH+k+GfTbCduP+RPBhcOKNB5R29vLPTysz684bCmIiBmT/M1BoD0Wq7vd7cWkyNzeDgVnHdSR/EwRbm6NBLVrvL3CJhLA8Ck2lRqaw2gp20ZU4hMaSLdLNlFYSeYLejY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UqbPHTeR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UqbPHTeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE071F00893;
	Sat, 12 Sep 2026 19:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240064;
	bh=4UXgxyU3HJ9Rybb5FDaRNvmUq0sIwYEo6n2MwXmImkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UqbPHTeRJSiuB1PB2TdDtxNGiBH3YgyeMjmIEKjqh0zlwC4i6y8eab6L6gqX0Oiyw
	 hBaESGUh3FjJQxnOdHdDm76KZRA9zUaVEP336ngXEupzo0prB9BlYAZ8Q4J/UFYmge
	 NPrK20lNabmVJwra5Ca8Ppq3ECUHn/eB3EXWucQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 792/935] UBI: fastmap: Pass to_be_tortured when reusing old fastmap PEBs
Date: Sat, 12 Sep 2026 09:03:42 +0200
Message-ID: <20260912065544.998397058@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



