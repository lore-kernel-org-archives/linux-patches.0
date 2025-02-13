Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CE91547E3;
	Thu, 13 Feb 2025 15:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460804; cv=none; b=IkLVSNoHPK9NKMsE9L4aXFuvbSDWPKc6Pbj0IynaZBokuUd4vp8sTzgKb+BCTpgKjnCpBHtvN/B5QuG7pAproaYNYmYRcOUy219bkxW8RGZGDlBw1I1pFm5ANRTSWOo1li5gtXhBlE8Jpjo/wkf9Zjhc7roZCliociGbDftKzLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460804; c=relaxed/simple;
	bh=h4GZpQs0YfUTRVm+hOaw4Y6AT7RiQUN2rMzkKdh52z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PS3c44FyZeGZePwcbmn43Nn3NjVV29gYj7elEKIpBLCC+PqhtZ0gtxvgGoD33mj+PdpV7x0xy10G9ZX/S8VNf4+LVvb9ATubg39CQX0ECWi3s7JIIFn4IDEzpe7VorEZSKzhtlcTnfwX3/p1YuoxDMg6RM7PgHVRLUUpLLy/8ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MpKs4iyn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MpKs4iyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D01C4CED1;
	Thu, 13 Feb 2025 15:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460804;
	bh=h4GZpQs0YfUTRVm+hOaw4Y6AT7RiQUN2rMzkKdh52z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MpKs4iynX9KlOWowVXlgiAysMtc0zb/mix1VbiW6bu5MGDlGZXjIl98436HtGAjY/
	 g67c1D3wh/0OrVn9V9bwY/WYpuBHgalJ5mW4fykVBKvLxzHnCmOUP2QYQAWwGSJGvX
	 m4ChKB60RLt5byHSp8OWEC+JHQ/L8/yW6QPTL/3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	reveliofuzzing <reveliofuzzing@gmail.com>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.6 218/273] ata: libata-sff: Ensure that we cannot write outside the allocated buffer
Date: Thu, 13 Feb 2025 15:29:50 +0100
Message-ID: <20250213142415.929891414@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

commit 6e74e53b34b6dec5a50e1404e2680852ec6768d2 upstream.

reveliofuzzing reported that a SCSI_IOCTL_SEND_COMMAND ioctl with out_len
set to 0xd42, SCSI command set to ATA_16 PASS-THROUGH, ATA command set to
ATA_NOP, and protocol set to ATA_PROT_PIO, can cause ata_pio_sector() to
write outside the allocated buffer, overwriting random memory.

While a ATA device is supposed to abort a ATA_NOP command, there does seem
to be a bug either in libata-sff or QEMU, where either this status is not
set, or the status is cleared before read by ata_sff_hsm_move().
Anyway, that is most likely a separate bug.

Looking at __atapi_pio_bytes(), it already has a safety check to ensure
that __atapi_pio_bytes() cannot write outside the allocated buffer.

Add a similar check to ata_pio_sector(), such that also ata_pio_sector()
cannot write outside the allocated buffer.

Cc: stable@vger.kernel.org
Reported-by: reveliofuzzing <reveliofuzzing@gmail.com>
Closes: https://lore.kernel.org/linux-ide/CA+-ZZ_jTgxh3bS7m+KX07_EWckSnW3N2adX3KV63y4g7M4CZ2A@mail.gmail.com/
Link: https://lore.kernel.org/r/20250127154303.15567-2-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-sff.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -602,7 +602,7 @@ static void ata_pio_sector(struct ata_qu
 {
 	struct ata_port *ap = qc->ap;
 	struct page *page;
-	unsigned int offset;
+	unsigned int offset, count;
 
 	if (!qc->cursg) {
 		qc->curbytes = qc->nbytes;
@@ -618,25 +618,27 @@ static void ata_pio_sector(struct ata_qu
 	page = nth_page(page, (offset >> PAGE_SHIFT));
 	offset %= PAGE_SIZE;
 
-	trace_ata_sff_pio_transfer_data(qc, offset, qc->sect_size);
+	/* don't overrun current sg */
+	count = min(qc->cursg->length - qc->cursg_ofs, qc->sect_size);
+
+	trace_ata_sff_pio_transfer_data(qc, offset, count);
 
 	/*
 	 * Split the transfer when it splits a page boundary.  Note that the
 	 * split still has to be dword aligned like all ATA data transfers.
 	 */
 	WARN_ON_ONCE(offset % 4);
-	if (offset + qc->sect_size > PAGE_SIZE) {
+	if (offset + count > PAGE_SIZE) {
 		unsigned int split_len = PAGE_SIZE - offset;
 
 		ata_pio_xfer(qc, page, offset, split_len);
-		ata_pio_xfer(qc, nth_page(page, 1), 0,
-			     qc->sect_size - split_len);
+		ata_pio_xfer(qc, nth_page(page, 1), 0, count - split_len);
 	} else {
-		ata_pio_xfer(qc, page, offset, qc->sect_size);
+		ata_pio_xfer(qc, page, offset, count);
 	}
 
-	qc->curbytes += qc->sect_size;
-	qc->cursg_ofs += qc->sect_size;
+	qc->curbytes += count;
+	qc->cursg_ofs += count;
 
 	if (qc->cursg_ofs == qc->cursg->length) {
 		qc->cursg = sg_next(qc->cursg);


