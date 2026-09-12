Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3970947D477;
	Sat, 12 Sep 2026 13:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218120; cv=none; b=Mz+II/L61eB3mHpPmwJVz4J87f29ibfZM5MQrb6BqiiGQZ8sYkQlzMzC1oBTDfWQoq4o5kHZUhRVJ6eRAriMveTmVUm4jb/T7as8ZbgUo7UtawPJPI3baqBBDXpEp4cxO4S/eekhdiSfb/bmSkdX9ifwD1OXfdZXClmgHbhtNEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218120; c=relaxed/simple;
	bh=dQEhDuP6Fm8uLgb2z7LLlh2jCvdSBBqpsoSK5L1adyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPf/4dqrukXpgOo5uOqu0vuvS/9lpmsaaut/8VW6TjaElQKcohMCvjNzuF8dOEDccPftHChEQSlZ0o79f7e2MUS0cyeOHUx8U4/Ei8MQ6H7Q15qW3FYEtRswttxytdRllixCT9D6nMDXt+ZlnwMaVrWiOYiTLJgqCG+pGbLH9O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0XiIRh3C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0XiIRh3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B091D1F000FF;
	Sat, 12 Sep 2026 13:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218118;
	bh=EDG6Re1mFJV6U42RQwWd6r7nxUKkWDMsFPIcv2ioBV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0XiIRh3CaU1+mKf2dLFCO+r2UmK5IVld5A5aujoeFCWc2+iYmmoYFpC4oeyH9dOCb
	 tpWtgmLpbhngdmT2B3rXzMII3XmPL2WzkmBgSzxUnnOwStJtZwyto8xpcVOU2D5azl
	 4TDEvsRK5VtdL4aMtR5BtRefFbiRob2ESyRoQbQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1080/1376] UBI: fastmap: Pass to_be_tortured when reusing old fastmap PEBs
Date: Sat, 12 Sep 2026 08:58:26 +0200
Message-ID: <20260912065631.631544543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 465ea97463e6d..12dd05fd37789 100644
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
 
@@ -1526,7 +1526,8 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 
 		if (!tmp_e) {
 			if (old_fm && old_fm->e[i]) {
-				ret = ubi_sync_erase(ubi, old_fm->e[i], &torture);
+				ret = ubi_sync_erase(ubi, old_fm->e[i],
+						    &old_fm->to_be_tortured[i]);
 				if (ret < 0) {
 					ubi_err(ubi, "could not erase old fastmap PEB");
 
@@ -1578,7 +1579,8 @@ int ubi_update_fastmap(struct ubi_device *ubi)
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



