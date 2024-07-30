Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F5F1A76A4;
	Tue, 30 Jul 2024 17:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359847; cv=none; b=NnJeXqXsO0G+RGZA7vfME1Rzm/VBt1PbB5gprQDBtwRJaf21GArv061+jLZ8VV/AEbxjvXdCTpUBgqSWkvfmPcVwsekBfwhcXZ7aaYw/z1a+wpV5QROuDNdtoddnyXVRbkZQtf3LL7kddFkhBKKin+OMzeyDtsdWPoYPChEsY9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359847; c=relaxed/simple;
	bh=YNSKtFr4jPUImlimrVYcX6dlt/5te3jmZl9njyB+opw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPTbjiS+ddPcH5dW5DMuaVrXpnstu30PDCiiMBqRvQRUKMxFXuUm+rWWNjBHXaZSp5JYcJ80/9Cv1eVlM6wQGUIR9f2KgHzx0tIqi3NFvT7vxsPyAUfGtto/1xXkpsxS/QiNRe/klDs2bA6tyXfNyH3Eq11oZXCHcYq87ciJc18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MvX4scDN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MvX4scDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5588BC32782;
	Tue, 30 Jul 2024 17:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359846;
	bh=YNSKtFr4jPUImlimrVYcX6dlt/5te3jmZl9njyB+opw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MvX4scDNC6qHRvD6JyEkgeLX/w5SbsuqCg7bH+jizx3BhXk+WtcMRaUhJYXlKMh0Q
	 YlvcmKMOk/ATjV+ExNn2lIgsPySvWE7Gl622CTLLzhSQkD1DOUP76Uay9jJBnyrTS1
	 VT5YKvn6Ad5T0r4vbp3A5peqi9RxVJj9HOcm7bH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: [PATCH 6.10 544/809] Revert "firewire: Annotate struct fw_iso_packet with __counted_by()"
Date: Tue, 30 Jul 2024 17:47:00 +0200
Message-ID: <20240730151746.238919389@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 00e3913b0416fe69d28745c0a2a340e2f76c219c upstream.

This reverts commit d3155742db89df3b3c96da383c400e6ff4d23c25.

The header_length field is byte unit, thus it can not express the number of
elements in header field. It seems that the argument for counted_by
attribute can have no arithmetic expression, therefore this commit just
reverts the issued commit.

Suggested-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20240725161648.130404-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/firewire.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -462,9 +462,8 @@ struct fw_iso_packet {
 				/* rx: Sync bit, wait for matching sy	*/
 	u32 tag:2;		/* tx: Tag in packet header		*/
 	u32 sy:4;		/* tx: Sy in packet header		*/
-	u32 header_length:8;	/* Length of immediate header		*/
-				/* tx: Top of 1394 isoch. data_block    */
-	u32 header[] __counted_by(header_length);
+	u32 header_length:8;	/* Size of immediate header		*/
+	u32 header[];		/* tx: Top of 1394 isoch. data_block	*/
 };
 
 #define FW_ISO_CONTEXT_TRANSMIT			0


