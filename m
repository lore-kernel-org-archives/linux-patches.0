Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4291649DD;
	Mon, 29 Jan 2024 17:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548442; cv=none; b=a6wg3/CvI+HKZdZUxmIVHESR389ioUXE6mSHXOMRCsdSvC2CT4+IPACzMSLpR33UB5yMSQagUbLFKu2rsydBkkuxzYoPathDSET97xcxOWtaD+N2FDV+VcziNAC2IUcwZpfM4VrmAY9PP2/vC9a2X0lemfo7QcnTqH/VJH7GTjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548442; c=relaxed/simple;
	bh=YjTPITiYpeYjASyYXydZmv1O4gNkfsCkI7VMAskgrok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s7670weaefpN5uYYA0EvRvtNgv7HSDBBjSgo9pCmFZOzRt64d4MMC7/pz7uwGQP52A0J5RbzcjvVx6/EBttJlHotxz8cyEfwUjij2IVua5uxvLnob/nwRdBKLYpmL9IHJ+6xuadWWvmO6z2XBFDXkKv6ywreY08pSZmlHxV5VYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+JauT6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+JauT6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE8EC433F1;
	Mon, 29 Jan 2024 17:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548442;
	bh=YjTPITiYpeYjASyYXydZmv1O4gNkfsCkI7VMAskgrok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+JauT6FzwKEYnOz+lfA0FiLTHgrxsdGDq6vGUTKiNWGQ6UG4RlYL9ch7uceVSLHL
	 V3qZP9eM0IuN4juzOIJGmS2hdqoiA8nNbt1fK3dn21Ns8nBWuUnwT4FilZM7ksPjCh
	 J2AfZcCR1mjQrvl0LZwpFB5h5xjWBJLerzJtIuNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shiyan <eagle.alexander923@gmail.com>,
	=?UTF-8?q?M=C3=A5ns=20Rullg=C3=A5rd?= <mans@mansr.com>,
	=?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 047/331] mtd: rawnand: Fix core interference with sequential reads
Date: Mon, 29 Jan 2024 09:01:51 -0800
Message-ID: <20240129170016.312225094@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 7c9414c870c027737d0f2ed7b0ed10f26edb1c61 upstream.

A couple of reports pointed at some strange failures happening a bit
randomly since the introduction of sequential page reads support. After
investigation it turned out the most likely reason for these issues was
the fact that sometimes a (longer) read might happen, starting at the
same page that was read previously. This is optimized by the raw NAND
core, by not sending the READ_PAGE command to the NAND device and just
reading out the data in a local cache. When this page is also flagged as
being the starting point for a sequential read, it means the page right
next will be accessed without the right instructions. The NAND chip will
be confused and will not output correct data. In order to avoid such
situation from happening anymore, we can however handle this case with a
bit of additional logic, to postpone the initialization of the read
sequence by one page.

Reported-by: Alexander Shiyan <eagle.alexander923@gmail.com>
Closes: https://lore.kernel.org/linux-mtd/CAP1tNvS=NVAm-vfvYWbc3k9Cx9YxMc2uZZkmXk8h1NhGX877Zg@mail.gmail.com/
Reported-by: Måns Rullgård <mans@mansr.com>
Closes: https://lore.kernel.org/linux-mtd/yw1xfs6j4k6q.fsf@mansr.com/
Reported-by: Martin Hundebøll <martin@geanix.com>
Closes: https://lore.kernel.org/linux-mtd/9d0c42fcde79bfedfe5b05d6a4e9fdef71d3dd52.camel@geanix.com/
Fixes: 003fe4b9545b ("mtd: rawnand: Support for sequential cache reads")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Tested-by: Martin Hundebøll <martin@geanix.com>
Link: https://lore.kernel.org/linux-mtd/20231215123208.516590-3-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/nand_base.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -3479,6 +3479,18 @@ static void rawnand_enable_cont_reads(st
 	rawnand_cap_cont_reads(chip);
 }
 
+static void rawnand_cont_read_skip_first_page(struct nand_chip *chip, unsigned int page)
+{
+	if (!chip->cont_read.ongoing || page != chip->cont_read.first_page)
+		return;
+
+	chip->cont_read.first_page++;
+	if (chip->cont_read.first_page == chip->cont_read.pause_page)
+		chip->cont_read.first_page++;
+	if (chip->cont_read.first_page >= chip->cont_read.last_page)
+		chip->cont_read.ongoing = false;
+}
+
 /**
  * nand_setup_read_retry - [INTERN] Set the READ RETRY mode
  * @chip: NAND chip object
@@ -3653,6 +3665,8 @@ read_retry:
 			buf += bytes;
 			max_bitflips = max_t(unsigned int, max_bitflips,
 					     chip->pagecache.bitflips);
+
+			rawnand_cont_read_skip_first_page(chip, page);
 		}
 
 		readlen -= bytes;


