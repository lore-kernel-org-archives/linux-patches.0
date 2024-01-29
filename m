Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166BA1586D7;
	Mon, 29 Jan 2024 17:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548030; cv=none; b=KEBFSYQ0O9F/MHhShPxU/b6SAkd+EACCV1e/c+WPKWakueNkmH/awkMxd71eJkqLHheEnuUeetn3qa8ALaNNBuZf93mSeTD3lZwdK5raZ5QqOI/4ljCc6Iicrxg+p2+Ulj/sTNSl0HFV85zgI1Ya9xjRzyNGmRtIp9Id/bxaIWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548030; c=relaxed/simple;
	bh=b9zkhMN6sVk0FkmGguiTYzOApW9Nv+wWD4lyPCjh4Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y1S3rtRBADWeuuiNaFsezIQkIyzWcRUsQaUC0pnkup58XKtnCNs5/rnxIYKc7fYD2e9py5tSY91bn/QC47DVFNSwGLC4+bgkeQwmDGwxtflH41MMjJXD3cfD0DmP4Xkls3yAFLD0q9o9mbVgbDLJI2tYMfSPznjC6wmp0LbfSew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c44mxoH0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c44mxoH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B638C433C7;
	Mon, 29 Jan 2024 17:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548029;
	bh=b9zkhMN6sVk0FkmGguiTYzOApW9Nv+wWD4lyPCjh4Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c44mxoH01DaAUpb8IM6VA18/b5W9/d8fOoCYB7//fU7a7jF1gwy+NiXlMdE+xYt8D
	 deFpt84d6FRr9V8C/9moUeNQJoUD7agJKEeogDJPumnTPuuCa87mm7+X36McCqcZpK
	 e3+AvYhqHhTc2lwTf1g4o8r3bwN8/YDNpMmc2W7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shiyan <eagle.alexander923@gmail.com>,
	=?UTF-8?q?M=C3=A5ns=20Rullg=C3=A5rd?= <mans@mansr.com>,
	=?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.7 024/346] mtd: rawnand: Fix core interference with sequential reads
Date: Mon, 29 Jan 2024 09:00:55 -0800
Message-ID: <20240129170017.086535817@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3478,6 +3478,18 @@ static void rawnand_enable_cont_reads(st
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
@@ -3652,6 +3664,8 @@ read_retry:
 			buf += bytes;
 			max_bitflips = max_t(unsigned int, max_bitflips,
 					     chip->pagecache.bitflips);
+
+			rawnand_cont_read_skip_first_page(chip, page);
 		}
 
 		readlen -= bytes;


