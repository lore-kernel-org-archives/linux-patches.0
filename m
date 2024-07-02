Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C5C1BE223;
	Tue,  2 Jul 2024 17:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940577; cv=none; b=G/242fouFeslnilFFOucrzVN/ImAn/cr2EiZvsmkrtHjtm3W8a1BiIdmRy779vzpj03gTZ1KotecS3idtLPbkOGKmqyuYbR7nzG6GT+Rqh/JaaTB4nhYbsqwsKHGdhdrn56opErrFDR/jE89hZyHO1rVJ1zFhS6KE2cWeabxTmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940577; c=relaxed/simple;
	bh=vDb4YLp3s2XujMAhhp56tT1Xv1QBUJtR0n6+mDxLAZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYuncoLrqv5RwB7XRIYWPvXS/sWf95u/U4nQORNTVxl8S/s7wNRkJaseyB3K/BlgRL6JoGaF4w0ReeMG/Fgt/yl5PEP5lF/ZvwmCDznC9FVVeeadRKbPknZQI1M+CveIH6cgbnpcTVKr4Kfcy5kGNWJ+4xI6VdVk/R61nPytgog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P7KWRKcZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P7KWRKcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F43C116B1;
	Tue,  2 Jul 2024 17:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940577;
	bh=vDb4YLp3s2XujMAhhp56tT1Xv1QBUJtR0n6+mDxLAZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P7KWRKcZQVIBYP5VEZv0GNxg5BflNTD2MKgUAEo6+58JIcDGJLZHEX3RErDjI/ehT
	 MkEjvevu8kTA9SXGFEHso15nQL6hGGPz9I5wsjxvFrF1bnq2/x3wpXeZ2Q8yLlaOIk
	 pycWmGao2S591GT0XivER2pC9LKUSBqxgTNcGdys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.9 197/222] bcachefs: Fix sb-downgrade validation
Date: Tue,  2 Jul 2024 19:03:55 +0200
Message-ID: <20240702170251.515343419@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

commit 9242a34b760648b722f4958749ad83ef7d0f7525 upstream.

Superblock downgrade entries are only two byte aligned, but section
sizes are 8 byte aligned, which means we have to be careful about
overrun checks; an entry that crosses the end of the section is allowed
(and ignored) as long as it has zero errors.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/sb-downgrade.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/bcachefs/sb-downgrade.c
+++ b/fs/bcachefs/sb-downgrade.c
@@ -146,6 +146,14 @@ static int bch2_sb_downgrade_validate(st
 	for (const struct bch_sb_field_downgrade_entry *i = e->entries;
 	     (void *) i	< vstruct_end(&e->field);
 	     i = downgrade_entry_next_c(i)) {
+		/*
+		 * Careful: sb_field_downgrade_entry is only 2 byte aligned, but
+		 * section sizes are 8 byte aligned - an empty entry spanning
+		 * the end of the section is allowed (and ignored):
+		 */
+		if ((void *) &i->errors[0] > vstruct_end(&e->field))
+			break;
+
 		if (BCH_VERSION_MAJOR(le16_to_cpu(i->version)) !=
 		    BCH_VERSION_MAJOR(le16_to_cpu(sb->version))) {
 			prt_printf(err, "downgrade entry with mismatched major version (%u != %u)",


