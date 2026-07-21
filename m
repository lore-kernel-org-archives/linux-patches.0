Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA72C436BC6;
	Tue, 21 Jul 2026 19:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663859; cv=none; b=RsV2uY8s0ayZZDVq0X8N86OCw+jCRt+kORk4HwytflV0ygXSFsPo+BqZYm3qP0l8y/JckgNEOz/I0x2wxcMnUwSuFdCAHYCXj061cozPB57srkWm6V9DFb75uUG4bjeF3hFUY/yz3t0PfVgEY1EFsR5iyYiaAC/xkGQwlkdLiIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663859; c=relaxed/simple;
	bh=2BnhLJP09CtT8Tb8C1G3t8dixa9qutQ+fbs18hE3xTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5Ok71ynQDFRSRYoFzA59GrmWsmawMc3r3miA6GcZCAWZAxezybGDHwbfTIA3NHFXo/w0icOW+wCN9MpoAVu0CZvp/5Aq/OskTEQ/FdeIVsicx095llYmUTcl7VADiOqspceCDjQvVbwYUQJd7Gj3HQiAZVCFSXH1n360ody1XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQ6B8UCS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQ6B8UCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5E71F000E9;
	Tue, 21 Jul 2026 19:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663858;
	bh=d5byEv6JQRWD1PnM4BIv7f8SgoZxmumpKFDjszMurp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yQ6B8UCSbHtEkzOV7MZp/i7gox6yLubbQ1eK7oFkRVlcHbMoF6oUoAYfgmKtSI9nr
	 kkx9kyEXFRpZjRzqUQ0pKKKornw+ZWK5JIfcxuhKtsOfb/HuS1vgfDvcQiTVe86swn
	 W+MGB0hdvfO5TS19QExs687HzoFkd81KBkVU9wnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.12 0983/1276] tpm: fix event_size output in tpm1_binary_bios_measurements_show
Date: Tue, 21 Jul 2026 17:23:46 +0200
Message-ID: <20260721152508.013550731@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 1a58f6115bfb34eabcc7de8a3a9745b219179781 upstream.

Commit 186d124f07da ("tpm_eventlog.c: fix binary_bios_measurements")
split the output to write the endian-converted event header first and
then the variable-length event data.

However, the split was at sizeof(struct tcpa_event) - 1, even though
event_data was a zero-length array, and later a flexible array member,
both of which already excluded the event data.

Therefore, the current code writes the first three bytes of event_size
from the endian-converted header and then the last byte from the raw
header, which can emit a corrupted event_size on PPC64, where
do_endian_conversion() maps to be32_to_cpu().

Split one byte later to write the full endian-converted header first,
followed by the variable-length event->event_data.

Fixes: 186d124f07da ("tpm_eventlog.c: fix binary_bios_measurements")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/eventlog/tpm1.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/char/tpm/eventlog/tpm1.c
+++ b/drivers/char/tpm/eventlog/tpm1.c
@@ -236,12 +236,12 @@ static int tpm1_binary_bios_measurements
 
 	temp_ptr = (char *) &temp_event;
 
-	for (i = 0; i < (sizeof(struct tcpa_event) - 1) ; i++)
+	for (i = 0; i < sizeof(struct tcpa_event); i++)
 		seq_putc(m, temp_ptr[i]);
 
 	temp_ptr = (char *) v;
 
-	for (i = (sizeof(struct tcpa_event) - 1);
+	for (i = sizeof(struct tcpa_event);
 	     i < (sizeof(struct tcpa_event) + temp_event.event_size); i++)
 		seq_putc(m, temp_ptr[i]);
 


