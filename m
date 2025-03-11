Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0E025E804;
	Tue, 11 Mar 2025 15:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707089; cv=none; b=N/KsNu7pL/jnBY7MNSOXbHxtv1JWMIX5nG1SGcf/HIIjpBD+qmhfQLzfSCKfg90IkQ/XOarKhnbAnBWBORfGLDzI6HdrNxTM/Gj3r7DH5zFGcpEdRbdogho3QRcxjP0XbBy3nf0sogGaWGK0fEgbV2BeNhaS8KfDlVv1cj2et0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707089; c=relaxed/simple;
	bh=ymUs0aE5ZYmqZzqRb07JJWQHgqMEv27amp2cI80vAMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBXuKkSPE5awJ0QT+iZZ4ufbN77o0pHd3B1IFxGPkvt9sTBdSp/qRJ1BcbtZ3l1eK5wjUWcB5mmCFC92ceSVskFAXZnfAqi+PwIwKapA/gW8yiBnjd9oR1Hx2W0X5r3B3jiqbvP9xfTw27/+tUU/KS40FhShsS3ezLE+OlbFpfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fx8bFbB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fx8bFbB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B96C4CEEC;
	Tue, 11 Mar 2025 15:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707089;
	bh=ymUs0aE5ZYmqZzqRb07JJWQHgqMEv27amp2cI80vAMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fx8bFbB3EyiD7sbXLdsAaGRs0jqpKa9gUF6ARJxUUsmZHHRMuqno1VSpplTZEvXJy
	 WInDe77xEuPj3VYzxyfL6uR0az6wCaYyaT9YPxyDBOk33RyZvIZ0nvWcY0TW9AsflU
	 M+soH020BhDztYMzAQzX/pnkRptV/Ia1QDUsVqyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 270/462] partitions: mac: fix handling of bogus partition table
Date: Tue, 11 Mar 2025 15:58:56 +0100
Message-ID: <20250311145809.032465357@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


