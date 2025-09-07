Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE0A1A0BFD;
	Sun,  7 Sep 2025 20:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277188; cv=none; b=QH1r8cZSmXeBuzwZW88AEWvrZFgAUel1qNUVS4DCzOQ+No4Vgk9RMqkcuY9HJlhznU8hi96K6wDVkpi2845eTQrzZipLjnxgPgjIjblHWndsdYXwMET/VGqawReJSUW6AtNjnQgWviUFXroB+CUkvvzRXnuPnt+/GfTugxni4Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277188; c=relaxed/simple;
	bh=ea7LXbuo5ZAVpr4DqDnI8rg7XYrSlRBhXC1zhNF6FXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W81EMud52otQlArAGSqY2U39UXQlyaXFDg561bh7Qt7I3zWIlO1sMxGvfv/9kXvWhboRULWcXNBzyYBuAk94u4tH8N9wBlVFydawtogBpHtJENUSonLG+BzI21+GV1HPpekquIxmBX78b1VimBzF931nBFIAAzGr2Twv2FPgSQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bsdKKhzw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bsdKKhzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554F4C4CEF0;
	Sun,  7 Sep 2025 20:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277188;
	bh=ea7LXbuo5ZAVpr4DqDnI8rg7XYrSlRBhXC1zhNF6FXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bsdKKhzwAGvOGt5OpvSgqfy3nrnRc6qw/KF071/jfxqJZvcxKldoK1AqfDUKPFefd
	 h1jBuT0uA1Bh7ttxRS5GoBIVJw2pgImDa29NLyU8kxLYgv9u5j/FlMEvMcelonHcZD
	 TRRoFVHUzzHUE5dZFhgQ5O/VdHT7N8k+u4Mha8DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	stable@kernel.org,
	Andrew Lunn <andrew@lunn.ch>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 112/175] net: ethernet: oa_tc6: Handle failure of spi_setup
Date: Sun,  7 Sep 2025 21:58:27 +0200
Message-ID: <20250907195617.506945321@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

commit b3852ae3105ec1048535707545d23c1e519c190f upstream.

There is no guarantee that spi_setup succeed, so properly handle
the error case.

Fixes: aa58bec064ab ("net: ethernet: oa_tc6: implement register write operation")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Cc: stable@kernel.org
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250827115341.34608-2-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/oa_tc6.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/oa_tc6.c
+++ b/drivers/net/ethernet/oa_tc6.c
@@ -1249,7 +1249,8 @@ struct oa_tc6 *oa_tc6_init(struct spi_de
 
 	/* Set the SPI controller to pump at realtime priority */
 	tc6->spi->rt = true;
-	spi_setup(tc6->spi);
+	if (spi_setup(tc6->spi) < 0)
+		return NULL;
 
 	tc6->spi_ctrl_tx_buf = devm_kzalloc(&tc6->spi->dev,
 					    OA_TC6_CTRL_SPI_BUF_SIZE,


