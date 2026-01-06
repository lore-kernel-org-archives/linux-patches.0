Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4181633C539;
	Tue,  6 Jan 2026 17:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721071; cv=none; b=QZgmKjAYyKwCzGg/Eprhcn8HmnfmhvDcw/ptomJ5VIa+d+ocoYr0E2Ol98jRKyXdZ78ELS/yzvhb6VVevUuahoy1/1wY/4cKaqW0EzUeRoIOJqPnLk82vBRacBy6JJE2KtiiQFo3LyaWVhCNF6yI1M1XuGWWthftBmfrhBntZPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721071; c=relaxed/simple;
	bh=epzQMZjj5EiVBA+KdCwdDIOus3sVn7fdVkKhDe9Uq88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+vlV9HiqxUqvIofZ6Ec4hVyAD/1Sg07sJe2u27j4vpY/FKGj0trR6oPTnzVDseF2jhbcfI67jDCTAMpZL73LPqnbcE/lYZxsPtueq53+FE4Q1M005bRQm8q6z6GUN1HuiaWLcx87iVhHkkJa0QgUyk0RSEkUanVshLJGlWYNEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3z6+Gv3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3z6+Gv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4F8C116C6;
	Tue,  6 Jan 2026 17:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721070;
	bh=epzQMZjj5EiVBA+KdCwdDIOus3sVn7fdVkKhDe9Uq88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3z6+Gv3z0oqjE80+0o/h0XQXfbJ75MbONOL/A28cXJwl04VI+5p77Jj5WoLFOm1u
	 ZZKuHaa7gb2GDZB9OQ/Ub6bgtwyERC69a/zH9v76DEa3gERtpOgSi8o3TmIPA8cXRT
	 Omfeap0l/jeULgW2+S3RrBI+1xUVwEUSrgzm+a8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 384/567] mtd: mtdpart: ignore error -ENOENT from parsers on subpartitions
Date: Tue,  6 Jan 2026 18:02:46 +0100
Message-ID: <20260106170505.547256658@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Christian Marangi <ansuelsmth@gmail.com>

commit 64ef5f454e167bb66cf70104f033c3d71e6ef9c0 upstream.

Commit 5c2f7727d437 ("mtd: mtdpart: check for subpartitions parsing
result") introduced some kind of regression with parser on subpartitions
where if a parser emits an error then the entire parsing process from the
upper parser fails and partitions are deleted.

Not checking for error in subpartitions was originally intended as
special parser can emit error also in the case of the partition not
correctly init (for example a wiped partition) or special case where the
partition should be skipped due to some ENV variables externally
provided (from bootloader for example)

One example case is the TRX partition where, in the context of a wiped
partition, returns a -ENOENT as the trx_magic is not found in the
expected TRX header (as the partition is wiped)

To better handle this and still keep some kind of error tracking (for
example to catch -ENOMEM errors or -EINVAL errors), permit parser on
subpartition to emit -ENOENT error, print a debug log and skip them
accordingly.

This results in giving better tracking of the status of the parser
(instead of returning just 0, dropping any kind of signal that there is
something wrong with the parser) and to some degree restore the original
logic of the subpartitions parse.

(worth to notice that some special partition might have all the special
header present for the parser and declare 0 partition in it, this is why
it would be wrong to simply return 0 in the case of a special partition
that is NOT init for the scanning parser)

Cc: stable@vger.kernel.org
Fixes: 5c2f7727d437 ("mtd: mtdpart: check for subpartitions parsing result")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdpart.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -425,9 +425,12 @@ int add_mtd_partitions(struct mtd_info *
 
 		mtd_add_partition_attrs(child);
 
-		/* Look for subpartitions */
+		/* Look for subpartitions (skip if no maching parser found) */
 		ret = parse_mtd_partitions(child, parts[i].types, NULL);
-		if (ret < 0) {
+		if (ret < 0 && ret == -ENOENT) {
+			pr_debug("Skip parsing subpartitions: %d\n", ret);
+			continue;
+		} else if (ret < 0) {
 			pr_err("Failed to parse subpartitions: %d\n", ret);
 			goto err_del_partitions;
 		}


