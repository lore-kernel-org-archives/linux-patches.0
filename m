Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22EC46D2CC;
	Tue, 21 Jul 2026 18:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659100; cv=none; b=uD0N2CSx/jI9E+Q6JdCB0UWN5u1IUTgEAhPrI/ObIUO0UTQc7yVsgUgXQjhklNQhQoRfd9mT9XrmZo7Jtd3jGpEDhaeMSzsCWsKNwZ+JcdnJWQ+zYyfIYqMJRSV/EA7bh/9sW4wBRspAm/MNRfPi90f8oWPVaacyb9LC7ecPu3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659100; c=relaxed/simple;
	bh=xflIk4lfD5L68MK6Ps2Iw1pKRQb+zfb9KSCWIX3AzYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sc0uooOZEkgVRILe/0Px7LMqT3ENgH4ZnN8OAivppocGO6aG36shDr9JMt3BsPlqvB2aeAGTHJSIsocMjPL+4GI30OdWYc/MunM73Q5xIBSMGyo2bG9t6LoezD5gkGScks2rkctDbGnsmnnr/AQ4w8luOE2rXOx8tDULtwKpifs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mT06vi4x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mT06vi4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514791F00A3E;
	Tue, 21 Jul 2026 18:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659096;
	bh=77JD/ZKJEYlYAxU0eH0JcZZBIE3vxWTeG8P8rRENeXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mT06vi4xfAbPxib9ShGIu3Z8LGpFk/IEuDgXsSiEmhUreF6bejKgBdE5cNxYSbFhN
	 b2o2sDLvYVrVjelln9UvKlfkaSf9upy/lrqbysya8fEn3GE+LiO8zTV37HWzoLgP+E
	 1z02U7kbaC2GsJCerDn2wDcjP+WD7w0HMnH9fa64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 1348/1611] dm-bufio: fix wrong count calculation in dm_bufio_issue_discard
Date: Tue, 21 Jul 2026 17:24:24 +0200
Message-ID: <20260721152545.776360162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2215,7 +2215,9 @@ int dm_bufio_issue_discard(struct dm_buf
 	struct dm_io_region io_reg = {
 		.bdev = c->bdev,
 		.sector = block_to_sector(c, block),
-		.count = block_to_sector(c, count),
+		.count = likely(c->sectors_per_block_bits >= 0) ?
+			count << c->sectors_per_block_bits :
+			count * (c->block_size >> SECTOR_SHIFT),
 	};
 
 	if (WARN_ON_ONCE(dm_bufio_in_request()))


