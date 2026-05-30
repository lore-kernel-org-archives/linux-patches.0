Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A40481DD;
	Sat, 30 May 2026 17:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160752; cv=none; b=uasf2gNQyrrUN5RYHtZIUxGznEueulC4HPxPCCHJDIvKY0lttb49O3ynIlWBFy2tGhOAdc07rLN3+vEqQv6ffv3BQkxL38ATI6/AuGbi28LQxrtTV+7InfR6XSkCSFjdu3AK1JOLCCdZRC037071mYjuZq7OYMcyjAaGgh+KgJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160752; c=relaxed/simple;
	bh=PYSzRLuRVjHnISvZVJuJ4YjPQz9gIaHTOANNBLdi0Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggwLmJi5DwyP3BpcMaCL5yU4d1kxCYtuQnZLLW26YgXgdP7tMH49Ql0/Q/j2CWdgj+INU6+UOfygPQyBVOlEwczSfliSGbSUzU8lfQA3zekk0XcuA6B0cvPG+hi0jv4MqdCSehgzYCYlkmgbEdtRtXeDAD0Hn2X3ISUCwxUpTLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmuPiTHb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmuPiTHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C0F1F00893;
	Sat, 30 May 2026 17:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160751;
	bh=RPfzTXHh/UClxmxGRGIaVzEm2KcsO67SRRH44GR3uVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wmuPiTHbrw6/Iio+Ai3ADgrqJiUhK+XWEzc4MEjSaXvVGZ1jqCYtXdqC5rJfiC/Rq
	 eSJPUX6hxoS4dOja56mcYRsdDWOMGOzM0QGifdOd+bdpCHmuiGqmpCivpBv4VT54tL
	 da+xusdG0o61RDY3JyNqi7TH7DWamFXT8MgtOttA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjaikumar V S <sanjaikumar.vs@dicortech.com>,
	Hendrik Donner <hd@os-cillation.de>,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: [PATCH 6.1 424/969] mtd: spi-nor: sst: Fix write enable before AAI sequence
Date: Sat, 30 May 2026 17:59:08 +0200
Message-ID: <20260530160311.971978841@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanjaikumar V S <sanjaikumar.vs@dicortech.com>

commit a0f64241d3566a49c0a9b33ba7ae458ae22003a9 upstream.

When writing to SST flash starting at an odd address, a single byte is
first programmed using the byte program (BP) command. After this
operation completes, the flash hardware automatically clears the Write
Enable Latch (WEL) bit.

If an AAI (Auto Address Increment) word program sequence follows, it
requires WEL to be set. Without re-enabling writes, the AAI sequence
fails.

Add spi_nor_write_enable() after the odd-address byte program when more
data needs to be written. Use a local boolean for clarity.

Fixes: b199489d37b2 ("mtd: spi-nor: add the framework for SPI NOR")
Cc: stable@vger.kernel.org
Signed-off-by: Sanjaikumar V S <sanjaikumar.vs@dicortech.com>
Tested-by: Hendrik Donner <hd@os-cillation.de>
Reviewed-by: Hendrik Donner <hd@os-cillation.de>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/sst.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/mtd/spi-nor/sst.c
+++ b/drivers/mtd/spi-nor/sst.c
@@ -153,6 +153,8 @@ static int sst_nor_write(struct mtd_info
 
 	/* Start write from odd address. */
 	if (to % 2) {
+		bool needs_write_enable = (len > 1);
+
 		/* write one byte. */
 		ret = sst_nor_write_data(nor, to, 1, buf);
 		if (ret < 0)
@@ -160,6 +162,17 @@ static int sst_nor_write(struct mtd_info
 
 		to++;
 		actual++;
+
+		/*
+		 * Byte program clears the write enable latch. If more
+		 * data needs to be written using the AAI sequence,
+		 * re-enable writes.
+		 */
+		if (needs_write_enable) {
+			ret = spi_nor_write_enable(nor);
+			if (ret)
+				goto out;
+		}
 	}
 
 	/* Write out most of the data here. */


