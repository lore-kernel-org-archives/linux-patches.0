Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B733B6C06;
	Tue, 21 Jul 2026 20:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667405; cv=none; b=KfCz3FnEAf5E9aDzdubeV0ew0vtylm/JryLGwZ/RPAzhpNvphOUarOXAcRvYDn3VZpVKD30ZulZMbSzl7naR2VuuymSB3AoYq0IwmiDeBR9d1Olccku2NgRlWF1gCjC7l9YLl9a7SRy/XXdIMOexyE7pJf0vDD7pdD/e/Rps2Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667405; c=relaxed/simple;
	bh=djb94kPjpJARvM40e4VuWL/9EclrW5iDNK8tj/P0b/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffrPnBRb05bDaQfJgdEaO4se/Xwi/O6iC7aoeLs4yItqlzJseBfCc4bfhuy7wzKyc+NP5kQZfbQaC7UjBwREOgovzj0FW/DznMehSk9YxxusHKmY8GX9E4D13PWiHDlnRE/p9o+xIrcHENHO+GKTnpHz/ScXDubK5HSCFlzJ+W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOv5wmnq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOv5wmnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928061F000E9;
	Tue, 21 Jul 2026 20:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667403;
	bh=Z1NUIT45XUh4gGZwmSHwaeQ+zzTFiuwPIp5q86zT9iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vOv5wmnq56Au71rv068qB0KWQFOx6lmmUoKE2LPle7P7oP/ZDZD2ejr0ZPxgOSU7/
	 /CFBgmOcnbFxBkq56xVKMoVQlgdSmM+MAKsrZjcsffbeovDK7D/jt6qD9q5UEGF+0s
	 lljIgSZ532g3wZXJiF+pB9cca70Y4EtNai42H3Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 1047/1266] dm-bufio: fix wrong count calculation in dm_bufio_issue_discard
Date: Tue, 21 Jul 2026 17:24:44 +0200
Message-ID: <20260721152505.246651843@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 422f1d4f141eaa3a6e4199ceec86cc6b9bf26570 upstream.

block_to_sector converts a block number to a sector number and adds
c->start to the result. It is inappropriate to use this function for
converting the number of blocks to a number to sectors because c->start
would be incorrectly added to the result.

Luckily, the only target that uses dm_bufio_issue_discard is dm-ebs,
which sets c->start to 0, so this bug is latent.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Fixes: 6fbeb0048e6b ("dm bufio: implement discard")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-bufio.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -2189,7 +2189,9 @@ int dm_bufio_issue_discard(struct dm_buf
 	struct dm_io_region io_reg = {
 		.bdev = c->bdev,
 		.sector = block_to_sector(c, block),
-		.count = block_to_sector(c, count),
+		.count = likely(c->sectors_per_block_bits >= 0) ?
+			count << c->sectors_per_block_bits :
+			count * (c->block_size >> SECTOR_SHIFT),
 	};
 
 	if (WARN_ON_ONCE(dm_bufio_in_request()))


