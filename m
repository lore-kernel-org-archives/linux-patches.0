Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CB346D0A4;
	Tue, 21 Jul 2026 18:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658905; cv=none; b=GwaEXOq/iWv0OiQ+OF1BCLrrKsFqi1CqAkveoQmjkd9D/hgA6CdmkCLfkQZcqPPG7I1PFEBWr9DQrze1zufuWd6YI3Me/LtYJj7oCVm9ix8BHISUpkRjKmHvbz/d0GKwtKxB88+0vCWs09at86wKNxf2/mbgj9eXoU8k1NHYkCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658905; c=relaxed/simple;
	bh=qD/Nvzx/+/jf9Bc/Vja3sBCeBXiTux/K2hCYF/JHHUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eduLN5rgzPJupXgdlmj1I6fv446sAN94mu7IWthnaFeGrL+bbqBGS5kI0iN1uD+qJ89dvk66rdFYXaAyEoP8IXOcFfRtDhs1oUIxjOViO2hHp9r9WM8r1lhB63JWZcJaMYegfTIynAFIEMwaARWsPaTo7yHh+9o/t6/xU/km5es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVxvgZil; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVxvgZil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9BDF1F000E9;
	Tue, 21 Jul 2026 18:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658904;
	bh=9lxCRrcIVP5SiHBypyOUMLdyWlOEuV8IWlK2RpBTSi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WVxvgZilEQCf90N5b6wLcn1X15NNy9tTNkJxg/O8MwsrIz0el+f8+D4T1L1s13DFA
	 6aXsaqXLLN15wt0FRNJk9UtosFaNIbBbyW0Ms8Wl41KnlqMy9F+3MqeEUqGXosBusv
	 ABl1hIBDRJ3Rlm4efh9EXvxfrvJakN9aa+SwOAZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.18 1320/1611] tpm: fix event_size output in tpm1_binary_bios_measurements_show
Date: Tue, 21 Jul 2026 17:23:56 +0200
Message-ID: <20260721152545.147496252@linuxfoundation.org>
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
 


