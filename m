Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD451E0DDC;
	Wed, 19 Feb 2025 09:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957448; cv=none; b=dWWfRu/Dr62DPAcCUTKU9DxkTiGvjTBgAWvKHymMibSJxIxo5Peg7JMVBxdMjTWngua8AfM7uDsjJl0mvrYP+Y8cG+fh/R9Rz1hBkN4cYWDA9v03s2FWwxGl/4OIlvbDZDmKBLSxi8wTEgw00SaF97R59NNJ5b82Xdti+T61fak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957448; c=relaxed/simple;
	bh=olp0VcGfFuDlHvm11/T26fpe8eyaWVKj3X8NnC38780=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8A6fbA57s2loOCftS5ibIeYd+tsVh7en4KtcqzfzfqsdhwMPQpqrndM++2Ys4egX5mW4mr7gFpCqwLteEDLk5UNUWIIi0k1gA3yY9zn8wHKnRC19tYZztfpijdm04sYz36WV1VVT8zIIddRmcvKfFdTkqlGI6V/0jjGoyVQWhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxQb7MZ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxQb7MZ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98304C4CED1;
	Wed, 19 Feb 2025 09:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957448;
	bh=olp0VcGfFuDlHvm11/T26fpe8eyaWVKj3X8NnC38780=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxQb7MZ2eKtZhQMH3oGmY66eLKz8sh4mFcAKWtoD7uXZqj+2d0RmV9fGHYP/IxLs5
	 TWgXPBJAEP8kt662fTQxYWGrO6lGm2NdxO6JWl4kbcG+Td3UO+dhHR6yNnkkmvJQ59
	 JXQzAMhru7PZCP+GRiVf2VeT+HsV5dh5D/ac1/NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 530/578] partitions: mac: fix handling of bogus partition table
Date: Wed, 19 Feb 2025 09:28:54 +0100
Message-ID: <20250219082713.828244865@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 80e648042e512d5a767da251d44132553fe04ae0 upstream.

Fix several issues in partition probing:

 - The bailout for a bad partoffset must use put_dev_sector(), since the
   preceding read_part_sector() succeeded.
 - If the partition table claims a silly sector size like 0xfff bytes
   (which results in partition table entries straddling sector boundaries),
   bail out instead of accessing out-of-bounds memory.
 - We must not assume that the partition table contains proper NUL
   termination - use strnlen() and strncmp() instead of strlen() and
   strcmp().

Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/r/20250214-partition-mac-v1-1-c1c626dffbd5@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/partitions/mac.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/block/partitions/mac.c
+++ b/block/partitions/mac.c
@@ -51,13 +51,25 @@ int mac_partition(struct parsed_partitio
 	}
 	secsize = be16_to_cpu(md->block_size);
 	put_dev_sector(sect);
+
+	/*
+	 * If the "block size" is not a power of 2, things get weird - we might
+	 * end up with a partition straddling a sector boundary, so we wouldn't
+	 * be able to read a partition entry with read_part_sector().
+	 * Real block sizes are probably (?) powers of two, so just require
+	 * that.
+	 */
+	if (!is_power_of_2(secsize))
+		return -1;
 	datasize = round_down(secsize, 512);
 	data = read_part_sector(state, datasize / 512, &sect);
 	if (!data)
 		return -1;
 	partoffset = secsize % 512;
-	if (partoffset + sizeof(*part) > datasize)
+	if (partoffset + sizeof(*part) > datasize) {
+		put_dev_sector(sect);
 		return -1;
+	}
 	part = (struct mac_partition *) (data + partoffset);
 	if (be16_to_cpu(part->signature) != MAC_PARTITION_MAGIC) {
 		put_dev_sector(sect);
@@ -110,8 +122,8 @@ int mac_partition(struct parsed_partitio
 				int i, l;
 
 				goodness++;
-				l = strlen(part->name);
-				if (strcmp(part->name, "/") == 0)
+				l = strnlen(part->name, sizeof(part->name));
+				if (strncmp(part->name, "/", sizeof(part->name)) == 0)
 					goodness++;
 				for (i = 0; i <= l - 4; ++i) {
 					if (strncasecmp(part->name + i, "root",


